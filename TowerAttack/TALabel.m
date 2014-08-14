//
//  TALabel.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TALabel.h"

@implementation TALabel

- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configurePropertiesWithSize:size];
      //  self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
}

-(instancetype)initWithFontSize:(CGFloat)size
{
    self = [super init];
    if (self) {
        // Initialization code
        [self configurePropertiesWithSize:size];
      //  self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configurePropertiesWithSize:self.font.pointSize];
      //  self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
}

-(void)configurePropertiesWithSize:(CGFloat)size
{
    self.font = [UIFont fontWithName:@"Cochin" size:size];
    _fontSize = size;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.textAlignment = NSTextAlignmentCenter;
 //   self.adjustsFontSizeToFitWidth = YES;
 //   self.minimumScaleFactor = 0.1;
}

-(CGFloat)bestFontSize
{
    CGFloat size = self.font.pointSize + 10;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.font.fontName size:size], NSParagraphStyleAttributeName : style}];
    while ((textSize.width / self.frame.size.width + 1) * textSize.height >= self.frame.size.height) {
        size--;
        textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.font.fontName size:size]}];
    }
    return size;
}

-(void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    self.font = [UIFont fontWithName:@"Cochin" size:fontSize];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

}
 */


@end
