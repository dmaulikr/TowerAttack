//
//  TATower.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAUnit.h"

@class TAEnemy;
@class TABattleScene;

extern NSInteger const maxTowerLevel;

enum TATowerType : NSInteger {
    TATowerTypeArrowTower,
    TATowerTypeFreezeTower,
    TATowerTypeBlastTower,
    TATowerTypePsychicTower,
    TATowerTypeFireballTower,
    TATowerTypeNoTower
};

enum TATowerSize : NSInteger {
    TATowerSizeArrowTower = 46,
    TATowerSizeFreezeTower = 40,
    TATowerSizeBlastTower = 45,
    TATowerSizePsychicTower = 60,
    TATowerSizeFireballTower = 50,
};

enum TATowerAttackRadius : NSInteger {
    TATowerAttackRadiusArrowTower = 90,
    TATowerAttackRadiusFreezeTower = 70,
    TATowerAttackRadiusBlastTower = 55,
    TATowerAttackRadiusPsychicTower = 150,
    TATowerAttackRadiusFireballTower = 100,
};

enum TATowerLevelDataStatPosition : NSInteger {
    TATowerLevelDataStatPositionAttackDamage,
    TATowerLevelDataStatPositionAttackRadius,
    TATowerLevelDataStatPositionTimeBetweenAttacks,
    TATowerLevelDataStatPositionEnemySpeedMultiplier
};

@interface TATower : TAUnit

@property (nonatomic) CGFloat attackRadius;
@property (nonatomic, strong) NSMutableArray *enemiesInRange;
@property (nonatomic, strong) NSMutableArray *levelStripes;
@property (nonatomic) NSUInteger purchaseCost;
@property (nonatomic) NSUInteger towerType;
@property (nonatomic) NSInteger towerLevel;
@property (nonatomic) BOOL isPassive;

-(void)beginAttack;
-(void)endAttack;
-(void)endAttackOnEnemy:(TAEnemy *)enemy;

@end
