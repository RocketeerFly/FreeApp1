//
//  AppDelegate.m
//  RocketeerApp1
//
//  Created by Rocketeer on 3/28/15.
//  Copyright (c) 2015 Rocketeer. All rights reserved.
//

#import "AppDelegate.h"
#import "UserAccount.h"
#import "Utils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[[UITabBar appearance] setTintColor:[UIColor colorWithRed:26 green:134 blue:139 alpha:1.0f]];
    //unselected icon tint color
    //[[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor colorWithRed:26 green:134 blue:139 alpha:1.0f]];
    
    //selected tint color
    //[[UITabBar appearance] setTintColor:[UIColor colorWithRed:26 green:134 blue:139 alpha:1.0f]];
    
//    //text tint color
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]
//                                             forState:UIControlStateNormal];
//    
//    //background tint color
//    [[UITabBar appearance] setBarTintColor:[UIColor blueColor]];
    //unselected icon tint color
//    [[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor grayColor]];
//    
//    //selected tint color
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:26 green:134 blue:139 alpha:1.0f]];
//    
//    //text tint color
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
//                                             forState:UIControlStateNormal];
//    
//    //background tint color
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor greenColor] }
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
//                                             forState:UIControlStateSelected];
//   [[UITabBar appearance] setSelectedImageTintColor:[UIColor cyanColor]];
    // Assign tab bar item with titles
//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//    UITabBar *tabBar = tabBarController.tabBar;
//    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
//    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
//    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
//    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
//    
//    (void)[tabBarItem1 initWithTitle:nil image:[UIImage imageNamed:@"ic_action_position.png"] selectedImage:[UIImage imageNamed:@"ic_action_position_selected.png"]];
//    (void)[tabBarItem2 initWithTitle:nil image:[UIImage imageNamed:@"ic_action_alert.png"] selectedImage:[UIImage imageNamed:@"ic_action_alert_selected.png"]];
//    (void)[tabBarItem3 initWithTitle:nil image:[UIImage imageNamed:@"ic_action_chat.png"] selectedImage:[UIImage imageNamed:@"ic_action_chat_selected.png"]];
//    (void)[tabBarItem4 initWithTitle:nil image:[UIImage imageNamed:@"ic_action_more.png"] selectedImage:[UIImage imageNamed:@"ic_action_more_selected.png"]];
    
//    // Change the tab bar background
//    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
//    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"ArialMT" size:16.0], NSFontAttributeName,nil]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = [defaults valueForKey:@"user_id"];
    NSString* token = [defaults valueForKey:@"token"];
    if (userId && token) {
        UserAccount* userAcc = [UserAccount sharedInstance];
        userAcc.userId = userId;
        userAcc.token = token;
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
