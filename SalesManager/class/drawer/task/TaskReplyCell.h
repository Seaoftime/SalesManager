//
//  TaskReplyCell.h
//  SalesManager
//
//  Created by tianjing on 14-3-11.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSummaryReplyFileds;

@interface TaskReplyCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *nameLabel;

//@property(nonatomic,strong) IBOutlet UITextView *replyContent;


@property (weak, nonatomic) IBOutlet UILabel *replyContent;


@property (nonatomic, strong) YSummaryReplyFileds *replyFields;

- (void)setFileds:(YSummaryReplyFileds *)fileds;

@end
