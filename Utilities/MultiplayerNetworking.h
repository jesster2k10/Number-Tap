//
//  MutiplayerNetworking.h
//  Number Tap
//
//  Created by Jesse on 20/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

#import "GameKitHelper.h"

@protocol MultiplayerNetworkingProtocol <NSObject>
- (void)matchEnded;
- (void)gameBegan;
- (void)matchStarted;
- (void)gameOver:(BOOL)player1Won;
- (void)newNumber:(int)number;
- (void)point;
- (void)resetTimer;
- (void)getNumberArray:(NSArray *)array;
- (void)receivedElements:(NSArray *)array startingNumber:(int)num;
@end

@interface MultiplayerNetworking : NSObject<GameKitHelperDelegate>
@property (nonatomic, assign) id<MultiplayerNetworkingProtocol> delegate;

- (void)sendPoint;
- (void)sendNewNumber:(int)newNumber;
- (void)sendAllElemements:(NSArray *)array startingNumber:(int)num;
- (void)sendRandomNumber;
- (void)sendGameEnd:(BOOL)player1Won;
- (void)sendArray:(NSArray *)array;
@end
