//
//  TAAreaSelectViewController.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface TAAreaSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidth;
@property (nonatomic) NSInteger numStages;

-(void)showBlack;

@end
