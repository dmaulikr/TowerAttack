//
//  TAInfoPopUp.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-31.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TALabel;

@interface TAInfoPopUp : UIView

@property (nonatomic) CGPoint originPoint;
@property (nonatomic, strong) TALabel *infoLabel;
@property (nonatomic, strong) TALabel *goldCostLabel;

-(instancetype)initWithOrigin:(CGPoint)origin;
-(void)setText:(NSString *)text andGoldCost:(NSInteger)goldCost;

@end
