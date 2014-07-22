//
//  TAPsychicTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAPsychicTower.h"
#import "TAEnemy.h"

@implementation TAPsychicTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        self.attackRadius = TATowerAttackRadiusPsychicTower;
        self.size = CGSizeMake(TATowerSizePsychicTower, TATowerSizePsychicTower);
        self.texture = [SKTexture textureWithImageNamed:@"SpinTower"];
        self.timeBetweenAttacks = 0.05;
        self.unitType = @"Psychic Tower";
        self.imageName = @"SpinTower";
        self.attackDamage = 0.2;
        self.damageTimers = [NSMutableArray array];
        self.description = (NSString *)[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerDescriptions"] objectAtIndex:TATowerTypePsychicTower];
        self.damageNodes = [NSMutableArray array];
        [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:5]]];
    }
    return self;
}

-(void)beginAttack
{
    TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange lastObject];
    NSTimer *enemyDamageTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeBetweenAttacks target:self selector:@selector(damageEnemyFromTimer:) userInfo:enemy repeats:YES];
    [self.damageTimers addObject:enemyDamageTimer];
    SKEmitterNode *damageNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"PsychicDamage" ofType:@"sks"]];
    [enemy addChild:damageNode];
    damageNode.name = @"PsychicDamage";
    [self.damageNodes addObject:damageNode];
}

-(void)damageEnemyFromTimer:(NSTimer *)timer
{
    TAEnemy *enemy = (TAEnemy *)[timer userInfo];
    [enemy childNodeWithName:@"PsychicDamage"].zRotation = enemy.zRotation * -1;
    enemy.currentHealth -= self.attackDamage;
}

-(void)endAttackOnEnemy:(TAEnemy *)enemy
{
    NSUInteger index = [self.enemiesInRange indexOfObjectIdenticalTo:enemy];
    if (index != NSNotFound) {
        [[self.damageTimers objectAtIndex:index] invalidate];
        [self.damageTimers removeObjectAtIndex:index];
        SKEmitterNode *damageNode = (SKEmitterNode *)[self.damageNodes objectAtIndex:index];
        damageNode.particleBirthRate = 0;
        [self.damageNodes removeObjectAtIndex:index];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [enemy removeChildrenInArray:@[damageNode]];
        });
    }
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    NSArray *stats = [(NSString *)[[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerStatsForLevel"] objectAtIndex:TATowerTypePsychicTower] objectAtIndex:towerLevel-1] componentsSeparatedByString:@" "];
    self.attackDamage = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackDamage] floatValue];
    self.attackRadius = [[stats objectAtIndex:TATowerLevelDataStatPositionAttackRadius] floatValue];
    self.timeBetweenAttacks = [[stats objectAtIndex:TATowerLevelDataStatPositionTimeBetweenAttacks] floatValue];
    [super setTowerLevel:towerLevel];
}


@end
