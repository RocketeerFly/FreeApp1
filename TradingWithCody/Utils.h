//
//  Utils.h
//  Trading with Cody
//
//  Created by Rocketeer on 5/7/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+(NSMutableAttributedString*)convertString:(NSString*)string;
+(UIImage*)createYoutubeThumbnail:(NSString*)videoId;
+(UIImage*)addPlayIconYoutube:(UIImage*)img;
+(NSString*)detectYoutubeIdFromString:(NSString*)message;
+(UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;
@end
