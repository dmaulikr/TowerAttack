//
//  TAEnemy.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TABattleScene;

@interface TAEnemy : SKSpriteNode

@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic, weak) TABattleScene *battleScene;
@property (nonatomic) NSInteger maximumHealth;
@property (nonatomic) NSInteger currentHealth;
@property (nonatomic, strong) SKSpriteNode *healthBarInside;
@property (nonatomic) NSUInteger goldReward;


-(id)initWithImageNamed:(NSString *)name andLocation:(CGPoint)location inScene:(TABattleScene *)scene;

@end
