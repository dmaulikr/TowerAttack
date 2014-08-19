//
//  TALabel.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

enum TALabelTextAttribute : NSUInteger {
    TALabelTextAttributeColour,
    TALabelTextAttributeFont,
    TALabelTextAttributeOutlineColour
};

@interface TALabel : UILabel

@property (nonatomic) CGFloat fontSize;
@property (nonatomic) BOOL shouldResizeFontForSize;
@property (nonatomic) NSMutableAttributedString *attributedStringReference;

-(instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size;
-(instancetype)initWithFontSize:(CGFloat)size;
-(void)configurePropertiesWithSize:(CGFloat)size;
-(void)applyValue:(id)value forAttribute:(NSUInteger)attribute  forRange:(NSRange)range;
-(CGFloat)bestFontSize;

@end
