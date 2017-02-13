//
//  UITableViewController+MMDrawerController.m
//  SalesManager
//
//  Created by Kris on 13-12-3.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "UITableViewController+MMDrawerController.h"

@implementation UITableViewController (MMDrawerController)

-(MMDrawerController*)mm_drawerController
{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil)
    {
        if([parentViewController isKindOfClass:[MMDrawerController class]])
        {
            return (MMDrawerController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

@end
