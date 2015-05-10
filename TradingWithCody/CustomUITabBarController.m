//
//  CustomUITabBarController.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/31/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "CustomUITabBarController.h"

@interface CustomUITabBarController ()

@end

@implementation CustomUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray* listTabBar = self.tabBar.items;
    
    UITabBarItem* itemPosistion = [listTabBar objectAtIndex:1];
    [itemPosistion setSelectedImage:[[UIImage imageNamed:@"ic_action_position_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemAlert = [listTabBar objectAtIndex:2];
    [itemAlert setSelectedImage:[[UIImage imageNamed:@"ic_action_alert_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemChat = [listTabBar objectAtIndex:0];
    [itemChat setSelectedImage:[[UIImage imageNamed:@"ic_action_chat_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem* itemMore = [listTabBar objectAtIndex:3];
    [itemMore setSelectedImage:[[UIImage imageNamed:@"ic_action_more_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    NSMutableDictionary* dic =[[NSMutableDictionary alloc] init];
    [dic setValue:[UIFont fontWithName:[NSString stringWithFormat:@"%@-%@",[UIFont systemFontOfSize:11].fontName,@"Thin"] size:16] forKey:NSFontAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:
     dic];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:27/255.0 green:134/255.0 blue:139/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
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
