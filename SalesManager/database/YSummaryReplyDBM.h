//
//  YSummaryReplyDBM.h
//  业务点点通
//
//  Created by Kris on 13-10-15.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "baseDatabase.h"
#import "YSummaryReplyFileds.h"

@interface YSummaryReplyDBM : baseDatabase
{
}

- (void)saveSummaryReply:(YSummaryReplyFileds *)summaryReply;

- (NSArray *)findSummaryReplyBySummaryID:(NSString *)summaryID;

- (void)cleanDataBase;

-(void)cleanReply:(NSString* )summaryID;    //清楚单条日志批复内容
@end
