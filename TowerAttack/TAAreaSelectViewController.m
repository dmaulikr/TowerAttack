//
//  TAAreaSelectViewController.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAAreaSelectViewController.h"
#import "TAUIOverlay.h"
#import "TABattleScene.h"
#import "AppDelegate.h"
#import "TAPLayerProfile.h"
#import "TALabel.h"

@interface TAAreaSelectViewController ()

@end

@implementation TAAreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassMainMenuBackground];
    self.tableView.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassMainMenuBackground];
    self.numStages = [[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Game Data" ofType:@"plist"]] objectForKey:@"StageColors"] count];
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    if IOS8 {
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, (self.view.frame.size.height - self.tableView.frame.size.width) / -2, self.tableView.frame.size.height / 2 - 36);
 //       self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.height, self.tableView.frame.size.width);
 //       self.tableViewHeight.constant = 568;
 //       self.tableViewWidth.constant = 320;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"TACell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Generic Cell"];
}

-(void)viewDidLayoutSubviews
{
    [self scrollViewDidScroll:self.tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Generic Cell"];
 /*   if (!cell) {
        cell = [[TACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Generic Cell" areaNumber:[indexPath row]];
    }*/
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    [(UIImageView *)[cell viewWithTag:5] setImage:[UIImage imageNamed:[self picNameForArea:[indexPath row] % 3]]];
    [(TALabel *)[cell viewWithTag:4] setText:[NSString stringWithFormat:@"Area %ld",[indexPath row]+1]];
    cell.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassMainMenuBackground];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  [self showBlack];
    UIView *b = [[UIView alloc] initWithFrame:self.view.frame];
    b.backgroundColor = [UIColor blackColor];
    [self.view addSubview:b];
    [[TAPlayerProfile sharedInstance] setLastStagePlayed:[indexPath row] % 3 + 1];
    [self startGame];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numStages*10;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        CGFloat distanceFromCenter = (CGFloat)abs(self.tableView.frame.size.width / 2 - (cell.center.y - self.tableView.contentOffset.y));
        CGFloat minimizeFactor = 0.7;
        CGFloat scale = minimizeFactor + (self.tableView.frame.size.width / 2 - distanceFromCenter) / (self.tableView.frame.size.width / 2) * (1 - minimizeFactor);
        CGAffineTransform c = CGAffineTransformMakeRotation(M_PI_2);
        cell.transform = CGAffineTransformScale(c, scale, scale);
    }
}

-(void)showBlack
{
    UIView *b = [[UIView alloc] initWithFrame:self.view.frame];
    b.backgroundColor = [UIColor blackColor];
    [self.view addSubview:b];
}

-(void)startGame
{
    CGFloat screenWidth;
    if IOS8 screenWidth = screenWidthIOS8;
    else screenWidth = screenWidthIOS7;
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
  //  self.scenePresented = YES;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.battleScene = scene;
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(NSString *)picNameForArea:(NSInteger)area
{
    switch (area) {
        case 0:
            return @"Grass.jpg";
            break;
        case 1:
            return @"FireArea.jpg";
        case 2:
            return @"Desert.jpg";
        default:
            return @"Grass.jpg";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
