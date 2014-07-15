//
//  TATowerPurchaseSidebar.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATowerPurchaseSidebar.h"
#import "TATower.h"

@implementation TATowerPurchaseSidebar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.9];
        self.canSelectTowers = YES;
        self.selectedTowerType = TATowerTypeNoTower;
        self.towerIcons = [NSArray arrayWithObjects:[UIButton buttonWithType:UIButtonTypeCustom], [UIButton buttonWithType:UIButtonTypeCustom], [UIButton buttonWithType:UIButtonTypeCustom], [UIButton buttonWithType:UIButtonTypeCustom], nil];
        int i = 0;
        for (UIButton *b in self.towerIcons) {
            [b setImage:[UIImage imageNamed:@"Tower"] forState:UIControlStateNormal];
            [b setImage:[UIImage imageNamed:@"Tower_Selected"] forState:UIControlStateSelected];
            b.tag = i;
            [b setFrame:CGRectMake(12, 9 + 81 * i, 45, 45)];
            [b addTarget:self action:@selector(selectTowerFromButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
            i++;
        }
        self.towerLabels = [NSArray arrayWithObjects:[[UILabel alloc] initWithFrame:CGRectMake(10, 47, 50, 45)], [[UILabel alloc] initWithFrame:CGRectMake(10, 128, 50, 45)], [[UILabel alloc] initWithFrame:CGRectMake(10, 209, 50, 45)], [[UILabel alloc] initWithFrame:CGRectMake(10, 290, 50, 45)], nil];
        for (UILabel *l in self.towerLabels) {
            l.font = [UIFont fontWithName:@"Cochin" size:12];
            l.text = @"Tower\n50 Gold";
            l.adjustsFontSizeToFitWidth = YES;
            l.numberOfLines = 0;
            l.textAlignment = NSTextAlignmentCenter;
            l.minimumScaleFactor = 2;
            [self addSubview:l];
        }
        self.contentSize = CGSizeMake(68, [self.towerLabels count] * 81 + 20);
    }
    return self;
}

-(void)selectTowerFromButton:(UIButton *)button
{
    if (button.selected) {
        self.selectedTowerType = TATowerTypeNoTower;
        button.selected = NO;
    }
    else {
        self.selectedTowerType = button.tag;
        for (UIButton *b in self.towerIcons) {
            b.selected = NO;
        }
        button.selected = YES;
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
