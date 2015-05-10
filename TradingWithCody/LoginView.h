//
//  LoginView.h
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccount.h"
#import "ProgessView.h"

@interface LoginView : UIViewController<UITextFieldDelegate,NSURLConnectionDataDelegate>{
    IBOutlet UIButton* btnLogin;
    IBOutlet UIButton* btnRegister;
    IBOutlet UIButton* btnForgotPass;
    
    IBOutlet UITextField* tfUserName;
    IBOutlet UITextField* tfPassWord;
    
    UserAccount* userAcc;
    ProgessView* spinner;
}


@end
