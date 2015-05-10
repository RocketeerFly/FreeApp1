//
//  PositionsView.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "PositionsView.h"
#import "PositionCellData.h"
#import "PositionCell.h"
#import "Contants.h"
#import "UserAccount.h"

@interface PositionsView ()

@end
static int offset_margin = 10;
static int text_height = 19;

@implementation PositionsView

@synthesize twListLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    responseData = [[NSMutableData alloc] init];
    cellData = [[NSMutableArray alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [twListLocation addSubview:refreshControl];
    
    // Do any additional setup after loading the view.
    [self sendRequestGetList];
    isRefreshing = NO;
}

-(IBAction)refresh:(id)sender{
    isRefreshing = YES;
    [self sendRequestGetList];
}
-(IBAction)stopLoadMore:(id)sender{
    [twListLocation reloadData];
    [refreshControl endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[cellData count]);
    return [cellData count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *alertCellIdentifier = @"PositionCell";
    UITableViewCell *cell = [self.twListLocation dequeueReusableCellWithIdentifier:alertCellIdentifier];
    PositionCellData* data = [cellData objectAtIndex:indexPath.row];
    if (!cell || !data.isInitialed) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:alertCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        int maxWidth = [UIScreen mainScreen].bounds.size.width-3*offset_margin;
        
        //lbDate
        CGRect rectDate = CGRectMake(offset_margin, offset_margin, maxWidth, text_height);
        UILabel* lbDate = [[UILabel alloc] initWithFrame:rectDate];
        lbDate.textColor = [UIColor whiteColor];
        lbDate.font = [UIFont italicSystemFontOfSize:16];
        lbDate.backgroundColor = [UIColor clearColor];
        lbDate.text = data.time;
        lbDate.tag = 1;
        [cell addSubview:lbDate];
        
        //lbHeader
        //calculate height string
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName : paragraphStyle};
        CGRect rectHeader = [data.header boundingRectWithSize:CGSizeMake(maxWidth, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil];
        rectHeader.origin.x = offset_margin;
        rectHeader.origin.y = rectDate.origin.y+rectDate.size.height+offset_margin/2;
        UILabel* lbHeader = [[UILabel alloc] initWithFrame:rectHeader];
        lbHeader.text = data.header;
        lbHeader.font = [UIFont systemFontOfSize:16];
        lbHeader.backgroundColor = [UIColor clearColor];
        lbHeader.numberOfLines = 0;
        lbHeader.tag = 2;
        
        lbHeader.adjustsFontSizeToFitWidth = NO;
        lbHeader.lineBreakMode = NSLineBreakByWordWrapping;
        [cell addSubview:lbHeader];
        data.frameHeader = lbHeader.frame;
        [lbHeader sizeToFit];
        
        //lbContent
        //calculate height string
        CGRect rectContent = [data.message boundingRectWithSize:CGSizeMake(maxWidth, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
        rectContent.origin.x = offset_margin;
        rectContent.origin.y = rectHeader.origin.y+rectHeader.size.height+offset_margin/2;
        
        UILabel* lbContent = [[UILabel alloc] initWithFrame:rectContent];
        lbContent.text = data.message;
        lbContent.textColor = [UIColor whiteColor];
        lbContent.font = [UIFont systemFontOfSize:16];
        lbContent.backgroundColor = [UIColor clearColor];
        lbContent.numberOfLines = 4;
        lbContent.tag = 3;
        lbContent.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell addSubview:lbContent];
        
        int numberLines = rectContent.size.height/lbContent.font.pointSize;
        if (numberLines>4) {
            rectContent.size.height = lbContent.font.pointSize*5;
            lbContent.frame = rectContent;
        }
        data.frameMessage = lbContent.frame;
        
        //update height
        data.height =rectDate.size.height+rectHeader.size.height+rectContent.size.height+3*offset_margin;
        data.isInitialed = YES;
    }else{
        NSArray* subViews = cell.subviews;
        for (UIView* view in subViews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel* lb = (UILabel*)view;
                NSInteger tag = lb.tag;
                switch (tag) {
                    case 1:{
                        lb.text = data.time;
                    }
                        break;
                    case 2:{
                        lb.text = data.header;
                        lb.frame = data.frameHeader;
                    }
                        break;
                    case 3:{
                        lb.text = data.message;
                        lb.frame = data.frameMessage;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    //Set content
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PositionCellData* data = [cellData objectAtIndex:indexPath.row];
    return data.height;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    //show spinner
    if (!spinner) {
        spinner = [[ProgessView alloc] initWithNibName:nil bundle:nil];
        spinner.view.frame = self.view.frame;
    }
    [self.view addSubview:spinner.view];
    return request;
}
-(void)sendRequestGetList{
    UserAccount* user = [UserAccount sharedInstance];
    NSString* token = [user.token stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    token = [token stringByReplacingOccurrencesOfString:@"/" withString:@"@"];
    NSString* url = [NSString stringWithFormat:@"%@%@/%@/%@",baseURL,pathLastPosition,user.userId,token];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    request.HTTPMethod=@"GET";
    NSLog(@"%@",url);
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    conn=nil;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    @try {
        [responseData appendData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"parsing occured error: %@",exception.reason);
    }
    @finally {
        
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self removeSpinner];
    @try {
        NSArray* arrayResp = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        NSMutableArray* arrayOfIndexPath = [[NSMutableArray alloc] init];
        for (int i = 0; i<arrayResp.count; i++) {
            NSDictionary* dict = [arrayResp objectAtIndex:i];
            PositionCellData* cell = [[PositionCellData alloc] init];
            [cell setHeader:[dict valueForKey:@"Title"]];
            [cell setMessage:[dict valueForKey:@"Scuttle"]];
            long timeStamp = [[[dict valueForKey:@"Submitted"] valueForKey:@"$date"] longLongValue];
            timeStamp=timeStamp/1000;
            NSDate* time = [NSDate dateWithTimeIntervalSince1970:timeStamp];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEEE, MMMM d YYYY"];
            NSString *dateString = [dateFormat stringFromDate:time];
            [cell setTime:dateString];
            [cellData addObject:cell];
            NSIndexPath* index = [NSIndexPath indexPathForRow:cellData.count-1 inSection:0];
            [arrayOfIndexPath addObject:index];
        }
        [twListLocation beginUpdates];
        [twListLocation insertRowsAtIndexPaths:arrayOfIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        [twListLocation endUpdates];
        
        //stop refresh
        if (isRefreshing) {
            [self stopLoadMore:nil];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    popup = [storyboard instantiateViewControllerWithIdentifier:@"DetailPopup"];
    popup.view.frame = self.view.frame;
    PositionCellData* data = [cellData objectAtIndex:indexPath.row];
    [popup setStrHeader:data.header];
    [popup setStrTime:data.time];
    [popup setStrMessage:data.message];
    popup.delegate = self;
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view.window addSubview:popup.view];
    } completion:^(BOOL finished) {
        
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self removeSpinner];
    NSLog(@"error:%@",error.localizedDescription);
}
-(void)removeSpinner{
    [spinner removeFromParentViewController];
    [spinner.view removeFromSuperview];
}
-(void)closePopup{
    [popup removeFromParentViewController];
    [popup.view removeFromSuperview];
    popup = nil;
}

@end
