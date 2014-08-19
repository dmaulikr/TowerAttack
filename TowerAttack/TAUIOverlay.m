//
//  TAUIOverlay.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-09.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAUIOverlay.h"
#import "TABattleScene.h"
#import "TANonPassiveTower.h"
#import "TATowerInfoPanel.h"
#import "TAUnit.h"
#import "TATowerPurchaseSidebar.h"
#import "TALabel.h"
#import "TAButton.h"
#import "TAPLayerProfile.h"
#import "TAAreaSelectViewController.h"

CGFloat const panelY = 240;
CGFloat const purchaseBarWidth = 68;

@implementation TAUIOverlay

#pragma mark - configuration

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topDisplayLabel = [[TALabel alloc] initWithFrame:CGRectMake(0, 5, 45, 60) andFontSize:20];
        self.topDisplayLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.topDisplayLabel];
        
        self.currentGold = 100;
        self.lastScale = 1.0f;
        self.scenePoint = self.battleScene.position;
        self.sceneScale = 1.0f;
        self.livesLeft = 10;
        self.shouldPassTouches = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.bottomDisplayLabel = [[TALabel alloc] initWithFrame:CGRectMake(6, self.frame.size.height - 20, 200, 20) andFontSize:14];
        if (screenWidth == 480) {
            self.bottomDisplayLabel.fontSize = 12;
        }
        self.bottomDisplayLabel.textAlignment = NSTextAlignmentLeft;
        self.bottomDisplayLabel.numberOfLines = 1;
        self.bottomDisplayLabel.shouldResizeFontForSize = NO;
        [self addSubview:self.bottomDisplayLabel];
        
        self.xpBar = [[UIProgressView alloc] initWithFrame:CGRectMake(-1, self.frame.size.height - 5, 120, 4)];
        self.xpBar.progressTintColor = [UIColor colorWithRed:22.0f / 255.0f green:87.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f];
        self.xpBar.trackTintColor = [UIColor colorWithRed:255.0f / 255.0f green:254.0f / 255.0f blue:201.0f / 255.0f alpha:0.7f];
        [self addSubview:self.xpBar];
        self.xpBar.center = CGPointMake(self.xpBar.center.x, self.bottomDisplayLabel.center.y);
        
        [self configureBottomLabel];
    
        UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
        heart.frame = CGRectMake(50, 39, 16, 16);
        [self addSubview:heart];
        UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin2"]];
        coin.frame = CGRectMake(50, 16, 16, 16);
        [self addSubview:coin];
        
        self.startWaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startWaveButton setFrame:CGRectMake(screenWidth - purchaseBarWidth - 3 - 30, 2 + 25 + 2 - 40 + 25, 40, 40)];
        self.startWaveButton.adjustsImageWhenHighlighted = NO;
        [self.startWaveButton setImage:[UIImage imageNamed:@"StartWave"] forState:UIControlStateNormal];
    //    self.startWaveButton.alpha = 0.7;
        [self.startWaveButton addTarget:self action:@selector(startWave) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startWaveButton];
        
        self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pauseButton setFrame:CGRectMake(screenWidth - purchaseBarWidth - 3 - 30, 2 - 35 + 25, 40, 40)];
        [self.pauseButton setImage:[UIImage imageNamed:@"PauseButton"] forState:UIControlStateNormal];
        [self.pauseButton addTarget:self action:@selector(pauseGame) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pauseButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
        self.cancelButton.tag = 1;
        self.cancelButton.alpha = 0;
        [self addSubview:self.cancelButton];
        [self.cancelButton addTarget:self action:@selector(decideTowerPlacementFromButton:) forControlEvents:UIControlEventTouchUpInside];

        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton setImage:[UIImage imageNamed:@"Confirm"] forState:UIControlStateNormal];
        self.confirmButton.alpha = 0;
        self.confirmButton.tag = 0;
        [self addSubview:self.confirmButton];
        [self.confirmButton addTarget:self action:@selector(decideTowerPlacementFromButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.infoPanel = [[TATowerInfoPanel alloc] initWithFrame:CGRectMake(0, 320, screenWidth, 80)];
        [self addSubview:self.infoPanel];
        
        self.purchaseSidebar = [[TATowerPurchaseSidebar alloc] initWithFrame:CGRectMake(screenWidth - purchaseBarWidth, 0, purchaseBarWidth, 320)];
        [self addSubview:self.purchaseSidebar];
        
        UIPinchGestureRecognizer *pinchListener = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(userPinchedWithInfo:)];
        [self addGestureRecognizer:pinchListener];
        
    }
    return self;
}

