//
//  TABlastTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TABlastTower.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"
#import "TAEnemy.h"

@implementation TABlastTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"BlastTower";
        self.size = CGSizeMake(TATowerSizeBlastTower, TATowerSizeBlastTower);
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.attackRadius = TATowerAttackRadiusBlastTower;
        self.unitType = @"Blast Tower";
        self.maximumSimultaneouslyAffectedEnemies = 0;
        self.description = (NSString *)[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerDescriptions"] objectAtIndex:TATowerTypeBlastTower];
        super.attackDamage = 20;
        super.timeBetweenAttacks = 1.5;
        self.projectileToFire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Blast" ofType:@"sks"]];
        self.normalBirthRateOfProjectile = self.projectileToFire.particleBirthRate;
        self.projectileToFire.particleBirthRate = 0;
        self.projectileToFire.zPosition = -1;
        [self addChild:self.projectileToFire];
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Damage/blast: %ld",(long)self.attackDamage], [NSString stringWithFormat:@"%g blasts/second",1.0f/self.timeBetweenAttacks], nil]];
    }
    return self;
}

-(void)fireProjectile
{
    self.projectileToFire.particleBirthRate = self.normalBirthRateOfProjectile;
    [self performSelector:@selector(turnOffEmitter) withObject:nil afterDelay:0.15];
    int enemiesToRemove = 0;
    for (TAEnemy *enemy in [self enemiesInRange]) {
        enemy.currentHealth -= self.attackDamage;
        if (enemy.currentHealth <= 0) {
            [self.enemiesInRange performSelector:@selector(removeObject:) withObject:enemy afterDelay:0.1];
            enemiesToRemove++;
           // [self.enemiesInRange removeObject:enemy];
        }
    }
    if ([self.enemiesInRange count] <= enemiesToRemove) {
        [self endAttack];
    }
}

-(void)setAttackDamage:(NSInteger)attackDamage
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Damage/blast: %ld",(long)self.attackDamage]];
    [super setAttackDamage:attackDamage];
    [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Damage/blast: %ld",(long)self.attackDamage]];
}

-(void)setTimeBetweenAttacks:(CGFloat)timeBetweenAttacks
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"%g blasts/second",1.0f/self.timeBetweenAttacks]];
    [super setTimeBetweenAttacks:timeBetweenAttacks];
    [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%g blasts/second",1.0f/self.timeBetweenAttacks]];
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    NSArray *stats = [(NSString *)[[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"] objectAtIndex:TATowerTypeBlastTower] objectAtIndex:towerLevel-1] componentsSeparatedByString:@" "];
    self.attackDamage = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackDamage] integerValue];
    self.attackRadius = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackRadius] floatValue];
    self.timeBetweenAttacks = [[stats objectAtIndex:TATowerLevelDataStatPositionTimeBetweenAttacks] floatValue];
    [super setTowerLevel:towerLevel];
}

@end
