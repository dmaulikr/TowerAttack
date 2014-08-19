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

-(IBAction)startGame:(id)sender
{
    SKView * skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 320)];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    //   skView.showsPhysics = YES;
    [skView setBackgroundColor:nil];
    [self.view setBackgroundColor:nil];
    [self.view addSubview:skView];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, areaWidth / 2, areaHeight - areaHeight);
    CGFloat x = areaWidth / 2, y = areaHeight, xC1, yC1, xC2, yC2;
    while (y > 50) {
        xC1 = x;
        yC1 = y;
        y -= arc4random() % (int)areaHeight / 2 + 10;
        do {
            x = arc4random() % ((int)areaWidth - 50) + 25;
        }while (x == xC1);
        
        if (y <= 50) {
            y = 0;
            x = areaWidth / 2 - 20 + arc4random() % 40;
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
        CGPathAddCurveToPoint(path, NULL, xC1, areaHeight - yC1, xC2, areaHeight - yC2, x,areaHeight -  y);
    }
    CGPathMoveToPoint(path, NULL, areaWidth / 2, areaHeight - 0);
    
    [self.view bringSubviewToFront:skView];
    
    TABattleScene *scene = [[TABattleScene alloc] initWithSize:CGSizeMake(areaWidth, areaHeight) path:path spawnPoint:CGPointMake(x, self.view.frame.size.height -  y)];
    
    TAScene *sceneToPresent = [TAScene sceneWithSize:skView.frame.size];
    [sceneToPresent setBackgroundColor:nil];
    sceneToPresent.physicsWorld.gravity = CGVectorMake(0, 0);
    sceneToPresent.physicsWorld.contactDelegate = scene;
    sceneToPresent.scaleMode = SKSceneScaleModeAspectFill;
    [sceneToPresent addChild:scene];
    
    TAUIOverlay *overLay = [[TAUIOverlay alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 320)];
    overLay.battleScene = scene;
    [overLay configureBottomLabel];
    [skView addSubview:overLay];
    
    scene.uiOverlay = overLay;
    // Present the scene.
    [skView presentScene:sceneToPresent];
    self.scenePresented = YES;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.battleScene = scene;

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
