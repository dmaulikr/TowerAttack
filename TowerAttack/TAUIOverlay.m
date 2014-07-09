//
//  TAUIOverlay.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-09.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAUIOverlay.h"
#import "TABattleScene.h"

@implementation TAUIOverlay

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 200, 60)];
        self.livesLeft = 10;
        [self.displayLabel setFont:[UIFont fontWithName:@"Cochin" size:15]];
        self.displayLabel.numberOfLines = 2;
        [self addSubview:self.displayLabel];
        self.currentGold = 100;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.battleScene touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.battleScene touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.battleScene touchesEnded:touches withEvent:event];
}

 -(void)setCurrentGold:(NSUInteger)currentGold
{
    [self.displayLabel setText:[NSString stringWithFormat:@"Gold: %lu\nLives: %ld",currentGold,(long)self
                                .livesLeft]];
    _currentGold = currentGold;
}

-(void)setLivesLeft:(NSInteger)livesLeft
{
    [self.displayLabel setText:[NSString stringWithFormat:@"Gold: %lu\nLives: %ld",self.currentGold,(long)livesLeft]];
    if (livesLeft == 0) {
        [self.battleScene.view setPaused:YES];
        UILabel *endGame = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, self.frame.size.width / 2 - 25, 200, 50)];
        [endGame setText:@"YOU LOSE"];
        [endGame setFont:[UIFont fontWithName:@"Cochin" size:30]];
        [self addSubview:endGame];
    }
    _livesLeft = livesLeft;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
