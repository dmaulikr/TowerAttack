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
        self.goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 100, 30)];
        [self.goldLabel setFont:[UIFont fontWithName:@"Cochin" size:15]];
        [self addSubview:self.goldLabel];
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
    [self.goldLabel setText:[NSString stringWithFormat:@"Gold: %lu",currentGold]];
    _currentGold = currentGold;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
