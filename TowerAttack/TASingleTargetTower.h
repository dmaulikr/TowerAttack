//
//  TASingleTargetTower.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TANonPassiveTower.h"

@interface TASingleTargetTower : TANonPassiveTower

-(SKEmitterNode *)projectile;
-(NSInteger)towerTypeFromSubclass;

@end
