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
        self.click = NO;
        self.towersOnField = [[NSMutableArray alloc] init];
        self.enemiesOnField = [[NSMutableArray alloc] init];
        self.isDraggingTowerPlaceholder = NO;
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        self.enemyMovementPath = CGPathCreateCopy(path);
        
    /*    for (int i = -25; i <= 25; i += 25) {
            SKNode *pathNode = [SKNode node];
            pathNode.position = CGPointMake(pathNode.position.x + i, pathNode.position.y);
            pathNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:self.enemyMovementPath];
            pathNode.physicsBody.categoryBitMask = TAContactTypeTower;
            pathNode.physicsBody.contactTestBitMask = TAContactTypeTower;
            pathNode.physicsBody.collisionBitMask = 0;
            i += 25;
            [self addChild:pathNode];
        }
        for (int i = -25; i <= 25; i += 25) {
            SKNode *pathNode = [SKNode node];
            pathNode.position = CGPointMake(pathNode.position.x, pathNode.position.y + i);
            pathNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:self.enemyMovementPath];
            pathNode.physicsBody.categoryBitMask = TAContactTypeTower;
            pathNode.physicsBody.contactTestBitMask = TAContactTypeTower;
            pathNode.physicsBody.collisionBitMask = 0;
            i += 25;
            [self addChild:pathNode];
        }*/
   //     NSTimer *spawnTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(spawnEnemy) userInfo:nil repeats:YES];
        SKNode *n = [SKNode node];
        n.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 100)];//[SKPhysicsBody bodyWithPolygonFromPath:CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 100)];
        [self addChild:n];
        n.physicsBody.categoryBitMask = TAContactTypeTower;
        n.physicsBody.contactTestBitMask = TAContactTypeTower;
        n.name = @"Path";
        n.physicsBody.collisionBitMask = TAContactTypeNothing;
    }
    return self;
}

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB
{
    return sqrtf(powf((pointA.x - pointB.x), 2) + powf((pointA.y - pointB.y), 2));
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.click = YES;
    if ([[self childNodeWithName:@"Placeholder"] containsPoint:[[touches anyObject] locationInNode:self]]) {
        self.isDraggingTowerPlaceholder = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.click = NO;
    if (self.isDraggingTowerPlaceholder) {
        [[self childNodeWithName:@"Placeholder"] setPosition:[[touches anyObject] locationInNode:self]];
        if ([[[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] physicsBody] allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
            [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor redColor]];
        }
        else
            [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor greenColor]];
     //   [self.uiOverlay changeNodeOverlayLocation:[[touches anyObject] locationInView:self.uiOverlay] andHidden:NO];
        [self.uiOverlay changeNodeOverlayLocation:CGPointMake(0, 0) andHidden:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.click) {
        [self userClickedAtLocation:[[touches anyObject] locationInNode:self]];
    }
    if (self.isDraggingTowerPlaceholder) {
        [self.uiOverlay changeNodeOverlayLocation:[[touches anyObject] locationInView:self.uiOverlay] andHidden:NO];
    }
    self.isDraggingTowerPlaceholder = NO;
  /*  if ([[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] color] isEqual:[UIColor greenColor]]) {
       
       // self.uiOverlay.currentGold -= 50;
    }
    [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];*/
}

-(void)userClickedAtLocation:(CGPoint)point
{
 /*   if ([[[self nodeAtPoint:point] name] characterAtIndex:0] == 'P') {
        self.uiOverlay.selectedNode = [self nodeAtPoint:point];
    }
    else */if ([[[self nodeAtPoint:point] name] characterAtIndex:0] == 'T') {
        self.uiOverlay.selectedTower = (TATower *)[self nodeAtPoint:point];
        //this will be implemented with the tower overlay
    }
    else {
        if (point.y < 40) {
            [self spawnEnemy];
        }
        else if ([self childNodeWithName:@"Placeholder"] == nil) {
            SKSpriteNode *towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Tower"] size:CGSizeMake(towerHeightAndWidth, towerHeightAndWidth)];
            towerPlaceHolder.colorBlendFactor = 0.5;
            towerPlaceHolder.color = [UIColor greenColor];
            towerPlaceHolder.name = @"Placeholder";
            towerPlaceHolder.position = point;
            towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:towerHeightAndWidth / 2];
            towerPlaceHolder.physicsBody.collisionBitMask = TAContactTypeNothing;
            towerPlaceHolder.physicsBody.categoryBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.dynamic = YES;
            [self addChild:towerPlaceHolder];
            self.uiOverlay.selectedNode = towerPlaceHolder;
            if ([[towerPlaceHolder.physicsBody allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
                    towerPlaceHolder.color = [UIColor redColor];
            }
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact between %@ and %@", contact.bodyA.node.name, contact.bodyB.node.name);
    if ([[contact bodyA].node.name characterAtIndex:0] == 'D' && [[contact bodyB].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyA].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
     //   NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyB.node;
        [tower.enemiesInRange addObject:enemy];
        if (!tower.isAttacking) {
            [tower beginAttackOnEnemy:enemy];
        }
    }
    else  if ([[contact bodyB].node.name characterAtIndex:0] == 'D' && [[contact bodyA].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyB].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
   //     NSLog(@"%@ contact began",tower.name);
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
            NSLog(@"Left");
        }
    }
}

-(void)addTower
{
    TATower *tower = [[TATower alloc] initWithImageNamed:@"Tower" andLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
    self.uiOverlay.currentGold -= 50;
    [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];
    [self addChild:tower];
    [self.towersOnField addObject:tower];
}

-(void)spawnEnemy
{
    TAEnemy *enemy = [[TAEnemy alloc] initWithImageNamed:@"Goblin" andLocation:self.spawnPoint inScene:self];
    [self addChild:enemy];
    [self.enemiesOnField addObject:enemy];
}

-(void)update:(CFTimeInterval)currentTime {

}

@end
