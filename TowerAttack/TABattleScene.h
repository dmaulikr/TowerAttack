//
//  MyScene.h
//  TowerAttack
//

//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TANonPassiveTower;
@class TAUIOverlay;
@class TAPathDrawer;

typedef enum : uint8_t {
    TAContactTypeTower             = 1,
    TAContactTypeEnemy             = 2,
    TAContactTypeProjectile        = 4,
    TAContactTypeDetector          = 8,
    TAContactTypeNothing           = 0
} TAContactType;

@interface TABattleScene : SKNode <SKPhysicsContactDelegate>

@property (strong, nonatomic) NSMutableArray *towersOnField;
@property (strong, nonatomic) NSMutableArray *enemiesOnField;
@property (nonatomic) CGPoint spawnPoint;
@property (nonatomic) NSInteger spawnRefreshCount;
@property (nonatomic) CGPathRef enemyMovementPath;
@property (nonatomic) CGFloat enemyMovementPathLength;
@property (nonatomic) BOOL click;
@property (nonatomic) BOOL isDraggingTowerPlaceholder;
@property (nonatomic) CGPoint lastPoint;
@property (strong, nonatomic) TAUIOverlay *uiOverlay;
@property (strong, nonatomic) TAPathDrawer *pathDrawer;
@property (nonatomic) CGRect pathDrawerFrame;

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB;
-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point;
-(void)spawnEnemy;
-(void)addTower;
-(void)userClickedAtLocation:(UITouch *)touch;

@end
