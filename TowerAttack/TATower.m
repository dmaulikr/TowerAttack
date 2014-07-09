//
//  TATower.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATower.h"
#import "TABattleScene.h"
#import "TAEnemy.h"

@implementation TATower

-(id)initWithImageNamed:(NSString *)name andLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithImageNamed:name]) {
        //init code
        self.attackRadius = 200;
        self.battleScene = sceneParam;
        self.timeBetweenAttacks = 0.25;
        self.attackDamage = 3;
        self.isAttacking = NO;
        self.projectileSpeed = 400;
        self.enemiesInRange = [NSMutableSet set];
        
        self.size = CGSizeMake(30, 30);
        self.name =  [NSString stringWithFormat:@"Tower %d", [self.battleScene.towersOnField count]];
        self.position = location;
        
        self.physicsBody.contactTestBitMask = TAContactTypeEnemy;
        self.physicsBody.categoryBitMask = TAContactTypeTower;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 2];
        self.physicsBody.dynamic = NO;
        
        SKNode *collisionDetection = [SKNode node];
       // SKSpriteNode *collisionDetection = [SKSpriteNode spriteNodeWithImageNamed:@"1"];
       // collisionDetection.size = CGSizeMake(self.attackRadius * 2, self.attackRadius * 2);
        collisionDetection.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.attackRadius];
        collisionDetection.name = [NSString stringWithFormat:@"Detector %d", [self.battleScene.towersOnField count]];
        collisionDetection.position = self.position;
        collisionDetection.physicsBody.contactTestBitMask = TAContactTypeEnemy;
        collisionDetection.physicsBody.categoryBitMask = TAContactTypeDetector;
        collisionDetection.physicsBody.collisionBitMask = TAContactTypeNothing;
        collisionDetection.physicsBody.dynamic = NO;
        [self.battleScene addChild:collisionDetection];
    }
    return self;
}

-(void)beginAttackOnEnemy:(TAEnemy *)enemy
{
  //  NSLog(@"Begin");
    self.attackUpdate = [NSTimer scheduledTimerWithTimeInterval:self.timeBetweenAttacks target:self selector:@selector(fireProjectileCalledByTimer:) userInfo:enemy repeats:YES];
    self.isAttacking = YES;
}

-(void)fireProjectileCalledByTimer:(NSTimer *)timer
{
    //code to show projectile
  //  NSLog(@"%@ shot",self.name);
    TAEnemy *enemy = (TAEnemy *)[timer userInfo];
    SKEmitterNode *projectileToFire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Projectile" ofType:@"sks"]];
    projectileToFire.position = self.position;
    [self.battleScene addChild:projectileToFire];
    [projectileToFire runAction:[SKAction moveTo:enemy.position
                                        duration:[self.battleScene distanceFromA:self.position
                                                                             toB:enemy.position]/ (self.projectileSpeed + 50)]
                     completion:^{
                         [projectileToFire removeFromParent];
                         [enemy setCurrentHealth:enemy.currentHealth - self.attackDamage];
                        // NSLog(@"Hit; enemy health = %d",enemy.currentHealth);
                         if ([enemy currentHealth] <= 0) {
                             [self endAttack];
                         }
                     }];
}

-(void)endAttack
{
  //  NSLog(@"End");
    [self.attackUpdate invalidate];
    if ([self.enemiesInRange count] > 0) {
        self.attackUpdate = [NSTimer scheduledTimerWithTimeInterval:self.timeBetweenAttacks target:self selector:@selector(fireProjectileCalledByTimer:) userInfo:[self.enemiesInRange anyObject] repeats:YES];
    }
    else {
        self.isAttacking = NO;
    }
}


@end
