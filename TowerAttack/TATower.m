//
//  TATower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-16.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATower.h"
#import "TANonPassiveTower.h"
#import "TABattleScene.h"
#import "TAEnemy.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"

NSInteger const maxTowerLevel = 5;

@implementation TATower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        //init code
        
        _attackRadius = 0;
        self.enemiesInRange = [NSMutableArray array];
        self.purchaseCost = 50;
        self.isPassive = YES;
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Level %ld",(long)self.towerLevel], [NSString stringWithFormat:@"%gm attack radius",self.attackRadius], nil]];
        self.levelStripes = [NSMutableArray array];
        self.towerLevel = 1;
        self.name =  [NSString stringWithFormat:@"Tower %lu", (unsigned long)[self.battleScene.towersOnField count]];
        
        self.zPosition = TANodeZPositionTower;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.size.width - 4) / 2];
        self.physicsBody.contactTestBitMask = TAContactTypeEnemy;
        self.physicsBody.categoryBitMask = TAContactTypeTower;
        self.physicsBody.collisionBitMask = TAContactTypeNothing;
        self.physicsBody.dynamic = NO;
        
        [self runAction:[SKAction playSoundFileNamed:@"TowerPlaced.wav" waitForCompletion:NO]];
    }
    return self;
}

-(instancetype)init
{
   return [self initWithLocation:CGPointMake(0, 0) inScene:nil];
}

-(void)beginAttack
{
    //overidden by subclasses
}

-(void)endAttack
{
   //overidden by subclasses
}

-(void)endAttackOnEnemy:(TAEnemy *)enemy
{
    //overidden by subclasses
}

+(NSArray *)towerIconStrings
{
    return [NSArray arrayWithObjects:@"50Tower", @"40FreezeTower", @"45BlastTower", @"60SpinTower", nil]; //hardcoded
}

+(NSArray *)towerNames
{
    return [NSArray arrayWithObjects:@"Tower", @"Freeze Tower", @"Blast Tower", @"Psychic Tower", nil]; //hardcoded
}

-(void)setAttackRadius:(CGFloat)attackRadius
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"%gm attack radius",self.attackRadius]];
    _attackRadius = attackRadius;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%gm attack radius",self.attackRadius]];
    }
    self.battleScene.towerRadiusDisplay.size = CGSizeMake(attackRadius * 2 + 25, attackRadius * 2 + 25);
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Level %ld",(long)self.towerLevel]];
    _towerLevel = towerLevel;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Level %ld",(long)self.towerLevel]];
    }
    SKSpriteNode *levelStripe = [SKSpriteNode spriteNodeWithImageNamed:@"LevelStripe"];
    levelStripe.size = CGSizeMake(15, 7);
    levelStripe.zPosition = TANodeZPositionTower;
    levelStripe.position = CGPointMake(20 + self.position.x, self.position.y - 30 + towerLevel * 3);
    [self.battleScene addChild:levelStripe];
    [self.levelStripes addObject:levelStripe];
}


@end
