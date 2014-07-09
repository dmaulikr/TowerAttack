//
//  MyScene.h
//  TowerAttack
//

//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TATower;

typedef enum : uint8_t {
    TAContactTypeTower             = 1,
    TAContactTypeEnemy             = 2,
    TAContactTypeProjectile        = 4,
    TAContactTypeDetector          = 8,
    TAContactTypeNothing           = 16
} TAContactType;

@interface TABattleScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) CGPoint destination;
@property (strong, nonatomic) NSMutableArray *towersOnField;
@property (strong, nonatomic) NSMutableArray *enemiesOnField;
@property (nonatomic) CGPoint spawnPoint;
@property (nonatomic) NSInteger spawnRefreshCount;
@property (nonatomic) NSInteger enemiesLetThrough;
@property (nonatomic) CGPathRef enemyMovementPath;
@property (nonatomic) CGFloat enemyMovementPathLength;

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB;
-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point;

@end
