//
//  YWNoticeViewController.h
//  TJtest
//
//  Created by tianjing on 13-11-26.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWNewNoticeViewController.h"
//#import "PullingRefreshTableView.h"
#import "YNoticDBM.h"
#import "XHIndicatorView.h"

@class YNoticFileds;


@interface YWNoticeViewController : YWbaseVC<UITableViewDataSource,UITableViewDelegate,YWAddNoticeVCDelegate,UIScrollViewDelegate,UIActionSheetDelegate>

{
 // UITableView *noticeTable;

    int _dataCount;
    YNoticDBM* noticDB;
    NSMutableArray* upLoadNoticArray;
    BOOL firstAndAdd;//第一次进入界面和从增加通知列表返回来，不进行刷新列表
    BOOL resendafterfail;//
     UIActionSheet *modifySheet;
    UIActionSheet *draftSheet;
    YNoticFileds *willSendNoticeData;
    NSIndexPath *willsendindexPath;
    XHIndicatorView * willsendIndicatorView;
}
@property(nonatomic,strong)UINavigationController *homeNavi;
@property(nonatomic,strong)NSMutableArray *noticeList;
//@property(nonatomic,strong)PullingRefreshTableView *noticeTable;

@property(nonatomic,strong) UITableView *noticeTableView;




 //-(void)getNoticeData;
- (void)addCell:(YNoticFileds *)aField;

@end
