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

CGFloat panelY = 240;

@implementation TAUIOverlay


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 200, 60)];
        self.livesLeft = 10;
        self.shouldPassTouches = YES;
        [self.displayLabel setFont:[UIFont fontWithName:@"Cochin" size:15]];
        self.displayLabel.numberOfLines = 2;
        [self addSubview:self.displayLabel];
        self.currentGold = 100;
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton setImage:[UIImage imageNamed:@"Confirm"] forState:UIControlStateNormal];
        self.confirmButton.hidden = YES;
        self.confirmButton.tag = 0;
        self.cancelButton.tag = 1;
        self.cancelButton.hidden = YES;
        self.purchaseSidebar = [[TATowerPurchaseSidebar alloc] initWithFrame:CGRectMake(500, 0, 68, 320)];
        [self addSubview:self.purchaseSidebar];
        [self addSubview:self.cancelButton];
        [self addSubview:self.confirmButton];
        [self.cancelButton addTarget:self action:@selector(decideTowerPlacementFromButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmButton addTarget:self action:@selector(decideTowerPlacementFromButton:) forControlEvents:UIControlEventTouchUpInside];
        self.infoPanel = [[TATowerInfoPanel alloc] initWithFrame:CGRectMake(0, 320, 568, 100)];
        [self addSubview:self.infoPanel];
    }
    return self;
}

-(void)changeNodeOverlayLocation:(CGPoint)point andHidden:(BOOL)hidden
{
    if (!hidden) {
        [self.cancelButton setFrame:CGRectMake(point.x + (float)self.selectedNode.size.width / 15.0f, point.y + (float)self.selectedNode.size.width / (1.0f + 2.0f/3.0f), (float)self.selectedNode.size.width / 2.0f, (float)self.selectedNode.size.width / 2.0f)];
        [self.confirmButton setFrame:CGRectMake(point.x - (float)self.selectedNode.size.width / 2.0f, point.y + (float)self.selectedNode.size.width / (1.0f + 2.0f/3.0f), (float)self.selectedNode.size.width / 2.0f, (float)self.selectedNode.size.width / 2.0f)];
    }
    self.confirmButton.hidden = hidden;
    self.cancelButton.hidden = hidden;
    self.lastOverlayLocation = point;
}

-(void)decideTowerPlacementFromButton:(UIButton *)button
{
    if (button.tag == 0 && [self.selectedNode.color isEqual:[UIColor greenColor]]) {
        [self.battleScene addTower];
        [[self.battleScene childNodeWithName:@"Placeholder"] removeFromParent];
        [self changeNodeOverlayLocation:CGPointMake(0,0) andHidden:YES];
    }
    else if (button.tag == 1) {
        [[self.battleScene childNodeWithName:@"Placeholder"] removeFromParent];
        [self changeNodeOverlayLocation:CGPointMake(0,0) andHidden:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.infoPanel.frame.origin.y == panelY) {
        if ([[touches anyObject] locationInView:self].y < panelY) {
            [UIView animateWithDuration:0.25 animations:^(void) {
                self.infoPanel.frame = CGRectMake(0, 568, 568, 80);
                self.purchaseSidebar.frame = CGRectMake(500, 0, 68, 320);
            }];
        }
        self.shouldPassTouches = NO;
    }
    else {
        [self.battleScene touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.shouldPassTouches) {
        [self.battleScene touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.shouldPassTouches) {
        [self.battleScene touchesEnded:touches withEvent:event];
    }
    else {
        self.shouldPassTouches = YES;
    }
}

 -(void)setCurrentGold:(NSUInteger)currentGold
{
    [self.displayLabel setText:[NSString stringWithFormat:@"Gold: %lu\nLives: %ld",(unsigned long)currentGold,(long)self
                                .livesLeft]];
    _currentGold = currentGold;
}

-(void)setLivesLeft:(NSInteger)livesLeft
{
    [self.displayLabel setText:[NSString stringWithFormat:@"Gold: %lu\nLives: %ld",(unsigned long)self.currentGold,(long)livesLeft]];
    if (livesLeft == 0) {
        [self.battleScene.scene.view setPaused:YES];
        UILabel *endGame = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, self.frame.size.width / 2 - 25, 200, 50)];
        [endGame setText:@"YOU LOSE"];
        [endGame setFont:[UIFont fontWithName:@"Cochin" size:30]];
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
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.infoPanel.frame = CGRectMake(0, panelY, 568, 80);
        self.purchaseSidebar.frame = CGRectMake(568, 0, 68, 320);
    }];
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