-(void)configureBottomLabel
{
    TAPlayerProfile *profile = [TAPlayerProfile sharedInstance];

    NSInteger previousLevel = 0;
    if (self.xpBar.frame.origin.x > 0) {
        NSRange range = [self.bottomDisplayLabel.text rangeOfString:@"Level "];
        NSUInteger index = range.location + range.length;
        range = NSMakeRange(index, [self.bottomDisplayLabel.text rangeOfString:@" " options:0 range:NSMakeRange(index, self.bottomDisplayLabel.text.length - index)].location - index);
        previousLevel = [[self.bottomDisplayLabel.text substringWithRange:range] integerValue];
    }
    
    self.bottomDisplayLabel.text = [NSString stringWithFormat:@"Area %lu Wave %lu | %@: Level %lu (%luxp / %luxp)",(unsigned long)self.battleScene.currentArea, (unsigned long)self.battleScene.currentWave,profile.name,(unsigned long)profile.level,(unsigned long)profile.currentLevelXP,(unsigned long)profile.totalLevelXP];
    [self.bottomDisplayLabel sizeToFit];

    if (self.xpBar.frame.origin.x > 0) {
        NSInteger level = profile.level;
    //    NSInteger xpGained = [profile currentLevelXP] - self.xpBar.progress * [profile totalLevelXP];
        
        [self popText:[NSString stringWithFormat:@"%ldXP",(long)profile.lastXpGain] withColour:self.xpBar.progressTintColor overPoint:[self.battleScene convertPoint:[self.battleScene.scene convertPointFromView:CGPointMake(CGRectGetMaxX(self.bottomDisplayLabel.frame) + 20, self.xpBar.frame.origin.y - 10)] fromNode:self.battleScene.scene]  completion:nil];
        
        [self performSelectorInBackground:@selector(configureXPBarNumberOfLevels:) withObject:[NSNumber numberWithInteger:level - previousLevel]];
    }
    else {
        [self.xpBar setProgress:(CGFloat)[profile currentLevelXP] / (CGFloat)[profile totalLevelXP]];
    }
    
    CGFloat bufferSpace = 6.0, maxWidth = self.frame.size.width - purchaseBarWidth - bufferSpace - CGRectGetMaxX(self.bottomDisplayLabel.frame) - bufferSpace;
    
    self.xpBar.frame = CGRectMake(CGRectGetMaxX(self.bottomDisplayLabel.frame) + 6, self.xpBar.frame.origin.y, maxWidth, self.xpBar.frame.size.height);
}

-(void)configureXPBarNumberOfLevels:(NSNumber *)levels
{
    for (int i = 0; i < [levels intValue]; i++) {
        [self.xpBar setProgress:1.0 animated:YES];
        [self.xpBar setProgress:0.0];
    }
    [self.xpBar setProgress:(CGFloat)[[TAPlayerProfile sharedInstance] currentLevelXP] / (CGFloat)[[TAPlayerProfile sharedInstance] totalLevelXP] animated:YES];
}

#pragma mark - confirm / cancel button handling

-(void)decideTowerPlacementFromButton:(UIButton *)button
{
    if (button.tag == 0 && [self.selectedNode.color isEqual:[UIColor greenColor]]) {
        [self.battleScene addTower];
        [[self.battleScene childNodeWithName:@"Placeholder"] removeFromParent];
        [self changeNodeOverlayLocation:CGPointMake(0,0) andHidden:YES];
        self.battleScene.towerRadiusDisplay.alpha = 0.0;
    }
    else if (button.tag == 1) {
        [[self.battleScene childNodeWithName:@"Placeholder"] removeFromParent];
        [self changeNodeOverlayLocation:CGPointMake(0,0) andHidden:YES];
        self.battleScene.towerRadiusDisplay.alpha = 0.0;
    }
}

