//
//  BubbleMessage.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/30/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    BubbleMessageTypeMine=0,
    BubbleMessageTypeSomeone=1
} BubbleMessageType;
@interface BubbleMessage : NSObject{
    NSString* message;
    NSString* name;
    NSString* time;
    UIImage* avatar;
    UIImage* imgPost;
    UIImage* imgBubble;
    NSString* urlImgPost;
    NSString* urlImgAvatar;
    CGSize size;
    BubbleMessageType* type;
    bool isShowImage;//show image or youtube
    NSString* youtubeVideoId;
    bool initialed;
    long timeStamp;
    
    //Rect
    CGRect rectAvatar;
    CGRect rectName;
    CGRect rectBubble;
    CGRect rectMessage;
    CGRect rectImage;
    CGRect rectTime;
}
@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) UIImage* avatar;
@property (nonatomic,assign) CGSize size;
@property (nonatomic) BubbleMessageType* type;
@property (nonatomic,retain) UIImage* imgPost;
@property (nonatomic,retain) NSString* urlImgPost;
@property (nonatomic,assign) CGRect rectAvatar;
@property (nonatomic,assign) CGRect rectName;
@property (nonatomic,assign) CGRect rectBubble;
@property (nonatomic,assign) CGRect rectMessage;
@property (nonatomic,assign) CGRect rectImage;
@property (nonatomic,assign) CGRect rectTime;
@property (nonatomic, retain) UIImage* imgBubble;
@property (nonatomic, retain) NSString* urlImgAvatar;
@property (nonatomic, assign) bool isShowImage;
@property (nonatomic, retain) NSString* youtubeVideoId;
@property (nonatomic, assign) bool initialed;
@property (nonatomic, assign) long timeStamp;
@end
