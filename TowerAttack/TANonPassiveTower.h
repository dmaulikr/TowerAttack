//
//  TATower.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATower.h"

@interface TANonPassiveTower : TATower

@property (nonatomic) CGFloat timeBetweenAttacks;
@property (nonatomic) NSInteger attackDamage;
@property (nonatomic) NSInteger projectileSpeed;
@property (nonatomic) NSUInteger maximumSimultaneouslyAffectedEnemies;
@property (nonatomic) CGFloat normalBirthRateOfProjectile;
@property (nonatomic, strong) NSTimer *attackUpdate;
@property (nonatomic, strong) SKEmitterNode *projectileToFire;
@property (nonatomic, strong) NSString *projectileWAVSoundString;

-(void)fireProjectile;
-(void)turnOffEmitter;

@end
