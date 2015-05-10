//
//  BubbleMessageCell.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/30/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleMessage.h"

@interface BubbleMessageCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UIImageView* avatar;
@property(nonatomic,retain) IBOutlet UIImageView* bubble;
@property(nonatomic,retain) IBOutlet UILabel* message;
@property(nonatomic,retain) IBOutlet UILabel* user;
@end
