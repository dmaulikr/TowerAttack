//
//  TAPLayerProfile.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-12.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAPlayerProfile.h"
#import "TABattleScene.h"

@implementation TAPlayerProfile

static TAPlayerProfile *sharedInstance;
NSArray *levelXPs;

+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[TAPlayerProfile alloc] init];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        levelXPs = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"LevelXPs"];
        if (![userDefaults boolForKey:@"notFirstTimeSetup"]) {
            [self runFirstTimeSetup:userDefaults];
        }
        [self extractValuesFromUserDefaults:userDefaults];
    }
    return self;
}

+(TAPlayerProfile *)sharedInstance
{
    return sharedInstance;
}

-(void)extractValuesFromUserDefaults:(NSUserDefaults *)userDefaults
{ //hardcoded
    self.level = [userDefaults integerForKey:@"level"];
    self.totalLevelXP = [levelXPs[self.level - 1] integerValue];
    self.stage = [userDefaults integerForKey:@"stage"];
    self.currentLevelXP = [userDefaults integerForKey:@"currentLevelXP"];
    self.name = [userDefaults stringForKey:@"name"];
}

-(void)runFirstTimeSetup:(NSUserDefaults *)userDefaults
{ //hardcoded
    [userDefaults setBool:YES forKey:@"notFirstTimeSetup"];
    [userDefaults setInteger:1 forKey:@"level"];
    [userDefaults setInteger:TAAreaGrassy forKey:@"stage"];
    [userDefaults setInteger:0 forKey:@"currentLevelXP"];
    [userDefaults setObject:@"Profile" forKey:@"name"];
}


-(void)setStage:(NSUInteger)stage
{
    _stage = stage;
    [[NSUserDefaults standardUserDefaults] setInteger:stage forKey:@"stage"];
}

-(void)setLevel:(NSUInteger)level
{
    if (level > levelXPs.count) {
        level = levelXPs.count;
    }
    _level = level;
    self.totalLevelXP = [levelXPs[_level - 1] integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
}

-(void)setCurrentLevelXP:(NSUInteger)currentLevelXP
{
    while (currentLevelXP >= self.totalLevelXP) {
        currentLevelXP -= self.totalLevelXP;
        self.level++;
    }
    _currentLevelXP = currentLevelXP;
    [[NSUserDefaults standardUserDefaults] setInteger:currentLevelXP forKey:@"currentLevelXP"];
}

-(void)setName:(NSString *)name
{
    _name = name;
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
}

@end
