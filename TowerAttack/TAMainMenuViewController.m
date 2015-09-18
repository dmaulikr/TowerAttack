//
//  ViewController.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAMainMenuViewController.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"
#import "AppDelegate.h"
#import "TAPLayerProfile.h"
#import "TALabel.h"
#import "TAButton.h"

@implementation TAMainMenuViewController

-(void)viewDidLoad
{
    self.scenePresented = NO;
    self.view.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassMainMenuBackground];
 //   [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view setNeedsUpdateConstraints];
}

-(void)refreshSubviews
{
    for (UIView *v in self.view.subviews) {
        if (v.class == [TALabel class]) {
            [(TALabel *)v configurePropertiesWithSize:[(TALabel *)v fontSize]];
        }
        else if (v.class == [TAButton class]) {
            [(TAButton *)v configurePropertiesWithTextSize:[[[(TAButton *)v titleLabel] font] pointSize]];
        }
    }
    self.view.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassMainMenuBackground];
}

-(IBAction)unwindToMainScreenFromSegue:(UIStoryboardSegue *)segue
{
    //TODO: put code for retreiving profile changes
    [self refreshSubviews];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
