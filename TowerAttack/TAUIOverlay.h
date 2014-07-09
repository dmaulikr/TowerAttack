//
//  TAUIOverlay.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-09.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TABattleScene;

@interface TAUIOverlay : UIView

@property (weak, nonatomic) TABattleScene *battleScene;
@property (nonatomic) NSUInteger currentGold;
@property (strong, nonatomic) UILabel *goldLabel;

-(id)initWithFrame:(CGRect)frame;

@end
