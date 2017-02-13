//
//  UITableViewController+MMDrawerController.h
//  SalesManager
//
//  Created by Kris on 13-12-3.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface UITableViewController (MMDrawerController)

@property(nonatomic, strong, readonly) MMDrawerController *mm_drawerController;

@end
