//
//  TAEnemy.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAEnemy.h"
#import "TABattleScene.h"

@implementation TAEnemy

-(id)initWithImageNamed:(NSString *)name andLocation:(CGPoint)location inScene:(TABattleScene *)scene
{
    if (self == [super initWithImageNamed:name]) {
        //init code
        self.battleScene = scene;
        self.movementSpeed = 20;
        self.maximumHealth = 100;
        self.currentHealth = 100;
        
        self.name =  [NSString stringWithFormat:@"Enemy %lu", (unsigned long)[self.battleScene.towersOnField count]];
        self.size = CGSizeMake(100, 100);
        self.position = location;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 6];
        self.physicsBody.dynamic = YES;
        self.physicsBody.contactTestBitMask = TAContactTypeTower | TAContactTypeProjectile | TAContactTypeDetector;
        self.physicsBody.categoryBitMask = TAContactTypeEnemy;
        self.physicsBody.collisionBitMask = TAContactTypeTower;
        
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
            self.battleScene.enemiesLetThrough++;
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
    self.healthBarInside.size = CGSizeMake(33.5 * self.currentHealth / self.maximumHealth, self.healthBarInside.size.height);
    if (_currentHealth <= 0) {
        [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
        [self.battleScene.enemiesOnField removeObject:self];
    }
}

-(void)setMaximumHealth:(NSInteger)maximumHealth
{
    _maximumHealth = maximumHealth;
    self.currentHealth = maximumHealth;
}

@end
