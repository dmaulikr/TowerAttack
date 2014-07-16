//
//  TATower.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TAUnit.h"

@class TAEnemy;
@class TABattleScene;

extern NSInteger const maxTowerLevel;

enum TATowerType : NSInteger {
    TATowerTypeTower,
    TATowerTypeFreezeTower,
    TATowerTypeBlastTower,
    TATowerTypeNoTower
};

enum TATowerSize : NSInteger {
    TATowerSizeTower = 50,
    TATowerSizeFreezeTower = 40,
    TATowerSizeBlastTower = 45
};

enum TATowerAttackRadius : NSInteger {
    TATowerAttackRadiusTower = 100,
    TATowerAttackRadiusFreezeTower = 70,
    TATowerAttackRadiusBlastTower = 55
};

@interface TATower : TAUnit

@property (nonatomic) CGFloat spaceUsedRadius;
@property (nonatomic) CGFloat attackRadius;
@property (nonatomic) CGFloat timeBetweenAttacks;
@property (nonatomic) NSInteger attackDamage;
@property (nonatomic) NSInteger projectileSpeed;
@property (nonatomic) BOOL isAttacking;
@property (nonatomic, strong) NSTimer *attackUpdate;
@property (nonatomic, strong) NSMutableSet *enemiesInRange;
@property (nonatomic) NSUInteger purchaseCost;
@property (nonatomic) NSUInteger towerLevel;

-(void)beginAttackOnEnemy: (TAEnemy *)enemy;
-(void)endAttack;
-(void)fireProjectileCalledByTimer: (NSTimer *)timer;
+(NSArray *)towerNames;
+(NSArray *)towerIconStrings;


@end
