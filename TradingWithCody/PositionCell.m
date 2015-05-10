//
//  PositionCell.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/29/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "PositionCell.h"

@implementation PositionCell

@synthesize lbHeader,lbMessage,lbTime;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
