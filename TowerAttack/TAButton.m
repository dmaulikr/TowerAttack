//
//  TAButton.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAButton.h"

@implementation TAButton

- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configurePropertiesWithTextSize:12];
    }
    return self;
}

- (instancetype)initWithFontSize:(CGFloat)size
{
    self = [super init];
    if (self) {
        // Initialization code
        [self configurePropertiesWithTextSize:size];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configurePropertiesWithTextSize:12];
    }
    return self;
}

-(void)configurePropertiesWithTextSize:(CGFloat)size
{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"Cochin" size:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
    
    self.defaultColor = [UIColor colorWithRed:0.5 green:0.7 blue:0.4 alpha:0.9];
    self.highlightedColor = [UIColor colorWithRed:0.41 green:0.54 blue:0.34 alpha:0.9];
    self.backgroundColor = self.defaultColor;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = self.highlightedColor;
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = self.defaultColor;
    [super touchesEnded:touches withEvent:event];
}

-(CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right, size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
