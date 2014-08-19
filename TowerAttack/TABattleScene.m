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
#import "TAArrowTower.h"
#import "TAEnemy.h"
#import "TAPsychicTower.h"
#import "TAUIOverlay.h"
#import "TATowerPurchaseSidebar.h"
#import "TAInfoPopUp.h"
#import "TAAttacker.h"
#import "TAProtector.h"
#import "TADemon.h"
#import "TANinja.h"
#import "TAButton.h"
#import "TAPLayerProfile.h"

@implementation TAScene

int numWaves = 2;

-(void)didSimulatePhysics
{
    TABattleScene *node = [[self children] lastObject];
    if (node.uiOverlay.sceneScale != node.uiOverlay.lastScale) {
        node.scale = node.uiOverlay.sceneScale;
        node.position = node.uiOverlay.scenePoint;
    }
    
    if ([[[(SKSpriteNode *)[node childNodeWithName:@"Placeholder"] physicsBody] allContactedBodies] count] > 0 || node.uiOverlay.currentGold < 50) {
        [(SKSpriteNode *)[node childNodeWithName:@"Placeholder"] setColor:[UIColor redColor]];
    }
    else
        [(SKSpriteNode *)[node childNodeWithName:@"Placeholder"] setColor:[UIColor greenColor]];
    
    for (TATower *tower in [node towersOnField]) {
        for (TAEnemy *enemy in [node enemiesOnField]) {
            CGFloat distance = [node distanceFromA:tower.position toB:enemy.position];
            if (distance - enemy.size.width / 2 <= tower.attackRadius && ![tower.enemiesInRange containsObject:enemy]) {
                [node contactBeganBetweenTower:tower andEnemy:enemy];
            }
            else if (distance - enemy.size.width > tower.attackRadius && [tower.enemiesInRange containsObject:enemy]) {
                [node contactEndedBetweenTower:tower andEnemy:enemy];
            }
        }
    }
    
    if (node.waveIsSpawning && !node.isPaused && arc4random() % 20 == 0) {
        NSString *waveString = (NSString *)[node.waveInfo objectAtIndex:node.currentWave % node.waveInfo.count];
        waveString = @"101";
        [node spawnEnemyOfType:[waveString characterAtIndex:node.enemyCount] - 48];
        if (node.enemyCount++ >= waveString.length - 1) {
            node.waveIsSpawning = NO;
        }
    }
}

@end


@implementation TABattleScene

#pragma mark - scene configuration

-(id)initWithSize:(CGSize)size path:(CGPathRef)path spawnPoint:(CGPoint)point {
    if (self = [super initWithColor:[UIColor redColor] size:size]) {
        
        TAPlayerProfile *profile = [TAPlayerProfile sharedInstance];
        
        self.currentWave = 1;
        self.enemyCount = 0;
        self.currentArea = profile.lastStagePlayed;//profile.stage;
        self.spawnPoint = CGPointMake(point.x, areaHeight);//point;
        self.click = NO;
        _waveIsSpawning = NO;
        self.towersOnField = [[NSMutableArray alloc] init];
        self.enemiesOnField = [[NSMutableArray alloc] init];
        self.isDraggingTowerPlaceholder = NO;
        self.enemyMovementPath = CGPathCreateCopy(path);
       
        self.position = CGPointMake((point.x - screenWidth / 2) * -1, 320 - areaHeight);
        self.size = size;
        self.scale = 1.0f;
        
        self.zPosition = TANodeZPositionBackground;
        self.anchorPoint = CGPointMake(0, 0);
        
        self.towerRadiusDisplay = [SKSpriteNode spriteNodeWithImageNamed:@"TowerRadius"];
        self.towerRadiusDisplay.alpha = 0.0;
        self.towerRadiusDisplay.zPosition = TANodeZPositionRadius;
        [self addChild:self.towerRadiusDisplay];
        
        self.waveInfo = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"WaveInfo"];
        
        [self configurePathsForSize:size];
        
    }
    return self;
}

