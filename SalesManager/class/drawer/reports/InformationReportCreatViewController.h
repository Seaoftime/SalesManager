//
//  InformationReportCreatViewController.h
//  SalesManager
//
//  Created by Kris on 13-12-3.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class ReportCheckBoxCell;
@class ReportAddressBoxCell;

@interface InformationReportCreatViewController : UITableViewController

@property (nonatomic,strong) YformFileds *formFiled;
@property (nonatomic, strong) NSMutableArray *selectPersonArray;
@property (nonatomic,strong) NSMutableArray *selectPictureArray;
@property (strong, nonatomic) NSMutableDictionary *creatDic;//存储汇报内容
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) int editPosttime;

- (void)reportCheckBoxCell:(ReportCheckBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;
- (void)reportAddressBoxCell:(ReportAddressBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end
