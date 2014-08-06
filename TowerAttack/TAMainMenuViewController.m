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

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.scenePresented = NO;
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!self.scenePresented) {
        SKView * skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 320)];
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        //   skView.showsPhysics = YES;
        [skView setBackgroundColor:nil];
        [self.view setBackgroundColor:nil];
        [self.view addSubview:skView];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 1200 / 2, 900 - 900);
        CGFloat x = 1200 / 2, y = 900, xC1, yC1, xC2, yC2;
        while (y > 50) {
            xC1 = x;
            yC1 = y;
            y -= arc4random() % (int)900 / 2 + 10;
            do {
                x = arc4random() % ((int)1200 - 50) + 25;
            }while (x == xC1);
            
            if (y <= 50) {
                y = 0;
                x = 1200 / 2 - 20 + arc4random() % 40;
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
            CGPathAddCurveToPoint(path, NULL, xC1, 900 - yC1, xC2, 900 - yC2, x,900 -  y);
        }
        CGPathMoveToPoint(path, NULL, 1200 / 2, 900 - 0);
        
        [self.view bringSubviewToFront:skView];
        
        TABattleScene *scene = [[TABattleScene alloc] initWithSize:CGSizeMake(1200, 900) andPath:path andSpawnPoint:CGPointMake(x, self.view.frame.size.height -  y)];
        
        SKScene *sceneToPresent = [SKScene sceneWithSize:skView.frame.size];
        [sceneToPresent setBackgroundColor:nil];
        sceneToPresent.physicsWorld.gravity = CGVectorMake(0, 0);
        sceneToPresent.physicsWorld.contactDelegate = scene;
        sceneToPresent.scaleMode = SKSceneScaleModeAspectFill;
        [sceneToPresent addChild:scene];
        
        TAUIOverlay *overLay = [[TAUIOverlay alloc] initWithFrame:skView.frame];
        overLay.battleScene = scene;
        [skView addSubview:overLay];
        
        scene.uiOverlay = overLay;
        // Present the scene.
        [skView presentScene:sceneToPresent];
        self.scenePresented = YES;
    }
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
