//
//  TATowerPurchaseSidebar.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATowerPurchaseSidebar.h"
#import "TANonPassiveTower.h"

@implementation TATowerPurchaseSidebar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.9];
        self.canSelectTowers = YES;
        self.selectedTowerType = TATowerTypeNoTower;
        self.towerIcons = [NSArray arrayWithObjects:[UIButton buttonWithType:UIButtonTypeCustom], [UIButton buttonWithType:UIButtonTypeCustom], [UIButton buttonWithType:UIButtonTypeCustom], /*[UIButton buttonWithType:UIButtonTypeCustom],*/ nil];
        int i = 0;
        CGFloat yCount = 0.0, bufferThickness = 11.0 / 2.0 + 5.0;
        NSArray *towerImageNames = [TANonPassiveTower towerIconStrings];
        for (UIButton *b in self.towerIcons) {
            [b setImage:[UIImage imageNamed:[[towerImageNames objectAtIndex:i] substringFromIndex:2]] forState:UIControlStateNormal];
            b.tag = i;
            CGFloat dimensions = [[[towerImageNames objectAtIndex:i] substringToIndex:2] floatValue];
            yCount += dimensions / 2 + bufferThickness;
          //  [b setFrame:CGRectMake(12, 9 + 81 * i, 45, 45)];
            [b setFrame:CGRectMake(12, yCount, dimensions, dimensions)];
            [b setCenter:CGPointMake(self.frame.size.width / 2, yCount)];
            yCount += dimensions / 2 + bufferThickness;
            [b addTarget:self action:@selector(selectTowerFromButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
            i++;
        }
        self.towerLabels = [NSArray arrayWithObjects:[[UILabel alloc] initWithFrame:CGRectMake(0, 62, 70, 11)], [[UILabel alloc] initWithFrame:CGRectMake(0, 123, 70, 11)], [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 70, 11)], /*[[UILabel alloc] initWithFrame:CGRectMake(10, 290, 50, 45)],*/ nil];
        NSArray *towerNames = [TANonPassiveTower towerNames];
        i = 0;
        for (UILabel *l in self.towerLabels) {
            l.font = [UIFont fontWithName:@"Cochin" size:11];
            l.text = [NSString stringWithFormat:@"%@"/*\n50 Gold"*/,[towerNames objectAtIndex:i]];
            l.adjustsFontSizeToFitWidth = YES;
            l.numberOfLines = 0;
            l.textAlignment = NSTextAlignmentCenter;
            l.minimumScaleFactor = 2;
            [self addSubview:l];
            i++;
        }
        self.contentSize = CGSizeMake(68, yCount + bufferThickness);
    }
    return self;
}

-(void)selectTowerFromButton:(UIButton *)button
{
    if (button.selected) {
        self.selectedTowerType = TATowerTypeNoTower;
        button.selected = NO;
        button.highlighted = NO;
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
