//
//  YWNoticeByIdVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNoticDBM.h"


@interface YWNoticeByIdVC : YWbaseVC
{
    YNoticDBM* noticDB;
    YNoticFileds* noticFileds;
}
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *nameLabel;
@property(nonatomic,strong)IBOutlet UILabel *tiemLabel;
@property(nonatomic,strong)IBOutlet UILabel *forWhoLabel;
@property(nonatomic,strong)IBOutlet UITextView *contentText;
@property(nonatomic,strong)IBOutlet UIImageView *bgView;
@property(nonatomic,strong)IBOutlet UIScrollView *totalBgView;
@property(nonatomic,strong)NSDictionary *noticeByIdData;
@property(nonatomic,strong)NSString *noticeid;
@property(nonatomic,assign)NSInteger noticPostTime;
@property(nonatomic,assign)BOOL fromPush;
@property(nonatomic,assign)BOOL fromHomepage;



//
//
@property (nonatomic, strong) NSMutableArray * remoteWordsArray;
@property (nonatomic, strong) NSMutableArray * locationWordsArray;

@property (nonatomic, strong) NSMutableDictionary * wordDownloadManager;//下载管理器






@end
