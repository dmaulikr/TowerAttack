//
//  TATowerPurchaseSidebar.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATowerPurchaseSidebar.h"
#import "TAFireballTower.h"
#import "TAFreezeTower.h"
#import "TABlastTower.h"
#import "TAPsychicTower.h"
#import "TAInfoPopUp.h"
#import "TALabel.h"

@implementation TATowerPurchaseSidebar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.7];
        self.canSelectTowers = YES;
        self.clipsToBounds = NO;
        self.selectedTowerType = TATowerTypeNoTower;
        self.towerIcons = [NSMutableArray array];
        self.towerLabels = [NSMutableArray array];
        CGFloat yCount = 0.0, bufferThickness = 11.0 / 2.0 + 5.0;
        NSArray *towerImageNames = [TANonPassiveTower towerIconStrings];
        self.towers = @[[[TAFireballTower alloc] init], [[TAFreezeTower alloc] init], [[TABlastTower alloc] init], [[TAPsychicTower alloc] init]]; //hardcoded
        
        for (int i = 0; i < [self.towers count]; i++) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:[UIImage imageNamed:[[towerImageNames objectAtIndex:i] substringFromIndex:2]] forState:UIControlStateNormal];
            b.tag = i;
            CGFloat dimensions = [[[towerImageNames objectAtIndex:i] substringToIndex:2] floatValue];
            yCount += dimensions / 2 + bufferThickness;
            [b setFrame:CGRectMake(12, yCount, dimensions, dimensions)];
            [b setCenter:CGPointMake(self.frame.size.width / 2, yCount)];
            yCount += dimensions / 2 + bufferThickness;
            [b addTarget:self action:@selector(selectTowerFromButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.towerIcons addObject:b];
            [self addSubview:b];
            
            TALabel *l = [[TALabel alloc] initWithFrame:CGRectMake(0, yCount - bufferThickness + 2, 70, 11) andFontSize:11];
            l.text = [NSString stringWithFormat:@"%@",[(TATower *)[self.towers objectAtIndex:i] unitType]];
            [self.towerLabels addObject:l];
            [self addSubview:l];
        }
        
        self.contentSize = CGSizeMake(68, yCount + bufferThickness);
        self.infoPopUp = [[TAInfoPopUp alloc] initWithOrigin:CGPointMake(0, 0)];
        self.infoPopUp.alpha = 0;
        [self addSubview:self.infoPopUp];
    }
    return self;
}

-(void)selectTowerFromButton:(UIButton *)button
{
    if (button.selected) {
        self.selectedTowerType = TATowerTypeNoTower;
        button.selected = NO;
        button.highlighted = NO;
        self.infoPopUp.alpha = 0;
    }
    else {
        self.selectedTowerType = button.tag;
        for (UIButton *b in self.towerIcons) {
            b.selected = NO;
            b.highlighted = NO;
        }
        button.selected = YES;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            button.highlighted = YES;
        }];
        self.infoPopUp.alpha = 0;
        self.infoPopUp.originPoint = CGPointMake(0, button.center.y);
        [self.infoPopUp setText:[(TATower *)[self.towers objectAtIndex:button.tag] description] andGoldCost:[(TATower *)[self.towers objectAtIndex:button.tag] purchaseCost]];
        [UIView animateWithDuration:0.2 animations:^{
            self.infoPopUp.alpha = 1;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
