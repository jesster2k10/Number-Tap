
//
//  MutiplayerNetworking.m
//  Number Tap
//
//  Created by Jesse on 20/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

#import "MultiplayerNetworking.h"
#import "Number_Tap_iOS-Swift.h"

#define playerIdKey @"PlayerId"
#define randomNumberKey @"randomNumber"

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForElements,
    kGameStateWaitingForArray,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateNumberTapped,
    kGameStateGameOver,
    kGameStateResetTimer,
    kGameStateDone
};

typedef NS_ENUM(NSUInteger, MessageType) {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeSendArray,
    kMessageTypePoint,
    kMessageTypeResetTimer,
    kMessageNewNumber,
    kMessageTypeGameOver,
    kMessageArray,
    kMessageElements
};

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    __unsafe_unretained NSArray *array;
    uint32_t startingNumber;
} MessageElements;

typedef struct {
    Message message;
    __unsafe_unretained NSArray *array;
} MessageArray;

typedef struct {
    Message message;
} MessagePoint;

typedef struct {
    Message message;
    int newNumber;
} MessageNewNumber;

typedef struct {
    Message message;
} MessageResetTimer;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

@implementation MultiplayerNetworking {
    uint32_t _ourRandomNumber;
    uint32_t _newNumber;
    NSArray *_boxArray;
    NSArray *_array;
    SKLabelNode *_tapLabel;
    ProgressNode *timer;
    GameState _gameState;
    BOOL _isPlayer1, _receivedAllRandomNumbers, _receivedAllElements;
    
    NSMutableArray *_orderOfPlayers;
}

- (id)init
{
    if (self = [super init]) {
        _ourRandomNumber = arc4random();
        _gameState = kGameStateWaitingForMatch;
        
        _orderOfPlayers = [NSMutableArray array];
        [_orderOfPlayers addObject:@{playerIdKey : [GKLocalPlayer localPlayer].playerID,
                                     randomNumberKey : @(_ourRandomNumber)}];
    }
    return self;
}

#pragma mark GameKitHelper delegate methods

- (void)matchStarted
{
    NSLog(@"Match has started successfully");
    if (_receivedAllRandomNumbers && _receivedAllElements) {
        _gameState = kGameStateWaitingForStart;
    } else {
        if (_receivedAllRandomNumbers) {
            _gameState = kGameStateWaitingForElements;
        } else {
            _gameState = kGameStateWaitingForRandomNumber;
        }
    }
    [self sendRandomNumber];
    [_delegate matchStarted];
    [self tryStartGame];
}

- (void)sendAllElemements:(NSArray *)array startingNumber:(int)num {
    MessageElements message;
    message.message.messageType = kMessageElements;
    message.array = array;
    message.startingNumber = num;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageElements)];
    [self sendData:data];
}

- (void)sendNewNumber:(int)newNumber {
    MessageNewNumber message;
    message.message.messageType = kMessageNewNumber;
    message.newNumber = newNumber;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageNewNumber)];
    [self sendData:data];
}

- (void)sendArray:(NSArray *)array {
    MessageArray message;
    message.message.messageType = kMessageArray;
    message.array = array;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageArray)];
    [self sendData:data];
}

- (void)sendRestTimer {
    MessageResetTimer message;
    message.message.messageType = kMessageTypeResetTimer;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageResetTimer)];
    [self sendData:data];
}

