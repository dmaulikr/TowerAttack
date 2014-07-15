//
//  TAUnit.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAUnit.h"

@implementation TAUnit

-(id)initWithImageNamed:(NSString *)name andLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithImageNamed:name]) {
        //init code
        self.battleScene = sceneParam;
        self.position = location;
    }
    return self;
}

@end
