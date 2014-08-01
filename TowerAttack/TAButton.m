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
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.7 blue:0.4 alpha:0.9];
        self.titleLabel.font = [UIFont fontWithName:@"Cochin" size:size];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.minimumScaleFactor = 0.5;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
