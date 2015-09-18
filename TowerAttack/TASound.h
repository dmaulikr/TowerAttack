//
//  TASound.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-19.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TASound : NSObject

+(void)playSoundWithFileName:(NSString *)fileName ofType:(NSString *)extension;

@end
