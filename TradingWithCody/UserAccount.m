//
//  User.m
//  RocketeerApp1
//
//  Created by Rocketeer on 4/30/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

static UserAccount* instance = nil;

@synthesize userId,token,timeLogin,firstName,lastName;

+(UserAccount*)sharedInstance{
    if(!instance){
        instance = [[UserAccount alloc] init];
    }
    return instance;
}
-(void)clearInfo{
    userId = nil;
    token = nil;
    timeLogin = nil;
    firstName = nil;
    lastName = nil;
}
@end
