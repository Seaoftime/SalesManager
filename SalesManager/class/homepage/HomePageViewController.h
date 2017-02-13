//
//  HomePageViewController.h
//  SalesManager
//
//  Created by Kris on 13-12-9.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateView.h"

@interface HomePageViewController : YWBaseTableVC{
    NSTimer* checkNew;
    NSMutableArray* afNetConnectArray;
    UpdateView *updateView;
    NSString *mostVersion;
    BOOL getBoth;
    int formTime;
    int personTime;
    UIImageView *gifImage;
    UIView *GestureView;
    
    NSString* getPersonTime;
}

@end
