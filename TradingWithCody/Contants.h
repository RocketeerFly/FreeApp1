//
//  Contants.h
//  RocketeerApp1
//
//  Created by Rocketeer on 4/30/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#ifndef RocketeerApp1_Contants_h
#define RocketeerApp1_Contants_h

#define baseURL @"http://twcservice.scutify.com/Service.svc"
#define pathLogin @"/users/login"  //{"user"{"Email":"thitruongvo@gmail.com","Password":"1791989vtT1"}}
#define loginParams @"{"user":{"Email":"%@","Password":"%@"}}"
#define pathTradeAlert @"/content/tradealerts/"            //uid,tkn
#define pathLastPosition @"/content/latestpositions/"    //uid,tkn
#define pathChatStream @"/chat/get/"      //uid,tkn,skip,limit
#define pathURLImage @"https://twc.scutify.com/img/chat/"
#define pathURLAvatar @"http://www.scutify.com/img/scutifiers/"
#define pathPostImg @"/upload/"
#define pathPostCmt @"/chat/post"

#define urlContact @"support@tradingwithcody.com"
#define urlRegister @"https://www.scutify.com/premiumplans/codywillard.html"
#define urlForgotPass @"https://www.scutify.com/verify-email.html"

#define msgCantLogin @"Can't login. Please try again"
#define msgFailLogin @"Ca"
#endif
