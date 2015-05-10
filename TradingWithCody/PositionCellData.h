//
//  PositionCellData.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/29/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface PositionCellData : NSObject{
    NSString* time;
    NSString* header;
    NSString* message;
    NSInteger height;
    CGRect frameMessage;
    CGRect frameHeader;
    bool isInitialed;
}
@property (nonatomic,retain) NSString* time;
@property (nonatomic,retain) NSString* header;
@property (nonatomic,retain) NSString* message;
@property (nonatomic,assign) NSInteger height;
@property (assign) CGRect frameMessage;
@property (nonatomic, assign) bool isInitialed;
@property (nonatomic, assign) CGRect frameHeader;
@end
