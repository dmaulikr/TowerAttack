//
//  TATowerPurchaseSidebar.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-15.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATowerPurchaseSidebar.h"
#import "TAFireballTower.h"
#import "TAFreezeTower.h"
#import "TABlastTower.h"
#import "TAPsychicTower.h"
#import "TAArrowTower.h"
#import "TAInfoPopUp.h"
#import "TAPLayerProfile.h"
#import "TALabel.h"

@implementation TATowerPurchaseSidebar

CGFloat topAndBottomBuffer = 8, iconToNameBuffer = 2, nameToIconBuffer = 6, towerIconDimensions = 50;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassPurchaseSidebar];//[UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.7];
        self.canSelectTowers = YES;
   //     self.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5);
        self.clipsToBounds = NO;
        self.selectedTowerType = TATowerTypeNoTower;
        self.towerIcons = [NSMutableArray array];
        self.towerLabels = [NSMutableArray array];
        self.towers = @[[[TAArrowTower alloc] init], [[TAFreezeTower alloc] init], [[TABlastTower alloc] init], [[TAPsychicTower alloc] init],[[TAFireballTower alloc] init]]; //hardcoded
        
        for (int i = 0; i < [self.towers count]; i++) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:[UIImage imageNamed:[(TATower *)self.towers[i] imageName]] forState:UIControlStateNormal];
            b.tag = i;
            [b addTarget:self action:@selector(selectTowerFromButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.towerIcons addObject:b];
            [self addSubview:b];
            
            TALabel *l = [[TALabel alloc] initWithFontSize:10];
            l.numberOfLines = 1;
            l.text = [NSString stringWithFormat:@"%@",[(TATower *)[self.towers objectAtIndex:i] unitType]];
            [self.towerLabels addObject:l];
            [self addSubview:l];
        }
        
        self.infoPopUp = [[TAInfoPopUp alloc] initWithOrigin:CGPointMake(0, 0)];
        self.infoPopUp.alpha = 0;
        [self addSubview:self.infoPopUp];
    }
    [self setContentSize:CGSizeMake(68, topAndBottomBuffer * 2 + (50 + iconToNameBuffer + 12 + nameToIconBuffer) * self.towers.count)];
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    for (UIView *v in self.subviews) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    
    [self removeConstraints:self.constraints];
    
    
    NSDictionary *metrics = @{ @"topAndBottomBuffer" : [NSNumber numberWithFloat:topAndBottomBuffer], @"iconToNameBuffer" : [NSNumber numberWithFloat:iconToNameBuffer], @"nameToIconBuffer" : [NSNumber numberWithFloat:nameToIconBuffer], @"towerIconDimensions" : [NSNumber numberWithFloat:towerIconDimensions]};
    
    NSMutableString *visualString = [NSMutableString stringWithString:@"V:|"];
    
    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    for (int i = 0; i < [self.towerLabels count]; i++) {
        [views setObject:[self.towerLabels objectAtIndex:i] forKey:[NSString stringWithFormat:@"name%d",i]];
        [views setObject:[self.towerIcons objectAtIndex:i] forKey:[NSString stringWithFormat:@"icon%d",i]];
        
        [visualString appendString:[NSString stringWithFormat:@"-nameToIconBuffer-[icon%d(==50)]-iconToNameBuffer-[name%d]",i,i]];
    }
    
    for (UIButton *icon in self.towerIcons) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:icon
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:0]];
    }
    
   /* for (UILabel *name in self.towerLabels) {
        NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1 constant:-20];
        c.priority = UILayoutPriorityRequired;
        [self addConstraint:c];
    }
    */
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.towerIcons[0] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:self.frame.size.width / 2]];
    
    [visualString replaceCharactersInRange:NSMakeRange(4, 16) withString:@"topAndBottomBuffer"];
    [visualString appendString:@"-topAndBottomBuffer-|"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualString options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}

-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

-(void)selectTowerFromButton:(UIButton *)button
{
    if (button.selected) {
        self.selectedTowerType = TATowerTypeNoTower;
        button.selected = NO;
        button.highlighted = NO;
        self.infoPopUp.alpha = 0;
    }
    else {
        self.selectedTowerType = [(TATower *)[self.towers objectAtIndex:button.tag] towerType];
        for (UIButton *b in self.towerIcons) {
            b.selected = NO;
            b.highlighted = NO;
        }
        button.selected = YES;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            button.highlighted = YES;
        }];
        self.infoPopUp.alpha = 0;
        self.infoPopUp.originPoint = CGPointMake(0, button.center.y);
        [self.infoPopUp setText:[(TATower *)[self.towers objectAtIndex:button.tag] description] andGoldCost:[(TATower *)[self.towers objectAtIndex:button.tag] purchaseCost]];
        [UIView animateWithDuration:0.2 animations:^{
            self.infoPopUp.alpha = 1;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
