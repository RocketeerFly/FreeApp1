//
//  TradeAlertsView.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionCell.h"
#import "ProgessView.h"
#import "DetailPopup.h"
@interface TradeAlertsView : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>{
    NSMutableArray* cellData;
    NSMutableData* responseData;
    ProgessView* spinner;
    DetailPopup* popup;
    
    UIRefreshControl *refreshControl;
    bool isRefreshing;
}
@property (nonatomic,retain) IBOutlet UITableView* twListLocation;
@property (strong,nonatomic) PositionCell* customCell;
@end
