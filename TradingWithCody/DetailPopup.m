//
//  DetailPopup.m
//  RocketeerApp1
//
//  Created by Rocketeer on 5/4/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "DetailPopup.h"
#import "Utils.h"

@interface DetailPopup ()

@end

@implementation DetailPopup

@synthesize strHeader,strMessage,strTime,delegate;

static int offset_margin = 10;
static int text_height = 19;

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.layer.borderColor=[UIColor grayColor].CGColor;
    scrollView.layer.borderWidth = 1;

}
-(IBAction)closePopup{
    [delegate performSelector:@selector(closePopup)];
    NSLog(@"Close");
}
-(void)viewWillAppear:(BOOL)animated{
    
    int maxWidth = [UIScreen mainScreen].bounds.size.width-3*offset_margin;
    
    //lbDate
    CGRect rectDate = CGRectMake(offset_margin, offset_margin, maxWidth, text_height);
    UILabel* lbDate = [[UILabel alloc] initWithFrame:rectDate];
    lbDate.textColor = [UIColor whiteColor];
    lbDate.font = [UIFont italicSystemFontOfSize:16];
    lbDate.backgroundColor = [UIColor clearColor];
    lbDate.text = strTime;
    lbDate.tag = 1;
    [scrollView addSubview:lbDate];
    
    //lbHeader
    //calculate height string
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName : paragraphStyle};
    CGRect rectHeader = [strHeader boundingRectWithSize:CGSizeMake(maxWidth, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil];
    rectHeader.origin.x = offset_margin;
    rectHeader.origin.y = rectDate.origin.y+rectDate.size.height+offset_margin/2;
    
    int lineHeader = rectHeader.size.height/[UIFont systemFontOfSize:16].pointSize;
    NSLog(@"lines: %d",lineHeader);
    UILabel* lbHeader = [[UILabel alloc] initWithFrame:rectHeader];
    lbHeader.text = strHeader;
    lbHeader.font = [UIFont systemFontOfSize:16];
    lbHeader.backgroundColor = [UIColor clearColor];
    lbHeader.numberOfLines = 0;
    lbHeader.tag = 2;
    
    lbHeader.adjustsFontSizeToFitWidth = NO;
    lbHeader.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:lbHeader];
    [lbHeader sizeToFit];
    
    //lbContent
    //calculate height string
    CGRect rectContent = [strMessage boundingRectWithSize:CGSizeMake(maxWidth, NSIntegerMax) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    rectContent.origin.x = offset_margin;
    rectContent.origin.y = rectHeader.origin.y+rectHeader.size.height+offset_margin/2;
    
    UITextView* lbContent = [[UITextView alloc] initWithFrame:rectContent];
    lbContent.textColor = [UIColor whiteColor];
    lbContent.font = [UIFont systemFontOfSize:16];
    lbContent.backgroundColor = [UIColor clearColor];
    lbContent.tag = 3;
    lbContent.editable = NO;
    lbContent.scrollEnabled = NO;
    lbContent.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    lbContent.textContainerInset = UIEdgeInsetsZero;
    lbContent.dataDetectorTypes = UIDataDetectorTypeNone;
    lbContent.dataDetectorTypes = UIDataDetectorTypeLink;
    lbContent.contentMode = UIViewContentModeScaleAspectFill;
    lbContent.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString* attText =[Utils convertString:strMessage];
    if(attText){
        [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attText.length)];
        [attText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attText.length)];
        lbContent.attributedText = attText;
    }else{
        lbContent.text = strMessage;
    }
    lbContent.editable = YES;
    lbContent.editable = NO;
    lbContent.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor purpleColor]};

    [scrollView addSubview:lbContent];
    
    //update height
    float height =rectDate.size.height+rectHeader.size.height+rectContent.size.height+3*offset_margin;
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
