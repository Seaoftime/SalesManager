//
//  YWAppDelegate.m
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWAppDelegate.h"
#import "NSUserDefaults+Additions.h"
#import "MainViewController.h"
#import "YWLeftMenuViewController.h"
#import "MMDrawerVisualState.h"
#import "YNewFeatureViewController.h"
#import "JDStatusBarNotification.h"

#import "YWNoticeByIdVC.h"
#import "ILBarButtonItem.h"
#import "InformationReportDetailViewController.h"
#import "YWOtherNotDoneVC.h"
#import "YWSettingVC.h"
#import "YWLibrayVC.h"
#import "SignInDetailViewController.h"
#import "YSummaryFields.h"
#import <AudioToolbox/AudioToolbox.h>
#import "initApp.h"
#import "YWAuthenticate.h"




//是否刷新页面标志

BOOL firstIn;
BOOL alert;

@implementation YWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    userDefaults = [NSUserDefaults standardUserDefaults];

    
//    
    //判断是否第一次启动
    if (![userDefaults boolForKey:@"everLaunched-V3.1.0"]) {
        [userDefaults setBool:YES forKey:@"everLaunched-V3.1.0"];
        [userDefaults setBool:YES forKey:@"firstLaunch-V3.1.0"];
    }
    else{
        [userDefaults setBool:NO forKey:@"firstLaunch-V3.1.0"];
    }
    

//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startLocationServices) userInfo:nil repeats:YES];
    
    
    //注册服务 推送 bugly
    [[[YWAuthenticate alloc]init] authenticateTripartite:launchOptions];
    
    NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    if (IS_IOS7)
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                              [UIFont systemFontOfSize:19], UITextAttributeFont,
                                                              [UIColor whiteColor], UITextAttributeTextColor,
                                                              nil]];
    }
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    
 //    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
//        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
//    }else{
    
        NSLog(@"不是第一次启动");
        
        //判断是否可以自动登陆
        //if (!userDefaults.randCode)
        //{
        //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
        //    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
       // }else{
            [initApp appStart];
            YWLeftMenuViewController *leftVC = [[YWLeftMenuViewController alloc]
                                                init];
            MainViewController * drawerController = [[MainViewController alloc]
                                                     initWithCenterViewController:leftVC.navSlideSwitchVC
                                                     leftDrawerViewController:leftVC
                                                     rightDrawerViewController:nil];
            [drawerController setMaximumLeftDrawerWidth:220];
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            [drawerController setShouldStretchDrawer:NO];
            [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                MMDrawerControllerDrawerVisualStateBlock block;
                block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.0];
                block(drawerController, drawerSide, percentVisible);
            }];
            
            self.window.rootViewController = drawerController;
       // }
//    }

    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReach startNotifier];
    if (pushInfo != nil)
    {
        NSLog(@"推送信息:%@",pushInfo.description);
        int a = [[UIApplication sharedApplication] applicationIconBadgeNumber];
        [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:a+1];
        
        NSString *opid = [[pushInfo objectForKey:@"aps"]objectForKey:@"opid"];
        int type = [[[pushInfo objectForKey:@"aps"]objectForKey:@"type"] integerValue];
        NSLog(@"type:%i,opid:%@",type,opid);
        
        switch (type)
        {
            case 1://新信息汇报
            {
                YSummaryFields *summary = [[YSummaryFields alloc] init];//
                summary.summaryId = opid;
                summary.timeStampList = 222;
                
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                
                InformationReportDetailViewController *detail = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReportDetail"];;
                detail.summaryListField = summary;
                detail.isPush = YES;
                
                navi = [[UINavigationController alloc] initWithRootViewController:detail];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                
                break;
            }
            case 2://新通知
            {
                YWNoticeByIdVC *notice = [[YWNoticeByIdVC alloc] init];
                notice.fromPush = YES;
                notice.noticeid = opid;
                navi = [[UINavigationController alloc] initWithRootViewController:notice];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                
                break;
            }
            case 3://图库更新
            {
                YWLibrayVC *libray = [[YWLibrayVC alloc] init];
                libray.fromPush = YES;
                navi = [[UINavigationController alloc] initWithRootViewController:libray];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                break;
            }
                
            case 5://版本升级
            {
                YWSettingVC *setting = [[YWSettingVC alloc] init];
                setting.fromPush = YES;
                navi = [[UINavigationController alloc] initWithRootViewController:setting];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                
                break;
            }
            case 6://收到信息汇报的人添加提醒
            {
                YSummaryFields *summary = [[YSummaryFields alloc] init];//
                summary.summaryId = opid;
                summary.timeStampList = 222;
                
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                
                InformationReportDetailViewController *detail = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReportDetail"];
                detail.summaryListField = summary;
                detail.isPush = YES;
                
                navi = [[UINavigationController alloc] initWithRootViewController:detail];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                break;
            }
            case 10://签到
            {
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
                SignInDetailViewController *detailVC = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"signInDetail"];
                YSignInFields *sign = [[YSignInFields alloc] init];
                sign.signInID = opid;
                detailVC.signInFileds = sign;
                detailVC.isPush = YES;
                navi = [[UINavigationController alloc] initWithRootViewController:detailVC];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                break;
            }
                
            case 4://新任务
            {
                
            }
            case 7://修改任务
            {
                
            }
            case 8://关闭任务
            {
                
            }
            case 9://完成任务
            {
                YWOtherNotDoneVC *task = [[YWOtherNotDoneVC alloc] init];
                task.taskID = opid;
                task.fromPush = YES;
                navi = [[UINavigationController alloc] initWithRootViewController:task];
                [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                }];
                break;
            }
                
            default:
                break;
        }
        
    }
    else
    {
        NSLog(@"没有推送信息");
    }
    isNetWork = YES;
    
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
    
