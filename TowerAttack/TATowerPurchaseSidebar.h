//
//  TATowerPurchaseSidebar.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TAInfoPopUp;

@interface TATowerPurchaseSidebar : UIScrollView

@property (nonatomic) BOOL canSelectTowers;
@property (nonatomic) NSInteger selectedTowerType;
@property (strong, nonatomic) NSMutableArray *towerIcons;
@property (strong, nonatomic) NSMutableArray *towerLabels;
@property (strong, nonatomic) TAInfoPopUp *infoPopUp;
@property (strong, nonatomic) NSArray *towers;

-(void)selectTowerFromButton:(UIButton *)button;

@end
