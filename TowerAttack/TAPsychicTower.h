//
//  TAPsychicTower.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TANonPassiveTower.h"

@interface TAPsychicTower : TATower

@property (nonatomic) CGFloat timeBetweenAttacks;
@property (nonatomic) CGFloat attackDamage;
@property (nonatomic, strong) NSMutableArray *damageTimers;
@property (nonatomic, strong) NSMutableArray *damageNodes;

-(void)damageEnemyFromTimer:(NSTimer *)timer;

@end
