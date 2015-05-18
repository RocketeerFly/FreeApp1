//
//  ChatRoomView.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "ChatRoomView.h"
#import "BubbleMessage.h"
#import "BubbleMessageMine.h"
#import "BubbleMessageSomeone.h"
#import "Contants.h"
#import "UserAccount.h"
#import "ProgessView.h"
#import "JTSImageInfo.h"
#import "JTSPopup/JTSImageViewController.h"
#import "Utils.h"
#import "HCYoutubeParser.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface ChatRoomView ()

@end
static int margin_offset = 10;
static int avatar_size = 50;
static int text_size = 18;
static int pageSize = 30;
static int chatbox_height = 40;
static int refresh_interval = 60;
static int tv_chat_height = 30;
static NSString* idCellMineReuse = @"bubbleMessageCellMine";
static NSString* idCellSomeoneReuse = @"bubbleMessageCellSomeone";
@implementation ChatRoomView

-(CGSize)calculateSizeBubbleMessage:(NSString*) message maxWidth:(int)width{
    return CGSizeMake(0, 0);
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];[tap cancelsTouchesInView];
    [self.view addGestureRecognizer:tap];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventValueChanged];
    [twChat addSubview:refreshControl];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    currentSize = 0;
    numLineTextChatOld = 1;
    currentHeightTextBox = 0;
    responseData = [[NSMutableData alloc] init];
    windowWidth = [UIScreen mainScreen].bounds.size.width;
    // Do any additional setup after loading the view.

    bubbleData = [[NSMutableArray alloc] init];
    isFirstRequest = YES;
    firstLoad = YES;
    isAfterRefresh = NO;
    isAfterPostComment = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:refresh_interval target:self selector:@selector(refreshList) userInfo:nil repeats:YES];
    //[self showSpinner];
    [self sendRequest];
}
-(void)refreshList{
    NSLog(@"Refresh");
    currentSize = 0;
    isAfterRefresh = YES;
    [self sendRequest];
}
-(void)viewWillAppear:(BOOL)animated{
    if (isFirstRequest) {
        [self showSpinner];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
}
-(void)viewDidAppear:(BOOL)animated{
    if (firstLoad) {
        chatView.layer.borderColor = [UIColor whiteColor].CGColor;
        orginHeightListChat = twChat.frame.size.height;
        oldYTextBox = chatView.frame.origin.y;
        ;
        //change frame chatTextView
        int left = btnAttach.frame.origin.x+btnAttach.frame.size.width+10;
        int right = btnSend.frame.origin.x-10;
        if (currentHeightTextBox==0) {
            twChatBox.frame = CGRectMake(left  , 5, right-left, tv_chat_height);
        }
        //twChatBox.layer.borderWidth = 1;
        //twChatBox.layer.borderColor = [UIColor redColor].CGColor;
        twChatBox.contentSize = twChatBox.frame.size;
        
//        chatView.layer.borderColor = [UIColor yellowColor].CGColor;
//        chatView.layer.borderWidth = 1;
        
        oldHeightTextBox = chatView.frame.size.height;
        currentHeightTextBox = oldHeightTextBox;
    }else{
    }
    
    firstLoad = NO;
}
-(void)startTimer{
    [timer fire];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return bubbleData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    float minHeight = avatar_size+text_size+2*margin_offset;
    BubbleMessage* messageData = [bubbleData objectAtIndex:indexPath.row];
    
//    UITableViewCell* newCell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if(!newCell){
//        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    newCell.backgroundColor = [UIColor clearColor];
//    newCell.textLabel.text = messageData.name;
//    return newCell;
//    
    if(messageData.type==BubbleMessageTypeMine){
        UITableViewCell* cellCustom = [twChat dequeueReusableCellWithIdentifier:idCellMineReuse];
        if(!cellCustom || messageData.size.height==0){
            //text message
            if (!cellCustom) {
                cellCustom = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCellMineReuse];
            }else{
                [[cellCustom subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            }
           
            cellCustom.backgroundColor = [UIColor clearColor];
            NSString* message = [messageData message];
            float maxWidthMessage = windowWidth - 4*margin_offset;
            UIFont *font = [UIFont systemFontOfSize:16];
            
            CGSize constraint = CGSizeMake(maxWidthMessage-avatar_size,NSUIntegerMax);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
            
            NSDictionary *attributes = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle};
             NSDictionary *attributesSmall = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
            CGRect rect = [message boundingRectWithSize:constraint
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:attributes 
                                               context:nil];
            CGRect minRect = [messageData.time boundingRectWithSize:constraint
                                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                         attributes:attributesSmall
                                                            context:nil];
            
            if (rect.size.width<minRect.size.width) {
                rect.size.width = minRect.size.width;
            }else{
                if(rect.size.height<20){
                    rect.size.width+=margin_offset;
                }
                if(rect.size.width>maxWidthMessage){
                    rect.size.width=maxWidthMessage;
                }
            }
            rect.size.height += text_size;
            
            //Mesage
            CGRect rectLabel = CGRectMake(windowWidth-2*margin_offset-rect.size.width-2.5, margin_offset, rect.size.width, rect.size.height-text_size);
            UITextView* lbMessage = [[UITextView alloc] initWithFrame:rectLabel];
            lbMessage.editable = NO;
            lbMessage.scrollEnabled = NO;
            lbMessage.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            lbMessage.textContainerInset = UIEdgeInsetsZero;
            lbMessage.dataDetectorTypes = UIDataDetectorTypeNone;
            lbMessage.dataDetectorTypes = UIDataDetectorTypeLink;
            lbMessage.contentMode = UIViewContentModeScaleAspectFill;
            lbMessage.textAlignment = NSTextAlignmentLeft;
//            lbMessage.layer.borderColor = [UIColor redColor].CGColor;
//            lbMessage.layer.borderWidth = 1;
//            lbMessage.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
            NSMutableAttributedString* attText =[Utils convertString:message];
            if(attText){
                [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                lbMessage.attributedText = attText;
            }else{
                attText = [[NSMutableAttributedString alloc] initWithString:message];
                [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                lbMessage.text = message;
            }
            lbMessage.font = [UIFont systemFontOfSize:16];
            lbMessage.backgroundColor = [UIColor clearColor];
            lbMessage.tag = 1;
            lbMessage.editable = YES;
            lbMessage.editable = NO;
            lbMessage.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:42/256 green:102/256 blue:153/256 alpha:1.0f]};
            messageData.rectMessage = lbMessage.frame;
            
            //picture
            CGRect rectImage = CGRectMake(0, rectLabel.origin.y+rectLabel.size.height, 0, 0);
            UIButton* picture = [UIButton buttonWithType:UIButtonTypeCustom];
            picture.tag = 2;
            picture.imageView.contentMode = UIViewContentModeScaleAspectFit;
            if(messageData.urlImgPost){
                
                [picture sd_setImageWithURL:[NSURL URLWithString:messageData.urlImgPost] forState:UIControlStateNormal placeholderImage:[Utils imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)]];
                
                rectImage.size.width = rectLabel.size.width;
                //float ratio = messageData.imgPost.size.width/messageData.imgPost.size.height;
                float ratio = 1;
                rectImage.size.height = rectImage.size.width/ratio;
                rectImage.origin.x = windowWidth-2*margin_offset-rectImage.size.width;
                picture.frame = rectImage;
//                [picture setImage:messageData.imgPost forState:UIControlStateNormal];
                [picture addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                messageData.rectImage = rectImage;
                messageData.isShowImage = YES;
                picture.titleLabel.tag = indexPath.row;
                //update bubble
                minHeight+=rectImage.size.height;
            }else{
                NSString* videoId =[Utils detectYoutubeIdFromString:message];
                if(videoId){
                    UIImage* img = [Utils createYoutubeThumbnail:videoId];
                    if(img){
                        rectImage.size.width = rectLabel.size.width;
                        float ratio = img.size.width/img.size.height;
                        rectImage.size.height = rectImage.size.width/ratio;
                        rectImage.origin.x = windowWidth-2*margin_offset-rectImage.size.width;
                        picture.frame = rectImage;
                        [picture setImage:img forState:UIControlStateNormal];
                        [picture addTarget:self action:@selector(playYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                        messageData.rectImage = rectImage;
                        messageData.isShowImage = NO;
                        messageData.imgPost = img;
                        messageData.youtubeVideoId = videoId;
                        picture.titleLabel.tag = indexPath.row;
                        //update bubble
                        minHeight+=rectImage.size.height;
                    }
                }
            }

            
            //bubble
            CGRect rectBubble=CGRectMake(rectLabel.origin.x-0.5*margin_offset, rectLabel.origin.y-margin_offset, rect.size.width+2*margin_offset, rectLabel.size.height+2*margin_offset+text_size+rectImage.size.height);
            UIImageView* bubbleBG = [[UIImageView alloc] initWithFrame:rectBubble];
            bubbleBG.image = [self createBubbleWithType:BubbleMessageTypeMine];
            bubbleBG.tag = 3;
            messageData.rectBubble = rectBubble;
            messageData.imgBubble = bubbleBG.image;
            [cellCustom addSubview:bubbleBG];
            [cellCustom addSubview:lbMessage];
            [cellCustom addSubview:picture];
            
            //Time
            CGRect rectTime = CGRectMake(rectLabel.origin.x, rectImage.origin.y+rectImage.size.height, rect.size.width, text_size);
            UILabel* lbTime = [[UILabel alloc] initWithFrame:rectTime];
            lbTime.text = messageData.time;
            lbTime.tag = 4;
            lbTime.textAlignment = NSTextAlignmentRight;
            lbTime.font = [UIFont systemFontOfSize:12];
            messageData.rectTime = rectTime;
            [cellCustom addSubview:lbTime];

            //update cell's height
            messageData.size = CGSizeMake(windowWidth, rect.size.height+2*margin_offset+rectTime.size.height+rectImage.size.height);
        }else{
            //fill content
            //fill content
            NSArray* subView = cellCustom.subviews;
            for (UIView* view in subView) {
                NSInteger tag = view.tag;
                switch (tag) {
                    case 3:{//bubble
                        UIImageView* img = (UIImageView*)view;
                        img.image = messageData.imgBubble;
                        img.frame = messageData.rectBubble;
                    }
                        break;
                    case 1:{//message
                        UITextView* lb = (UITextView*)view;
                        lb.editable = YES;
                        lb.editable = NO;
                        lb.textAlignment = NSTextAlignmentLeft;
                        lb.frame = messageData.rectMessage;
                        NSMutableAttributedString* attText =[Utils convertString:messageData.message];
                        if(attText){
                            [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                            lb.attributedText = attText;
                        }else{
                            attText =[[NSMutableAttributedString alloc] initWithString:messageData.message];
                            [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                            lb.attributedText = attText;
                            lb.text = messageData.message;
                        }
                        
                    }
                        break;
                    case 2:{//picture or youtubeVideo
                        UIButton* btn = (UIButton*)view;
                        if(messageData.urlImgPost || messageData.imgPost){
                            if(messageData.imgPost){
                                [btn setImage:messageData.imgPost forState:UIControlStateNormal];
                            }else{
                                [btn sd_setImageWithURL:[NSURL URLWithString:messageData.urlImgPost] forState:UIControlStateNormal placeholderImage:[Utils imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)]];
                            }
                            //[btn setImage:messageData.imgPost forState:UIControlStateNormal];
                            btn.frame = messageData.rectImage;
                            btn.titleLabel.tag = indexPath.row;
                            [btn removeTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                            [btn removeTarget:self action:@selector(playYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                            if(messageData.isShowImage){//image
                                messageData.isShowImage = YES;
                                [btn addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                                
                            }else{//youtube
                                messageData.isShowImage = NO;
                                [btn addTarget:self action:@selector(playYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                            }
                        }else{
                            btn.frame = CGRectZero;
                        }
                    }
                        break;
                    case 4:{//time
                        UILabel* lb = (UILabel*)view;
                        lb.frame  = messageData.rectTime;
                        lb.text = messageData.time;
                    }
                        break;
                    default:
                        break;
                }
                
            }
        }
        [cellCustom layoutSubviews];
        return cellCustom;
    }else{
        UITableViewCell* cellCustom = [twChat dequeueReusableCellWithIdentifier:idCellSomeoneReuse];
        if(!cellCustom || messageData.size.height==0){
            if(!cellCustom){
                cellCustom = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCellSomeoneReuse];
            }else{
                [[cellCustom subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            }
            [cellCustom setBackgroundColor:[UIColor clearColor]];
            NSString* message = [messageData message];
            float maxWidthMessage = windowWidth - 4*margin_offset-avatar_size;
            UIFont *font = [UIFont systemFontOfSize:16];
            
            CGSize constraint = CGSizeMake(maxWidthMessage,NSUIntegerMax);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
            NSDictionary *attributes = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle};
            NSDictionary *attributesSmall = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
            CGRect minRect = [messageData.time boundingRectWithSize:constraint
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesSmall
                                                   context:nil];
            CGRect rect = [message boundingRectWithSize:constraint
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:attributes
                                                context:nil];
            rect.size.height += text_size;
            if (rect.size.width<minRect.size.width) {
                rect.size.width = minRect.size.width;
            }else{
                rect.size.width+=margin_offset;
                if(rect.size.width>maxWidthMessage){
                    rect.size.width=maxWidthMessage;
                }
            }
            
            //Message
            CGRect rectLabel = CGRectMake(2*margin_offset+avatar_size, margin_offset*2, rect.size.width, rect.size.height-text_size);
            UITextView* lbMessage = [[UITextView alloc] initWithFrame:rectLabel];
            lbMessage.editable = NO;
            lbMessage.scrollEnabled = NO;
            lbMessage.delegate = self;
            lbMessage.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            lbMessage.textContainerInset = UIEdgeInsetsZero;
            lbMessage.dataDetectorTypes = UIDataDetectorTypeNone;
            lbMessage.dataDetectorTypes = UIDataDetectorTypeLink;
            lbMessage.contentMode = UIViewContentModeScaleAspectFill;
            lbMessage.textAlignment = NSTextAlignmentLeft;
            lbMessage.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
//            lbMessage.layer.borderColor = [UIColor redColor].CGColor;
//            lbMessage.layer.borderWidth = 1;
            
            NSMutableAttributedString* attText =[Utils convertString:message];
            if(attText){
                [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                lbMessage.attributedText = attText;
            }else{
                [lbMessage setAttributedText:nil];
                lbMessage.text = message;
            }
            lbMessage.font = [UIFont systemFontOfSize:16];
            lbMessage.backgroundColor = [UIColor clearColor];
            lbMessage.tag = 4;
            lbMessage.editable = YES;
            lbMessage.editable = NO;
            lbMessage.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:42/256.0f green:102/256.0f blue:153/256.0f alpha:1.0f]};
            messageData.rectMessage = lbMessage.frame;
            
            
            //picture
            
            CGRect rectImage = CGRectMake(rectLabel.origin.x, rectLabel.origin.y+rectLabel.size.height, 0, 0);
            UIButton* picture = [UIButton buttonWithType:UIButtonTypeCustom];
            picture.tag = 5;
            picture.imageView.contentMode = UIViewContentModeScaleAspectFit;
            if(messageData.urlImgPost){
                [picture sd_setImageWithURL:[NSURL URLWithString:messageData.urlImgPost] forState:UIControlStateNormal placeholderImage:[Utils imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)]];
                
                rectImage.size.width = rectLabel.size.width;
                //float ratio = messageData.imgPost.size.width/messageData.imgPost.size.height;
                float ratio = 1;
                rectImage.size.height = rectImage.size.width/ratio;
                picture.frame = rectImage;
                //[picture setImage:messageData.imgPost forState:UIControlStateNormal];
                
                [picture addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                messageData.rectImage = rectImage;
                messageData.isShowImage = YES;
                picture.titleLabel.tag = indexPath.row;
                //update bubble
                minHeight+=rectImage.size.height;
                NSLog(@"Image height: %f",rectImage.size.height);
            }else{
                NSString* videoId =[Utils detectYoutubeIdFromString:message];
                if(videoId){
                    UIImage* img = [Utils createYoutubeThumbnail:videoId];
                    if(img){
                        rectImage.size.width = rectLabel.size.width;
                        float ratio = img.size.width/img.size.height;
                        rectImage.size.height = rectImage.size.width/ratio;
                        picture.frame = rectImage;
                        
                        [picture setImage:img forState:UIControlStateNormal];
                        [picture addTarget:self action:@selector(playYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                        messageData.rectImage = rectImage;
                        messageData.imgPost = img;
                        messageData.isShowImage = NO;
                        messageData.youtubeVideoId = videoId;
                        picture.titleLabel.tag = indexPath.row;
                        //update bubble
                        minHeight+=rectImage.size.height;
                        NSLog(@"Image youtube: %f",rectImage.size.height);
                        //rectImage.size.height -=50;
                    }
                }
            }
            
            //bubble
            CGRect rectBubble=CGRectMake(rectLabel.origin.x-margin_offset-3, rectLabel.origin.y-margin_offset, rect.size.width+2*margin_offset, rect.size.height+2*margin_offset+rectImage.size.height);
            UIImageView* bubbleBG = [[UIImageView alloc] initWithFrame:rectBubble];
            bubbleBG.image = [self createBubbleWithType:BubbleMessageTypeSomeone];
            bubbleBG.tag = 3;
            messageData.rectBubble = rectBubble;
            messageData.imgBubble = bubbleBG.image;
            [cellCustom addSubview:bubbleBG];
            [cellCustom addSubview:lbMessage];
            [cellCustom addSubview:picture];
            

            //Time
            CGRect rectTime = CGRectMake(rectImage.origin.x+margin_offset-2.5, rectImage.origin.y+rectImage.size.height, maxWidthMessage, text_size);
            UILabel* lbTime = [[UILabel alloc] initWithFrame:rectTime];
            lbTime.text = messageData.time;
            lbTime.font = [UIFont systemFontOfSize:12];
            lbTime.tag = 6;
            [cellCustom addSubview:lbTime];
            messageData.rectTime = rectTime;
            
            //avatar
            CGRect rectAva = CGRectMake(margin_offset,rect.size.height-text_size -margin_offset+8+rectImage.size.height, avatar_size, avatar_size);
            UIImageView* avatar = [[UIImageView alloc] initWithFrame:rectAva];
            [avatar sd_setImageWithURL:[NSURL URLWithString:messageData.urlImgAvatar] placeholderImage:[UIImage imageNamed:@"default_profile.png"]];
            avatar.layer.cornerRadius = avatar_size/2;
            avatar.layer.masksToBounds = YES;
            avatar.tag = 1;
            [cellCustom addSubview:avatar];
            messageData.rectAvatar = rectAva;
            messageData.avatar = avatar.image;
            
            //nickname
            CGRect rectNickname = CGRectMake(margin_offset, rectAva.origin.y+avatar_size+0.5*margin_offset-5, windowWidth/2, text_size);
            UILabel* nickname = [[UILabel alloc] initWithFrame:rectNickname];
            nickname.text = messageData.name;
            nickname.textAlignment=NSTextAlignmentLeft;
            nickname.textColor = [UIColor colorWithRed:80 green:229 blue:236 alpha:1.0f];
            nickname.backgroundColor = [UIColor clearColor];
            nickname.font = [UIFont systemFontOfSize:12];
            nickname.tag=2;
            [cellCustom addSubview:nickname];
            messageData.rectName = rectNickname;
            
            //extend height (for iphone 5/5S-)
            float extendHeight = 0;
            if([self isIphone5AndOlder]){
                NSLog(@"Iphone 5 and Older");
                extendHeight=margin_offset;
            }
            
            //update cell's height
            messageData.size = (rect.size.height+4*margin_offset)>=minHeight?CGSizeMake(windowWidth, rect.size.height+3*margin_offset+rectTime.size.height+rectImage.size.height):CGSizeMake(windowWidth, minHeight);
            if (messageData.youtubeVideoId) {
                messageData.size = CGSizeMake(windowWidth, rect.size.height+3*margin_offset+rectTime.size.height+rectImage.size.height);
            }
        }else{
            //fill content
            NSArray* subView = cellCustom.subviews;
            for (UIView* view in subView) {
                NSInteger tag = view.tag;
                switch (tag) {
                    case 1:{//avatar
                        
                        UIImageView* img = (UIImageView*)view;
                        img.frame = messageData.rectAvatar;
                        //img.image = messageData.avatar;
                        [img sd_setImageWithURL:[NSURL URLWithString:messageData.urlImgAvatar] placeholderImage:[UIImage imageNamed:@"default_profile.png"]];
                    }
                        break;
                    case 2:{//nickname
                        UILabel* lb = (UILabel*) view;
                        lb.frame = messageData.rectName;
                        lb.text = messageData.name;
                    }
                        break;
                    case 3:{//bubble
                        UIImageView* img = (UIImageView*)view;
                        img.image = messageData.imgBubble;
                        img.frame = messageData.rectBubble;
                    }
                        break;
                    case 4:{//message
                        UITextView* lb = (UITextView*)view;
                        lb.editable = YES;
                        lb.editable = NO;
                        lb.frame = messageData.rectMessage;
                        lb.textAlignment = NSTextAlignmentLeft;
                        NSMutableAttributedString* attText =[Utils convertString:messageData.message];
                        if(attText){
                            [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                            lb.attributedText = attText;
                        }else{
                            attText =[[NSMutableAttributedString alloc] initWithString:messageData.message];
                            [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
                            lb.attributedText = attText;
                            lb.text = messageData.message;
                        }
                    }
                        break;
                    case 5:{//picture or youtubeVideo
                        UIButton* btn = (UIButton*)view;
                        if(messageData.urlImgPost || messageData.imgPost){
                            if(messageData.imgPost){
                                [btn setImage:messageData.imgPost forState:UIControlStateNormal];
                            }else{
                                [btn sd_setImageWithURL:[NSURL URLWithString:messageData.urlImgPost] forState:UIControlStateNormal placeholderImage:[Utils imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)]];
                            }
                            
                            //[btn setImage:messageData.imgPost forState:UIControlStateNormal];
                            btn.frame = messageData.rectImage;
                            btn.titleLabel.tag = indexPath.row;
                            [btn removeTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                            [btn removeTarget:self action:@selector(playYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                            if(messageData.isShowImage){//image
                                messageData.isShowImage = YES;
                                [btn addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchUpInside];
                                
                            }else{//youtube
                                messageData.isShowImage = NO;
                                [btn addTarget:self action:@selector(playYoutubeVideo:) forControlEvents:UIControlEventTouchUpInside];
                            }
                        }else{
                            btn.frame = CGRectZero;
                        }
                    }
                        break;
                    case 6:{//time
                        UILabel* lb = (UILabel*)view;
                        lb.frame  = messageData.rectTime;
                        lb.text = messageData.time;
                    }
                        break;
                    default:
                        break;
                }
                
            }
        }
        //[cellCustom setNeedsDisplay];
        [cellCustom layoutSubviews];
        return cellCustom;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BubbleMessage* bubbleMessage = [bubbleData objectAtIndex:indexPath.row];
    if (bubbleMessage.size.height==0) {
        return 1;
    }
    return bubbleMessage.size.height;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIImage*) createBubbleWithType:(BubbleMessageType)type{
    UIImage* img;
    if(type==BubbleMessageTypeMine){
        img =[[UIImage imageNamed:@"bubble_mine.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        
    }else{
        img =[[UIImage imageNamed:@"bubble_someone.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:20];
    }
    return img;
}
-(BOOL)isIphone5AndOlder{
    return (UI_USER_INTERFACE_IDIOM() && (([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) <= 568.0f));
}
-(void)sendRequest{
    UserAccount* user = [UserAccount sharedInstance];
    NSString* token = [user.token stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    token = [token stringByReplacingOccurrencesOfString:@"/" withString:@"@"];
    NSString* url = [NSString stringWithFormat:@"%@%@/%@/%@/%d/%d",baseURL,pathChatStream,user.userId,token,currentSize,pageSize];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    request.HTTPMethod=@"GET";
    NSLog(@"%@",url);
    cnnGetListChat = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    BubbleMessage* msg = [bubbleData lastObject];
    timeLastComment = msg.timeStamp;
}
-(NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    if([connection isEqual:cnnGetListChat]){
        //show spinner
//        if(isFirstRequest){
//           
//        }
    }else{
        if ([connection isEqual:cnnPostCmt]) {
            
        }
    }
    return request;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Cannot connect to Scutify" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (spinner) {
        [self removeSpinner];
    }
    NSLog(@"Done reciving data!");
    @try {
        if ([connection isEqual:cnnGetListChat]) {
           
            int oldSizeArr = (int)bubbleData.count;
            if (isAfterRefresh) {
                [bubbleData removeAllObjects];
            }
            
            NSArray* arrayResp = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            [responseData setData:[[NSData alloc] init]];
            NSMutableArray* arrayOfIndexPath = [[NSMutableArray alloc] init];
            UserAccount* user = [UserAccount sharedInstance];
            int j = 0;
            int sizeArray = (int)arrayResp.count-1;
            for (int i = sizeArray; i>=0; i--) {
                NSDictionary* dict = [arrayResp objectAtIndex:j];
                BubbleMessage* messageData = [[BubbleMessage alloc] init];
                if ([user.userId isEqualToString:[dict valueForKey:@"UserId"]]) {
                    messageData.type = BubbleMessageTypeMine;
                }else{
                    messageData.type = BubbleMessageTypeSomeone;
                }
        
                [messageData setName:[dict valueForKey:@"Username"]];
                [messageData setMessage:[dict valueForKey:@"Scuttle"]];
//                if(i==7){
//                    [messageData setMessage:@"Chek my video https://www.youtube.com/watch?v=4NW9-yQcb70 hope u like it :D"];
//                }
//                if (messageData.type == BubbleMessageTypeMine) {
//                    messageData.message = [NSString stringWithFormat:@"%@ sdfasdfsdf $sdfasd sdaf sdaf asdfds sadf asdf asdf as https://www.youtube.com/watch?v=4NW9-yQcb70 sdf $safsd fsadf sdf sdf $sdf",messageData.message];
//                }
                long timeStamp = [[[dict valueForKey:@"Submitted"] valueForKey:@"$date"] longLongValue];
                [messageData setTimeStamp:timeStamp];
                timeStamp=timeStamp/1000;
                NSDate* time = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMMM dd YYYY HH:mm"];
                NSString *dateString = [dateFormat stringFromDate:time];
                [messageData setTime:dateString];
                
                //image url
                if ([messageData.message containsString:@"[media=1]"]) {
                    messageData.message = [messageData.message stringByReplacingOccurrencesOfString:@"[media=1]" withString:@""];
                    [messageData setUrlImgPost:[NSString stringWithFormat:@"%@%@.png",pathURLImage,[[dict valueForKey:@"_id"] objectForKey:@"$oid"]]];
//                    messageData.imgPost = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:messageData.urlImgPost]]];
//                    dispatch_queue_t checkInQueueForPostImage = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//                    
//                    dispatch_async(checkInQueueForPostImage, ^{
//                        UIImage *image;
//                        @try {
//                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:messageData.urlImgPost]]];
//                        }
//                        @catch (NSException *exception) {
//                            
//                        }
//                        @finally {
//                            
//                        }
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            if (image) {
//                                messageData.imgPost = image;
//                            }
//                        });
//                    });
                }
                //avatar
                [messageData setUrlImgAvatar:[NSString stringWithFormat:@"%@%@.png",pathURLAvatar,messageData.name]];
                [bubbleData insertObject:messageData atIndex:0];
                NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
                [arrayOfIndexPath addObject:index];
                j++;
            }
            //remove
            NSMutableArray* arrIndexDel = [[NSMutableArray alloc] init];
            if (oldSizeArr>0) {
                for (int i=0; i<oldSizeArr; i++) {
                    [arrIndexDel addObject:[NSIndexPath indexPathForItem:i inSection:0 ]];
                }
            }
            //insert
            if (isAfterRefresh) {
                BubbleMessage* msg =[bubbleData lastObject];
                if (timeLastComment != msg.timeStamp) {
                    [twChat reloadData];
                }
            }else{
                    [twChat reloadData];
            }
//            [twChat beginUpdates];
//            if (oldSizeArr>0 && isAfterRefresh) {
//                [twChat deleteRowsAtIndexPaths:arrIndexDel withRowAnimation:UITableViewRowAnimationNone];
//            }
//            [twChat insertRowsAtIndexPaths:arrayOfIndexPath withRowAnimation:UITableViewRowAnimationNone];
//            [twChat endUpdates];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [twChat reloadData];
//            });
            if(isFirstRequest || isAfterRefresh){
                NSLog(@"First Request or refresh");
                [twChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bubbleData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.01];
            }else{
            }
            isFirstRequest = NO;
            isAfterRefresh = NO;
        }else{
            if ([connection isEqual:cnnPostCmt]) {
                NSLog(@"Finish post comment!");
                
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}
-(void)scrollToBottom{
    [twChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bubbleData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    isAfterRefresh = NO;
}
-(void)showSpinner{
    if (!spinner) {
        spinner = [[ProgessView alloc] initWithNibName:nil bundle:nil];
        spinner.view.frame = self.view.frame;
    }
    [self.view addSubview:spinner.view];
}
-(void)removeSpinner{
    [spinner removeFromParentViewController];
    [spinner.view removeFromSuperview];
    spinner = nil;
}
-(IBAction)openImage:(id)sender{
    UIButton* btn = sender;
    
    NSLog(@"Open image!");
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    NSInteger tag = btn.titleLabel.tag;
    //BubbleMessage* msg =[bubbleData objectAtIndex:tag];
    imageInfo.image = btn.imageView.image;
    imageInfo.referenceRect = self.view.frame;
    imageInfo.referenceView = self.view.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    btn.tag = 5;
}
- (void)didShowKeyboard:(NSNotification*)notification{
    bool isScrollBottom = NO;
    if (twChat.contentSize.height <= twChat.contentOffset.y + twChat.frame.size.height){
        NSLog(@"bottom");
        isScrollBottom = YES;
    }
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyboardFrameBeginRect = [self.view convertRect:keyboardFrameBeginRect fromView:nil];
    float distance = keyboardFrameBeginRect.size.height-49;
    
    //listView
    CGRect newFrame = twChat.frame;
    newFrame.size.height = newFrame.size.height-distance-(currentHeightTextBox-oldHeightTextBox);

    //chat box
    CGRect rectChatBox = chatView.frame;
    rectChatBox.size.height = currentHeightTextBox;
    rectChatBox.origin.y = rectChatBox.origin.y-distance-(currentHeightTextBox-oldHeightTextBox);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01f];
    if (isScrollBottom) {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(checkIfScrolledBottom)];
    }
    
    twChat.frame = newFrame;
    chatView.frame  =rectChatBox;
    //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-distance, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)checkIfScrolledBottom{
    //check uitableview scrolled at bottom
    [twChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bubbleData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
-(IBAction)handleTap:(id)sender{
    NSLog(@"TAP");
    UITapGestureRecognizer* gesture = sender;
    CGPoint position = [gesture locationInView:self.view];
    if (![twChatBox isFirstResponder] || position.y>= chatView.frame.origin.y) {
        return;
    }
    
    [twChatBox resignFirstResponder];
    if (isAfterPostComment) {
        twChatBox.text = NSLocalizedString(@"MSG_PLACEHOLDER_CHAT", nil);
        oldHeightTextBox = chatbox_height;
        currentHeightTextBox = oldHeightTextBox;
    }
    CGRect newFrame = twChat.frame;
    newFrame.size.height = orginHeightListChat -(currentHeightTextBox - oldHeightTextBox);
    
    CGRect rectChatView = chatView.frame;
    rectChatView.origin.y = oldYTextBox - (currentHeightTextBox - oldHeightTextBox);
    
    if (isAfterPostComment) {
        CGRect rectTextBox = twChatBox.frame;
        rectTextBox.size.height = tv_chat_height;
        twChatBox.frame = rectTextBox;
    }
    
    NSLog(@"chatview height: %f",rectChatView.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    twChat.frame = newFrame;
    chatView.frame = rectChatView;
    //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
//    currentHeightTextBox = chatbox_height;
//    oldHeightTextBox = chatbox_height;
    //oldHeightTextBox = currentHeightTextBox;

    [UIView commitAnimations];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:NSLocalizedString(@"MSG_PLACEHOLDER_CHAT", nil)]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor whiteColor];
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(textView.text.length==0){
        textView.text = NSLocalizedString(@"MSG_PLACEHOLDER_CHAT", nil);
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    int numLines = textView.contentSize.height/textView.font.leading;
    if (numLines>numLineTextChatOld) {
        //new line
        
        if (numLines<4) {
            NSLog(@"Change height UP !!!");
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(adjustContentSize)];
            
            CGRect frame = chatView.frame;
            frame.size.height += textView.font.leading;
            frame.origin.y -= textView.font.leading;
            chatView.frame = frame;
            
            CGRect rectChatBox = twChatBox.frame;
            rectChatBox.size.height +=textView.font.leading;
            twChatBox.frame = rectChatBox;
            [UIView commitAnimations];
        }else{
            [self adjustContentSize];
        }
    }else{
        if(numLineTextChatOld>numLines){
            if (numLines<3 & numLines>0) {
                NSLog(@"Change height DOWN !!!");
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0];
                [UIView setAnimationDelegate:self];
                
                CGRect frame = chatView.frame;
                frame.size.height -= textView.font.leading;
                frame.origin.y += textView.font.leading;
                chatView.frame = frame;
                
                CGRect rectChatBox = twChatBox.frame;
                rectChatBox.size.height -=textView.font.leading;
                twChatBox.frame = rectChatBox;
                [UIView commitAnimations];
            }
        }
    }
    NSLog(@"numLines: %d",numLines);
    numLineTextChatOld = numLines;
    currentHeightTextBox = chatView.frame.size.height;
}
-(void)adjustTextView{
    
}
-(IBAction)stopLoadMore:(id)sender{
    [refreshControl endRefreshing];
    
}
-(IBAction)loadMore:(id)sender{
    NSLog(@"Load more!!!!");
    if (currentSelectedText) {
        currentSelectedText.selectedTextRange = nil;
    }
    currentSize+=pageSize;
    [self sendRequest];
    [self performSelector:@selector(stopLoadMore:) withObject:nil afterDelay:1];
}
-(IBAction)postComment:(id)sender{
    if ([twChatBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
        //send post comment request
        isAfterPostComment = YES;
        NSString* message = twChatBox.text;
        if(imgAttach){
            message = [NSString stringWithFormat:@"%@ [media=1]",message];
        }
        //reset textbox
        [self handleTap:nil];
        
        isAfterPostComment = NO;
        UserAccount* user = [UserAccount sharedInstance];
       NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,pathPostCmt]]];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        NSString* params = [NSString stringWithFormat:@"{\"chat\":{\"Token\":\"%@\",\"UserId\":\"%@\",\"Scuttle\":\"%@\"}}",user.token,user.userId,message,nil];
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"post comment: %@",message);
        
        //show spinner
        [self showSpinner];
        //test
//        if(!imgAttach){
//            [self performSelector:@selector(refreshList) withObject:nil afterDelay:2];
//        }else{
//            [self postImageV2:nil forCmtId:nil];
//        }
        
       [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
           
           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSString* commentId = [dict valueForKey:@"result"];
           NSLog(@"Finish postComment id: %@",commentId);
           //PostImage
           if(imgAttach && commentId && commentId.length>0){
               [self postImageV2:imgAttach forCmtId:commentId];
           }else{
               //reload chat view
               NSLog(@"Reload...");
               [self refreshList];
           }
       }];
    }
}

-(void)postImageV2:(UIImage*)image forCmtId:(NSString*)cmtId{
    NSLog(@"URL %@",[NSString stringWithFormat:@"%@%@%@",baseURL,pathPostImg,cmtId]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",baseURL,pathPostImg,cmtId]]];
    [request setHTTPMethod:@"POST"];
    NSData *imgData = UIImageJPEGRepresentation(imgAttach, 0.5);
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:imgData];
    [request setHTTPBodyStream:inputStream];
    
    [self performSelector:@selector(deleteAttachImageAndRefresh) withObject:nil afterDelay:3];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *retString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", retString);
        imgAttach = nil;
        [self refreshList];
    }];
}
-(void)deleteAttachImageAndRefresh{
    imgAttach = nil;
    [self refreshList];
}
-(void)postImage:(UIImage*)image forCmtId:(NSString*)cmtId{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",baseURL,pathPostImg,cmtId]]];
    NSLog(@"URL %@",[NSString stringWithFormat:@"%@%@%@",baseURL,pathPostImg,cmtId]);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString* strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Finish posting image RS: %@",strResult);
        [self refreshList];
    }];
}
-(void)pickupImage:(int)typeSource{
    pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.delegate = self;
    NSArray* arrType = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerImage.mediaTypes = [NSArray arrayWithObject:[arrType objectAtIndex:0]];
    NSLog(@"Type size:%lu",(unsigned long)arrType.count);
    if (typeSource==1) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }else{
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [UIView transitionWithView:self.view.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ { [self.view.window  addSubview:pickerImage.view]; }
                    completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Selected image");
    [UIView transitionWithView:self.view.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ {
                        [picker removeFromParentViewController];
                        [picker.view removeFromSuperview];
                    }
                    completion:nil];
    imgAttach = [info objectForKey:UIImagePickerControllerOriginalImage];

    picker = nil;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Cancell");
    imgAttach = nil;
    [UIView transitionWithView:self.view.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ {
                        [picker removeFromParentViewController];
                        [picker.view removeFromSuperview];
                    }
                    completion:nil];
    picker = nil;
}
-(IBAction)showAttachActions:(id)sender{
    [twChatBox resignFirstResponder];
    UIActionSheet *popupQuery;
    if(imgAttach){
        popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select from Gallery", @"Remove Image", nil];
    }else{
        popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select from Gallery", nil];
    }
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    popupQuery = nil;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Select at %ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:{
            [self pickupImage:0];
        }
            break;
        case 1:{
            [self pickupImage:1];
        }
            break;
        case 2:{
            imgAttach = nil;
        }
            break;
        default:
            break;
    }
}

-(IBAction)playYoutubeVideo:(id)sender{
    UIButton* btn = sender;
    NSLog(@"Open video!");
    NSInteger tag = btn.titleLabel.tag;
    BubbleMessage* msg =[bubbleData objectAtIndex:tag];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",msg.youtubeVideoId]];
    ;
    [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
        
        if (!error) {
            
            [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                
                
                NSDictionary *qualities = videoDictionary;
                
                NSString *URLString = nil;
                if ([qualities objectForKey:@"medium"] != nil) {
                    URLString = [qualities objectForKey:@"medium"];
                }
                else if ([qualities objectForKey:@"live"] != nil) {
                    URLString = [qualities objectForKey:@"live"];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                    return;
                }
                _urlToLoad = [NSURL URLWithString:URLString];
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }];
    if(!_urlToLoad){
        NSLog(@"Try again!");
        [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
            
            if (!error) {
                
                [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                    
                    
                    NSDictionary *qualities = videoDictionary;
                    
                    NSString *URLString = nil;
                    if ([qualities objectForKey:@"medium"] != nil) {
                        URLString = [qualities objectForKey:@"medium"];
                    }
                    else if ([qualities objectForKey:@"live"] != nil) {
                        URLString = [qualities objectForKey:@"live"];
                    }
                    else {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                        return;
                    }
                    _urlToLoad = [NSURL URLWithString:URLString];
                    
                    if (_urlToLoad) {
                        
                        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:_urlToLoad];
                        [self presentViewController:mp animated:YES completion:NULL];
                    }
                }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    currentSelectedText = textView;
}
-(void)adjustContentSize{
    NSLog(@"scroll to bottom, content size: %f",twChatBox.contentSize.height);
    //[twChatBox layoutIfNeeded];
//    NSRange range = NSMakeRange(twChatBox.text.length, 1); //I ignore the final carriage return, to avoid a blank line at the bottom
//
//    [twChatBox scrollRangeToVisible:range];
    //[twChatBox setContentOffset:CGPointMake(0, twChatBox.contentSize.height)];
    [twChatBox scrollRectToVisible:CGRectMake(0, 0, twChatBox.frame.size.width, twChatBox.contentSize.height) animated:NO];
}
@end

