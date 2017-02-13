//
//  YWLeftMenuViewController.h
//  TJtest
//
//  Created by tianjing on 13-11-26.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "YWLibrayVC.h"
#import "YWNoticeViewController.h"
#import "YWPersonalVC.h"
#import "InformationReportViewController.h"
#import "YWSettingVC.h"
#import "SignInViewController.h"
#import "YWTaskVC.h"
#import "ContactsViewController.h"

@interface YWLeftMenuViewController :UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView *navigationTb;
    UINavigationController *_navSlideSwitchVC;                //滑动切换视图
    UINavigationController *_navCommonComponentVC;              //通用控件
    HomePageViewController *slideSwitchVC;
}

@property (nonatomic, strong) UINavigationController *navSlideSwitchVC;
@property (nonatomic, strong) UINavigationController *navCommonComponentVC;
@property (nonatomic, strong) YWLibrayVC *librayVC;
@property (nonatomic, strong) UINavigationController *NVlibrayVC;
@property (nonatomic, strong) YWNoticeViewController *noticeVC;
@property (nonatomic, strong) UINavigationController *NVnoticeVC;
@property (nonatomic, strong) YWPersonalVC *personalVC;
@property (nonatomic, strong) UINavigationController *NVpersonalVC;
@property (nonatomic, strong) InformationReportViewController *reportsVC;
@property (nonatomic, strong) UINavigationController *NVreportsVC;
@property (nonatomic, strong) YWSettingVC *settingVC;
@property (nonatomic, strong) UINavigationController *NVsettingVC;
@property (nonatomic, strong) SignInViewController *signInVC;
@property (nonatomic, strong) UINavigationController *NVsignInVC;
@property (nonatomic, strong) YWTaskVC *taskVC;
@property (nonatomic, strong) UINavigationController *NVtaskVC;
@property (nonatomic, strong) SignInViewController *quickSignInVC;
@property (nonatomic, strong) UINavigationController *NVquickSignInVC;
@property (nonatomic, strong) ContactsViewController *contactsVC;
@property (nonatomic, strong) UINavigationController *NVcontactsVC;

@property (nonatomic,assign) BOOL isShowSelect;

- (void)selectOneItem:(NSString *)formId task:(BOOL)isTask notice:(BOOL)isNotice;

@end