//    self.inBackground = YES;
//    [self.locationManager stopUpdatingLocation];
//    
//    UIBackgroundTaskIdentifier __block bgTask;
//    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        // Clean up any unfinished task business by marking where you.
//        // stopped or ending the task outright.
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//    
//    // Start the long-running task and return immediately.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (self.inBackground) {
//            [self startLocationServices];
//            [NSThread sleepForTimeInterval:(550)];
//        }
//        
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getNews" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    
    if (status == NotReachable) {
        if (firstIn) {
            [SVProgressHUD showErrorWithStatus:@"您已失去网络的链接"];
            
        }
        firstIn = YES;
                isNetWork = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkNetWork" object:@"2"];
        
        
    }else{
        if (firstIn) {
            [SVProgressHUD showSuccessWithStatus:@"网络已恢复"];
            
        }
        firstIn = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkNetWork" object:@"1"];
        
        isNetWork = YES;
    }
}

//推送方法
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [userDefaults setObject:token forKey:@"token"];
    
    NSLog(@"%@",token);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

UINavigationController *navi;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    int a = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:a+1];
    NSLog(@"%@",userInfo);
    NSString *opid = [[userInfo objectForKey:@"aps"]objectForKey:@"opid"];
    int type = [[[userInfo objectForKey:@"aps"]objectForKey:@"type"] integerValue];
    NSLog(@"type:%i,opid:%@",type,opid);
    UIApplicationState appState = UIApplicationStateActive;
    if([application respondsToSelector:@selector(applicationState)])
    {
        appState = application.applicationState;
    }

    if(appState == UIApplicationStateActive)
    {
//        if (!alert)
//        {
//            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"消息提醒" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//            alerView.tag = 9911;
//            [alerView show];
        
        
        
        
            if (type == 11 || type == 12) {
                
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getNews" object:nil];
                
            }
            else{
                
                AudioServicesPlaySystemSound(1008);
                 [JDStatusBarNotification showWithStatus:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] dismissAfter:3.f styleName:JDStatusBarStyleYWheaderStyel];
                
            }
        
        
//        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
//        SystemSoundID theSoundID;
//        OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
//        AudioServicesPlaySystemSound(soundID);
//        alert = YES;
//        }
    }else{
        //判断是否可以自动登陆
        if (!userDefaults.randCode)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        }else{
            YWLeftMenuViewController *leftVC = [[YWLeftMenuViewController alloc]
                                                init];
            MainViewController * drawerController = [[MainViewController alloc]
                                                     initWithCenterViewController:leftVC.navSlideSwitchVC
                                                     leftDrawerViewController:leftVC
                                                     rightDrawerViewController:nil];
            [drawerController setMaximumLeftDrawerWidth:220];
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            [drawerController setShouldStretchDrawer:NO];
            [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                MMDrawerControllerDrawerVisualStateBlock block;
                block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.0];
                block(drawerController, drawerSide, percentVisible);
            }];
            
            self.window.rootViewController = drawerController;
            
            
            
            switch (type)
            {
                case 1://新信息汇报
                {
                    YSummaryFields *summary = [[YSummaryFields alloc] init];//
                    summary.summaryId = opid;
                    summary.timeStampList = 222;
                    
                    UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                    
                    InformationReportDetailViewController *detail = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReportDetail"];;
                    detail.summaryListField = summary;
                    detail.isPush = YES;
                    
                    navi = [[UINavigationController alloc] initWithRootViewController:detail];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];
                    
                    break;
                }
                case 2://新通知
                {
                    YWNoticeByIdVC *notice = [[YWNoticeByIdVC alloc] init];
                    notice.fromPush = YES;
                    notice.noticeid = opid;
                    navi = [[UINavigationController alloc] initWithRootViewController:notice];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];
                    
                    break;
                }
                case 3://图库更新
                {
                    YWLibrayVC *libray = [[YWLibrayVC alloc] init];
                    libray.fromPush = YES;
                    navi = [[UINavigationController alloc] initWithRootViewController:libray];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];
                    break;
                }
                
                case 5://版本升级
                {
                    YWSettingVC *setting = [[YWSettingVC alloc] init];
                    setting.fromPush = YES;
                    navi = [[UINavigationController alloc] initWithRootViewController:setting];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];

                    break;
                }
                case 6://收到信息汇报的人添加提醒
                {
                    YSummaryFields *summary = [[YSummaryFields alloc] init];//
                    summary.summaryId = opid;
                    summary.timeStampList = 222;
                    
                    UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                    
                    InformationReportDetailViewController *detail = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReportDetail"];
                    detail.summaryListField = summary;
                    detail.isPush = YES;
                    
                    navi = [[UINavigationController alloc] initWithRootViewController:detail];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];
                    break;
                }
                case 10://签到
                {
                    UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
                    SignInDetailViewController *detailVC = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"signInDetail"];
                    YSignInFields *sign = [[YSignInFields alloc] init];
                    sign.signInID = opid;
                    detailVC.signInFileds = sign;
                    detailVC.isPush = YES;
                    navi = [[UINavigationController alloc] initWithRootViewController:detailVC];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];
                    break;
                }
                    
                case 4://新任务
                {
                   
                }
                case 7://修改任务
                {
                    
                }
                case 8://关闭任务
                {
                    
                }
                case 9://完成任务
                {
                    YWOtherNotDoneVC *task = [[YWOtherNotDoneVC alloc] init];
                    task.taskID = opid;
                    task.fromPush = YES;
                    navi = [[UINavigationController alloc] initWithRootViewController:task];
                    [self.window.rootViewController presentViewController:navi animated:YES completion:^{
                    }];
                    break;
                }
                
                default:
                    break;
            }
        
        }

        
    }

}




@end
