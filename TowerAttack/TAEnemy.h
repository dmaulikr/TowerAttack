//
//  TAEnemy.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TAUnit.h"

@class TABattleScene;

@interface TAEnemy : TAUnit

@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic) CGFloat maximumHealth;
@property (nonatomic) CGFloat currentHealth;
@property (nonatomic, strong) SKSpriteNode *healthBarInside;
@property (nonatomic) NSUInteger goldReward;


@end
