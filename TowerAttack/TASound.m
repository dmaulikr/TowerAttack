//
//  TASound.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-19.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TASound.h"
#import "TAPlayerProfile.h"

@implementation TASound

static AVAudioPlayer *soundPlayer;

+(void)playSoundWithFileName:(NSString *)fileName ofType:(NSString *)extension
{
    NSError *err;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:extension]] error:&err];
    soundPlayer.volume = [[TAPlayerProfile sharedInstance] fxVolume];
    [soundPlayer play];
}

@end
