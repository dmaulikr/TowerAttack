//
//  TATowerInfoPanel.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-14.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TATowerInfoPanel.h"
#import "TATower.h"
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
        
        self.unitName = [[UILabel alloc] initWithFrame:CGRectMake(17, 54, 46, 21)];
        self.unitName.font = [UIFont fontWithName:@"Cochin" size:15];
        self.unitName.adjustsFontSizeToFitWidth = YES;
        self.unitName.minimumScaleFactor = 2;
        self.unitName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.unitName];
        
        self.unitDescription = [[UILabel alloc] initWithFrame:CGRectMake(71, 7, 151, 66)];
        self.unitDescription.font = [UIFont fontWithName:@"Cochin" size:13];
        self.unitDescription.numberOfLines = 0;
        self.unitDescription.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.unitDescription];
        
        self.additionalUnitInfo = [NSArray arrayWithObjects:[[UILabel alloc] initWithFrame:CGRectMake(236, 9, 150, 21)], [[UILabel alloc] initWithFrame:CGRectMake(236, 29, 150, 21)], [[UILabel alloc] initWithFrame:CGRectMake(236, 49, 150, 21)], nil];
        for (UILabel *l in self.additionalUnitInfo) {
            l.font = [UIFont fontWithName:@"Cochin" size:14];
            l.adjustsFontSizeToFitWidth = YES;
            l.minimumScaleFactor = 2;
            [self addSubview:l];
        }
        
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
    _selectedUnit = selectedUnit;
    self.unitIcon.image = [UIImage imageNamed:selectedUnit.imageName];
    self.unitName.text = selectedUnit.unitType;
    self.unitDescription.text = selectedUnit.description;
    if ([selectedUnit.unitType characterAtIndex:0] == 'T') {
        TATower *tower = (TATower *)selectedUnit;
        [(UILabel *)[self.additionalUnitInfo objectAtIndex:0] setText:[NSString stringWithFormat:@"Level: %lu",(unsigned long)tower.towerLevel]];
        [(UILabel *)[self.additionalUnitInfo objectAtIndex:1] setText:[NSString stringWithFormat:@"Damage: %lu",(unsigned long)tower.attackDamage]];
        [(UILabel *)[self.additionalUnitInfo objectAtIndex:2] setText:[NSString stringWithFormat:@"%g shots/second",tower.timeBetweenAttacks]];
        [self.upgradeButton setTitle:[NSString stringWithFormat:@"Upgrade: %lu gold",(unsigned long)tower.towerLevel * 10] forState:UIControlStateNormal];
        self.upgradeButton.hidden = NO;
        if (((TATower *)self.selectedUnit).towerLevel == maxTowerLevel) {
            self.upgradeButton.enabled = NO;
        }
        else {
            self.upgradeButton.enabled = YES;
        }
    }
    else {
        TAEnemy *enemy = (TAEnemy *)selectedUnit;
        [(UILabel *)[self.additionalUnitInfo objectAtIndex:0] setText:[NSString stringWithFormat:@"Health: %lu/%lu",(unsigned long)enemy.currentHealth,(unsigned long)enemy.maximumHealth]];
        [(UILabel *)[self.additionalUnitInfo objectAtIndex:1] setText:[NSString stringWithFormat:@"+%lu gold on death",(unsigned long)enemy.goldReward]];
        [(UILabel *)[self.additionalUnitInfo objectAtIndex:2] setText:@""];
        self.upgradeButton.hidden = YES;
    }
}

-(void)upgradeSelectedTower
{
    if (self.selectedUnit.battleScene.uiOverlay.currentGold >= ((TATower *)self.selectedUnit).towerLevel*10) {
        self.selectedUnit.battleScene.uiOverlay.currentGold -= ((TATower *)self.selectedUnit).towerLevel*10;
        ((TATower *)self.selectedUnit).towerLevel++;
        if (((TATower *)self.selectedUnit).towerLevel == maxTowerLevel) {
            self.upgradeButton.enabled = NO;
        }
        else {
            [self.upgradeButton setTitle:[NSString stringWithFormat:@"Upgrade: %lu gold",(unsigned long)((TATower *)self.selectedUnit). towerLevel * 10] forState:UIControlStateNormal];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(c, 224, 8);
    CGContextAddLineToPoint(c, 224, 73);
    CGContextStrokePath(c);
}


@end
