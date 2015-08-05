//
//  BKAppDelegate.m
//  Hypnosister
//
//  Created by vivi 卫 on 15-7-8.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKAppDelegate.h"
#import "BKHypnosisView.h"

@implementation BKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2;
//    bigRect.size.height *= 2;
    
    // 创建一个屏幕大小的scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.pagingEnabled = YES; // 一页一页的移动，不会停留在中间页
    [self.window addSubview:scrollView];
    
    // 创建一个是屏幕两倍大小的视图，并添加到scroll view中
    BKHypnosisView *myView = [[BKHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:myView];
    
    screenRect.origin.x += screenRect.size.width;
    BKHypnosisView *myView2 = [[BKHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:myView2];

    
    scrollView.contentSize = bigRect.size;
    
    
    
//    // 将BKHypnosisView设置为全屏，即window的bounds
//    CGRect firstFrame = self.window.bounds;
//    BKHypnosisView *firstView = [[BKHypnosisView alloc] initWithFrame:firstFrame];
//    [self.window addSubview:firstView];
    
//    CGRect secondFrame = CGRectMake(20, 30, 50, 50);
//    BKHypnosisView *secondView = [[BKHypnosisView alloc] initWithFrame:secondFrame];
//    secondView.backgroundColor = [UIColor blueColor];
////    [self.window addSubview:secondView];
//    [firstView addSubview:secondView];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
