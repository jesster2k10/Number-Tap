//
//  AnimatedScoreLabel.h
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AnimatedScoreLabel : SKLabelNode

+(AnimatedScoreLabel *)labelWithText:(NSString *)text score:(int)score size:(int)fontSize color:(UIColor *)fontColor;
@property (nonatomic) int score;

@end
