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
@class TALabel;
@class TAButton;

@interface TATowerInfoPanel : UIView

@property (weak, nonatomic) TAUnit *selectedUnit;
@property (strong, nonatomic) UIImageView *unitIcon;
@property (strong, nonatomic) TALabel *unitName;
@property (strong, nonatomic) TALabel *unitDescription;
@property (strong, nonatomic) TALabel *otherUnitInfo;
@property (strong, nonatomic) TAButton *upgradeButton;
@property (strong, nonatomic) TAButton *sellButton;
@property (strong, nonatomic) NSLayoutConstraint *aspectConstraint;
//@property (strong, nonatomic) NSArray *additionalUnitInfo;

-(id)initWithFrame:(CGRect)frame;
-(void)upgradeSelectedTower;
-(void)sellSelectedTower;
-(void)refreshLabelsWithInfo:(NSArray *)otherUnitInfoStrings;

@end
