//
//  TAPathDrawer.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-08.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAPathDrawer.h"

@implementation TAPathDrawer

- (id)initWithFrame:(CGRect)frame andPath:(CGPathRef)path
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pathToDraw = CGPathCreateCopy(path);
        self.backgroundColor = [UIColor colorWithRed:21.0f/255.0f green:115.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef drawContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(drawContext, self.pathToDraw);
    CGContextSetRGBStrokeColor(drawContext, 0, 0, 0, 0.7f);
    CGContextSetRGBFillColor(drawContext, 250.0f/255.0f, 224.0f/255.0f, 150.0f/255.0f, 1.0f);
    CGContextSetLineWidth(drawContext, 2);
    CGContextSetLineCap(drawContext, kCGLineCapRound);
    CGContextSetLineJoin(drawContext, kCGLineJoinRound);
    CGContextStrokePath(drawContext);
    CGContextAddPath(drawContext, self.pathToDraw);
    CGContextFillPath(drawContext);
    CGContextAddRect(drawContext, self.frame);
    CGContextStrokePath(drawContext);
}


@end
