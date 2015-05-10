//
//  PositionCellData.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/29/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "PositionCellData.h"

@implementation PositionCellData
@synthesize message,time,header,height,frameMessage,isInitialed,frameHeader;
-(id)init{
    self = [super init];
    if(self){
        isInitialed = NO;
    }
    return self;
}
@end
