//
//  TAPsychicTower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAPsychicTower.h"
#import "TAEnemy.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"

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
        self.towerType = TATowerTypePsychicTower;
        self.damageTimers = [NSMutableArray array];
        self.description = (NSString *)[[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"TowerDescriptions"] objectAtIndex:TATowerTypePsychicTower];
        self.damageNodes = [NSMutableArray array];
        [self runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:5]]];
        [self.infoStrings addObject:[NSString stringWithFormat:@"DPS: %g",self.attackDamage / self.timeBetweenAttacks]];
    }
    return self;
}

-(void)beginAttack
{
    TAEnemy *enemy = (TAEnemy *)[self.enemiesInRange lastObject];
    if (arc4random() % 2  || ![enemy.unitType isEqual:@"Ninja"]) {
        NSTimer *enemyDamageTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeBetweenAttacks target:self selector:@selector(damageEnemyFromTimer:) userInfo:enemy repeats:YES];
        [self.damageTimers addObject:enemyDamageTimer];
        SKEmitterNode *damageNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"PsychicDamage" ofType:@"sks"]];
        [enemy addChild:damageNode];
        damageNode.name = @"PsychicDamage";
        damageNode.position = CGPointMake(0, 15);
        [self.damageNodes addObject:damageNode];
    }
    else {
        [self.battleScene.uiOverlay popText:@"Dodge" withColour:[UIColor blueColor] overPoint:enemy.position completion:nil];
        [self.enemiesInRange removeObject:enemy];
    }
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

-(void)setTimeBetweenAttacks:(CGFloat)timeBetweenAttacks
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"DPS: %g",self.attackDamage / self.timeBetweenAttacks]];
    _timeBetweenAttacks = timeBetweenAttacks;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"DPS: %g",self.attackDamage / self.timeBetweenAttacks]];
    }
}

-(void)setAttackDamage:(CGFloat)attackDamage
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"DPS: %g",self.attackDamage / self.timeBetweenAttacks]];
    _attackDamage = attackDamage;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"DPS: %g",self.attackDamage / self.timeBetweenAttacks]];
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
