//
//  ViewController.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-07.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAMainMenuViewController.h"
#import "TABattleScene.h"
#import "TAPathDrawer.h"

@implementation TAMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = [[SKView alloc] initWithFrame:self.view.frame];//(SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.allowsTransparency = YES;
    [skView setBackgroundColor:nil];
    [self.view setBackgroundColor:nil];
    [self.view addSubview:skView];
    
    // Create and configure the scene.
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.view.frame.size.width / 2, self.view.frame.size.height);
    CGPathMoveToPoint(path, NULL, self.view.frame.size.width / 2, self.view.frame.size.height - self.view.frame.size.height);
    CGFloat x = self.view.frame.size.width / 2, y = self.view.frame.size.height, xC1, yC1, xC2, yC2;
    while (y > 0) {
        xC1 = x;
        yC1 = y;
        do {
            x = arc4random() % ((int)self.view.frame.size.width - 50) + 25;
        }while (x == xC1);
        y -= arc4random() % (int)self.view.frame.size.height / 2 + 10;
        xC1 = arc4random() % abs((int)(x - xC1)) + MIN(x, xC1);
        yC1 -= arc4random() % (int)(yC1 - y);
        if (x == xC1) {
            xC1 += 10;
        }
        xC2 = arc4random() % abs((int)(x - xC1)) + MIN(x, xC1);
        yC2 = yC1 - arc4random() % (int)(yC1 - y);
        if (y <= 0) {
            y = -10;
        }
        CGPathAddCurveToPoint(pathToDraw, NULL, xC1, yC1, xC2, yC2, x, y);
        CGPathAddCurveToPoint(path, NULL, xC1, self.view.frame.size.height - yC1, xC2, self.view.frame.size.height - yC2, x,self.view.frame.size.height -  y);
    }
    
    TAPathDrawer *pathDrawer = [[TAPathDrawer alloc] initWithFrame:self.view.frame andPath:pathToDraw];
    [self.view addSubview:pathDrawer];
    [self.view bringSubviewToFront:skView];
    
    SKScene * scene = [[TABattleScene alloc] initWithSize:self.view.frame.size andPath:path andSpawnPoint:CGPointMake(x, self.view.frame.size.height -  y)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
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