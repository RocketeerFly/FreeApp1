//
//  User.h
//  RocketeerApp1
//
//  Created by Rocketeer on 4/30/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* token;
@property(nonatomic, retain) NSDate* timeLogin;
@property(nonatomic, retain) NSString* firstName;
@property(nonatomic, retain) NSString* lastName;

+(UserAccount*)sharedInstance;
-(void)clearInfo;
@end
