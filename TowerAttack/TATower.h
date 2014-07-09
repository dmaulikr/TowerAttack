//
//  TATower.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TAEnemy;
@class TABattleScene;

@interface TATower : SKSpriteNode

@property (nonatomic) CGFloat spaceUsedRadius;
@property (nonatomic) CGFloat attackRadius;
@property (nonatomic) CGFloat timeBetweenAttacks;
@property (nonatomic) NSInteger attackDamage;
@property (nonatomic) NSInteger projectileSpeed;
@property (nonatomic) BOOL isAttacking;
@property (nonatomic, strong) NSTimer *attackUpdate;
@property (nonatomic, weak) TABattleScene *battleScene;
@property (nonatomic, strong) NSMutableSet *enemiesInRange;
@property (nonatomic) NSUInteger purchaseCost;


-(void)beginAttackOnEnemy: (TAEnemy *)enemy;
-(void)endAttack;
-(void)fireProjectileCalledByTimer: (NSTimer *)timer;
-(id)initWithImageNamed:(NSString *)name andLocation:(CGPoint)location inScene: (TABattleScene *)sceneParam;


@end
