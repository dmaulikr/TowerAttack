//
//  TABlastTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TABlastTower.h"

@implementation TABlastTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"BlastTower";
        self.size = CGSizeMake(TATowerSizeBlastTower, TATowerSizeBlastTower);
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.attackRadius = TATowerAttackRadiusBlastTower;
    }
    return self;
}

@end