- (void)sendRandomNumber {
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = _ourRandomNumber;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameEnd:(BOOL)player1Won {
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
}

- (void)sendGameBegin {
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
}

- (void)sendPoint {
    MessagePoint messagePoint;
    messagePoint.message.messageType = kMessageTypePoint;
    NSData *data = [NSData dataWithBytes:&messagePoint
                                  length:sizeof(MessagePoint)];
    [self sendData:data];
}

- (void)tryStartGame {
    if (_isPlayer1 && _gameState == (kGameStateWaitingForStart | kGameStateWaitingForElements)) {
        _gameState = kGameStateActive;
        [self sendGameBegin];
    }
}

- (void)matchEnded {
    NSLog(@"Match has ended");
    [_delegate matchEnded];
}

- (void)sendData:(NSData*)data
{
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    BOOL success = [gameKitHelper.match
                    sendDataToAllPlayers:data
                    withDataMode:GKMatchSendDataReliable
                    error:&error];
    
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player
{
    
    Message *message = (Message*)[data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        MessageRandomNumber *messageRandomNumber = (MessageRandomNumber*)[data bytes];
        
        NSLog(@"Received random number:%d", messageRandomNumber->randomNumber);
        
        BOOL tie = NO;
        if (messageRandomNumber->randomNumber == _ourRandomNumber) {
            //2
            NSLog(@"Tie");
            tie = YES;
            _ourRandomNumber = arc4random();
            [self sendRandomNumber];
        } else {
            //3
            NSDictionary *dictionary = @{playerIdKey : player.playerID,
                                         randomNumberKey : @(messageRandomNumber->randomNumber)};
            [self processReceivedRandomNumber:dictionary];
        }
        
        //4
        if (_receivedAllRandomNumbers) {
            _isPlayer1 = [self isLocalPlayerPlayer1];
        }
        
        if (!tie && _receivedAllRandomNumbers) {
            //5
            if (_gameState == kGameStateWaitingForRandomNumber) {
                _gameState = kGameStateWaitingForStart;
            }
            [self tryStartGame];
        }
    } else if (message->messageType == kMessageTypeGameBegin) {
        NSLog(@"Begin game message received");
        _gameState = kGameStateActive;
        [_delegate gameBegan];
    }
    
    else if (message->messageType == kMessageElements) {
        NSLog(@"Array message received");
    }
    
    else if (message->messageType == kMessageArray) {
        NSLog(@"Array message received");
        _gameState = kGameStateWaitingForArray;
        MessageArray *messageArray = (MessageArray *) [data bytes];
        [_delegate getNumberArray:messageArray->array];
        [self tryStartGame];
    }
    
    else if (message->messageType == kMessageNewNumber) {
        NSLog(@"New Number message received");
        MessageNewNumber *messageNumber = (MessageNewNumber *) [data bytes];
        [_delegate newNumber:messageNumber->newNumber];
    }
    
    else if (message->messageType == kMessageTypeRandomNumber) {
        NSLog(@"Random number message received");
        [self tryStartGame];
        _gameState = kGameStateWaitingForElements;
    }
    
    else if (message->messageType == kMessageTypeResetTimer) {
        NSLog(@"Reset timer message received");
        [_delegate resetTimer];
    }
    
    else if (message->messageType == kMessageTypePoint) {
        NSLog(@"Point message received");
        [_delegate point];
    }
    
    else if(message->messageType == kMessageTypeGameOver) {
        NSLog(@"Game over message received");
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        [self.delegate gameOver:messageGameOver->player1Won];
    }
}

- (BOOL)allRandomNumbersAreReceived
{
    NSMutableArray *receivedRandomNumbers =
    [NSMutableArray array];
    
    for (NSDictionary *dict in _orderOfPlayers) {
        [receivedRandomNumbers addObject:dict[randomNumberKey]];
    }
    
    NSArray *arrayOfUniqueRandomNumbers = [[NSSet setWithArray:receivedRandomNumbers] allObjects];
    
    if (arrayOfUniqueRandomNumbers.count ==
        [GameKitHelper sharedGameKitHelper].match.players.count + 1) {
        return YES;
    }
    return NO;
}

-(void)processReceivedRandomNumber:(NSDictionary*)randomNumberDetails {
    if([_orderOfPlayers containsObject:randomNumberDetails]) {
        [_orderOfPlayers removeObjectAtIndex:
         [_orderOfPlayers indexOfObject:randomNumberDetails]];
    }
    
    [_orderOfPlayers addObject:randomNumberDetails];
    
    NSSortDescriptor *sortByRandomNumber =
    [NSSortDescriptor sortDescriptorWithKey:randomNumberKey
                                  ascending:NO];
    NSArray *sortDescriptors = @[sortByRandomNumber];
    [_orderOfPlayers sortUsingDescriptors:sortDescriptors];
    
    if ([self allRandomNumbersAreReceived]) {
        _receivedAllRandomNumbers = YES;
    }
}

- (BOOL)isLocalPlayerPlayer1 {
    NSDictionary *dictionary = _orderOfPlayers[0];
    if ([dictionary[playerIdKey]
         isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        NSLog(@"I'm player 1");
        return YES;
    }
    return NO;
}

- (NSUInteger)indexForLocalPlayer
{
    NSString *playerId = [GKLocalPlayer localPlayer].playerID;
    
    return [self indexForPlayerWithId:playerId];
}

- (NSUInteger)indexForPlayerWithId:(NSString*)playerId
{
    __block NSUInteger index = -1;
    [_orderOfPlayers enumerateObjectsUsingBlock:^(NSDictionary
                                                  *obj, NSUInteger idx, BOOL *stop){
        NSString *pId = obj[playerIdKey];
        if ([pId isEqualToString:playerId]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

@end