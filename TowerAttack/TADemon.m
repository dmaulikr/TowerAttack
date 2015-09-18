//
//  TADemon.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-05.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TADemon.h"
#import "TAUIOverlay.h"
#import "TABattleScene.h"

@implementation TADemon

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.size = CGSizeMake(40, 40);
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + self.size.height * 3 / 4);
        self.goldReward = TAEnemyGoldRewardDemon;
        self.xpReward = TAEnemyXPRewardDemon;
        self.movementSpeed = arc4random() % 10 + TAEnemyMovementSpeedDemon;
        self.maximumHealth = TAEnemyMaximumHealthDemon;
        self.unitDescription = @"Demons are dangerously fast - don't let one get through: they take an extra life if they do!";
        self.unitType = @"Demon";
        self.imageName = @"Demon";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
    }
    return self;
}

- (CGFloat)movementSpeed
{
    if ([super movementSpeed] == 0) {
        self.movementSpeed = arc4random() % 10 + TAEnemyMovementSpeedDemon;
    }
    return [super movementSpeed];
}

-(void)finishPath
{
    self.battleScene.uiOverlay.livesLeft--;
    [super finishPath];
}

@end
