//
//  Utils.m
//  Trading with Cody
//
//  Created by Rocketeer on 5/7/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "Utils.h"
#import "HCYoutubeParser.h"
@implementation Utils
+(NSMutableAttributedString*)convertString:(NSString*)string{
    NSString* orginStr = string;
    int numAtt = 0;
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
    @try {
        while (YES) {
            NSRange range = [string rangeOfString:@"$"];
            if(range.length==0){
                if(numAtt>0){
                    [result appendAttributedString:[[NSMutableAttributedString alloc] initWithString:string]];
                }
                break;
            }else{
                [result appendAttributedString:[[NSAttributedString alloc] initWithString:[string substringWithRange:NSMakeRange(0, range.location)]]];
                string = [string substringFromIndex:range.location];
                NSRange rangSpace = [string rangeOfString:@" "];
                NSString* linkDetected;
                if(rangSpace.length==0){
                    linkDetected = string;
                    string = @"";
                }else{
                    linkDetected = [string substringToIndex:rangSpace.location];
                    string = [string substringFromIndex:rangSpace.location];
                    numAtt++;
                }
                
                NSMutableAttributedString * strAtt = [[NSMutableAttributedString alloc] initWithString:linkDetected];
                NSString* hyperLink = [NSString stringWithFormat:NSLocalizedString(@"URL_SCUTIFY_APP", nil)];
                [hyperLink stringByAppendingString:[linkDetected substringFromIndex:1]];
                bool isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:hyperLink]];
                if(isInstalled){
                    [strAtt addAttribute: NSLinkAttributeName value: hyperLink range: NSMakeRange(0, linkDetected.length)];
                }else{
                    [strAtt addAttribute: NSLinkAttributeName value:NSLocalizedString(@"URL_APP_SCUTIFY", nil)  range: NSMakeRange(0, linkDetected.length)];
                }
                [result appendAttributedString:strAtt];
                
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error String: %@",orginStr);
        NSLog(@"%@",exception.reason);
    }
    @finally {
        
    }
    
    if (numAtt==0) {
        return nil;
    }else{
        
    }
    return result;
}
+(UIImage*)createYoutubeThumbnail:(NSString *)videoId{
    UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoId]]]];
    if(img || img.size.width>120){
        img = [UIImage imageWithCGImage:[img CGImage]
                            scale:(img.scale * 2)
                      orientation:(img.imageOrientation)];
        return [self addPlayIconYoutube:img];
    }
    return nil;
}
+(UIImage*)addPlayIconYoutube:(UIImage *)img{
    UIImage* iconPlay = [UIImage imageNamed:@"ic_play_youtube.png"];
    CGPoint point = CGPointMake(img.size.width/2-iconPlay.size.width/2, img.size.height/2-iconPlay.size.height/2);
    UIGraphicsBeginImageContextWithOptions(img.size, FALSE, 0.0);
    [img drawInRect:CGRectMake( 0, 0, img.size.width, img.size.height)];
    [iconPlay drawInRect:CGRectMake( point.x, point.y, iconPlay.size.width, iconPlay.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(NSString*)detectYoutubeIdFromString:(NSString *)message{
    //https://m.youtube.com/?#/watch?v=-Tvse54LYsE
    NSRange range = [message rangeOfString:@"/watch?v="];
    if (range.length==0) {
        return nil;
    }else{
        while (YES) {
            range = [message rangeOfString:@"/watch?v="];
            
            if(range.length==0){
                NSRange rangeSpace = [message rangeOfString:@" "];
                NSString* result;
                if (rangeSpace.length!=0) {
                    result = [message substringToIndex:rangeSpace.location];
                }else{
                    result = message;
                }
                if(result.length>11){
                    return [result substringToIndex:11];
                }else{
                    return result;
                }
            }else{
                message = [message substringFromIndex:range.location+9];
            }
        }
    }
    return nil;
}
+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
