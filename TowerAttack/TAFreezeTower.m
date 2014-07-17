//
//  TAFreezeTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAFreezeTower.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"
#import "TAEnemy.h"


@implementation TAFreezeTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"FreezeTower";
        self.size = CGSizeMake(TATowerSizeFreezeTower, TATowerSizeFreezeTower);
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.attackRadius = TATowerAttackRadiusFreezeTower;
        self.unitType = @"Freeze Tower";
        self.affectedEnemyStats = [NSMutableArray array];
        SKEmitterNode *frost = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Frost" ofType:@"sks"]];
        frost.zPosition = 0.4;
        [self addChild:frost];
    }
    return self;
}



-(void)beginAttack
{
    TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange lastObject];
    [enemy setColor:[SKColor purpleColor]];//[UIColor colorWithRed:155.0f/255.0f green:255.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [enemy setColorBlendFactor:1.0];
    [self.affectedEnemyStats addObject:[NSNumber numberWithFloat:[enemy movementSpeed]]];
    //enemy.movementSpeed /= 2;
    enemy.speed = 0.5;
    enemy.healthBarInside.speed = 0.5;
}

-(void)endAttackOnEnemy:(TAEnemy *)enemy
{
    enemy.color = [SKColor whiteColor];
  //  enemy.movementSpeed = [(NSNumber *)[self.affectedEnemyStats objectAtIndex:[self.enemiesInRange indexOfObject:enemy]] floatValue];
    enemy.speed = 1;
    enemy.healthBarInside.speed = 1;
    [self.affectedEnemyStats removeObjectAtIndex:[self.enemiesInRange indexOfObject:enemy]];
}

@end
