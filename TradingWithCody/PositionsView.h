//
//  PositionsView.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionCell.h"
#import "ProgessView.h"
#import "DetailPopup.h"

@interface PositionsView : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>{
    NSMutableArray* cellData;
    NSMutableData* responseData;
    ProgessView* spinner;
    DetailPopup* popup;
    
    UIRefreshControl *refreshControl;
    bool isRefreshing;
}
@property (nonatomic,retain) IBOutlet UITableView* twListLocation;
@property (strong,nonatomic) PositionCell* customCell;
@property (nonatomic, retain) UINavigationBar* bar;
@end
