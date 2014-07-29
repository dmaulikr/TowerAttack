//
//  TATowerInfoPanel.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATowerInfoPanel.h"
#import "TANonPassiveTower.h"
#import "TAUnit.h"
#import "TAEnemy.h"
#import "TABattleScene.h"
#import "TAUIOverlay.h"

@implementation TATowerInfoPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.9];
        
        self.unitIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 45, 45)];
        [self addSubview:self.unitIcon];
        
        self.unitName = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 70, 21)];
        self.unitName.font = [UIFont fontWithName:@"Cochin" size:13];
        self.unitName.adjustsFontSizeToFitWidth = YES;
        self.unitName.minimumScaleFactor = 0.5;
        self.unitName.textAlignment = NSTextAlignmentCenter;
        [self.unitName setCenter:CGPointMake(self.unitIcon.center.x, self.unitName.center.y)];
        [self addSubview:self.unitName];
        
        self.unitDescription = [[UILabel alloc] initWithFrame:CGRectMake(74, 7, 151, 66)];
        self.unitDescription.font = [UIFont fontWithName:@"Cochin" size:12];
        self.unitDescription.numberOfLines = 0;
        self.unitDescription.textAlignment = NSTextAlignmentCenter;
        self.unitDescription.adjustsFontSizeToFitWidth = YES;
        self.unitDescription.minimumScaleFactor = 0.5;
        [self addSubview:self.unitDescription];
        
       /* self.additionalUnitInfo = [NSArray arrayWithObjects:[[UILabel alloc] initWithFrame:CGRectMake(236, 9, 150, 21)], [[UILabel alloc] initWithFrame:CGRectMake(236, 29, 150, 21)], [[UILabel alloc] initWithFrame:CGRectMake(236, 49, 150, 21)], nil];
        for (UILabel *l in self.additionalUnitInfo) {
            l.font = [UIFont fontWithName:@"Cochin" size:14];
            l.adjustsFontSizeToFitWidth = YES;
            l.minimumScaleFactor = 2;
            [self addSubview:l];
        }*/
        
        self.otherUnitInfo = [[UILabel alloc] initWithFrame:CGRectMake(245, 10, 200, 80)];
        self.otherUnitInfo.numberOfLines = 0;
        self.otherUnitInfo.textAlignment = NSTextAlignmentCenter;
        self.otherUnitInfo.font = [UIFont fontWithName:@"Cochin" size:12];
        self.otherUnitInfo.adjustsFontSizeToFitWidth = YES;
        self.otherUnitInfo.minimumScaleFactor = 0.5;
        self.otherUnitInfo.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.otherUnitInfo];
        
        self.upgradeButton = [UIButton buttonWithType:UIButtonTypeSystem]; //[[UIButton alloc] initWithFrame:CGRectMake(428, 12, 126, 56)];
        self.upgradeButton.frame = CGRectMake(428, 12, 126, 56);
        self.upgradeButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.7 blue:0.4 alpha:0.9];
        self.upgradeButton.titleLabel.font = [UIFont fontWithName:@"Cochin" size:15];
        [self.upgradeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.upgradeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.upgradeButton setTitle:@"Max Level" forState:UIControlStateDisabled];
        [self.upgradeButton addTarget:self action:@selector(upgradeSelectedTower) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.upgradeButton];
    }
    return self;
}

-(void)setSelectedUnit:(TAUnit *)selectedUnit
{
    if ([_selectedUnit.name characterAtIndex:0] == 'T') {
        NSUInteger towerNumber = [[_selectedUnit.name substringFromIndex:[_selectedUnit.name rangeOfString:@" "].location + 1] integerValue];
        SKSpriteNode *detector = (SKSpriteNode *)[_selectedUnit.battleScene childNodeWithName:[NSString stringWithFormat:@"Detector %lu", (unsigned long)towerNumber]];
        detector.alpha = 0.0;
    }
    _selectedUnit = selectedUnit;
    if (_selectedUnit != nil) {
        self.unitIcon.image = [UIImage imageNamed:selectedUnit.imageName];
        self.unitName.text = selectedUnit.unitType;
        self.unitDescription.text = selectedUnit.description;
        NSMutableArray *arr = _selectedUnit.infoStrings;
        _selectedUnit.infoStrings = arr;
    }
}

-(void)refreshLabelsWithInfo:(NSArray *)otherUnitInfoStrings
{
    self.otherUnitInfo.text = @"";
    for (NSString *s in otherUnitInfoStrings) {
        self.otherUnitInfo.text = [self.otherUnitInfo.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",s]];
    }
    self.otherUnitInfo.text = [self.otherUnitInfo.text substringToIndex:self.otherUnitInfo.text.length-1];
  //  [self.otherUnitInfo sizeToFit];
    [self.otherUnitInfo setCenter:CGPointMake((self.upgradeButton.frame.origin.x + 224) / 2, self.frame.size.height / 2)];
    if ([self.selectedUnit.unitType characterAtIndex:0] == 'E') {
        self.upgradeButton.hidden = YES;
    }
    else {
        self.upgradeButton.hidden = NO;
        if (((TATower *)self.selectedUnit).towerLevel == maxTowerLevel) {
            self.upgradeButton.enabled = NO;
        }
        else {
            [self.upgradeButton setTitle:[NSString stringWithFormat:@"Upgrade: %lu gold",(unsigned long)((TATower *)self.selectedUnit).towerLevel * 10] forState:UIControlStateNormal];
            self.upgradeButton.enabled = YES;
        }
    }
}

-(void)upgradeSelectedTower
{
    if (self.selectedUnit.battleScene.uiOverlay.currentGold >= ((TATower *)self.selectedUnit).towerLevel*10) {
        self.selectedUnit.battleScene.uiOverlay.currentGold -= ((TATower *)self.selectedUnit).towerLevel*10;
        ((TATower *)self.selectedUnit).towerLevel++;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(c, 227, 8);
    CGContextAddLineToPoint(c, 227, 92);
    CGContextStrokePath(c);
}


@end
