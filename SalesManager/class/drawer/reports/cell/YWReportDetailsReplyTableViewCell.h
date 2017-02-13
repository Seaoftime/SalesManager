//
//  YWReportDetailsReplyTableViewCell.h
//  SalesManager
//
//  Created by TonySheng on 16/4/12.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSummaryReplyFileds;

@interface YWReportDetailsReplyTableViewCell : UITableViewCell


@property (nonatomic, strong) YSummaryReplyFileds *replyFields;

- (void)setReplyFields:(YSummaryReplyFileds *)replyFields;


@end
