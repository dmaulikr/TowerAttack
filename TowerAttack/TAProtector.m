//
//  TAProtector.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-05.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAProtector.h"

@implementation TAProtector

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.size = CGSizeMake(60, 40);
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + self.size.height * 3 / 4);
        self.goldReward = TAEnemyGoldRewardProtector;
        self.xpReward = 350;//TAEnemyXPRewardProtector;
        self.maximumHealth = TAEnemyMaximumHealthProtector;
        self.description = @"Protectors are slow but heavily fortified, making them difficult to kill quickly.";
        self.unitType = @"Protector";
        self.imageName = @"Protector";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
    }
    return self;
}

- (CGFloat)movementSpeed
{
    if ([super movementSpeed] == 0) {
        self.movementSpeed = arc4random() % 10 + TAEnemyMovementSpeedProtector;
    }
    return [super movementSpeed];
}

@end
