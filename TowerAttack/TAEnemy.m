//
//  TAEnemy.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAEnemy.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "TATowerInfoPanel.h"
#import "TAPLayerProfile.h"

#define IS_IOS_8 2

@implementation TAEnemy

-(id)initWithLocation:(CGPoint)location inScene:(TABattleScene *)sceneParam
{
    if (self == [super initWithLocation:location inScene:sceneParam]) {
        //init code
        _movementSpeed = 0;
        _maximumHealth = 0;
        _currentHealth = 0;
        self.isVibrating = NO;
        self.goldReward = 0;
        self.unitDescription = @"Weak but relatively fast, enemies are a common enemy, but not too much of a threat.";
        self.unitType = @"Enemy";
        self.imageName = @"Attacker";
        [self.infoStrings addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth], [NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed], nil]];
        self.zPosition = TANodeZPositionEnemy;
        
        self.texture = [SKTexture textureWithImageNamed:self.imageName];
        self.name =  [NSString stringWithFormat:@"Enemy %lu", (unsigned long)[self.battleScene.enemiesOnField count]];
        self.size = CGSizeMake(40, 40);
        
        SKSpriteNode *outsideBar = [SKSpriteNode spriteNodeWithImageNamed:@"Health_Bar_Outside"];
        outsideBar.size = CGSizeMake(35, 5.6);
        outsideBar.anchorPoint = CGPointMake(0, 0.5);
        
        self.healthBarInside = [SKSpriteNode spriteNodeWithImageNamed:@"Health_Bar_Inside"];
        self.healthBarInside.size = CGSizeMake(33.5, 3.9);
        self.healthBarInside.zPosition = TANodeZPositionEnemy + 1;
        self.healthBarInside.position = CGPointMake(self.position.x - 33.5/2, self.position.y + self.size.height * 3 / 4);
        self.healthBarInside.anchorPoint = CGPointMake(0, 0.5);
        [self.healthBarInside addChild:outsideBar];
        [self.battleScene addChild:self.healthBarInside];
        
        SKAction *action;
        SKAction *actionHealthBar;
        
        if ([[SKAction class] respondsToSelector:@selector(followPath:asOffset:orientToPath:speed:)]) {
            action = [[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:YES speed:[self movementSpeed]] reversedAction];
            actionHealthBar = [[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:NO speed:[self movementSpeed]] reversedAction];
        }
        else {
            action = [[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:YES duration:40] reversedAction];
            actionHealthBar = [[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:NO duration:40] reversedAction];
        }
        
        [self runAction:action completion:^{
            [self finishPath];
        }];
        [self.healthBarInside runAction:actionHealthBar];

      /*  [self runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:YES duration:40] reversedAction] completion:^{
            self.battleScene.uiOverlay.livesLeft--;
            [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
            [self.battleScene.enemiesOnField removeObject:self];
        }];
        [self.healthBarInside runAction:[[SKAction followPath:self.battleScene.enemyMovementPath asOffset:YES orientToPath:NO duration:40] reversedAction]];
*/
    }
    return self;
}

-(void)finishPath
{
    self.battleScene.uiOverlay.livesLeft--;
    [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
    [self.battleScene.enemiesOnField removeObject:self];
    [self.battleScene checkForWaveOver];
}

-(void)die
{
    _currentHealth = 0;
    [self.battleScene removeChildrenInArray:[NSArray arrayWithObjects:self, self.healthBarInside, nil]];
    [self.battleScene.enemiesOnField removeObject:self];
    [self.battleScene checkForWaveOver];
    self.battleScene.uiOverlay.currentGold += self.goldReward;
    [TAPlayerProfile sharedInstance].currentLevelXP += self.xpReward;
    [self.battleScene.uiOverlay configureBottomLabel];
    [self.battleScene.uiOverlay popText:[NSString stringWithFormat:@"+%lu",(unsigned long)self.goldReward] withColour:[UIColor colorWithRed:255.0f/255.0f green:208.0f/255.0f blue:0.0f/255.0f alpha:1.0f] overPoint:self.position completion:nil];
    [self removeAllActions];
}

/*-(void)moveByTimer:(NSTimer *)timer
{
    NSMutableArray *arr = [(NSArray *)[timer userInfo] objectAtIndex:2];
    
    float x = [(NSNumber *)[arr objectAtIndex:0] floatValue];
    [arr replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:x+0.008]];
    CGFloat vibrateAngle = [(NSNumber *)[(NSArray *)[timer userInfo] objectAtIndex:0] floatValue];
    x += 0.004;
    CGFloat magnitude = [(NSNumber *)[(NSArray *)[timer userInfo] objectAtIndex:1] floatValue] *( (3-x) * (3-x) * 2*M_PI * cos(x*2*M_PI) - 2*(3-x) * sin(2*x*M_PI)/*(3-x)*(2 * M_PI) * cosf(x*(2 * M_PI)) - sinf(x*(2 * M_PI)));
   // CGFloat magnitude = [(NSNumber *)[(NSArray *)[timer userInfo] objectAtIndex:1] floatValue] *( sinf(x * 2 * M_PI) * (x-3));
    NSLog(@"%f, %f, (%f,%f)", x, magnitude, magnitude * cosf(vibrateAngle), magnitude * sinf(vibrateAngle));
    if (3 - x > 0) {
       // [self runAction:[SKAction moveTo:CGPointMake(600 + magnitude * cosf(vibrateAngle), 800 + magnitude * sinf(vibrateAngle)) duration:timer.timeInterval]];
        [self runAction:[SKAction moveByX:magnitude * cosf(vibrateAngle) y:magnitude * sinf(vibrateAngle) duration:timer.timeInterval]];
    }
    else {
        NSLog(@"inv");
        [timer invalidate];
        self.isVibrating = NO;
    }
}

-(void)vibrateAtAngle:(CGFloat)vibrateAngle
{
    if (!self.isVibrating) {
        NSTimer *moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(moveByTimer:) userInfo:@[[NSNumber numberWithFloat:vibrateAngle], [NSNumber numberWithFloat:0.1f /* magnitude ], [NSMutableArray arrayWithObject:[NSNumber numberWithInt:0]]] repeats:YES];
        self.isVibrating = YES;
    }
}
*/
-(void)setCurrentHealth:(CGFloat)currentHealth
{
//    NSUInteger index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth]];
    NSUInteger index = [self.infoStrings indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[(NSString *)obj substringToIndex:6] isEqualToString:@"Health"]) {
            return YES;
        }
        else {
            return NO;
        }
    }];
    _currentHealth = currentHealth;
    
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)self.currentHealth,(unsigned long)self.maximumHealth]];
    }
    self.healthBarInside.size = CGSizeMake(33.5 * self.currentHealth / self.maximumHealth, self.healthBarInside.size.height);
    if (_currentHealth <= 0 && [self.battleScene.enemiesOnField containsObject:self]) {
        [self die];
    }
}

-(void)setSpeed:(CGFloat)speed
{
    NSUInteger index = 0;
    index = [self.infoStrings indexOfObject:[NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed]];
    [super setSpeed:speed];
    if (index != NSNotFound) {
        [self.infoStrings replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"Movement Speed: %g",self.movementSpeed * self.speed]];
    }
}

-(void)setMaximumHealth:(CGFloat)maximumHealth
{
    _maximumHealth = maximumHealth;
    self.currentHealth = maximumHealth;
}

@end
