//
//  ViewController.h
//  TowerAttack
//

//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class TAButton;
@class TALabel;

@interface TAMainMenuViewController : UIViewController

@property (nonatomic) BOOL scenePresented;
@property (nonatomic, strong) IBOutlet TAButton *playButton;
@property (nonatomic, strong) IBOutlet TAButton *profileButton;
@property (nonatomic, strong) IBOutlet TAButton *settingsButton;
@property (nonatomic, strong) IBOutlet TALabel *titleLabel;


-(IBAction)unwindToMainScreenFromSegue:(UIStoryboardSegue *)segue;

@end