-(void)configurePathsForSize:(CGSize)size
{
    SKNode *pathDrawer = [SKNode node];
    pathDrawer.zPosition = TANodeZPositionPath;
    pathDrawer.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 40, kCGLineCapRound, kCGLineJoinRound, 100)];
    pathDrawer.physicsBody.categoryBitMask = TAContactTypeTower;
    pathDrawer.physicsBody.contactTestBitMask = TAContactTypeTower;
    pathDrawer.name = @"Path";
    pathDrawer.physicsBody.collisionBitMask = TAContactTypeNothing;
    [self addChild:pathDrawer];
    
    NSString *imageForArea;
    switch (self.currentArea) {
        case 1:
            imageForArea = @"Grass.jpg";
            break;
        case 2:
            imageForArea = @"FireArea.jpg";
            break;
        default:
            NSLog(@"Area out of range");
            imageForArea = @"Grass.jpg";
            break;
    }
    
    int i = 1;
    if IOS8 {
        i = 0;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, i);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(c, CGRectMake(0, 0, 240, 240), [UIImage imageNamed:imageForArea].CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.texture = [SKTexture textureWithImage:image];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, i);
    c = UIGraphicsGetCurrentContext();
    CGContextAddPath(c, CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 40, kCGLineCapRound, kCGLineJoinRound, 100));
    CGContextClip(c);
    CGContextDrawTiledImage(c, CGRectMake(0, 0, 240, 240), [UIImage imageNamed:@"sand.jpg"].CGImage);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SKSpriteNode *pathFill = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
    pathFill.zPosition = TANodeZPositionPath;
    pathFill.size = self.size;
    pathFill.yScale = -1.0;
    pathFill.colorBlendFactor = 1;
    pathFill.color = [UIColor colorWithRed:1 green:226.0/255.0 blue:145.0f/255.0f alpha:1];
    pathFill.position = CGPointMake(600, 450);
    [self addChild:pathFill];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, i);
    c = UIGraphicsGetCurrentContext();
    CGContextAddPath(c, CGPathCreateCopyByStrokingPath(self.enemyMovementPath, NULL, 42, kCGLineCapRound, kCGLineJoinRound, 100));
    CGContextSetRGBStrokeColor(c, 0, 0, 0, 1);
    CGContextSetLineWidth(c, 1.5);
    CGContextStrokePath(c);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    SKSpriteNode *pathOutline = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];
    pathOutline.zPosition = TANodeZPositionPath - 0.1;
    pathOutline.size = self.size;
    pathOutline.yScale = -1.0;
    pathOutline.position = CGPointMake(600, 450);
    [self addChild:pathOutline];

}

