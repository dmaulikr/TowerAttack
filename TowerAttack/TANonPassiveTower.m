//
//  TATower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TANonPassiveTower.h"
#import "TABattleScene.h"
#import "TAEnemy.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"

@implementation TANonPassiveTower

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        //init code
        self.isPassive = NO;
    }
    return self;
}

-(void)beginAttack
{
    self.attackUpdate = [NSTimer scheduledTimerWithTimeInterval:self.timeBetweenAttacks target:self selector:@selector(fireProjectile) userInfo:nil repeats:YES];
    [self fireProjectile];
}

-(void)fireProjectile
{
  //overidden by subclasses
}

-(void)endAttack
{
    //  NSLog(@"End");
    if ([self.enemiesInRange count] == 0) {
        NSLog(@"Inv");
        [self.attackUpdate invalidate];
    }
}

-(void)turnOffEmitter
{
    self.projectileToFire.particleBirthRate = 0;
}


@end
