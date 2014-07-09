//
//  MyScene.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TABattleScene.h"
#import "TATower.h"
#import "TAEnemy.h"
#import "TAPathDrawer.h"
#import "TAUIOverlay.h"


@implementation TABattleScene

-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self setBackgroundColor:nil];
        self.spawnRefreshCount = 0;
        self.spawnPoint = point;
        self.enemiesLetThrough = 0;
        
        self.towersOnField = [[NSMutableArray alloc] init];
        self.enemiesOnField = [[NSMutableArray alloc] init];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        self.enemyMovementPath = CGPathCreateCopy(path);
        
        NSArray *pathNodes = [NSArray arrayWithObjects:[SKNode node], [SKNode node],[SKNode node], nil];
        int i = -25;
        for (SKNode *pathNode in pathNodes) {
            pathNode.position = CGPointMake(pathNode.position.x + i, pathNode.position.y);
            pathNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:self.enemyMovementPath];
            pathNode.physicsBody.categoryBitMask = TAContactTypeTower;
            i += 25;
            [self addChild:pathNode];
        }
    }
    return self;
}

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB
{
    return sqrtf(powf((pointA.x - pointB.x), 2) + powf((pointA.y - pointB.y), 2));
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKSpriteNode *towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Tower"] size:CGSizeMake(30, 30)];
    towerPlaceHolder.colorBlendFactor = 0.5;
    towerPlaceHolder.color = [UIColor greenColor];
    towerPlaceHolder.name = @"Placeholder";
    towerPlaceHolder.position = [[touches anyObject] locationInNode:self];
    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    towerPlaceHolder.physicsBody.collisionBitMask = TAContactTypeNothing;
    towerPlaceHolder.physicsBody.categoryBitMask = TAContactTypeTower;
    towerPlaceHolder.physicsBody.dynamic = YES;
    [self addChild:towerPlaceHolder];
    if ([[towerPlaceHolder.physicsBody allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
        towerPlaceHolder.color = [UIColor redColor];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self childNodeWithName:@"Placeholder"] setPosition:[[touches anyObject] locationInNode:self]];
    if ([[[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] physicsBody] allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
        [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor redColor]];
    }
    else
        [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor greenColor]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] color] isEqual:[UIColor greenColor]]) {
        TATower *tower = [[TATower alloc] initWithImageNamed:@"Tower" andLocation:[(UITouch *)[touches anyObject] locationInNode:self] inScene:self];
        [self addChild:tower];
        [self.towersOnField addObject:tower];
        self.uiOverlay.currentGold -= 50;
    }
    [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if ([[contact bodyA].node.name characterAtIndex:0] == 'D' && [[contact bodyB].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyA].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyB.node;
        [tower.enemiesInRange addObject:enemy];
        if (!tower.isAttacking) {
            [tower beginAttackOnEnemy:enemy];
        }
    }
    else  if ([[contact bodyB].node.name characterAtIndex:0] == 'D' && [[contact bodyA].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyB].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyA.node;
        [tower.enemiesInRange addObject:enemy];
        if (!tower.isAttacking) {
            [tower beginAttackOnEnemy:enemy];
        }
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    if ([[contact bodyA].node.name characterAtIndex:0] == 'D' && [[contact bodyB].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyA].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        if (tower.isAttacking) {
            [tower endAttack];
            [tower.enemiesInRange removeObject:(TAEnemy *)([contact bodyB].node)];
        }
    }
    else  if ([[contact bodyB].node.name characterAtIndex:0] == 'D' && [[contact bodyA].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyB].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        if (tower.isAttacking) {
            [tower endAttack];
            [tower.enemiesInRange removeObject:(TAEnemy *)([contact bodyA].node)];
        }

    }
}


-(void)update:(CFTimeInterval)currentTime {
    
    if (self.spawnRefreshCount == 60 / self.view.frameInterval * 4) {
        self.spawnRefreshCount = 0;
        NSLog(@"Spawn");
        TAEnemy *enemy = [[TAEnemy alloc] initWithImageNamed:@"Goblin" andLocation:self.spawnPoint inScene:self];
        [self addChild:enemy];
        [self.enemiesOnField addObject:enemy];
    }
    else {
        self.spawnRefreshCount++;
    }
}

@end
