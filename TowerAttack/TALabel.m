//
//  TALabel.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-01.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TALabel.h"
#import "TAPLayerProfile.h"

@implementation TALabel

- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configurePropertiesWithSize:size];
    }
    return self;
}

-(instancetype)initWithFontSize:(CGFloat)size
{
    self = [super init];
    if (self) {
        // Initialization code
        [self configurePropertiesWithSize:size];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configurePropertiesWithSize:self.font.pointSize];
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
    self.textColor = [[TAPlayerProfile sharedInstance] colorForClass:TAClassLabelText];
    self.shouldResizeFontForSize = YES;
    self.attributedStringReference = [[NSMutableAttributedString alloc] init];
    //  self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
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
    while ((textSize.width / self.frame.size.width) * textSize.height >= self.frame.size.height) {
        size--;
        textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.font.fontName size:size]}];
    }
    return size;
}

-(void)applyValue:(id)value forAttribute:(NSUInteger)attribute forRange:(NSRange)range
{
    NSArray *attributes = @[NSForegroundColorAttributeName, NSFontAttributeName, NSStrokeColorAttributeName];
    [self.attributedStringReference.mutableString setString:self.text];
    [self.attributedStringReference addAttribute:attributes[attribute] value:value range:range];
    self.attributedText = self.attributedStringReference;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.shouldResizeFontForSize) {
        [self setFontSize:[self bestFontSize]];
    };
}

/*-(void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    [super setAdjustsFontSizeToFitWidth:NO];
}*/

-(void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    self.font = [UIFont fontWithName:@"Cochin" size:fontSize];
}

-(void)setText:(NSString *)text
{
    [self.attributedStringReference.mutableString setString:text];
    [super setText:text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

}
 */


@end
