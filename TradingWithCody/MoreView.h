//
//  MoreView.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView* twList;
    NSArray* arrItems;
}

@end
