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
        
        _towerLevel = 1;
        _attackRadius = 0;
        self.enemiesInRange = [NSMutableArray array];
        self.purchaseCost = 50;
        self.isPassive = YES;
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Level %ld",(long)self.towerLevel], [NSString stringWithFormat:@"%gm attack radius",self.attackRadius], nil]];
        self.name =  [NSString stringWithFormat:@"Tower %lu", (unsigned long)[self.battleScene.towersOnField count]];
        
        self.zPosition = 0.1;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.size.width - 4) / 2];
        self.physicsBody.contactTestBitMask = TAContactTypeEnemy;
        self.physicsBody.categoryBitMask = TAContactTypeTower;
        self.physicsBody.collisionBitMask = TAContactTypeNothing;
        self.physicsBody.dynamic = NO;
        
        SKSpriteNode *collisionDetection = [SKSpriteNode spriteNodeWithImageNamed:@"TowerRadius"];
   //     collisionDetection.size = CGSizeMake(self.attackRadius * 2, self.attackRadius * 2);
        collisionDetection.alpha = 0.0;
   //     collisionDetection.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.attackRadius];
        collisionDetection.name = [NSString stringWithFormat:@"Detector %lu", (unsigned long)[self.battleScene.towersOnField count]];
        collisionDetection.position = self.position;
        collisionDetection.anchorPoint = CGPointMake(0.5, 0.5);
        collisionDetection.physicsBody.contactTestBitMask = TAContactTypeEnemy;
        collisionDetection.physicsBody.categoryBitMask = TAContactTypeDetector;
        collisionDetection.physicsBody.collisionBitMask = TAContactTypeNothing;
        collisionDetection.physicsBody.dynamic = NO;
        [self.battleScene addChild:collisionDetection];
        [self runAction:[SKAction playSoundFileNamed:@"TowerPlaced.wav" waitForCompletion:NO]];
    }
    return self;
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
    NSUInteger ownTowerNumber = [[self.name substringFromIndex:[self.name rangeOfString:@" "].location + 1] integerValue];
    SKSpriteNode *detector = (SKSpriteNode *)[self.battleScene childNodeWithName:[NSString stringWithFormat:@"Detector %lu", ownTowerNumber]];
    detector.size = CGSizeMake(attackRadius * 2 + 20, attackRadius * 2 + 20);
    detector.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackRadius];
    detector.physicsBody.contactTestBitMask = TAContactTypeEnemy;
    detector.physicsBody.categoryBitMask = TAContactTypeDetector;
    detector.physicsBody.collisionBitMask = TAContactTypeNothing;
    detector.physicsBody.dynamic = NO;
}

-(void)setTowerLevel:(NSInteger)towerLevel
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Level %ld",(long)self.towerLevel]];
    _towerLevel = towerLevel;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Level %ld",(long)self.towerLevel]];
    }
}


@end
