//
//  InformationReportDetailViewController.h
//  SalesManager
//
//  Created by Kris on 13-12-3.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSummaryFields;
@class YformFileds;

@interface InformationReportDetailViewController : YWbaseVC

@property(nonatomic, retain) YSummaryFields *summaryListField;//列表的显示数据
@property(nonatomic, strong) YformFileds *summaryFormFiled; //记录栏目名称及id（判断是否有定位，图片，回复)
@property (nonatomic,assign) BOOL isPush;//来自推送
@property (nonatomic,assign) BOOL isHome;//来自首页

@end
