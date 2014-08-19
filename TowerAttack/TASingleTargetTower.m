//
//  TASingleTargetTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TASingleTargetTower.h"
#import "TABattleScene.h"
#import "TAEnemy.h"

@implementation TASingleTargetTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
   //     self.imageName = @"Fire";
   //     self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.projectileSpeed = 400;
   //     self.size = CGSizeMake(TATowerSizeFireballTower, TATowerSizeFireballTower);
        self.description = (NSString *)[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerDescriptions"] objectAtIndex:[self towerTypeFromSubclass]];
   //     self.unitType = @"Fireball Tower";
        self.maximumSimultaneouslyAffectedEnemies = 1;
   //     self.attackRadius = TATowerAttackRadiusFireballTower;
        self.projectileToFire = [self projectile];
        self.projectileToFire.zPosition = TANodeZPositionProjectile - TANodeZPositionTower;
        [self addChild:self.projectileToFire];
        self.projectileToFire.hidden = YES;
        self.towerType = [self towerTypeFromSubclass];
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Damage/shot: %ld",(long)self.attackDamage], [NSString stringWithFormat:@"%g shots/second",1.0f/self.timeBetweenAttacks], nil]];
    }
    return self;
}

-(SKEmitterNode *)projectile
{
    return NULL;
}

-(NSInteger)towerTypeFromSubclass
{
    return 0;
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
    NSArray *stats = [(NSString *)[[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"] objectAtIndex:[self towerTypeFromSubclass]] objectAtIndex:towerLevel-1] componentsSeparatedByString:@" "];
    self.attackDamage = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackDamage] integerValue];
    self.attackRadius = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackRadius] floatValue];
    self.timeBetweenAttacks = [[stats objectAtIndex:TATowerLevelDataStatPositionTimeBetweenAttacks] floatValue];
    [super setTowerLevel:towerLevel];
}

@end
