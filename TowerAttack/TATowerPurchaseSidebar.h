//
//  TATowerPurchaseSidebar.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATowerPurchaseSidebar : UIScrollView

@property (nonatomic) BOOL canSelectTowers;
@property (nonatomic) NSInteger selectedTowerType;
@property (strong, nonatomic) UIScrollView *towerScrollView;
@property (strong, nonatomic) NSArray *towerIcons;
@property (strong, nonatomic) NSArray *towerLabels;

-(void)selectTowerFromButton:(UIButton *)button;

@end
