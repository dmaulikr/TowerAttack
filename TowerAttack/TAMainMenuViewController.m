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

@implementation TAMainMenuViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    // Configure the view.
    SKView * skView = [[SKView alloc] initWithFrame:self.view.frame];//(SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
  //  skView.showsPhysics = YES;
    [skView setBackgroundColor:nil];
    [self.view setBackgroundColor:nil];
    [self.view addSubview:skView];
    
    // Create and configure the scene.
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGMutablePathRef path = CGPathCreateMutable();
 /*   CGPathMoveToPoint(pathToDraw, NULL, self.view.frame.size.width / 2, self.view.frame.size.height);
    CGPathMoveToPoint(path, NULL, self.view.frame.size.width / 2, self.view.frame.size.height - self.view.frame.size.height);
    CGFloat x = self.view.frame.size.width / 2, y = self.view.frame.size.height, xC1, yC1, xC2, yC2;
    while (y > 0) {
        xC1 = x;
        yC1 = y;
        do {
            x = arc4random() % ((int)self.view.frame.size.width - 50) + 25;
        }while (x == xC1);
        y -= arc4random() % (int)self.view.frame.size.height / 2 + 10;
        if (y <= 0) {
            y = 0;
        }
        xC1 = arc4random() % abs((int)(x - xC1)) + MIN(x, xC1);
        yC1 -= arc4random() % (int)(yC1 - y);
        if (x == xC1) {
            xC1 += 10;
        }
        xC2 = arc4random() % abs((int)(x - xC1)) + MIN(x, xC1);
        yC2 = yC1 - arc4random() % (int)(yC1 - y);
        CGPathAddCurveToPoint(pathToDraw, NULL, xC1, yC1, xC2, yC2, x, y);
        CGPathAddCurveToPoint(path, NULL, xC1, self.view.frame.size.height - yC1, xC2, self.view.frame.size.height - yC2, x,self.view.frame.size.height -  y);
    }*/
    CGPathMoveToPoint(pathToDraw, NULL, 1200 / 2, 900);
    CGPathMoveToPoint(path, NULL, 1200 / 2, 900 - 900);
    CGFloat x = 1200 / 2, y = 900, xC1, yC1, xC2, yC2;
    while (y > 0) {
        xC1 = x;
        yC1 = y;
        y -= arc4random() % (int)900 / 2 + 10;
        do {
            x = arc4random() % ((int)1200 - 50) + 25;
        }while (x == xC1);
        
        if (y <= 0) {
            y = 0;
            x = 1200 / 2;
        }
        if (x == xC1) {
            xC1 += 10;
        }
        xC1 = arc4random() % abs((int)(x - xC1)) + MIN(x, xC1);
        yC1 -= arc4random() % (int)(yC1 - y);
        if (x == xC1) {
            xC1 += 10;
        }
        xC2 = arc4random() % abs((int)(x - xC1)) + MIN(x, xC1);
        yC2 = yC1 - arc4random() % (int)(yC1 - y);
        CGPathAddCurveToPoint(pathToDraw, NULL, xC1, yC1, xC2, yC2, x, y);
        CGPathAddCurveToPoint(path, NULL, xC1, 900 - yC1, xC2, 900 - yC2, x,900 -  y);
    }

    
    CGPathRef newPath = CGPathCreateCopyByStrokingPath(pathToDraw, NULL, 50, kCGLineCapRound, kCGLineJoinRound, 100);
    [self.view bringSubviewToFront:skView];
    
    TABattleScene *scene = [[TABattleScene alloc] initWithSize:CGSizeMake(1200, 900) andPath:path andSpawnPoint:CGPointMake(x, self.view.frame.size.height -  y)];
    
    SKScene *sceneToPresent = [SKScene sceneWithSize:self.view.frame.size];
    [sceneToPresent setBackgroundColor:nil];
    sceneToPresent.physicsWorld.gravity = CGVectorMake(0, 0);
    sceneToPresent.physicsWorld.contactDelegate = scene;
    sceneToPresent.scaleMode = SKSceneScaleModeAspectFill;
    [sceneToPresent addChild:scene];
    
    TAUIOverlay *overLay = [[TAUIOverlay alloc] initWithFrame:self.view.frame];
    overLay.battleScene = scene;
    [skView addSubview:overLay];
    
    scene.uiOverlay = overLay;
    // Present the scene.
    [skView presentScene:sceneToPresent];
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
