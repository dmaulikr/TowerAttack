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


@implementation TABattleScene

-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.destination = CGPointMake(60, 60);
        [self setBackgroundColor:nil];
        self.spawnRefreshCount = 0;
        self.spawnPoint = point;
        self.enemiesLetThrough = 0;
        
        self.towersOnField = [[NSMutableArray alloc] init];
        self.enemiesOnField = [[NSMutableArray alloc] init];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        self.enemyMovementPath = CGPathCreateCopy(path);
    }
    return self;
}

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB
{
    return sqrtf(powf((pointA.x - pointB.x), 2) + powf((pointA.y - pointB.y), 2));
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    TATower *tower = [[TATower alloc] initWithImageNamed:@"1" andLocation:[(UITouch *)[touches anyObject] locationInNode:self] inScene:self];
    [self addChild:tower];
    [self.towersOnField addObject:tower];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if ([[contact bodyA].node.name characterAtIndex:0] == 'D' && [[contact bodyB].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyA].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyB.node;
        if (!tower.isAttacking) {
            [tower beginAttackOnEnemy:enemy];
        }
        else {
            [tower.enemiesInRange addObject:enemy];
        }
    }
    else  if ([[contact bodyB].node.name characterAtIndex:0] == 'D' && [[contact bodyA].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyB].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyA.node;
        if (!tower.isAttacking) {
            [tower beginAttackOnEnemy:enemy];
        }
        else {
            [tower.enemiesInRange addObject:enemy];
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
