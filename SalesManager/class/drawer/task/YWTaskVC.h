//
//  YWTaskVC.h
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWOtherNotDoneVC.h"
#import "YWEditAddTaskVC.h"
//#import "PullingRefreshTableView.h"
#import "YTaskDBM.h"
#import "YTaskFieleds.h"
#import "XHIndicatorView.h"

@class YTaskFieleds;

@interface YWTaskVC : YWbaseVC<UITableViewDataSource,UITableViewDelegate,YWDeleteTaskVCDelegate,YWEditAddTaskVCDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    YTaskDBM* taskDB;
    int _dataCount;
    int _toMeDataCount;
    UIActionSheet *modifySheet;
    UIActionSheet *draftSheet;
    YTaskFieleds *willSendTaskData;
    NSIndexPath *willsendindexPath;
    XHIndicatorView * willsendIndicatorView;
    BOOL firstAndNew;
    NSMutableArray* uploadTaskArray;
    UISwitch *switchView;
    UILabel *showLockLabel;
    UISegmentedControl *segmentedControl;
    BOOL firstComeToMe;
}

@property(nonatomic,strong)UINavigationController *homeNavi;
@property(nonatomic,strong)NSMutableArray *taskList;
@property(nonatomic,strong)NSMutableArray *toMeTaskList;
//@property(nonatomic,strong)PullingRefreshTableView *taskTable;
//@property(nonatomic,strong)PullingRefreshTableView *toMeTaskTabel;

@property (nonatomic,strong) UITableView *taskTableView;
@property (nonatomic,strong) UITableView *toMeTaskTableView;

- (void)addCell:(YTaskFieleds *)aField;

@end
