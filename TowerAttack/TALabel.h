//
//  TALabel.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TALabel : UILabel

@property (nonatomic) CGFloat fontSize;

-(instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size;

@end
