//
//  TASettingsViewController.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-19.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TASettingsViewController.h"
#import "TAPLayerProfile.h"

@interface TASettingsViewController ()

@end

@implementation TASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TAPlayerProfile *profile = [TAPlayerProfile sharedInstance];
    self.fxVolumeSlider.value = [profile fxVolume];
    self.fxVolumeSlider.minimumTrackTintColor = [profile colorForClass:TAClassSliderOrProgressViewDark];
    self.fxVolumeSlider.thumbTintColor = [profile colorForClass:TAClassSliderOrProgressViewDark];
    self.fxVolumeSlider.maximumTrackTintColor = [profile colorForClass:TAClassSliderOrProgressViewLight];
    self.view.backgroundColor = [profile colorForClass:TAClassMainMenuBackground];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)fxVolumeChanged:(id)sender
{
    [[TAPlayerProfile sharedInstance] setFxVolume:self.fxVolumeSlider.value];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
