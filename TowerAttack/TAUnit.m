//
//  TAUnit.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAUnit.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"

@implementation TAUnit

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super init]) {
        //init code
        self.battleScene = sceneParam;
        self.position = location;
        self.infoStrings = [NSMutableArray array];
    }
    return self;
}

-(NSMutableArray *)infoStrings
{
    if (self.battleScene.uiOverlay.infoPanel.selectedUnit == self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.battleScene.uiOverlay.infoPanel refreshLabelsWithInfo:_infoStrings];
        });
    }
    return _infoStrings;
}

@end
