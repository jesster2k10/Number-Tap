//
//  VoiceRecognitionHelper.h
//  Number Tap Universal
//
//  Created by Esther Onolememen on 25/09/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

#import <OpenEars/OEEventsObserver.h>

#import <Foundation/Foundation.h>

@interface VoiceRecognitionHelper : NSObject <OEEventsObserverDelegate>

+ (instancetype)sharedInstance;
- (id) init;
- (void)start;
- (void)stop;
@end
