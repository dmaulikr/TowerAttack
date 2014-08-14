//
//  MyScene.h
//  TowerAttack
//

//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class TANonPassiveTower;
@class TAUIOverlay;
@class TATower;
@class TAEnemy;

#define screenWidth [[UIScreen mainScreen] bounds].size.width


typedef enum : uint8_t {
    TAContactTypeTower             = 1,
    TAContactTypeEnemy             = 2,
    TAContactTypeProjectile        = 4,
    TAContactTypeDetector          = 8,
    TAContactTypeNothing           = 0
} TAContactType;

enum TANodeZPosition : NSInteger {
    TANodeZPositionBackground,
    TANodeZPositionPath,
    TANodeZPositionTower,
    TANodeZPositionEnemy,
    TANodeZPositionProjectile,
    TANodeZPositionRadius,
    TANodeZPositionPlaceholder
};

enum TAArea : NSInteger {
    TAAreaGrassy
};

@interface TAScene : SKScene

@end

@interface TABattleScene : SKSpriteNode <SKPhysicsContactDelegate>

@property (strong, nonatomic) NSMutableArray *towersOnField;
@property (strong, nonatomic) NSMutableArray *enemiesOnField;
@property (strong, nonatomic) NSArray *waveInfo;
@property (nonatomic) CGPoint spawnPoint;
@property (nonatomic) NSUInteger currentWave;
@property (nonatomic) NSUInteger currentArea;
@property (nonatomic) NSUInteger enemyCount;
@property (nonatomic) CGPathRef enemyMovementPath;
@property (nonatomic) BOOL click;
@property (nonatomic) BOOL isDraggingTowerPlaceholder;
@property (nonatomic) BOOL waveIsSpawning;
@property (nonatomic) CGPoint lastPoint;
@property (strong, nonatomic) TAUIOverlay *uiOverlay;
@property (nonatomic) CGRect pathDrawerFrame;
@property (nonatomic) CGFloat scale;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (strong, nonatomic) SKSpriteNode *towerRadiusDisplay;

-(CGFloat)distanceFromA:(CGPoint)pointA toB:(CGPoint)pointB;
-(id)initWithSize:(CGSize)size andPath:(CGPathRef)path andSpawnPoint:(CGPoint)point;
-(void)spawnEnemyOfType:(NSUInteger)enemyType;
-(void)addTower;
-(void)userClickedAtLocation:(UITouch *)touch;
-(void)checkForWaveOver;
-(void)contactBeganBetweenTower:(TATower *)tower andEnemy:(TAEnemy *)enemy;
-(void)contactEndedBetweenTower:(TATower *)tower andEnemy:(TAEnemy *)enemy;
-(void)removeTower:(TATower *)tower;
-(void)configurePathsForSize:(CGSize)size;

@end
