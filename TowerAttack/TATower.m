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
        
        self.towerLevel = 1;
        self.enemiesInRange = [NSMutableArray array];
        self.purchaseCost = 50;
        self.isPassive = YES;
        self.name =  [NSString stringWithFormat:@"Tower %lu", (unsigned long)[self.battleScene.towersOnField count]];
        
        self.zPosition = 0.1;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.size.width - 4) / 2];
        self.physicsBody.contactTestBitMask = TAContactTypeEnemy;
        self.physicsBody.categoryBitMask = TAContactTypeTower;
        self.physicsBody.collisionBitMask = TAContactTypeNothing;
        self.physicsBody.dynamic = NO;
        
        SKSpriteNode *collisionDetection = [SKSpriteNode spriteNodeWithImageNamed:@"TowerRadius"];
   //     collisionDetection.size = CGSizeMake(self.attackRadius * 2, self.attackRadius * 2);
        collisionDetection.alpha = 0.5;
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
    return [NSArray arrayWithObjects:@"50Tower", @"40FreezeTower", @"45BlastTower", nil];
}

+(NSArray *)towerNames
{
    return [NSArray arrayWithObjects:@"Tower", @"Freeze Tower", @"Blast Tower", nil];
}

-(void)setAttackRadius:(CGFloat)attackRadius
{
    _attackRadius = attackRadius;
    NSUInteger ownTowerNumber = [[self.name substringFromIndex:[self.name rangeOfString:@" "].location + 1] integerValue];
    SKSpriteNode *detector = (SKSpriteNode *)[self.battleScene childNodeWithName:[NSString stringWithFormat:@"Detector %lu", ownTowerNumber]];
    detector.size = CGSizeMake(attackRadius * 2 + 20, attackRadius * 2 + 20);
    detector.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackRadius];
    detector.physicsBody.contactTestBitMask = TAContactTypeEnemy;
    detector.physicsBody.categoryBitMask = TAContactTypeDetector;
    detector.physicsBody.collisionBitMask = TAContactTypeNothing;
    detector.physicsBody.dynamic = NO;
}


@end
