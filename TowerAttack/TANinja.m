//
//  TANinja.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-06.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TANinja.h"
#import "TAUIOverlay.h"
#import "TABattleScene.h"

@implementation TANinja

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.size = CGSizeMake(60, 40);
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + self.size.height * 3 / 4);
        self.goldReward = TAEnemyGoldRewardNinja;
        self.xpReward = TAEnemyXPRewardNinja;
        self.movementSpeed = arc4random() % 10 + TAEnemyMovementSpeedNinja;
        self.maximumHealth = TAEnemyMaximumHealthNinja;
        self.unitDescription = @"Killing a ninja is never a sure thing, because they have a chance to dodge any damaging attack!";
        self.unitType = @"Ninja";
        self.imageName = @"Ninja";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
    }
    return self;
}

- (CGFloat)movementSpeed
{
    if ([super movementSpeed] == 0) {
        self.movementSpeed = arc4random() % 10 + TAEnemyMovementSpeedNinja;
    }
    return [super movementSpeed];
}

-(void)setCurrentHealth:(CGFloat)currentHealth
{
    if (arc4random() % 2 || currentHealth == self.maximumHealth || super.currentHealth - currentHealth <= 1) {
        [super setCurrentHealth:currentHealth];
    }
    else {
        [self.battleScene.uiOverlay popText:@"Dodge" withColour:[UIColor blueColor] overPoint:self.position completion:nil];
    }
}

@end
