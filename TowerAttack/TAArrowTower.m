//
//  TAArrowTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAArrowTower.h"
#import "TAEnemy.h"

@implementation TAArrowTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"Tower";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.size = CGSizeMake(TATowerSizeArrowTower, TATowerSizeArrowTower);
        self.unitType = @"Arrow Tower";
        self.attackRadius = TATowerAttackRadiusArrowTower;
        self.projectileWAVSoundString = @"Arrow";
    }
    return self;
}

-(NSInteger)towerTypeFromSubclass
{
    return TATowerTypeArrowTower;
}

-(void)fireProjectile
{
    if ([self.enemiesInRange count] > 0) {
        TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange firstObject];
        CGFloat deltaX = enemy.position.x - self.position.x, deltaY = enemy.position.y - self.position.y;
        CGFloat rotation = atan2(deltaY, deltaX);
        self.projectileToFire.zRotation = rotation - M_PI_2;
    }
    [super fireProjectile];
}

-(SKEmitterNode *)projectile
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Arrow" ofType:@"sks"]];
}

@end

