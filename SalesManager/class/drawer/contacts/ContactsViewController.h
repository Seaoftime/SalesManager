//
//  ContactsViewController.h
//  SalesManager
//
//  Created by Kris on 14-2-7.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic,strong) UINavigationController *homeNavi;

@end
