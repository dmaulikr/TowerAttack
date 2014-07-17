//
//  TATowerInfoPanel.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TANonPassiveTower;
@class TAUnit;

@interface TATowerInfoPanel : UIView

@property (weak, nonatomic) TAUnit *selectedUnit;
@property (strong, nonatomic) UIImageView *unitIcon;
@property (strong, nonatomic) UILabel *unitName;
@property (strong, nonatomic) UILabel *unitDescription;
@property (strong, nonatomic) UIButton *upgradeButton;
@property (strong, nonatomic) NSArray *additionalUnitInfo;

-(id)initWithFrame:(CGRect)frame;
-(void)upgradeSelectedTower;

@end
