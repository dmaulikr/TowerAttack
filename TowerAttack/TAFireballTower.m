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

NSArray *towerStatsForLevel;

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.imageName = @"Tower";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        towerStatsForLevel = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"];
        self.timeBetweenAttacks = [[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] substringFromIndex:[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] rangeOfString:@" "].location] floatValue];
        self.attackDamage = [[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] substringToIndex:[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] rangeOfString:@" "].location] integerValue];
        self.projectileSpeed = 400;
        self.size = CGSizeMake(TATowerSizeFireballTower, TATowerSizeFireballTower);
        self.description = @"This tower shoots fireballs at enemies";
        self.unitType = @"Fireball Tower";
        self.maximumSimultaneouslyAffectedEnemies = 1;
        self.attackRadius = TATowerAttackRadiusFireballTower;
        self.projectileToFire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Projectile" ofType:@"sks"]];
        self.projectileToFire.zPosition = -1;
        [self addChild:self.projectileToFire];
        self.projectileToFire.hidden = YES;
    }
    return self;
}

-(void)fireProjectile
{
    TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange firstObject];
    self.projectileToFire.position = CGPointMake(0, 0);
    [self.projectileToFire resetSimulation];
    self.projectileToFire.hidden = NO;
    [self.projectileToFire runAction:[SKAction moveTo:CGPointMake(enemy.position.x - self.position.x, enemy.position.y - self.position.y)
                                        duration:[self.battleScene distanceFromA:self.position
                                                                             toB:enemy.position]/ (self.projectileSpeed + 50)]
                     completion:^{
                         self.projectileToFire.hidden = YES;
                         [enemy setCurrentHealth:enemy.currentHealth - self.attackDamage];
                         // NSLog(@"Hit; enemy health = %d",enemy.currentHealth);
                         if ([enemy currentHealth] <= 0) {
                             [self.enemiesInRange removeObject:enemy];
                         }
                     }];
    if ([self.enemiesInRange count] == 0) {
        [self endAttack];
    }
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    [super setTowerLevel:towerLevel];
    self.timeBetweenAttacks = [[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] substringFromIndex:[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] rangeOfString:@" "].location] floatValue];
    self.attackDamage = [[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] substringToIndex:[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] rangeOfString:@" "].location] integerValue];
    [(UILabel *)[self.battleScene.uiOverlay.infoPanel.additionalUnitInfo objectAtIndex:0] setText:[NSString stringWithFormat:@"Level: %lu",(unsigned long)self.towerLevel]];
    [(UILabel *)[self.battleScene.uiOverlay.infoPanel.additionalUnitInfo objectAtIndex:1] setText:[NSString stringWithFormat:@"Damage: %lu",(unsigned long)self.attackDamage]];
    [(UILabel *)[self.battleScene.uiOverlay.infoPanel.additionalUnitInfo objectAtIndex:2] setText:[NSString stringWithFormat:@"%g shots/second",self.timeBetweenAttacks]];
}

@end
