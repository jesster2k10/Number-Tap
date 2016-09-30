//
//  GameKitHelper.h
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GameKit;

@protocol GameKitHelperDelegate
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID;
- (void)inviteReceived;
@end

extern NSString *const PresentAuthenticationViewController;
extern NSString *const LocalPlayerIsAuthenticated;

@interface GameKitHelper : NSObject<GKMatchmakerViewControllerDelegate, GKMatchDelegate>

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

@property (nonatomic, strong) GKMatch *match;
@property (nonatomic, assign) id <GameKitHelperDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *playersDict;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GameKitHelperDelegate>)theDelegate;
@end

