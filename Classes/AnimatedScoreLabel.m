//
//  AnimatedScoreLabel.m
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

#import "AnimatedScoreLabel.h"

@implementation AnimatedScoreLabel {
    SKLabelNode *_scoreLabel;
    int _currentScore;
}

#pragma mark - Constants

static NSString *kAnimationKey = @"LabelAnimationKey";
static NSString *kFontName = @"Montserrat-SemiBold";
static const NSTimeInterval kAnimationDelay = 0.02;

#pragma mark - Initialization

+(AnimatedScoreLabel *)labelWithText:(NSString *)text score:(int)score size:(int)fontSize color:(UIColor *)fontColor {
    return [[AnimatedScoreLabel alloc]initWithText:text score:score size:fontSize color:fontColor];
}

-(instancetype) initWithText:(NSString *)text score:(int)score size:(int)fontSize color:(UIColor *)fontColor {
    self = [super initWithFontNamed:kFontName];
    if (self) {
        self.text = text;
        self.fontSize = fontSize;
        self.fontColor = [SKColor colorWithRed:231 green:76 blue:60 alpha:1];
        
        _currentScore = _score = score;
        _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        _scoreLabel.fontSize = fontSize;
        _scoreLabel.fontColor = fontColor;
        _scoreLabel.position = self.position;
        _scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        [self addChild:_scoreLabel];
    }
    return self;
}

#pragma mark - Animation

-(void)setScore:(int)score {
    _score = score;
    [self updateDisplay];
}

// Compute next multiple of 10 from _currentScore in the direction of _score:
-(int)computeNextScore {
    int next;
    if (_score > _currentScore) {
        if (_currentScore >= 0) {
            next = ((_currentScore + 10)/ 10) * 10;
        } else {
            next = ((_currentScore + 1)/ 10) * 10;
        }
        if (next > _score) {
            next = _score;
        }
    } else if (_score < _currentScore) {
        if (_currentScore <= 0) {
            next = ((_currentScore - 10) / 10) * 10;
        } else {
            next = ((_currentScore - 1) / 10) * 10;
        }
        if (next < _score) {
            next = _score;
        }
    } else {
        next = _score;
    }
    return next;
}

-(void)updateDisplay {
    if (_score != _currentScore) {
        SKAction *wait = [SKAction waitForDuration:kAnimationDelay];
        SKAction *update = [SKAction runBlock:^() {
            _currentScore = [self computeNextScore];
            _scoreLabel.text = [NSString stringWithFormat:@"%i", _currentScore];
        }];
        SKAction *checkAgain = [SKAction performSelector:@selector(updateDisplay) onTarget:self];
        [self runAction:[SKAction sequence:@[wait, update, checkAgain]] withKey:kAnimationKey];
    } else {
        [self removeActionForKey:kAnimationKey];
    }
}


@end