-(void)changeNodeOverlayLocation:(CGPoint)point andHidden:(BOOL)hidden
{
    if (!hidden) {
        [self.cancelButton setFrame:CGRectMake(point.x + (float)self.selectedNode.size.width / 15.0f * self.battleScene.scale, point.y + (float)self.selectedNode.size.width / (1.0f + 2.0f/3.0f) * self.battleScene.scale, (float)self.selectedNode.size.width / 2.0f * self.battleScene.scale, (float)self.selectedNode.size.width / 2.0f * self.battleScene.scale)];
        [self.confirmButton setFrame:CGRectMake(point.x - (float)self.selectedNode.size.width / 2.0f * self.battleScene.scale, point.y + (float)self.selectedNode.size.width / (1.0f + 2.0f/3.0f) * self.battleScene.scale, (float)self.selectedNode.size.width / 2.0f * self.battleScene.scale, (float)self.selectedNode.size.width / 2.0f * self.battleScene.scale)];
    }
    if (hidden) {
        self.confirmButton.alpha = 0;
        self.cancelButton.alpha = 0;
    }
    else {
        self.confirmButton.alpha = 1;
        self.cancelButton.alpha = 1;
    }
    self.lastOverlayLocation = point;
}

#pragma mark - respond to touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.battleScene isPaused]) {
        [self.battleScene touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.battleScene isPaused]) {
        [self.battleScene touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.battleScene isPaused]) {
        [self.battleScene touchesEnded:touches withEvent:event];
    }
}

-(void)userPinchedWithInfo:(UIPinchGestureRecognizer *)listener
{
    CGPoint touchZero = [listener locationOfTouch:0 inView:self], touchOne = [listener locationOfTouch:0 inView:self];
    if ([listener numberOfTouches] > 1) {
        touchOne = [listener locationOfTouch:1 inView:self];
    }
    CGFloat scale = listener.scale * self.lastScale;
    CGPoint point = CGPointMake((touchZero.x + touchOne.x) / 2, (touchZero.y + touchOne.y) / 2);
    if (listener.state == UIGestureRecognizerStateChanged) {
        if (areaWidth * scale < screenWidth) {
            scale = screenWidth / areaWidth;
        }
        [self changeNodeOverlayLocation:CGPointMake(0, 0) andHidden:YES];
        [self.battleScene runAction:[SKAction scaleTo:scale duration:0] completion:^{
            CGPoint newAnchorPoint = [self.battleScene.scene convertPoint:[self.battleScene.scene convertPointFromView:point] toNode:self.battleScene];
            CGFloat deltaX = newAnchorPoint.x - self.anchorPoint.x, deltaY = newAnchorPoint.y - self.anchorPoint.y;
            if (self.battleScene.position.x + deltaX > 0) {
                deltaX = (CGFloat)self.battleScene.position.x * -1;
            }
            else if (self.battleScene.position.x * -1 - deltaX + self.frame.size.width >= areaWidth * scale) {
                deltaX = (areaWidth * scale + self.battleScene.position.x - self.frame.size.width) * -1;
            }
            if (self.battleScene.position.y + deltaY > 0) {
                deltaY = self.battleScene.position.y * -1;
            }
            else if ((self.battleScene.position.y + deltaY) * -1 + self.frame.size.height >= areaHeight * scale) {
                deltaY = (areaHeight * scale + self.battleScene.position.y - self.frame.size.height) * -1;
            }
   //         self.battleScene.position = CGPointMake(self.battleScene.position.x + deltaX, self.battleScene.position.y + deltaY);
   //         self.battleScene.scale = scale;
            self.sceneScale = scale;
            self.scenePoint = CGPointMake(self.battleScene.position.x + deltaX, self.battleScene.position.y + deltaY);
     //       CGPoint pointCheck = [self.battleScene.scene convertPoint:[self.battleScene.scene convertPointFromView:point] toNode:self.battleScene];
     //       NSLog(@"new: %f %f old: %f %f check: %f %f position: %f %f",newAnchorPoint.x,newAnchorPoint.y,self.anchorPoint.x,self.anchorPoint.y, pointCheck.x, pointCheck.y, self.battleScene.position.x, self.battleScene.position.y);
     //       NSLog(@"%f",scale);
        }];
    }
    else if (listener.state == UIGestureRecognizerStateBegan) {
        self.anchorPoint = [self.battleScene.scene convertPoint:[self.battleScene.scene convertPointFromView:point] toNode:self.battleScene];
    }
    else if (listener.state == UIGestureRecognizerStateEnded) {
        self.lastScale = scale;
        [self changeNodeOverlayLocation:[self.battleScene.scene convertPointToView:[self.battleScene convertPoint:[[self.battleScene childNodeWithName:@"Placeholder"] position] toNode:self.battleScene.scene]] andHidden:NO];
    }
}

#pragma mark - change game states

