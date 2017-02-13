//
//  YWLibrayVC.h
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#import "CEPlayer.h"
#import "NavigationView.h"
#import "DownLoadProgressView.h"
//#import "PullingRefreshTableView.h"
#import "YPicturesDBM.h"
@interface YWLibrayVC : YWbaseVC<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    //PullingRefreshTableView *albumTable;
    
    UITableView *_albumTableView;
    
    int finishedPicNum;
    int failedPicNum;
   // CERoundProgressView *progressView;
    NavigationView *naviView;
    DownLoadProgressView *downloadView;
    YPicturesDBM* pictureDB;
    int _dataCount;
    
}
@property(nonatomic,strong)UINavigationController *homeNavi;
@property(nonatomic,strong)NSMutableArray *albumList;
@property(nonatomic,assign)BOOL fromPush;
@property(nonatomic,assign)BOOL fromHomepage;
@end
