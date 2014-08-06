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
#import "TAInfoPopUp.h"
#import "TALabel.h"
#import "TAButton.h"

@implementation TATowerInfoPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.7];
        
        self.unitIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 45, 45)];
        [self addSubview:self.unitIcon];
        
        self.unitName = [[TALabel alloc] initWithFrame:CGRectMake(10, 54, 70, 21) andFontSize:13];
        [self.unitName setCenter:CGPointMake(self.unitIcon.center.x, self.unitName.center.y)];
        [self addSubview:self.unitName];
        
        self.unitDescription = [[TALabel alloc] initWithFrame:CGRectMake(74, 7, 151, 66) andFontSize:12];
        [self addSubview:self.unitDescription];
        
        self.otherUnitInfo = [[TALabel alloc] initWithFrame:CGRectMake(245, 10, 200, 80) andFontSize:12];
        [self addSubview:self.otherUnitInfo];
        
        self.upgradeButton = [[TAButton alloc] initWithFrame:CGRectMake(428, 8, 126, 30) andFontSize:15];
        [self.upgradeButton setTitle:@"Max Level" forState:UIControlStateDisabled];
        [self.upgradeButton addTarget:self action:@selector(upgradeSelectedTower) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.upgradeButton];
        
        self.sellButton = [[TAButton alloc] initWithFrame:CGRectMake(428, 41, 126, 30) andFontSize:15];
        [self.sellButton setTitle:@"Can't Sell" forState:UIControlStateDisabled];
        [self.sellButton addTarget:self action:@selector(sellSelectedTower) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sellButton];
    }
    return self;
}

-(void)setSelectedUnit:(TAUnit *)selectedUnit
{
    if ([_selectedUnit.name characterAtIndex:0] == 'T') {
        self.selectedUnit.battleScene.towerRadiusDisplay.alpha = 0.0;
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
    if ([self.selectedUnit.name  characterAtIndex:0] == 'E') {
        self.upgradeButton.hidden = YES;
        self.sellButton.hidden = YES;
    }
    else {
        self.upgradeButton.hidden = NO;
        self.sellButton.hidden = NO;
        [self.sellButton setTitle:[NSString stringWithFormat:@"Sell: %ld gold",(long)[self sellCostForTower:(TATower *)self.selectedUnit]] forState:UIControlStateNormal];
        if (((TATower *)self.selectedUnit).towerLevel == maxTowerLevel) {
            self.upgradeButton.enabled = NO;
        }
        else {
            [self.upgradeButton setTitle:[NSString stringWithFormat:@"Upgrade: %lu gold",(unsigned long)((TATower *)self.selectedUnit).towerLevel * 10] forState:UIControlStateNormal];
            self.upgradeButton.enabled = YES;
        }
    }
}

-(NSInteger)sellCostForTower:(TATower *)tower
{
    NSInteger x = tower.towerLevel - 1;
    return 2.5 * x * x + 2.5 * x + tower.purchaseCost / 3;
}

-(void)sellSelectedTower
{
    [self.selectedUnit.battleScene removeTower:(TATower *)self.selectedUnit];
    self.selectedUnit.battleScene.uiOverlay.currentGold += [self sellCostForTower:(TATower *)self.selectedUnit];
    self.selectedUnit.battleScene.uiOverlay.selectedUnit = nil;
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
