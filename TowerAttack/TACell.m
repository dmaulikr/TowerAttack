//
//  TACell.m
//  TowerAttack
//
//  Created by Ethan Hardy on 2014-08-18.
//  Copyright (c) 2014 Ethan Hardy. All rights reserved.
//

#import "TACell.h"
#import "TALabel.h"

@implementation TACell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier areaNumber:(NSInteger)areaNumber {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"TACell" owner:self options:nil] lastObject];
        self.areaPicture = (UIImageView *)[self viewWithTag:5];
        self.areaPicture.image = [UIImage imageNamed:[self picNameForArea:areaNumber]];
        
        self.areaName = (TALabel *)[self viewWithTag:4];
        [self.areaName setText:[NSString stringWithFormat:@"Area %d",areaNumber+1]];
    }
    return self;
}

-(NSString *)picNameForArea:(NSInteger)area
{
    switch (area) {
        case 0:
            return @"Grass.jpg";
            break;
        case 1:
            return @"FireArea.jpg";
        default:
            return @"Grass.jpg";
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
