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
        self.imageName = @"Tower";
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
     /*   towerStatsForLevel = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"];
        super.timeBetweenAttacks = [[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] substringFromIndex:[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] rangeOfString:@" "].location] floatValue];
        super.attackDamage = [[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] substringToIndex:[(NSString *)[towerStatsForLevel objectAtIndex:self.towerLevel-1] rangeOfString:@" "].location] integerValue];*/
        self.projectileSpeed = 400;
        self.size = CGSizeMake(TATowerSizeFireballTower, TATowerSizeFireballTower);
        self.description = (NSString *)[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerDescriptions"] objectAtIndex:TATowerTypeFireballTower];
        self.unitType = @"Fireball Tower";
        self.maximumSimultaneouslyAffectedEnemies = 1;
        self.attackRadius = TATowerAttackRadiusFireballTower;
        self.projectileToFire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Projectile" ofType:@"sks"]];
        self.projectileToFire.zPosition = 0.6;
        [self addChild:self.projectileToFire];
        self.projectileToFire.hidden = YES;
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Damage/shot: %ld",(long)self.attackDamage], [NSString stringWithFormat:@"%g shots/second",1.0f/self.timeBetweenAttacks], nil]];
    }
    return self;
}

-(void)fireProjectile
{
    if ([self.enemiesInRange count] > 0) {
        TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange firstObject];
        SKEmitterNode *projectile;
        BOOL instance;
        if (self.projectileToFire.hidden == YES) {
            projectile = self.projectileToFire;
            instance = NO;
            projectile.position = CGPointMake(0, 0);
            [projectile resetSimulation];
            projectile.hidden = NO;
        }
        else {
            projectile = [self.projectileToFire copyWithZone:NULL];
            instance = YES;
        }
        [projectile runAction:[SKAction moveTo:CGPointMake(enemy.position.x - self.position.x, enemy.position.y - self.position.y)
                                duration:[self.battleScene distanceFromA:self.position
                                                                             toB:enemy.position]/ (self.projectileSpeed + 50)]
                              completion:^{
                                  projectile.hidden = YES;
                                  [enemy setCurrentHealth:enemy.currentHealth - self.attackDamage];
                                  // NSLog(@"Hit; enemy health = %d",enemy.currentHealth);
                                  if ([enemy currentHealth] <= 0) {
                                      [self.enemiesInRange removeObject:enemy];
                                  }
                                  if (instance) {
                                      [projectile removeFromParent];
                                  }
                     }];
        if ([self.enemiesInRange count] == 0) {
            [self endAttack];
        }
    }
}

-(void)setAttackDamage:(NSInteger)attackDamage
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Damage/shot: %ld",(long)self.attackDamage]];
    [super setAttackDamage:attackDamage];
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Damage/shot: %ld",(long)self.attackDamage]];
    }
}

-(void)setTimeBetweenAttacks:(CGFloat)timeBetweenAttacks
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"%g shot/second",1.0f/self.timeBetweenAttacks]];
    [super setTimeBetweenAttacks:timeBetweenAttacks];
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%g shot/second",1.0f/self.timeBetweenAttacks]];
    }
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    NSArray *stats = [(NSString *)[[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"] objectAtIndex:TATowerTypeFireballTower] objectAtIndex:towerLevel-1] componentsSeparatedByString:@" "];
    self.attackDamage = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackDamage] integerValue];
    self.attackRadius = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackRadius] floatValue];
    self.timeBetweenAttacks = [[stats objectAtIndex:TATowerLevelDataStatPositionTimeBetweenAttacks] floatValue];
    [super setTowerLevel:towerLevel];
}

@end
