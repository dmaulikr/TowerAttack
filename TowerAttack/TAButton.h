//
//  TAButton.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAButton : UIButton

@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *highlightedColor;

-(instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size;
-(instancetype)initWithFontSize:(CGFloat)size;
-(void)configurePropertiesWithTextSize:(CGFloat)size;

@end
