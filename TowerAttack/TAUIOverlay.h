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
@class TANonPassiveTower;
@class TATowerInfoPanel;
@class TAUnit;
@class TATowerPurchaseSidebar;
@class TALabel;
@class TAButton;

extern CGFloat const panelY;

@interface TAUIOverlay : UIView

@property (weak, nonatomic) TABattleScene *battleScene;
@property (weak, nonatomic) TAUnit *selectedUnit;
@property (strong, nonatomic) SKSpriteNode *selectedNode;
@property (nonatomic) NSUInteger currentGold;
@property (nonatomic) NSInteger livesLeft;
@property (strong, nonatomic) TALabel *topDisplayLabel;
@property (strong, nonatomic) TALabel *bottomDisplayLabel;
@property (strong, nonatomic) UIProgressView *xpBar;
@property (strong, nonatomic) UIButton *startWaveButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) TATowerInfoPanel *infoPanel;
@property (strong, nonatomic) TATowerPurchaseSidebar *purchaseSidebar;
@property (nonatomic) BOOL shouldPassTouches;
@property (nonatomic) CGPoint lastOverlayLocation;
@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CGPoint scenePoint;
@property (nonatomic) CGFloat lastScale;
@property (nonatomic) CGFloat sceneScale;


-(id)initWithFrame:(CGRect)frame;
-(void)changeNodeOverlayLocation:(CGPoint)point andHidden:(BOOL)hidden;
-(void)decideTowerPlacementFromButton:(UIButton *)button;
-(void)userPinchedWithInfo:(UIPinchGestureRecognizer *)listener;
-(void)startWave;
-(void)pauseGame;
-(void)resumeGame;
-(void)endGame;
-(void)presentNotificationWithText:(NSString *)text;
-(void)configureBottomLabel;
-(void)popText:(NSString *)text withColour:(UIColor *)colour overPoint:(CGPoint)point completion:(void (^)(void))block;

@end
