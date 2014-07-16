//
//  TAFreezeTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAFreezeTower.h"

@implementation TAFreezeTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"FreezeTower";
        self.size = CGSizeMake(TATowerSizeFreezeTower, TATowerSizeFreezeTower);
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.attackRadius = TATowerAttackRadiusFreezeTower;
    }
    return self;
}

@end
