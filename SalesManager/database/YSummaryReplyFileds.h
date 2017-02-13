//
//  YSummaryReplyFileds.h
//  业务点点通
//
//  Created by Kris on 13-10-15.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSummaryReplyFileds : NSObject

//@property (nonatomic, copy) NSString* autoIncremenID;   //存储在本地数据库自增的ID （做本地处理）
@property (nonatomic, copy) NSString* summaryID;        //日志ID
@property (nonatomic, assign) NSInteger replyDate;              //回复日期
@property (nonatomic, assign) NSInteger isSelf;           //是否是自己发的消息  1:自己  0:系统
@property (nonatomic, copy) NSString *replyContent;     //回复内容
@property (nonatomic, copy) NSString *replyPerson;      //回复人

@end
