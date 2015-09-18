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
NSArray *colors;

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
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]];
        levelXPs = [dict objectForKey:@"LevelXPs"];
        colors = [dict objectForKey:@"StageColors"]; //contains arrays, one for each stage; each has a list of UIcolors in string form representing the color of the class at its position (using the TAClass enum)
        if (![userDefaults boolForKey:@"notFirstTimeSetup"]) {
            [self runFirstTimeSetup:userDefaults];
        }
        [self extractValuesFromUserDefaults:userDefaults];
        self.lastXpGain = 0;
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
    self.lastStagePlayed = [userDefaults integerForKey:@"lastStagePlayed"];
    self.fxVolume = [userDefaults floatForKey:@"fxVolume"];
}

-(void)runFirstTimeSetup:(NSUserDefaults *)userDefaults
{ //hardcoded
    [userDefaults setBool:YES forKey:@"notFirstTimeSetup"];
    [userDefaults setInteger:TAAreaGrassy forKey:@"lastStagePlayed"];
    [userDefaults setInteger:1 forKey:@"level"];
    [userDefaults setInteger:TAAreaGrassy forKey:@"stage"];
    [userDefaults setInteger:0 forKey:@"currentLevelXP"];
    [userDefaults setObject:@"Profile" forKey:@"name"];
    [userDefaults setFloat:1.0 forKey:@"fxVolume"];
}

-(UIColor *)colorForClass:(NSUInteger)classToColor
{
    NSString *colorInStringForm = [colors[self.lastStagePlayed-1] objectAtIndex:classToColor];
    NSArray *colorComponents = [colorInStringForm componentsSeparatedByString:@" "];
    return [UIColor colorWithRed:[colorComponents[0] floatValue] green:[colorComponents[1] floatValue] blue:[colorComponents[2] floatValue] alpha:[colorComponents[3] floatValue]];
}

-(void)setStage:(NSUInteger)stage
{
    _stage = stage;
    [[NSUserDefaults standardUserDefaults] setInteger:stage forKey:@"stage"];
}

-(void)setLastStagePlayed:(NSUInteger)lastStagePlayed
{
    if (lastStagePlayed == 0 || lastStagePlayed-1 >= colors.count) {
        NSLog(@"Stage out of range; set to 1");
        lastStagePlayed = 1;
    }
    _lastStagePlayed = lastStagePlayed;
    [[NSUserDefaults standardUserDefaults] setInteger:lastStagePlayed forKey:@"lastStagePlayed"];
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
    self.lastXpGain = currentLevelXP - _currentLevelXP;
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
