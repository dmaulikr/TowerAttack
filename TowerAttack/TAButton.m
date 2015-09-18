//
//  TAButton.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAButton.h"
#import "TAPLayerProfile.h"

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
    [self setTitleColor:[[TAPlayerProfile sharedInstance] colorForClass:TAClassLabelText] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"Cochin" size:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
    
    self.defaultColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassButton];//[UIColor colorWithRed:0.5 green:0.7 blue:0.4 alpha:0.9];
 //   self.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 //   self.backgroundColor = self.highlightedColor;
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
 //   self.backgroundColor = self.defaultColor;
    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

-(CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right, size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
}

-(void)setDefaultColor:(UIColor *)defaultColor
{
    _defaultColor = defaultColor;
    CGFloat h,s,b,a;
    [defaultColor getHue:&h saturation:&s brightness:&b alpha:&a];
    self.highlightedColor = [UIColor colorWithHue:h saturation:s brightness:b * 0.75 alpha:a];
    [self setNeedsDisplay];
 //   self.backgroundColor = defaultColor;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    UIBezierPath *pathToDraw = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:6];
    if (self.highlighted) {
        [self.highlightedColor setFill];
    }
    else {
        [self.defaultColor setFill];
    }
    [pathToDraw fill];
}


@end
