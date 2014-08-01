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
        self.description = (NSString *)[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerDescriptions"] objectAtIndex:TATowerTypeFreezeTower];
        _speedMultiplier = 0.5;
        SKEmitterNode *frost = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Frost" ofType:@"sks"]];
        frost.zPosition = TANodeZPositionProjectile - TANodeZPositionTower;
      //  self.zPosition = TANodeZPositionTower;
        [self addChild:frost];
        [self.infoStrings addObject:[NSString stringWithFormat:@"Speed of all enemies within range decreased by factor of %g",1.0f / self.speedMultiplier]];
    }
    return self;
}



-(void)beginAttack
{
    TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange lastObject];
    [enemy setColor:[SKColor whiteColor]];//[UIColor colorWithRed:155.0f/255.0f green:255.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [enemy setColorBlendFactor:1.0];
    //enemy.movementSpeed /= 2;
    enemy.speed *= self.speedMultiplier;
    enemy.healthBarInside.speed *= self.speedMultiplier;
}

-(void)endAttackOnEnemy:(TAEnemy *)enemy
{
    if ([enemy.name characterAtIndex:0] == 'E') {
        enemy.speed /= self.speedMultiplier;
        enemy.healthBarInside.speed /= self.speedMultiplier;
        if (enemy.speed == 1) {
            enemy.color = [SKColor whiteColor];
        }
    }
}

-(void)setSpeedMultiplier:(CGFloat)speedMultiplier
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Speed of all enemies within range decreased by factor of %g",1.0f / self.speedMultiplier]];
    for (TAEnemy *enemy in [self enemiesInRange]) {
        enemy.speed /= (self.speedMultiplier / speedMultiplier);
        enemy.healthBarInside.speed /= (self.speedMultiplier / speedMultiplier);
    }
    _speedMultiplier = speedMultiplier;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Speed of all enemies within range decreased by factor of %g",1.0f / self.speedMultiplier]];
    }
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    NSArray *stats = [(NSString *)[[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"] objectAtIndex:TATowerTypeFreezeTower] objectAtIndex:towerLevel-1] componentsSeparatedByString:@" "];
    self.speedMultiplier = [[stats objectAtIndex:TATowerLevelDataStatPositionEnemySpeedMultiplier] floatValue];
    self.attackRadius = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackRadius] floatValue];
    [super setTowerLevel:towerLevel];
}

@end
