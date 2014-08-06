//
//  TAAttacker.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-05.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAAttacker.h"

@implementation TAAttacker

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.size = CGSizeMake(40, 40);
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + self.size.height * 3 / 4);
        self.goldReward = TAEnemyGoldRewardAttacker;
        self.maximumHealth = TAEnemyMaximumHealthAttacker;
        self.description = @"Weak but relatively fast, attackers are common enemies, but not too much of a threat.";
        self.unitType = @"Attacker";
        self.imageName = @"Attacker";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
    }
    return self;
}

- (CGFloat)movementSpeed
{
    if ([super movementSpeed] == 0) {
        self.movementSpeed = arc4random() % 10 + TAEnemyMovementSpeedAttacker;
    }
    return [super movementSpeed];
}

@end
