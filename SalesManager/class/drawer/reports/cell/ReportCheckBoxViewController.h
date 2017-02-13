//
//  ReportCheckBoxViewController.h
//  SalesManager
//
//  Created by Kris on 13-12-16.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class ReportCheckBoxCell;
@class InformationReportCreatViewController;

@interface ReportCheckBoxViewController : UITableViewController

@property (strong, nonatomic) YformFileds *formFiled;
@property (strong, nonatomic) ReportCheckBoxCell *reportCheckBoxCell;

@property (strong, nonatomic) InformationReportCreatViewController *informationReportCreatVC;

@end
