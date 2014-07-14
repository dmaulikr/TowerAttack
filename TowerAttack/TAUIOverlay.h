//
//  TAUIOverlay.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-09.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class TABattleScene;
@class TATower;

@interface TAUIOverlay : UIView

@property (weak, nonatomic) TABattleScene *battleScene;
@property (weak, nonatomic) TATower *selectedTower;
@property (strong, nonatomic) SKSpriteNode *selectedNode;
@property (nonatomic) NSUInteger currentGold;
@property (nonatomic) NSInteger livesLeft;
@property (strong, nonatomic) UILabel *displayLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;

-(id)initWithFrame:(CGRect)frame;
-(void)changeNodeOverlayLocation:(CGPoint)point andHidden:(BOOL)hidden;
-(void)decideTowerPlacementFromButton:(UIButton *)button;

@end
