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
        self.font = [UIFont fontWithName:@"Cochin" size:size];
        _fontSize = size;
        self.numberOfLines = 0;
      //  self.lineBreakMode = NSLineBreakByWordWrapping;
        self.textAlignment = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumScaleFactor = 0.1;
    }
    return self;
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
