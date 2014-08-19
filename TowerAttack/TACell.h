//
//  TACell.h
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TALabel;

@interface TACell : UITableViewCell

@property (nonatomic, strong) UIImageView *areaPicture;
@property (nonatomic, strong) TALabel *areaName;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier areaNumber:(NSInteger)areaNumber;
-(NSString *)picNameForArea:(NSInteger)area;

@end
