//
//  ProgessView.m
//  RocketeerApp1
//
//  Created by Rocketeer on 5/1/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "ProgessView.h"

@interface ProgessView ()

@end

@implementation ProgessView

@synthesize spiner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [spiner startAnimating];
}
-(void)viewWillAppear:(BOOL)animated{
    CGRect frame = self.view.frame;
    spiner.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width/2-50, frame.size.height/2-50);
    spiner.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [spiner startAnimating];
}
-(void)viewWillDisappear:(BOOL)animated{
    [spiner stopAnimating];
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
