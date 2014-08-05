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

CGFloat const panelY = 240;

@implementation TAUIOverlay


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.displayLabel = [[TALabel alloc] initWithFrame:CGRectMake(0, 5, 45, 60) andFontSize:20];
        self.displayLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.displayLabel];
        UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
        heart.frame = CGRectMake(50, 39, 16, 16);
        [self addSubview:heart];
        UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin2"]];
        coin.frame = CGRectMake(50, 16, 16, 16);
        [self addSubview:coin];
        self.livesLeft = 10;
        self.shouldPassTouches = YES;
        self.currentGold = 100;
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton setImage:[UIImage imageNamed:@"Confirm"] forState:UIControlStateNormal];
        self.confirmButton.alpha = 0;
        self.confirmButton.tag = 0;
        self.cancelButton.tag = 1;
        self.cancelButton.alpha = 0;
        self.lastScale = 1.0f;
        self.purchaseSidebar = [[TATowerPurchaseSidebar alloc] initWithFrame:CGRectMake(screenWidth - 68, 0, 68, 320)];
        [self addSubview:self.purchaseSidebar];
        [self addSubview:self.cancelButton];
        [self addSubview:self.confirmButton];
        [self.cancelButton addTarget:self action:@selector(decideTowerPlacementFromButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton addTarget:self action:@selector(decideTowerPlacementFromButton:) forControlEvents:UIControlEventTouchUpInside];
        self.infoPanel = [[TATowerInfoPanel alloc] initWithFrame:CGRectMake(0, 320, screenWidth, 100)];
        [self addSubview:self.infoPanel];
        
        UIPinchGestureRecognizer *pinchListener = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(userPinchedWithInfo:)];
        [self addGestureRecognizer:pinchListener];
    }
    return self;
}

-(void)changeNodeOverlayLocation:(CGPoint)point andHidden:(BOOL)hidden
{
    if (!hidden) {
        [self.cancelButton setFrame:CGRectMake(point.x + (float)self.selectedNode.size.width / 15.0f, point.y + (float)self.selectedNode.size.width / (1.0f + 2.0f/3.0f), (float)self.selectedNode.size.width / 2.0f, (float)self.selectedNode.size.width / 2.0f)];
        [self.confirmButton setFrame:CGRectMake(point.x - (float)self.selectedNode.size.width / 2.0f, point.y + (float)self.selectedNode.size.width / (1.0f + 2.0f/3.0f), (float)self.selectedNode.size.width / 2.0f, (float)self.selectedNode.size.width / 2.0f)];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // if (self.infoPanel.frame.origin.y == panelY) {
   /* if ([[touches anyObject] locationInView:self].y > panelY) {
            [UIView animateWithDuration:0.25 animations:^(void) {
                self.infoPanel.frame = CGRectMake(0, screenWidth, screenWidth, 80);
                self.purchaseSidebar.frame = CGRectMake(500, 0, 68, 320);
            }];
        }
        self.shouldPassTouches = NO;
    }
    else {*/
 //   self.lastScale = sca
    [self.battleScene touchesBegan:touches withEvent:event];    
     //self.anchorPoint = [self.battleScene.scene convertPoint:[self.battleScene.scene convertPointFromView:[[touches anyObject] locationInView:self]] toNode:self.battleScene];
    
  //  NSLog(@"%f %f",self.anchorPoint.x,self.anchorPoint.y);
    //  CGPoint anchorPoint = CGPointMake(pointInBattleScene.x, pointInBattleScene.y);
  //  CGPoint originalPoint = [self.battleScene.scene convertPointFromView:[[touches anyObject] locationInView:self]];

   // }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  //  if (self.shouldPassTouches) {
        [self.battleScene touchesMoved:touches withEvent:event];
  //  }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
 //   if (self.shouldPassTouches) {
        [self.battleScene touchesEnded:touches withEvent:event];
 /*   }
    else {
        self.shouldPassTouches = YES;
    }*/
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
        if (1200 * scale < screenWidth) {
            scale = screenWidth / 1200;
        }
        [self.battleScene runAction:[SKAction scaleTo:scale duration:0] completion:^{
            CGPoint newAnchorPoint = [self.battleScene.scene convertPoint:[self.battleScene.scene convertPointFromView:point] toNode:self.battleScene];
            CGFloat deltaX = newAnchorPoint.x - self.anchorPoint.x, deltaY = newAnchorPoint.y - self.anchorPoint.y;
            if (self.battleScene.position.x + deltaX > 0) {
                deltaX = (CGFloat)self.battleScene.position.x * -1;
            }
            else if (self.battleScene.position.x * -1 - deltaX + self.frame.size.width >= 1200 * scale) {
                deltaX = (1200 * scale + self.battleScene.position.x - self.frame.size.width) * -1;
            }
            if (self.battleScene.position.y + deltaY > 0) {
                deltaY = self.battleScene.position.y * -1;
            }
            else if ((self.battleScene.position.y + deltaY) * -1 + self.frame.size.height >= 900 * scale) {
                deltaY = (900 * scale + self.battleScene.position.y - self.frame.size.height) * -1;
            }
            self.battleScene.position = CGPointMake(self.battleScene.position.x + deltaX, self.battleScene.position.y + deltaY);
            self.battleScene.scale = scale;
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
    }
}

 -(void)setCurrentGold:(NSUInteger)currentGold
{
    [self.displayLabel setText:[NSString stringWithFormat:@"%lu\n%ld",(unsigned long)currentGold,(long)self
                                .livesLeft]];
    _currentGold = currentGold;
}

-(void)setLivesLeft:(NSInteger)livesLeft
{
    [self.displayLabel setText:[NSString stringWithFormat:@"%lu\n%ld",(unsigned long)self.currentGold,(long)livesLeft]];
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
            self.infoPanel.frame = CGRectMake(0, panelY, screenWidth, 80);
            self.purchaseSidebar.frame = CGRectMake(screenWidth, 0, 68, 320);
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^(void) {
            self.infoPanel.frame = CGRectMake(0, 320, screenWidth, 80);
            self.purchaseSidebar.frame = CGRectMake(screenWidth - 68, 0, 68, 320);
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
