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

-(id)initWithImageNamed:(NSString *)name andLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithImageNamed:name andLocation:location inScene:sceneParam]) {
        //init code
        self.movementSpeed = 20;
        self.maximumHealth = 100;
        self.currentHealth = 100;
        self.goldReward = 10;
        self.description = @"Weak but relatively fast, enemies are a common enemy, but not too much of a threat.";
        self.unitType = @"Enemy";
        self.imageName = @"Goblin";
        self.zPosition = 0.1;
        
        self.name =  [NSString stringWithFormat:@"Enemy %lu", (unsigned long)[self.battleScene.towersOnField count]];
        self.size = CGSizeMake(100, 100);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 4];
        self.physicsBody.dynamic = YES;
        self.physicsBody.contactTestBitMask = TAContactTypeProjectile | TAContactTypeDetector;
        self.physicsBody.categoryBitMask = TAContactTypeEnemy;
        self.physicsBody.collisionBitMask = TAContactTypeNothing;
        
        SKSpriteNode *outsideBar = [SKSpriteNode spriteNodeWithImageNamed:@"Health_Bar_Outside"];
        outsideBar.size = CGSizeMake(35, 5.6);
        outsideBar.anchorPoint = CGPointMake(0, 0.5);
        
        self.healthBarInside = [SKSpriteNode spriteNodeWithImageNamed:@"Health_Bar_Inside"];
        self.healthBarInside.size = CGSizeMake(33.5, 3.8);
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + 20);
        self.healthBarInside.anchorPoint = CGPointMake(0, 0.5);
        [self.healthBarInside addChild:outsideBar];
        [self.battleScene addChild:self.healthBarInside];
        
        [self runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:YES duration:30] reversedAction] completion:^{
            self.battleScene.uiOverlay.livesLeft--;
            [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
            [self.battleScene.enemiesOnField removeObject:self];
        }];
        [self.healthBarInside runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:NO duration:30] reversedAction]];
    }
    return self;
}

-(void)setCurrentHealth:(NSInteger)currentHealth
{
    _currentHealth = currentHealth;
    [(UILabel *)[self.battleScene.uiOverlay.infoPanel.additionalUnitInfo objectAtIndex:0] setText:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth]];
    self.healthBarInside.size = CGSizeMake(33.5 * self.currentHealth / self.maximumHealth, self.healthBarInside.size.height);
    if (_currentHealth <= 0 && [self.battleScene.enemiesOnField containsObject:self]) {
        _currentHealth = 0;
        [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
        [self.battleScene.enemiesOnField removeObject:self];
        self.battleScene.uiOverlay.currentGold += self.goldReward;
        [self removeAllActions];
    }
}

-(void)setMaximumHealth:(NSInteger)maximumHealth
{
    _maximumHealth = maximumHealth;
    self.currentHealth = maximumHealth;
}

@end
