//
//  TAUnit.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAUnit.h"

@implementation TAUnit

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super init]) {
        //init code
        self.battleScene = sceneParam;
        self.position = location;
    }
    return self;
}

@end
