//
//  MyScene.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TABattleScene.h"
#import "TAFireballTower.h"
#import "TAFreezeTower.h"
#import "TABlastTower.h"
#import "TAEnemy.h"
#import "TAPathDrawer.h"
#import "TAUIOverlay.h"
#import "TATowerPurchaseSidebar.h"


@implementation TABattleScene

-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point {
    if (self = [super init]) {
        /* Setup your scene here */
        
        self.spawnRefreshCount = 0;
        self.spawnPoint = point;
        self.click = NO;
        self.towersOnField = [[NSMutableArray alloc] init];
        self.enemiesOnField = [[NSMutableArray alloc] init];
        self.isDraggingTowerPlaceholder = NO;
        self.enemyMovementPath = CGPathCreateCopy(path);
        self.pathDrawer.alpha = 0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.pathDrawer.alpha = 1;
            self.position = CGPointMake(0, 0);
            self.pathDrawerFrame = CGRectMake(0, 0, 1200, 900);
            CGFloat deltaX = -(1200 / 2 - 568 / 2), deltaY = 1;
            self.position = CGPointMake(self.position.x + deltaX, self.position.y + deltaY);
            [self.pathDrawer setFrame:CGRectMake(self.pathDrawerFrame.origin.x + deltaX, self.pathDrawerFrame.origin.y - deltaY, self.pathDrawerFrame.size.width,self.pathDrawerFrame.size.height)];
            self.pathDrawerFrame = CGRectMake(self.pathDrawerFrame.origin.x + deltaX, self.pathDrawerFrame.origin.y - deltaY, self.pathDrawerFrame.size.width,self.pathDrawerFrame.size.height);
        });
    
        SKNode *n = [SKNode node];
        n.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 100)];
        [self addChild:n];
        n.physicsBody.categoryBitMask = TAContactTypeTower;
        n.physicsBody.contactTestBitMask = TAContactTypeTower;
        n.name = @"Path";
        n.position = CGPointMake(0, -580);
        n.physicsBody.collisionBitMask = TAContactTypeNothing;
        
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:size];
        [self addChild:node];
    }
    return self;
}

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB
{
    return sqrtf(powf((pointA.x - pointB.x), 2) + powf((pointA.y - pointB.y), 2));
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.click = YES;
    self.lastPoint = [[touches anyObject] locationInNode:self];
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
    else {
        CGFloat deltaX = [[touches anyObject] locationInNode:self].x - self.lastPoint.x, deltaY = [[touches anyObject] locationInNode:self].y - self.lastPoint.y;
        if (self.pathDrawerFrame.origin.x + deltaX > 0) {
            deltaX = (CGFloat)self.pathDrawerFrame.origin.x * -1;
        }
        else if (self.pathDrawerFrame.origin.x * -1 - deltaX + self.scene.view.frame.size.width >= 1200) {
            deltaX = (1200 + self.pathDrawerFrame.origin.x - self.scene.view.frame.size.width) * -1;
        }
        if (self.pathDrawerFrame.origin.y - deltaY > 0) {
            deltaY = self.pathDrawerFrame.origin.y;
        }
        else if (self.pathDrawerFrame.origin.y * -1 + deltaY + self.scene.view.frame.size.height >= 900) {
            deltaY = (900 + self.pathDrawer.frame.origin.y - self.scene.view.frame.size.height);
        }
        self.position = CGPointMake(self.position.x + deltaX, self.position.y + deltaY);
        [self.pathDrawer setFrame:CGRectMake(self.pathDrawerFrame.origin.x + deltaX, self.pathDrawerFrame.origin.y - deltaY, self.pathDrawerFrame.size.width,self.pathDrawerFrame.size.height)];
        self.pathDrawerFrame = CGRectMake(self.pathDrawerFrame.origin.x + deltaX, self.pathDrawerFrame.origin.y - deltaY, self.pathDrawerFrame.size.width,self.pathDrawerFrame.size.height);
        if ([self childNodeWithName:@"Placeholder"] != nil) {
            [self.uiOverlay changeNodeOverlayLocation:CGPointMake(self.uiOverlay.lastOverlayLocation.x + deltaX, self.uiOverlay.lastOverlayLocation.y - deltaY)  andHidden:NO];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.click) {
        [self userClickedAtLocation:[touches anyObject]];
        self.isDraggingTowerPlaceholder = NO;
    }
    if (self.isDraggingTowerPlaceholder) {
        [self.uiOverlay changeNodeOverlayLocation:[[touches anyObject] locationInView:self.uiOverlay] andHidden:NO];
    }
    self.isDraggingTowerPlaceholder = NO;
   /* if ([[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] color] isEqual:[UIColor greenColor]]) {
       
       // self.uiOverlay.currentGold -= 50;
    }
    [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];*/
}

-(void)userClickedAtLocation:(UITouch *)touch
{
    if ([[[self nodeAtPoint:[touch locationInNode:self]] name] characterAtIndex:0] == 'E') {
        self.uiOverlay.selectedUnit = (TAEnemy *)[self nodeAtPoint:[touch locationInNode:self]];
    }
    else if ([[[self nodeAtPoint:[touch locationInNode:self]] name] characterAtIndex:0] == 'T') {
        self.uiOverlay.selectedUnit = (TATower *)[self nodeAtPoint:[touch locationInNode:self]];
        //this will be implemented with the tower overlay
    }
    else {
        if ([touch locationInNode:self].y + self.position.y < 40) {
            [self spawnEnemy];
        }
        else if ([self childNodeWithName:@"Placeholder"] == nil && self.uiOverlay.purchaseSidebar.selectedTowerType != TATowerTypeNoTower) {
            SKSpriteNode *towerPlaceHolder;
            CGSize detectorSize;
            switch (self.uiOverlay.purchaseSidebar.selectedTowerType) {
                case TATowerTypeFireballTower:
                    towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Tower"] size:CGSizeMake(TATowerSizeFireballTower, TATowerSizeFireballTower)];
                    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:TATowerSizeFireballTower / 2];
                    detectorSize = CGSizeMake(TATowerAttackRadiusFireballTower * 2 + 25, TATowerAttackRadiusFireballTower * 2 + 25);
                    break;
                case TATowerTypeFreezeTower:
                    towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"FreezeTower"] size:CGSizeMake(TATowerSizeFreezeTower, TATowerSizeFreezeTower)];
                    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:TATowerSizeFreezeTower / 2];
                    detectorSize = CGSizeMake(TATowerAttackRadiusFreezeTower * 2 + 25, TATowerAttackRadiusFreezeTower * 2 + 25);
                    break;
                case TATowerTypeBlastTower:
                    towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"BlastTower"] size:CGSizeMake(TATowerSizeBlastTower, TATowerSizeBlastTower)];
                    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:TATowerSizeBlastTower / 2];
                    detectorSize = CGSizeMake(TATowerAttackRadiusBlastTower * 2 + 25, TATowerAttackRadiusBlastTower * 2 +  25);
                    break;
            }
            towerPlaceHolder.colorBlendFactor = 0.5;
            towerPlaceHolder.name = @"Placeholder";
            towerPlaceHolder.position = [touch locationInNode:self];
            towerPlaceHolder.zPosition = 0.2;
            towerPlaceHolder.physicsBody.collisionBitMask = TAContactTypeNothing;
            towerPlaceHolder.physicsBody.contactTestBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.categoryBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.dynamic = YES;
            
            SKSpriteNode *detectorPlaceholder = [SKSpriteNode spriteNodeWithImageNamed:@"TowerRadius"];
            detectorPlaceholder.size = detectorSize;
            detectorPlaceholder.alpha = 0.5;
            [towerPlaceHolder addChild:detectorPlaceholder];
            
            [self addChild:towerPlaceHolder];
            self.uiOverlay.selectedNode = towerPlaceHolder;
            self.uiOverlay.purchaseSidebar.selectedTowerType = TATowerTypeNoTower;
            [self.uiOverlay changeNodeOverlayLocation:[touch locationInView:self.uiOverlay] andHidden:NO];
            for (UIButton *b in self.uiOverlay.purchaseSidebar.towerIcons) {
                b.selected = NO;
                b.highlighted = NO;
            }
            if ([[[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] physicsBody] allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
                towerPlaceHolder.color = [UIColor redColor];
            }
            else {
                towerPlaceHolder.color = [UIColor greenColor];
            }
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if ([[contact bodyA].node.name characterAtIndex:0] == 'D' && [[contact bodyB].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyA].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
     //   NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyB.node;
        [tower.enemiesInRange addObject:enemy];
        if ([tower.enemiesInRange count] == 1 || tower.isPassive) {
            [tower beginAttack];
        }
    }
    else  if ([[contact bodyB].node.name characterAtIndex:0] == 'D' && [[contact bodyA].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyB].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
   //     NSLog(@"%@ contact began",tower.name);
        TAEnemy *enemy = (TAEnemy *)contact.bodyA.node;
        [tower.enemiesInRange addObject:enemy];
        if ([tower.enemiesInRange count] == 1 || tower.isPassive) {
            [tower beginAttack];
        }
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    if ([[contact bodyA].node.name characterAtIndex:0] == 'D' && [[contact bodyB].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyA].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        TAEnemy *enemy = (TAEnemy *)([contact bodyB].node);
        if (tower.isPassive) {
            //[tower endAttackOnEnemy:enemy];
            [tower performSelectorOnMainThread:@selector(endAttackOnEnemy:) withObject:enemy waitUntilDone:YES];
            [tower.enemiesInRange removeObject:enemy];
        }
        else {
            [tower.enemiesInRange removeObject:enemy];
            [tower endAttack];
        }
    }
    else  if ([[contact bodyB].node.name characterAtIndex:0] == 'D' && [[contact bodyA].node.name characterAtIndex:0] == 'E') {
        NSUInteger towerIndex = [[[contact bodyB].node.name substringFromIndex:9] integerValue];
        TATower *tower = (TATower *)[self.towersOnField objectAtIndex:towerIndex];
        TAEnemy *enemy = (TAEnemy *)([contact bodyB].node);
        if (tower.isPassive) {
           // [tower endAttackOnEnemy:enemy];
            [tower performSelectorOnMainThread:@selector(endAttackOnEnemy:) withObject:enemy waitUntilDone:YES];
            [tower.enemiesInRange removeObject:enemy];
        }
        else {
            [tower.enemiesInRange removeObject:enemy];
            [tower endAttack];
        }
    }
}

-(void)addTower
{
    switch ((NSInteger)[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] size].width) {
        case TATowerSizeFireballTower: {
            TAFireballTower *tower = [[TAFireballTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            self.uiOverlay.currentGold -= tower.purchaseCost;
            [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];
            [self addChild:tower];
            [self.towersOnField addObject:tower];
        }
            break;
        case TATowerSizeFreezeTower: {
            TAFreezeTower *tower = [[TAFreezeTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            self.uiOverlay.currentGold -= tower.purchaseCost;
            [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];
            [self addChild:tower];
            [self.towersOnField addObject:tower];
        }
            break;
        case TATowerSizeBlastTower: {
            TABlastTower *tower = [[TABlastTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            self.uiOverlay.currentGold -= tower.purchaseCost;
            [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];
            [self addChild:tower];
            [self.towersOnField addObject:tower];
        }
            break;
    }
}

-(void)spawnEnemy
{
    TAEnemy *enemy = [[TAEnemy alloc] initWithLocation:self.spawnPoint inScene:self];
    [self addChild:enemy];
    [self.enemiesOnField addObject:enemy];
}

-(void)didSimulatePhysics
{
    if ([[[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] physicsBody] allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
        [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor redColor]];
    }
    else
        [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor greenColor]];
}

@end
