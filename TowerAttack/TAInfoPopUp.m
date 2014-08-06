//
//  TAInfoPopUp.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-31.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TAInfoPopUp.h"
#import "TALabel.h"

@implementation TAInfoPopUp

- (instancetype)initWithOrigin:(CGPoint)origin {
    self = [super init];
    if (self) {
        // Initialization code
        self.originPoint = origin;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.infoLabel = [[TALabel alloc] initWithFrame:CGRectMake(4, 4, self.frame.size.width - 34, self.frame.size.height - 30) andFontSize:12];
        [self addSubview:self.infoLabel];
        self.goldCostLabel = [[TALabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15) andFontSize:10];
        self.goldCostLabel.center = CGPointMake((self.frame.size.width - 25) / 2 - 6, self.infoLabel.frame.size.height / 2 + self.frame.size.height / 2);
        [self addSubview:self.goldCostLabel];
    }
    return self;
}

-(void)setOriginPoint:(CGPoint)originPoint
{
    _originPoint = originPoint;
    self.frame = CGRectMake(originPoint.x - 140, originPoint.y - 80 / 2, 140, 80);
}

-(void)setText:(NSString *)text andGoldCost:(NSInteger)goldCost
{
    self.infoLabel.text = text;
    self.goldCostLabel.text = [NSString stringWithFormat:@"%ld",(long)goldCost];
}

- (void)drawRect:(CGRect)rect {
    CGFloat rectLeftSide = self.frame.size.width - 25, triangleLeftSideOffset = 20, triangleRightSideOffset = 10;
    UIBezierPath *pathToDraw = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, rectLeftSide-2, self.frame.size.height - 4) cornerRadius:8];
    [pathToDraw moveToPoint:CGPointMake(rectLeftSide, self.frame.size.height / 2 + triangleLeftSideOffset)];
    [pathToDraw addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height / 2 + triangleRightSideOffset)];
    [pathToDraw addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height / 2 - triangleRightSideOffset)];
    [pathToDraw addLineToPoint:CGPointMake(rectLeftSide, self.frame.size.height / 2 - triangleLeftSideOffset)];
    [[UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:0.7] setFill];
 //   [[UIColor brownColor] setFill];;
    [[UIColor blackColor] setStroke];
    pathToDraw.lineWidth = 2;
  //  [pathToDraw stroke];
    [pathToDraw fill];
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextDrawImage(c, CGRectMake(rectLeftSide / 2 + 4, self.infoLabel.frame.size.height / 2 + self.frame.size.height / 2 - 7.5, 15, 15), [UIImage imageNamed:@"coin1"].CGImage);
}


@end
