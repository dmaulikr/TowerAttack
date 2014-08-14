//
//  TAProfileViewController.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-12.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TAPlayerProfile;
@class TALabel;
@class TAButton;

@interface TAProfileViewController : UIViewController

@property (nonatomic, strong) IBOutlet TALabel *titleLabel;
@property (nonatomic, strong) IBOutlet TAButton *backButton;
@property (nonatomic, strong) IBOutlet TAButton *resetProfileButton;
@property (nonatomic, strong) IBOutlet TALabel *levelLabel;
@property (nonatomic, strong) IBOutlet TALabel *xpLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *xpBar;
@property (nonatomic, strong) IBOutlet UITextField *nameEntry;

-(IBAction)changeProfileName:(id)sender;
-(IBAction)resetProfile:(id)sender;
-(void)configureViews;

@end
