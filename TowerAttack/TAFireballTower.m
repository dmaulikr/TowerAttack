//
//  TAFireballTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAFireballTower.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"
#import "TAEnemy.h"

@implementation TAFireballTower


-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"Fire";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.size = CGSizeMake(TATowerSizeFireballTower, TATowerSizeFireballTower);
        self.unitType = @"Fireball Tower";
        self.attackRadius = TATowerAttackRadiusFireballTower;
    }
    return self;
}

-(SKEmitterNode *)projectile
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Projectile" ofType:@"sks"]];
}

-(NSInteger)towerTypeFromSubclass
{
    return TATowerTypeFireballTower;
}

@end
