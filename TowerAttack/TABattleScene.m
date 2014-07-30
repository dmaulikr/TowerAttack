//
//  MyScene.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TABattleScene.h"
#import "TATower.h"
#import "TAFireballTower.h"
#import "TAFreezeTower.h"
#import "TABlastTower.h"
#import "TAEnemy.h"
#import "TAPsychicTower.h"
#import "TAUIOverlay.h"
#import "TATowerPurchaseSidebar.h"

CGFloat const screenWidth = 568; //480

@implementation TABattleScene

-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point {
    if (self = [super init]) {
        /* Setup your scene here */
        
        self.spawnRefreshCount = 0;
        self.spawnPoint = CGPointMake(point.x, 900);//point;
        self.click = NO;
        self.position = CGPointMake((point.x - screenWidth / 2) * -1, 320 - 900);
        self.towersOnField = [[NSMutableArray alloc] init];
        self.enemiesOnField = [[NSMutableArray alloc] init];
        self.isDraggingTowerPlaceholder = NO;
        self.enemyMovementPath = CGPathCreateCopy(path);
        self.size = size;
        self.scale = 1.0f;
        
        SKShapeNode *pathDrawer = [SKShapeNode node];
        pathDrawer.path = CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 100);
        pathDrawer.strokeColor = [SKColor blackColor];
        pathDrawer.fillColor = [UIColor colorWithRed:250.0f/255.0f green:224.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        pathDrawer.lineWidth = 1.5;
        pathDrawer.zPosition = 0.2;
        pathDrawer.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 100)];
        pathDrawer.physicsBody.categoryBitMask = TAContactTypeTower;
        pathDrawer.physicsBody.contactTestBitMask = TAContactTypeTower;
        pathDrawer.name = @"Path";
        pathDrawer.physicsBody.collisionBitMask = TAContactTypeNothing;
        [self addChild:pathDrawer];
        
        SKShapeNode *pathFill = [SKShapeNode node];
        pathFill.path = self.enemyMovementPath;
        pathFill.strokeColor = [UIColor colorWithRed:250.0f/255.0f green:224.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        pathFill.lineWidth = 49;
        pathFill.lineCap = kCGLineCapRound;
        pathFill.lineJoin = kCGLineJoinRound;
        pathFill.zPosition = 0.3;
        [self addChild:pathFill];
        
        
        UIGraphicsBeginImageContext(size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextDrawTiledImage(c, CGRectMake(0, 0, 250, 250), [UIImage imageNamed:@"grass14"].CGImage);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.texture = [SKTexture textureWithImage:image];
        self.zPosition = 0;
        self.anchorPoint = CGPointMake(0, 0);
        
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(didSimulatePhysics) userInfo:nil repeats:YES];
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
    if ([self distanceFromA:[[self childNodeWithName:@"Placeholder"] position] toB:self.lastPoint] <= ((SKSpriteNode *)[self childNodeWithName:@"Placeholder"]).size.width) {
        self.isDraggingTowerPlaceholder = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.click = NO;
    [self.uiOverlay changeNodeOverlayLocation:CGPointMake(self.uiOverlay.lastOverlayLocation.x, self.uiOverlay.lastOverlayLocation.y) andHidden:YES];
    if (self.isDraggingTowerPlaceholder) {
        [[self childNodeWithName:@"Placeholder"] setPosition:[[touches anyObject] locationInNode:self]];
        if ([[[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] physicsBody] allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
            [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor redColor]];
        }
        else
            [(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] setColor:[UIColor greenColor]];
    }
    else {
        CGFloat deltaX = ([[touches anyObject] locationInNode:self].x - self.lastPoint.x) * self.scale, deltaY = ([[touches anyObject] locationInNode:self].y - self.lastPoint.y) * self.scale;
        if (self.position.x + deltaX > 0) {
            deltaX = (CGFloat)self.position.x * -1;
        }
        else if (self.position.x * -1 - deltaX + self.scene.view.frame.size.width >= 1200 * self.scale) {
            deltaX = (1200 * self.scale + self.position.x - self.scene.view.frame.size.width) * -1;
        }
        if (self.position.y + deltaY > 0) {
            deltaY = self.position.y * -1;
        }
        else if ((self.position.y + deltaY) * -1 + self.scene.view.frame.size.height >= 900 * self.scale) {
            deltaY = (900 * self.scale + self.position.y - self.scene.view.frame.size.height) * -1;
        }
        self.position = CGPointMake(self.position.x + deltaX, self.position.y + deltaY);
        self.lastPoint = [[touches anyObject] locationInNode:self];
        if ([self childNodeWithName:@"Placeholder"] != nil) {
         [self.uiOverlay changeNodeOverlayLocation:CGPointMake(self.uiOverlay.lastOverlayLocation.x + deltaX, self.uiOverlay.lastOverlayLocation.y - deltaY)  andHidden:YES];
         }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.click) {
        [self userClickedAtLocation:[touches anyObject]];
    }
    else if (self.isDraggingTowerPlaceholder) {
        [self.uiOverlay changeNodeOverlayLocation:[[touches anyObject] locationInView:self.uiOverlay] andHidden:NO];
    }
    else if ([self childNodeWithName:@"Placeholder"] != nil && self.uiOverlay.cancelButton.hidden) {
        [self.uiOverlay changeNodeOverlayLocation:CGPointMake(self.uiOverlay.lastOverlayLocation.x, self.uiOverlay.lastOverlayLocation.y)  andHidden:NO];
    }
    self.isDraggingTowerPlaceholder = NO;
}

-(void)userClickedAtLocation:(UITouch *)touch
{
    SKNode *nodeTouched = [SKNode node];
    if ([[self nodesAtPoint:[touch locationInNode:self]] count] > 1) {
        for (SKNode *n in [self nodesAtPoint:[touch locationInNode:self]]) {
            if (([n.name characterAtIndex:0] == 'E' && [nodeTouched.name characterAtIndex:0] != 'T') || ([n.name characterAtIndex:0] == 'T' && [self distanceFromA:n.position toB:[touch locationInNode:self]] <= [(SKSpriteNode *)n size].width)) {
                nodeTouched = n;
            }
        }
    }
    else {
        nodeTouched = [self nodeAtPoint:[touch locationInNode:self]];
    }
    if ([[nodeTouched name] characterAtIndex:0] == 'E') {
        self.uiOverlay.selectedUnit = (TAEnemy *)nodeTouched;
    }
    else if ([[nodeTouched name] characterAtIndex:0] == 'T') {
        TATower *tower = (TATower *)nodeTouched;
        self.uiOverlay.selectedUnit = tower;
        NSUInteger towerNumber = [[tower.name substringFromIndex:[tower.name rangeOfString:@" "].location + 1] integerValue];
        SKSpriteNode *detector = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"Detector %lu", (unsigned long)towerNumber]];
        detector.alpha = 0.7;
    }
    else {
        self.uiOverlay.selectedUnit = nil;
        if ([touch locationInView:self.uiOverlay].y < panelY && ((UIView *)self.uiOverlay.infoPanel).frame.origin.y == panelY) {
            [UIView animateWithDuration:0.25 animations:^(void) {
                ((UIView *)self.uiOverlay.infoPanel).frame = CGRectMake(0, screenWidth, screenWidth, 80);
                self.uiOverlay.purchaseSidebar.frame = CGRectMake(screenWidth - 68, 0, 68, 320);
            }];
        }
        if ([touch locationInView:self.uiOverlay].y > 280) {
            [self spawnEnemy];
        }
        else if ([self childNodeWithName:@"Placeholder"] == nil && self.uiOverlay.purchaseSidebar.selectedTowerType != TATowerTypeNoTower) {
            SKSpriteNode *towerPlaceHolder;
            CGSize detectorSize;
            switch (self.uiOverlay.purchaseSidebar.selectedTowerType) { //hardcoded
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
                case TATowerTypePsychicTower:
                    towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"SpinTower"] size:CGSizeMake(TATowerSizePsychicTower, TATowerSizePsychicTower)];
                    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:TATowerSizePsychicTower / 2];
                    detectorSize = CGSizeMake(TATowerAttackRadiusPsychicTower * 2 + 25, TATowerAttackRadiusPsychicTower * 2 +  25);
                    break;
            }
            towerPlaceHolder.colorBlendFactor = 0.5;
            towerPlaceHolder.name = @"Placeholder";
            towerPlaceHolder.position = [touch locationInNode:self];
            towerPlaceHolder.zPosition = 0.4;
            towerPlaceHolder.physicsBody.collisionBitMask = TAContactTypeNothing;
            towerPlaceHolder.physicsBody.contactTestBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.categoryBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.dynamic = YES;
            
            SKSpriteNode *detectorPlaceholder = [SKSpriteNode spriteNodeWithImageNamed:@"TowerRadius"];
            detectorPlaceholder.size = detectorSize;
            detectorPlaceholder.alpha = 0.7;
            detectorPlaceholder.zPosition = 0.4;
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
-(void)contactBeganBetweenTower:(TATower *)tower andEnemy:(TAEnemy *)enemy;
{
    if (![tower.enemiesInRange containsObject:enemy]) {
        [tower.enemiesInRange addObject:enemy];
        if ([tower.enemiesInRange count] == 1 || tower.isPassive) {
            [tower beginAttack];
        }
    }
}

-(void)contactEndedBetweenTower:(TATower *)tower andEnemy:(TAEnemy *)enemy;
{
    if (tower.isPassive) {
        [tower performSelectorOnMainThread:@selector(endAttackOnEnemy:) withObject:enemy waitUntilDone:YES];
        [tower.enemiesInRange removeObject:enemy];
    }
    else {
        [tower.enemiesInRange removeObject:enemy];
        [tower endAttack];
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
        case TATowerSizePsychicTower: {
            TAPsychicTower *tower = [[TAPsychicTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
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
    for (TATower *tower in [self towersOnField]) {
        for (TAEnemy *enemy in [self enemiesOnField]) {
            if ([self distanceFromA:tower.position toB:enemy.position] <= tower.attackRadius && ![tower.enemiesInRange containsObject:enemy]) {
                [self contactBeganBetweenTower:tower andEnemy:enemy];
            }
            else if ([self distanceFromA:tower.position toB:enemy.position] > tower.attackRadius && [tower.enemiesInRange containsObject:enemy]) {
                [self contactEndedBetweenTower:tower andEnemy:enemy];
            }
        }
    }
}

@end
