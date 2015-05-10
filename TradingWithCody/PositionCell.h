//
//  PositionCell.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/29/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCell : UITableViewCell{
    IBOutlet UILabel* lbTime;
    IBOutlet UILabel* lbHeader;
    IBOutlet UILabel* lbMessage;
}
@property (nonatomic,retain) UILabel* lbTime;
@property (nonatomic,retain) UILabel* lbHeader;
@property (nonatomic,retain) UILabel* lbMessage;
@end
