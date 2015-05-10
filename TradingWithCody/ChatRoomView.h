//
//  ChatRoomView.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgessView.h"

@interface ChatRoomView : UIViewController<UITableViewDelegate,
UITableViewDataSource,NSURLConnectionDataDelegate,UITextViewDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
    NSMutableArray* bubbleData;
    IBOutlet UITableView* twChat;
    NSInteger windowWidth;
     NSMutableData* responseData;
    int currentSize;
    ProgessView* spinner;
    UIImage* imgAvatarDefault;
    IBOutlet UITextView* twChatBox;
    NSTimer* timer;
    UIRefreshControl *refreshControl;
    
    NSURLConnection* cnnPostImage;
    NSURLConnection* cnnGetListChat;
    NSURLConnection* cnnPostCmt;
    
    UIImage* imgAttach;
    IBOutlet UIButton* btnAttach;
    IBOutlet UIButton* btnSend;
    UIImagePickerController * pickerImage;
    IBOutlet UIView* chatView;
    int numLineTextChatOld;
    
    int orginHeightListChat;
    int oldYTextBox;
    int oldHeightTextBox;
    int currentHeightTextBox;
    
    bool isFirstRequest;
    
    NSURL* _urlToLoad;
    
    UITextView* currentSelectedText;
    
    bool firstLoad;
    bool isAfterRefresh;
    bool isAfterPostComment;
}

@end
