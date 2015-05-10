//
//  DetailPopup.h
//  RocketeerApp1
//
//  Created by Rocketeer on 5/4/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPopup : UIViewController{
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIButton* btnClose;
    NSString* strTime;
    NSString* strHeader;
    NSString* strMessage;
    id delegate;
}
@property (nonatomic, retain) NSString* strTime;
@property (nonatomic, retain) NSString* strHeader;
@property (nonatomic, retain) NSString* strMessage;
@property (nonatomic, retain) id delegate;
@end