#pragma mark - respond to touches

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
        SKSpriteNode *placeholder = (SKSpriteNode *)[self childNodeWithName:@"Placeholder"];
        [placeholder setPosition:[[touches anyObject] locationInNode:self]];
        [self.towerRadiusDisplay setPosition:[[touches anyObject] locationInNode:self]];
        if ([[[placeholder physicsBody] allContactedBodies] count] > 0 || self.uiOverlay.currentGold < 50) {
            [placeholder setColor:[UIColor redColor]];
        }
        else
            [placeholder setColor:[UIColor greenColor]];
    }
    else {
        CGFloat deltaX = ([[touches anyObject] locationInNode:self].x - self.lastPoint.x) * self.scale, deltaY = ([[touches anyObject] locationInNode:self].y - self.lastPoint.y) * self.scale;
        if (self.position.x + deltaX > 0) {
            deltaX = (CGFloat)self.position.x * -1;
        }
        else if (self.position.x * -1 - deltaX + self.scene.view.frame.size.width >= areaWidth * self.scale) {
            deltaX = (areaWidth * self.scale + self.position.x - self.scene.view.frame.size.width) * -1;
        }
        if (self.position.y + deltaY > 0) {
            deltaY = self.position.y * -1;
        }
        else if ((self.position.y + deltaY) * -1 + self.scene.view.frame.size.height >= areaHeight * self.scale) {
            deltaY = (areaHeight * self.scale + self.position.y - self.scene.view.frame.size.height) * -1;
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
    else if ([self childNodeWithName:@"Placeholder"] != nil && self.uiOverlay.cancelButton.alpha == 0) {
        [self.uiOverlay changeNodeOverlayLocation:CGPointMake(self.uiOverlay.lastOverlayLocation.x, self.uiOverlay.lastOverlayLocation.y)  andHidden:NO];
    }
    self.isDraggingTowerPlaceholder = NO;
}

-(void)userClickedAtLocation:(UITouch *)touch
{
    SKNode *nodeTouched = [SKNode node];
    if ([[self nodesAtPoint:[touch locationInNode:self]] count] > 1) {
        for (SKNode *n in [self nodesAtPoint:[touch locationInNode:self]]) {
            if (([n.name characterAtIndex:0] == 'E' && [nodeTouched.name characterAtIndex:0] != 'T' && [nodeTouched.name characterAtIndex:1] != 'l') || ([n.name characterAtIndex:0] == 'T' && [self distanceFromA:n.position toB:[touch locationInNode:self]] <= [(SKSpriteNode *)n size].width  && [nodeTouched.name characterAtIndex:1] != 'l') || [n.name characterAtIndex:1] == 'l') {
                nodeTouched = n;
            }
        }
    }
    else {
        nodeTouched = [self nodeAtPoint:[touch locationInNode:self]];
    }
    if ([[nodeTouched name] characterAtIndex:0] == 'E') {
        self.uiOverlay.selectedUnit = (TAEnemy *)nodeTouched;
        self.towerRadiusDisplay.alpha = 0.0;
    }
    else if ([[nodeTouched name] characterAtIndex:0] == 'T') {
        TATower *tower = (TATower *)nodeTouched;
        self.uiOverlay.selectedUnit = tower;
        self.towerRadiusDisplay.size = CGSizeMake(tower.attackRadius * 2 + 25, tower.attackRadius * 2 + 25);
        self.towerRadiusDisplay.position = tower.position;
        self.towerRadiusDisplay.alpha = 0.7;
    }
    else {
        if ([touch locationInView:self.uiOverlay].y < panelY && ((UIView *)self.uiOverlay.infoPanel).frame.origin.y == panelY) {
            /*[UIView animateWithDuration:0.25 animations:^(void) {
                ((UIView *)self.uiOverlay.infoPanel).frame = CGRectMake(0, screenWidth, screenWidth, 80);
                self.uiOverlay.purchaseSidebar.frame = CGRectMake(screenWidth - 68, 0, 68, 320);
            }];*/
            [self.uiOverlay setSelectedUnit:nil];
        }
      /*  if ([touch locationInView:self.uiOverlay].y > 280) {
            [self spawnEnemyOfType:1];
        }*/
        else if ([self childNodeWithName:@"Placeholder"] == nil && self.uiOverlay.purchaseSidebar.selectedTowerType != TATowerTypeNoTower) {
            SKSpriteNode *towerPlaceHolder;
            CGSize detectorSize;
            switch (self.uiOverlay.purchaseSidebar.selectedTowerType) { //hardcoded
                case TATowerTypeArrowTower:
                    towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Tower"] size:CGSizeMake(TATowerSizeArrowTower, TATowerSizeArrowTower)];
                    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:TATowerSizeArrowTower / 2];
                    detectorSize = CGSizeMake(TATowerAttackRadiusArrowTower * 2 + 25, TATowerAttackRadiusArrowTower * 2 + 25);
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
                case TATowerTypeFireballTower:
                    towerPlaceHolder = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Fire"] size:CGSizeMake(TATowerSizeFireballTower, TATowerSizeFireballTower)];
                    towerPlaceHolder.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:TATowerSizeFireballTower / 2];
                    detectorSize = CGSizeMake(TATowerAttackRadiusFireballTower * 2 + 25, TATowerAttackRadiusFireballTower * 2 + 25);
                    break;
            }
            towerPlaceHolder.colorBlendFactor = 0.5;
            towerPlaceHolder.name = @"Placeholder";
            towerPlaceHolder.position = [touch locationInNode:self];
            towerPlaceHolder.zPosition = TANodeZPositionPlaceholder;
            towerPlaceHolder.physicsBody.collisionBitMask = TAContactTypeNothing;
            towerPlaceHolder.physicsBody.contactTestBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.categoryBitMask = TAContactTypeTower;
            towerPlaceHolder.physicsBody.dynamic = YES;
            
            self.towerRadiusDisplay.size = detectorSize;
            self.towerRadiusDisplay.position = towerPlaceHolder.position;
            self.towerRadiusDisplay.alpha = 0.7;
            
            [self addChild:towerPlaceHolder];
            self.uiOverlay.selectedNode = towerPlaceHolder;
            self.uiOverlay.purchaseSidebar.selectedTowerType = TATowerTypeNoTower;
            [UIView animateWithDuration:0.2 animations:^{
                self.uiOverlay.purchaseSidebar.infoPopUp.alpha = 0.0;
            }];
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
        else if ([nodeTouched.name characterAtIndex:0] != 'T' && [self childNodeWithName:@"Placeholder"] == nil) {
            self.towerRadiusDisplay.alpha = 0.0;
            self.uiOverlay.selectedUnit = nil;
        }
    }
}

