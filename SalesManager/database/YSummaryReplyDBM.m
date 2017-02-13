//
//  YSummaryReplyDBM.m
//  业务点点通
//
//  Created by Kris on 13-10-15.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "YSummaryReplyDBM.h"

@implementation YSummaryReplyDBM

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}



-(void)cleanReply:(NSString* )summaryID
{
    
    NSString * query = [NSString stringWithFormat:@"DELETE FROM YSummaryReplyFileds WHERE summaryID = '%@'",summaryID];
    [self executeSqlInBackground:query];
}

- (void)saveSummaryReply:(YSummaryReplyFileds *)summaryReply
{
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO YSummaryReplyFileds(summaryID, replyDate, isSelf, replyContent ,replyPerson) VALUES ( '%@', '%i', '%i', '%@', '%@')", summaryReply.summaryID, summaryReply.replyDate, summaryReply.isSelf, summaryReply.replyContent, summaryReply.replyPerson];
        [self executeSqlInBackground:sql];
}

- (NSArray *)findSummaryReplyBySummaryID:(NSString *)summaryID
{
    __block     NSMutableArray * array = [[NSMutableArray alloc] init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString *sql = [NSString stringWithFormat:@"select * from YSummaryReplyFileds where summaryID = '%@' ORDER BY replyDate ASC", summaryID];
    FMResultSet * rs = [_db executeQuery:sql];
    while ([rs next])
    {
        YSummaryReplyFileds *summaryRepley = [[YSummaryReplyFileds alloc] init];
        summaryRepley.replyDate = [rs intForColumn:@"replyDate"];
        summaryRepley.isSelf = [rs intForColumn:@"isSelf"];
        summaryRepley.replyContent = [rs stringForColumn:@"replyContent"];
        summaryRepley.replyPerson = [rs stringForColumn:@"replyPerson"];
        [array addObject:summaryRepley];
	}
	[rs close];
    }];
    
    return array;
}

-(void)cleanDataBase
{
    [self executeSqlInBackground:@"DELETE FROM YSummaryReplyFileds"];
    NSLog(@"清空数据");
}

@end
