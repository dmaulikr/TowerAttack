//
//  TAPLayerProfile.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-12.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAPlayerProfile : NSObject

@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger stage;
@property (nonatomic) NSUInteger currentLevelXP;
@property (nonatomic) NSUInteger totalLevelXP;
@property (nonatomic, strong) NSString *name;

-(void)runFirstTimeSetup:(NSUserDefaults *)userDefaults;
-(void)extractValuesFromUserDefaults:(NSUserDefaults *)userDefaults;
+(TAPlayerProfile *)sharedInstance;

@end
