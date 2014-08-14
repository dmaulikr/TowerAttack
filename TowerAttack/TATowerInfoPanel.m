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
        {
      /*  self.unitIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 45, 45)];
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
        [self addSubview:self.sellButton];*/
        }
        
  //      [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.unitIcon = [[UIImageView alloc] init];
        [self addSubview:self.unitIcon];
        
        self.unitName = [[TALabel alloc] initWithFontSize:16];
   //     [self.unitName setCenter:CGPointMake(self.unitIcon.center.x, self.unitName.center.y)];
        [self addSubview:self.unitName];
        
        self.unitDescription = [[TALabel alloc] initWithFontSize:14];
        [self addSubview:self.unitDescription];
        
        self.otherUnitInfo = [[TALabel alloc] initWithFontSize:14];
        [self addSubview:self.otherUnitInfo];
        
        self.upgradeButton = [[TAButton alloc] initWithFontSize:15];
        [self.upgradeButton setTitle:@"Max Level" forState:UIControlStateDisabled];
        self.upgradeButton.titleLabel.numberOfLines = 1;
        self.upgradeButton.titleLabel.adjustsFontSizeToFitWidth = NO;
        [self.upgradeButton addTarget:self action:@selector(upgradeSelectedTower) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.upgradeButton];
        
        self.sellButton = [[TAButton alloc] initWithFontSize:15];
        self.sellButton.titleLabel.numberOfLines = 1;
        self.sellButton.titleLabel.adjustsFontSizeToFitWidth = NO;
        [self.sellButton setTitle:@"Can't Sell" forState:UIControlStateDisabled];
        [self.sellButton addTarget:self action:@selector(sellSelectedTower) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sellButton];

    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
 //   [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (UIView *v in self.subviews) {
        [v setTranslatesAutoresizingMaskIntoConstraints:NO];
    }

    [self removeConstraints:self.constraints];
    NSDictionary *dict = NSDictionaryOfVariableBindings(_unitIcon, _unitName, _unitDescription, _otherUnitInfo, _upgradeButton, _sellButton);
    NSDictionary *metrics = @{@"upgradeButtonWidth" : [NSNumber numberWithFloat:self.upgradeButton.intrinsicContentSize.width]};
    NSMutableString *visualString = [NSMutableString stringWithString:@"|-8-[_unitName]-15-[_unitDescription(<=150)]-25-[_otherUnitInfo]"];
    
    if ([self.selectedUnit.name  characterAtIndex:0] == 'E') {
        [visualString appendString:@"-20-|"];

    }
    else {
        [visualString appendString:@"-20-[_upgradeButton(==upgradeButtonWidth)]-8-|"];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_sellButton]-4-[_upgradeButton(==_sellButton)]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:dict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_sellButton(==_upgradeButton)]-8-|" options:0 metrics:nil views:dict]];
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualString options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_unitIcon(<=50)]-2-[_unitName]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_unitDescription]-8-|" options:0 metrics:nil views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_otherUnitInfo]-8-|" options:0 metrics:nil views:dict]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.otherUnitInfo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.unitDescription attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.unitIcon attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.unitName attribute:NSLayoutAttributeBottom multiplier:-1 constant:self.frame.size.height]];
    
    if (self.selectedUnit != nil) {
        CGFloat aspect = self.selectedUnit.size.height / self.selectedUnit.size.width;
        if ([self.constraints containsObject:self.aspectConstraint]) {
            [self removeConstraint:self.aspectConstraint];
        }
        self.aspectConstraint = [NSLayoutConstraint constraintWithItem:self.unitIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.unitIcon attribute:NSLayoutAttributeWidth multiplier:aspect constant:0];
        [self addConstraint:self.aspectConstraint];
    }
    
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
 //   [self.otherUnitInfo setCenter:CGPointMake((self.upgradeButton.frame.origin.x + 224) / 2, self.frame.size.height / 2)];
    if ([self.selectedUnit.name  characterAtIndex:0] == 'E') {
        self.upgradeButton.hidden = YES;
        self.sellButton.hidden = YES;
        if ([self.subviews containsObject:self.sellButton]) {
            [self.sellButton removeFromSuperview];
            [self.upgradeButton removeFromSuperview];
        }
    }
    else {
        if (![self.subviews containsObject:self.sellButton]) {
            [self addSubview:self.sellButton];
            [self addSubview:self.upgradeButton];
        }
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
    [self setNeedsUpdateConstraints];
}

-(BOOL)translatesAutoresizingMaskIntoConstraints
{
    return [super translatesAutoresizingMaskIntoConstraints];
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

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)upgradeSelectedTower
{
    if (self.selectedUnit.battleScene.uiOverlay.currentGold >= ((TATower *)self.selectedUnit).towerLevel*10) {
        self.selectedUnit.battleScene.uiOverlay.currentGold -= ((TATower *)self.selectedUnit).towerLevel*10;
        ((TATower *)self.selectedUnit).towerLevel++;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(c, 227, 8);
    CGContextAddLineToPoint(c, 227, 92);
    CGContextStrokePath(c);
}*/


@end