-(void)startWave
{
    self.battleScene.waveIsSpawning = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.startWaveButton.alpha = 0;
    }];
}

-(void)pauseGame
{
    [self.battleScene setPaused:YES];
    
    UIView *grayCover = [[UIView alloc] initWithFrame:self.frame];
    grayCover.tag = 20;
    grayCover.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    grayCover.alpha = 0;
    [self addSubview:grayCover];
    
    TAButton *resume = [[TAButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40) andFontSize:20];
    [resume setTitle:@"Resume" forState:UIControlStateNormal];
    resume.center = self.center;
    resume.tag = 21;
    resume.alpha = 0;
    [self addSubview:resume];
    [resume addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
    
    TAButton *settings = [[TAButton alloc] initWithFrame:resume.frame andFontSize:20];
    [settings setTitle:@"Settings" forState:UIControlStateNormal];
    settings.tag = 22;
    settings.alpha = 0;
    [self addSubview:settings];
    
    TAButton *exit = [[TAButton alloc] initWithFrame:resume.frame andFontSize:20];
    [exit setTitle:@"Exit" forState:UIControlStateNormal];
    exit.tag = 23;
    exit.alpha = 0;
    [self addSubview:exit];
    [exit addTarget:self action:@selector(endGame) forControlEvents:UIControlEventTouchUpInside];
    
    TALabel *pauseLabel = [[TALabel alloc] initWithFrame:CGRectMake(screenWidth / 2 - 160 / 2, 20, 160, 50) andFontSize:45];
    pauseLabel.text = @"Paused";
    pauseLabel.textColor = [UIColor whiteColor];
    pauseLabel.alpha = 0;
    pauseLabel.tag = 24;
    [self addSubview:pauseLabel];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat bufferSpace = 15;
                         resume.frame = CGRectMake(resume.frame.origin.x, resume.frame
                                                   .origin.y - resume.frame.size.height - bufferSpace, resume.frame.size.width, resume.frame.size.height);
                         exit.frame = CGRectMake(exit.frame.origin.x, exit.frame
                                                   .origin.y + exit.frame.size.height + bufferSpace, exit.frame.size.width, exit.frame.size.height);
                         grayCover.alpha = 0.4;
                         resume.alpha = 1.0;
                         settings.alpha = 1.0;
                         exit.alpha = 1.0;
                         pauseLabel.alpha = 0.7;
                     }completion:nil];
}

-(void)resumeGame
{
    UIView *grayCover = [self viewWithTag:20];
    TAButton *resume = (TAButton *)[self viewWithTag:21];
    TAButton *settings = (TAButton *)[self viewWithTag:22];
    TAButton *exit = (TAButton *)[self viewWithTag:23];
    TALabel *pauseLabel = (TALabel *)[self viewWithTag:24];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         resume.frame = settings.frame;
                         exit.frame = settings.frame;
                         grayCover.alpha = 0;
                         resume.alpha = 0;
                         settings.alpha = 0;
                         exit.alpha = 0;
                         pauseLabel.alpha = 0;
                     }completion:^(BOOL finished) {
                         [grayCover removeFromSuperview];
                         [resume removeFromSuperview];
                         [settings removeFromSuperview];
                         [exit removeFromSuperview];
                         [pauseLabel removeFromSuperview];
                         [self.battleScene setPaused:NO];
                     }];
}

-(void)endGame
{
 //   [self.battleScene.scene.view presentScene:nil];
    TAAreaSelectViewController *v = (TAAreaSelectViewController *)[self.battleScene.scene.view.superview nextResponder];
    
    [v performSegueWithIdentifier:@"Unwind" sender:v];
    [self.battleScene.scene.view removeFromSuperview];
  //  [v.view setBackgroundColor:[UIColor whiteColor]];
  //  NSLog(@"%@",v.view.backgroundColor);
}


#pragma mark - show text

-(void)presentNotificationWithText:(NSString *)text
{
    CGFloat x = self.frame.size.width / 2 - 150, y = -80, width = self.frame.size.width - x * 2, height = y * -1;
    TAButton *notification = [[TAButton alloc] initWithFrame:CGRectMake(x, y, width, height) andFontSize:40];
    [notification setTitle:text forState:UIControlStateNormal];
    [self addSubview:notification];
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         notification.frame = CGRectMake(notification.frame.origin.x, self.frame.size.height / 2 - notification.frame.size.height / 2, notification.frame.size.width, notification.frame.size.height);
                         self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
                     }
                     completion:nil];
}

