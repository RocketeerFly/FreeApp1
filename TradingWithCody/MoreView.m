//
//  MoreView.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "MoreView.h"
#import "LoginView.h"

@interface MoreView ()

@end

@implementation MoreView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrItems = [[NSArray alloc] initWithObjects:@"Contact Us", @"Sign Out",@"Visit Scutify",nil];
    twList.tableFooterView = [[UIView alloc] init];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [twList dequeueReusableCellWithIdentifier:@"items"];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"items"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.indentationLevel=0;
        cell.indentationWidth=0;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [arrItems objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cellIndex = indexPath.row;
    switch (cellIndex) {
        case 0:{
            NSString* email = NSLocalizedString(@"CONTACT_MAIL", nil);
            NSString *url = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
            [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
        }
            break;
        case 1:{
            //remove login data
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"user_id"];
            [defaults removeObjectForKey:@"token"];
            
            [self performSegueWithIdentifier:@"SignOut" sender:self];
        }
            break;
        case 2:{
            NSString *iTunesLink = NSLocalizedString(@"URL_APP_SCUTIFY", nil);
            bool isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:NSLocalizedString(@"URL_SCUTIFY_APP", nil)]];
            if(isInstalled){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"URL_SCUTIFY_APP", nil)]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            }
        }
            break;
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    arrItems = nil;
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
