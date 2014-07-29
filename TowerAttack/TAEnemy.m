//
//  TAEnemy.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAEnemy.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"

@implementation TAEnemy

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        //init code
        _movementSpeed = arc4random() % 20 + 30;
        _maximumHealth = 100;
        _currentHealth = 100;
        self.goldReward = 10;
        self.description = @"Weak but relatively fast, enemies are a common enemy, but not too much of a threat.";
        self.unitType = @"Enemy";
        self.imageName = @"Goblin";
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth], [NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed], nil]];
        self.zPosition = 0.4;
        
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.name =  [NSString stringWithFormat:@"Enemy %lu", (unsigned long)[self.battleScene.enemiesOnField count]];
        self.size = CGSizeMake(100, 100);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 4];
        self.physicsBody.dynamic = YES;
        self.physicsBody.contactTestBitMask = TAContactTypeDetector;
        self.physicsBody.categoryBitMask = TAContactTypeEnemy;
        self.physicsBody.collisionBitMask = TAContactTypeNothing;
        
        SKSpriteNode *outsideBar = [SKSpriteNode spriteNodeWithImageNamed:@"Health_Bar_Outside"];
        outsideBar.size = CGSizeMake(35, 5.6);
        outsideBar.anchorPoint = CGPointMake(0, 0.5);
        
        self.healthBarInside = [SKSpriteNode spriteNodeWithImageNamed:@"Health_Bar_Inside"];
        self.healthBarInside.size = CGSizeMake(33.5, 3.9);
        self.healthBarInside.zPosition = 0.4;
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + 20);
        self.healthBarInside.anchorPoint = CGPointMake(0, 0.5);
        [self.healthBarInside addChild:outsideBar];
        [self.battleScene addChild:self.healthBarInside];
        
        [self runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:YES speed:self.movementSpeed] reversedAction] completion:^{
            self.battleScene.uiOverlay.livesLeft--;
            [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
            [self.battleScene.enemiesOnField removeObject:self];
        }];
        [self.healthBarInside runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:NO speed:self.movementSpeed] reversedAction]];
     /*   [self runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:YES duration:60] reversedAction] completion:^{
            self.battleScene.uiOverlay.livesLeft--;
            [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
            [self.battleScene.enemiesOnField removeObject:self];
        }];
        [self.healthBarInside runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:NO duration:60] reversedAction]];*/
    }
    return self;
}

-(void)setCurrentHealth:(CGFloat)currentHealth
{
    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth]];
    _currentHealth = currentHealth;
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth]];
    }
    self.healthBarInside.size = CGSizeMake(33.5 * self.currentHealth / self.maximumHealth, self.healthBarInside.size.height);
    if (_currentHealth <= 0 && [self.battleScene.enemiesOnField containsObject:self]) {
        _currentHealth = 0;
        [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
        [self.battleScene.enemiesOnField removeObject:self];
        self.battleScene.uiOverlay.currentGold += self.goldReward;
        [self removeAllActions];
    }
}

-(void)setSpeed:(CGFloat)speed
{
    NSUInteger index = 0;
  //  if (speed != 1) {
        index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed]];
  /*  }
    else {
        index = [self.infoStrings indexOfObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed] attributes:[NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName]]];
    }*/
    [super setSpeed:speed];
//    if (speed == 1) {
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed]];
    }
 /*   }
    else {
        [self.infoStrings replaceObjectAtIndex:index withObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed] attributes:[NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName]]];
    }*/
}

-(void)setMaximumHealth:(CGFloat)maximumHealth
{
    _maximumHealth = maximumHealth;
    self.currentHealth = maximumHealth;
}

@end
