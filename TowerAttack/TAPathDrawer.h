//
//  TAPathDrawer.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-07-08.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAPathDrawer : UIView

@property (nonatomic) CGPathRef pathToDraw;

-(id)initWithFrame:(CGRect)frame andPath:(CGPathRef)path;

@end
