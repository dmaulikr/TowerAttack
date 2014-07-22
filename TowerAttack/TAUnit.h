//
//  TAUnit.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TABattleScene;

@interface TAUnit : SKSpriteNode {
   // NSMutableArray *_infoStrings;
}

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, weak) TABattleScene *battleScene;
@property (nonatomic, strong) NSString *unitType;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSMutableArray *infoStrings;

-(id)initWithLocation:(CGPoint)location inScene: (TABattleScene *)sceneParam;


@end
