//
//  TAProfileViewController.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-12.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAProfileViewController.h"
#import "TAPlayerProfile.h"
#import "TALabel.h"

@interface TAProfileViewController ()

@end

@implementation TAProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view setNeedsUpdateConstraints];
    [self configureViews];
    self.view.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassMainMenuBackground];
//    self.levelLabel.textAlignment = NSTextAlignmentLeft;
//    self.xpLabel.textAlignment = NSTextAlignmentLeft;
    
    // Do any additional setup after loading the view.
}

-(void)configureViews
{
    TAPlayerProfile *profile = [TAPlayerProfile sharedInstance];
    [self.titleLabel setText:[profile name]];
    [self.levelLabel setText:[NSString stringWithFormat:@"Level %lu",(unsigned long)[profile level]]];
    [self.xpLabel setText:[NSString stringWithFormat:@"XP: %lu/%lu",(unsigned long)[profile currentLevelXP],(unsigned long)[profile totalLevelXP]]];
    [self.xpBar setProgress:(CGFloat)[profile currentLevelXP] / (CGFloat)[profile totalLevelXP]];
    self.xpBar.trackTintColor = [profile colorForClass:TAClassSliderOrProgressViewLight];
    self.xpBar.progressTintColor = [profile colorForClass:TAClassSliderOrProgressViewDark];
}

-(IBAction)changeProfileName:(id)sender
{
    UITextField *nameField = (UITextField *)sender;
    if (nameField.text.length > 0) {
        [[TAPlayerProfile sharedInstance] setName:[nameField text]];
        [self.titleLabel setText:[nameField text]];
        [nameField setText:@""];
    }
}

-(void)resetProfile:(id)sender
{
    [[TAPlayerProfile sharedInstance] runFirstTimeSetup:[NSUserDefaults standardUserDefaults]];
    [[TAPlayerProfile sharedInstance] extractValuesFromUserDefaults:[NSUserDefaults standardUserDefaults]];
    [self configureViews];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
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