-(void)popText:(NSString *)text withColour:(UIColor *)colour overPoint:(CGPoint)point completion:(void (^)(void))block
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Cochin-Bold"];
    label.fontColor = colour;
    label.fontSize = 13;
    label.text = text;
    label.zPosition = TANodeZPositionPlaceholder + 1;
    label.position = point;
    [self.battleScene addChild:label];
    [label runAction:[SKAction group:@[[SKAction moveBy:CGVectorMake(0, 20) duration:1.5],[SKAction fadeAlphaTo:0 duration:1.5]]] completion:^{
        [label removeFromParent];
        if (block) { block(); }
    }];
}

#pragma mark - setters

 -(void)setCurrentGold:(NSUInteger)currentGold
{
    [self.topDisplayLabel setText:[NSString stringWithFormat:@"%lu\n%ld",(unsigned long)currentGold,(long)self
                                .livesLeft]];
    _currentGold = currentGold;
}

-(void)setLivesLeft:(NSInteger)livesLeft
{
    [self.topDisplayLabel setText:[NSString stringWithFormat:@"%lu\n%ld",(unsigned long)self.currentGold,(long)livesLeft]];
    if (livesLeft == 0) {
        [self.battleScene.scene.view setPaused:YES];
        TALabel *endGame = [[TALabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, self.frame.size.width / 2 - 25, 200, 50) andFontSize:30];
        [endGame setText:@"YOU LOSE"];
        [self addSubview:endGame];
    }
    _livesLeft = livesLeft;
}

-(void)setSelectedNode:(SKSpriteNode *)selectedNode //this property is for the placeholder
{
    _selectedNode = selectedNode;
   // [self changeNodeOverlayLocation:[self.battleScene.scene convertPointToView:selectedNode.position] andHidden:NO];
}

-(void)setSelectedUnit:(TAUnit *)selectedUnit
{
    _selectedUnit = selectedUnit;
    _selectedNode = selectedUnit;
    self.infoPanel.selectedUnit = selectedUnit;
    if (selectedUnit != nil) {
        [UIView animateWithDuration:0.25 animations:^(void) {
            self.infoPanel.frame = CGRectMake(0, self.frame.size.height - self.infoPanel.frame.size.height, screenWidth, self.infoPanel.frame.size.height);
            self.bottomDisplayLabel.frame = CGRectMake(self.bottomDisplayLabel.frame.origin.x, self.infoPanel.frame.origin.y - 20, self.bottomDisplayLabel.frame.size.width, self.bottomDisplayLabel.frame.size.height);
            self.xpBar.center = CGPointMake(self.xpBar.center.x, self.bottomDisplayLabel.center.y);
            self.purchaseSidebar.frame = CGRectMake(screenWidth, 0, purchaseBarWidth, self.frame.size.height);
            self.pauseButton.frame = CGRectMake(screenWidth - 2 - 30, self.pauseButton.frame.origin.y, self.pauseButton.frame.size.width, self.pauseButton.frame.size.height);
            self.startWaveButton.frame = CGRectMake(screenWidth - 2 - 30, self.startWaveButton.frame.origin.y, self.startWaveButton.frame.size.width, self.startWaveButton.frame.size.height);
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^(void) {
            self.infoPanel.frame = CGRectMake(0, self.frame.size.height, screenWidth, self.infoPanel.frame.size.height);
            self.bottomDisplayLabel.frame = CGRectMake(self.bottomDisplayLabel.frame.origin.x, self.frame.size.height - 20, self.bottomDisplayLabel.frame.size.width, self.bottomDisplayLabel.frame.size.height);
            self.xpBar.center = CGPointMake(self.xpBar.center.x, self.bottomDisplayLabel.center.y);
            self.purchaseSidebar.frame = CGRectMake(screenWidth - purchaseBarWidth, 0, purchaseBarWidth, self.frame.size.height);
            self.pauseButton.frame = CGRectMake(screenWidth - 2 - purchaseBarWidth - 30, self.pauseButton.frame.origin.y, self.pauseButton.frame.size.width, self.pauseButton.frame.size.height);
            self.startWaveButton.frame = CGRectMake(screenWidth - 2 - purchaseBarWidth - 30, self.startWaveButton.frame.origin.y, self.startWaveButton.frame.size.width, self.startWaveButton.frame.size.height);
        }];
    }
    //code for bringing up tower upgrade / info overlay
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
