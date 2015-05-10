//
//  LoginView.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "LoginView.h"
#import "Contants.h"

@interface LoginView ()

@end

@implementation LoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    
    //change background
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.image = [UIImage imageNamed:@"img_login_bg.9.png"];
    [self.view addSubview:imgView];
    [self.view sendSubviewToBack:imgView];
    
    
    //change textfield,button border
    tfPassWord.layer.borderColor = [UIColor whiteColor].CGColor;
    tfPassWord.layer.cornerRadius = 18.0f;
    tfPassWord.layer.borderWidth=2.0f;
    
    tfUserName.layer.borderColor = [UIColor whiteColor].CGColor;
    tfUserName.layer.cornerRadius = 18.0f;
    tfUserName.layer.borderWidth=2.0f;

    btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    btnLogin.layer.borderWidth = 2.0f;
    btnLogin.layer.cornerRadius = 18.0f;
    
    tfUserName.delegate = self;
    
    //test
//    tfPassWord.text = @"1791989vtT";
//    tfUserName.text = @"thitruongvo@gmail.com";
}

-(IBAction)login:(id)sender{
    
    //validate email
    if(![self validateEmail:[tfUserName text]])
    {
        // user entered invalid email address
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid email address!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [tfUserName becomeFirstResponder];
        return;
        //email.text=@"";
    }
    
    
    //validate password
    if(!(tfPassWord.text.length>1))
    {
        // user entered invalid password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid password!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [tfPassWord becomeFirstResponder];
        return;
        //email.text=@"";
    }
    
    //show spinner
    if (!spinner) {
        spinner = [[ProgessView alloc] initWithNibName:nil bundle:nil];
        spinner.view.frame = self.view.frame;
    }
    [self.view addSubview:spinner.view];
    
    //do send login request
    [self sendLoginRequest];
}
-(void)sendLoginRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,pathLogin]]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString* params = [NSString stringWithFormat:@"{\"user\":{\"Email\":\"%@\",\"Password\":\"%@\"}}",tfUserName.text,tfPassWord.text,nil];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:self];
    conn = nil;
}
-(IBAction)registerAccount:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"URL_REGISTER", nil)]];
}
-(IBAction)forgotPass:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"URL_FORGOT_PASS", nil)]];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self removeSpinner];
    @try {
        NSError* error;
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString* result = [jsonDict valueForKey:@"result"];
        if ([result isEqual:@"valid"]) {
            userAcc = [UserAccount sharedInstance];
            userAcc.firstName = [jsonDict valueForKey:@"firstname"];
            userAcc.lastName = [jsonDict valueForKey:@"lastname"];
            userAcc.userId = [jsonDict valueForKey:@"uid"];
            userAcc.token = [jsonDict valueForKey:@"token"];
            
            //save account
            // initialize defaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:tfUserName.text forKey:@"user_name"];
            [defaults setObject:tfPassWord.text forKey:@"pass_word"];
            [defaults setObject:userAcc.userId forKey:@"user_id"];
            [defaults setObject:userAcc.token forKey:@"token"];
            
            [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
        }else{
            userAcc = nil;
            [self loginFailed];
        }
    }
    @catch (NSException *exception) {
        [self loginError];
    }
    @finally {
        
    }
   
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self removeSpinner];
    NSLog(@"connectionDidFaidWithError:%@",error.localizedDescription);
    [self loginError];
}

- (void)didShowKeyboard:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    float newY = self.view.frame.size.height-keyboardFrameBeginRect.size.height-btnLogin.frame.size.height -10;
    float distance = newY - btnLogin.frame.origin.y;
    
    if(distance>0) return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+distance, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tfUserName resignFirstResponder];
    [tfPassWord resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
    
}

-(void) loginError{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"MSG_LOGIN_CANT", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void) loginFailed{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"MSG_LOGIN_FAIL", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)removeSpinner{
    [spinner removeFromParentViewController];
    [spinner.view removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
