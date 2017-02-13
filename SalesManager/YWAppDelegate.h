//
//  YWAppDelegate.h
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "YWLocationDBM.h"

@interface YWAppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability  *hostReach;
}
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL inBackground;

@end
