//
//  InformationReportSearchResuleViewController.h
//  SalesManager
//
//  Created by Kris on 14-1-7.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "YWbaseVC.h"

@class YformFileds;
@class YManagerUserInfoFileds;

@interface InformationReportSearchResuleViewController : YWbaseVC

@property (nonatomic,strong) YformFileds *formFiled;//记录栏目名称及id
@property (nonatomic,strong) YManagerUserInfoFileds *userFiled;

@end