#pragma mark - wave handling

-(void)setCurrentWave:(NSUInteger)currentWave
{
    _currentWave = currentWave;
    if (currentWave >= numWaves) {
        //do stuff
    }
}

-(void)setWaveIsSpawning:(BOOL)waveIsSpawning
{
    _waveIsSpawning = waveIsSpawning;
    if (waveIsSpawning) {
        self.enemyCount = 0;
        self.currentWave++;
    }
}

-(void)checkForWaveOver
{
    if (self.enemiesOnField.count == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.uiOverlay.startWaveButton.alpha = 1.0;
        }];
        self.currentWave++;
    }
}

#pragma mark - tower range handling

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB
{
    return sqrtf(powf((pointA.x - pointB.x), 2) + powf((pointA.y - pointB.y), 2));
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

#pragma mark - add/remove units

-(void)addTower
{
    TATower *tower;
    switch ((NSInteger)[(SKSpriteNode *)[self childNodeWithName:@"Placeholder"] size].width) {
        case TATowerSizeArrowTower: //hardcoded
            tower = [[TAArrowTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            break;
        case TATowerSizeFreezeTower:
            tower = [[TAFreezeTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            break;
        case TATowerSizeBlastTower:
            tower = [[TABlastTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            break;
        case TATowerSizePsychicTower:
            tower = [[TAPsychicTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            break;
        case TATowerSizeFireballTower:
            tower = [[TAFireballTower alloc] initWithLocation:[[self childNodeWithName:@"Placeholder"] position] inScene:self];
            break;
    }
    self.uiOverlay.currentGold -= tower.purchaseCost;
    [self removeChildrenInArray:[NSArray arrayWithObject:[self childNodeWithName:@"Placeholder"]]];
    [self addChild:tower];
    [self.towersOnField addObject:tower];
}

-(void)removeTower:(TATower *)tower
{
    [self.towersOnField removeObject:tower];
    [tower removeFromParent];
    [self removeChildrenInArray:tower.levelStripes];
}

-(void)spawnEnemyOfType:(NSUInteger)enemyType
{
    switch (enemyType) { //hardcoded
        case 0: {
            TAAttacker *enemy = [[TAAttacker alloc] initWithLocation:self.spawnPoint inScene:self];
            [self addChild:enemy];
            [self.enemiesOnField addObject:enemy];
        }
            break;
        case 1: {
            TAProtector *enemy = [[TAProtector alloc] initWithLocation:self.spawnPoint inScene:self];
            [self addChild:enemy];
            [self.enemiesOnField addObject:enemy];
        }
            break;
        case 2: {
            TADemon *enemy = [[TADemon alloc] initWithLocation:self.spawnPoint inScene:self];
            [self addChild:enemy];
            [self.enemiesOnField addObject:enemy];
        }
            break;
        case 3: {
            TANinja *enemy = [[TANinja alloc] initWithLocation:self.spawnPoint inScene:self];
            [self addChild:enemy];
            [self.enemiesOnField addObject:enemy];
        }
            break;
            
        default:
            NSLog(@"Invalid Enemy Type");
            break;
    }
}

@end
