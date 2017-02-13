//
//  YSummaryDBM.m
//  业务点点通
//
//  Created by s k y on 12-12-23.
//  Copyright (c) 2012年 Sky. All rights reserved.
//

#import "YSummaryDBM.h"
#import "TOOL.h"


@implementation YSummaryDBM

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) saveSummaryList:(YSummaryFields *) summary{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString* query;
    if (summary.summaryId) {
        query = [NSString stringWithFormat:@"select * from YSummaryListFields where summaryId = '%@'",summary.summaryId];
    }else{
        query = [NSString stringWithFormat:@"select * from YSummaryListFields where postTime = %d",summary.postTime];
    }
    FMResultSet *rs = [_db executeQuery:query];
    if ([rs next]) {
        NSMutableString * query = [NSMutableString stringWithFormat:@"UPDATE YSummaryListFields SET "];
        
        if (summary.summaryTitle) {
            [query appendString:[NSString stringWithFormat:@"summaryTitle = '%@',",summary.summaryTitle]];
        }
        
        if (summary.isread) {
            [query appendString:[NSString stringWithFormat:@"isread = %i,",summary.isread]];
        }
        if (summary.isreply) {
            [query appendString:[NSString stringWithFormat:@"isreply = %i,",summary.isreply]];
        }
        
        
        if (summary.sectionID) {
            [query appendString:[NSString stringWithFormat:@"sectionID = %i,",summary.sectionID]];
        }
        
        if (summary.reciver) {
             [query appendString:[NSString stringWithFormat:@"reciver = '%@',",summary.reciver]];
        }
        if (summary.reciverID) {
            [query appendString:[NSString stringWithFormat:@"reciverID = '%@',",summary.reciverID]];
        }

        if (summary.replyNum) {
            [query appendString:[NSString stringWithFormat:@"replyNum = %d,",summary.replyNum]];
        }
        
        if (summary.senderName) {
            [query appendString:[NSString stringWithFormat:@"senderName = '%@',",summary.senderName]];
        }
        if (summary.senderUserID) {
            [query appendString:[NSString stringWithFormat:@"senderUserID = '%@',",summary.senderUserID]];
        }
        
        if (summary.timeStampContent) {
            [query appendString:[NSString stringWithFormat:@"timeStampContent = %d,",summary.timeStampContent]];
            
        }
        if (summary.timeStampList) {
            [query appendString:[NSString stringWithFormat:@"timeStampList = %d,",summary.timeStampList]];
            
        }
        if (summary.summaryPreview) {
            [query appendString:[NSString stringWithFormat:@"summaryPreview = '%@',",summary.summaryPreview]];
        }
        if (summary.myLocation) {
              [query appendString:[NSString stringWithFormat:@"myLocation = '%@',",summary.myLocation]];
        }
        if (summary.upload) {
            [query appendString:[NSString stringWithFormat:@"upload = %i",summary.upload]];
            
        }
        
        if (summary.summaryId) {
            
            [query appendString:[NSString stringWithFormat:@" WHERE summaryId = '%@'",summary.summaryId]];
        }else{
            [query appendString:[NSString stringWithFormat:@" WHERE postTime = %i",summary.postTime]];
        }
        NSLog(@"更新一条数据");
        
        [_db executeUpdate:query];
    }else {
        
        
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YSummaryListFields"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (summary.postTime) {
            [keys appendString:@"postTime,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.postTime]];
        }
        if (summary.summaryTitle) {
            [keys appendString:@"summaryTitle,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.summaryTitle];
        }
        
        if (summary.summaryId) {
            [keys appendString:@"summaryId,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.summaryId];
        }
    
        if (summary.isread) {
            [keys appendString:@"isread,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.isread]];
        }
        if (summary.isreply) {
            [keys appendString:@"isreply,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.isreply]];
        }
        
        if (summary.sectionID) {
            [keys appendString:@"sectionID,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.sectionID]];
        }
        
        if (summary.timeStampList) {
            [keys appendString:@"timeStampList,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.timeStampList]];
        }
        
        if (summary.timeStampContent) {
            [keys appendString:@"timeStampContent,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.timeStampContent]];
        }
        if (summary.isMine) {
            [keys appendString:@"isMine,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.isMine]];
        }
        
        if (summary.replyNum) {
            [keys appendString:@"replyNum,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.replyNum]];
        }
        if (summary.upload) {
            [keys appendString:@"upload,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.upload]];
        }
        
        if (summary.reciver) {
            [keys appendString:@"reciver,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.reciver];
        }
        if (summary.reciverID) {
            [keys appendString:@"reciverID,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.reciverID];
        }
        
        if (summary.senderUserID) {
            [keys appendString:@"senderUserID,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.senderUserID];
        }
        if (summary.senderName) {
            [keys appendString:@"senderName,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.senderName];
        }
        if (summary.longitude) {
            [keys appendString:@"longitude,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.longitude];
        }
        if (summary.latitude) {
            [keys appendString:@"latitude,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.latitude];
        }
        if (summary.myLocation) {
            [keys appendString:@"myLocation,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.myLocation];
        }
        

        if (summary.summaryPreview) {
            [keys appendString:@"summaryPreview,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.summaryPreview];
        }
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        NSLog(@"插入一条数据");
        [_db executeUpdate:query withArgumentsInArray:arguments];
    }
        if (_db.lastError) NSLog(@"%@",[_db lastError]);

        [rs close];
    }];
}


- (void) saveSummaryContent:(YSummaryFields *) summary{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"select * from YSummaryContentFields where postTime = %ld and formName = '%@'",summary.postTime,summary.formName]];
    if ([rs next]) {
        NSMutableString * query = [NSMutableString stringWithFormat:@"UPDATE YSummaryContentFields SET "];
        
        
        if (summary.formName) {
            [query appendString:[NSString stringWithFormat:@"formName = '%@',",summary.formName]];
        }
        
        if (summary.formValue) {
            [query appendString:[NSString stringWithFormat:@"formValue = '%@'",summary.formValue]];
        }
        [query appendString:[NSString stringWithFormat:@" WHERE postTime = '%i' and formName = '%@'",summary.postTime,summary.formName]];
        
        NSLog(@"插入一条数据");
        
        [_db executeUpdate:query];
    }else {
        
        
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YSummaryContentFields"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (summary.postTime) {
            [keys appendString:@"postTime,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.postTime]];
        }
        
        if (summary.sectionID) {
            [keys appendString:@"sectionID,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:summary.sectionID]];
        }
        
        if (summary.formValue) {
            [keys appendString:@"formValue,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.formValue];
        }
        if (summary.formName) {
            [keys appendString:@"formName,"];
            [values appendString:@"?,"];
            [arguments addObject:summary.formName];
        }
        
        
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        NSLog(@"插入一条数据");
        [_db executeUpdate:query withArgumentsInArray:arguments];
    }
        if (_db.lastError) NSLog(@"%@",[_db lastError]);
        [rs close];
    }];
}



- (void)upDataSummaryID:(int)summaryID withPostTime:(int)postTime{
    
    [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YSummaryListFields SET summaryID = '%i' WHERE postTime = '%i'",summaryID,postTime]];
    [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YSummaryContentFields SET summaryID = '%i' WHERE postTime = '%i'",summaryID,postTime]];
    
}


- (void) deleteSummaryWithpostTime:(NSInteger ) postTime{
    NSString * queryList = [NSString stringWithFormat:@"DELETE FROM YSummaryListFields WHERE postTime = %d",postTime];
    NSString * queryContent = [NSString stringWithFormat:@"DELETE FROM YSummaryContentFields WHERE postTime = %d",postTime];
    
    NSLog(@"删除一条数据");
    [self executeSqlInBackground:queryList];
    [self executeSqlInBackground:queryContent];
}



- (NSArray *) findWithsummaryID:(NSString *)summaryID BySummaryDate:(NSInteger )summaryDate inSectionID:(NSInteger )sectionId limit:(int) limit byUserID:(NSInteger )userID{
    __block NSMutableArray * array = [[NSMutableArray alloc]init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YSummaryListFields";
    if (summaryDate) {
        if (summaryID) {
            query = [query stringByAppendingFormat:@" WHERE summaryId = %@",summaryID];
        }else{
            query = [query stringByAppendingFormat:@" WHERE postTime = %d",summaryDate];
        }
    }else if(userID) {
        query = [query stringByAppendingFormat:@" WHERE sectionID = %d and senderUserID = %d ORDER BY postTime DESC limit %d",sectionId,userID,limit];
    }else{
        query = [query stringByAppendingFormat:@" WHERE sectionID = %d ORDER BY postTime DESC limit %d",sectionId,limit];
        
        
    }
        
    FMResultSet * rs = [_db executeQuery:query];
    TOOL* getStartWeekDate = [[TOOL alloc]init];
    NSDate* beginNingMonthDate = [getStartWeekDate getStartOfMonth:[NSDate date]];
    NSString* beginningMothTimeString =  [NSString stringWithFormat:@"%ld",(long)[beginNingMonthDate timeIntervalSince1970]];
    NSString* lastMonthTimaeString = [NSString stringWithFormat:@"%i",[beginningMothTimeString integerValue]-1];
    NSDate* lastMonthDate = [NSDate dateWithTimeIntervalSince1970:[lastMonthTimaeString integerValue]];
    lastMonthDate = [getStartWeekDate getStartOfMonth:lastMonthDate];
    lastMonthTimaeString = [NSString stringWithFormat:@"%ld",(long)[lastMonthDate timeIntervalSince1970]];
    
    
    int thisMonth = [beginningMothTimeString integerValue];
    
    int lastMonth = [lastMonthTimaeString integerValue];

    
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    NSMutableArray * array3 = [[NSMutableArray alloc]init];
	while ([rs next]) {
        YSummaryFields* summary = [YSummaryFields new];
//        summary.autoIncremenID = [rs intForColumn:@"autoIncremenID"];
        summary.summaryId = [rs stringForColumn:@"summaryId"];
        summary.postTime = [rs intForColumn:@"postTime"];
//        summary.summaryDate = [rs intForColumn:@"summaryDate"];
        summary.isread = [rs intForColumn:@"isread"];
        summary.isreply = [rs intForColumn:@"isreply"];
        summary.upload = [rs intForColumn:@"upload"];
        summary.isMine = [rs intForColumn:@"isMine"];
        summary.summaryTitle = [rs stringForColumn:@"summaryTitle"];
        summary.timeStampList = [rs intForColumn:@"timeStampList"];
        summary.timeStampContent = [rs intForColumn:@"timeStampContent"];
        summary.senderUserID = [rs stringForColumn:@"senderUserID"];
        summary.senderName = [rs stringForColumn:@"senderName"];
        summary.sectionID = [rs intForColumn:@"sectionID"];
        summary.reciver = [rs stringForColumn:@"reciver"];
        summary.reciverID = [rs stringForColumn:@"reciverID"];
        summary.senderUserID = [rs stringForColumn:@"senderUserID"];
        summary.longitude = [rs stringForColumn:@"longitude"];
        summary.latitude = [rs stringForColumn:@"latitude"];
        summary.summaryPreview = [rs stringForColumn:@"summaryPreview"];
        summary.replyNum = [rs intForColumn:@"replyNum"];
        summary.myLocation = [rs stringForColumn:@"myLocation"];
        if (!summaryDate) {
            if (summary.postTime >= thisMonth) {
                [array1 addObject:summary];
            }else if (summary.postTime < thisMonth && summary.postTime >= lastMonth){
                [array2 addObject:summary];
            }else{
                [array3 addObject:summary];
            }
            
        }else{
            
            [array addObject:summary];
            
        }
	}
    if (!summaryDate) {
        [array addObject:array1];
        [array addObject:array2];
        [array addObject:array3];
    }
    
	[rs close];
    if (_db.lastError) NSLog(@"%@",[_db lastError]);

    NSLog(@"%i%i%i%i",array.count,array1.count,array2.count,array3.count);
    }];
    return array;
}


- (NSDictionary *) findWithsummaryPostTime:(NSInteger) postTime{
    
    
    __block NSMutableDictionary * summaryDic = [[NSMutableDictionary alloc]init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YSummaryContentFields";
//     ORDER BY autoIncremenID DESC
    query = [query stringByAppendingFormat:@" WHERE postTime = %i",postTime];
    
    FMResultSet * rs = [_db executeQuery:query];
    
    
    
	while ([rs next]) {

        NSString *string ;
        if (![rs stringForColumn:@"formValue"]) {
            string = @"";
        }else{
            string = [rs stringForColumn:@"formValue"];
        }
        
        if ([rs stringForColumn:@"formName"]) {
            [summaryDic setValue:string forKey:[rs stringForColumn:@"formName"]];
        }

        
    }
	[rs close];
    }];
    
    return summaryDic;
}

-(NSArray* )findPhotoUrlWithPostTime:(NSInteger )postTime{
    __block    NSMutableArray* photUrls = [[NSMutableArray alloc]init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YSummaryContentFields";
    //     ORDER BY autoIncremenID DESC
    query = [query stringByAppendingFormat:@" WHERE postTime = %i and photoUrl is not null",postTime];
    FMResultSet * rs = [_db executeQuery:query];
    
    
	while ([rs next]) {

        [photUrls addObject:[rs stringForColumn:@"photoUrl"]];
        
    }
	[rs close];
    if (_db.lastError) NSLog(@"%@",[_db lastError]);

    }];
    
    return photUrls;

}

-(void)savePhotoUrl:(NSString* )photoUrl byPostTime:(NSInteger )postTime{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"select * from YSummaryContentFields where postTime = %ld and photoUrl = '%@'",(long)postTime,photoUrl]];
    if (![rs next]) {
         [_db executeUpdate:[NSString stringWithFormat:@"INSERT INTO YSummaryContentFields(postTime, photoUrl) VALUES (%ld,'%@')",(long)postTime,photoUrl]];
        if (_db.lastError) NSLog(@"%@",[_db lastError]);
    }
    [rs close];
    }];

    
}

-(void)cleandataBase{
    NSString * queryList = [NSString stringWithFormat:@"DELETE FROM YSummaryListFields"];
    NSString * queryContent = [NSString stringWithFormat:@"DELETE FROM YSummaryContentFields"];
    NSLog(@"清空信息汇报数据");
    [self executeSqlInBackground:queryList];
    [self executeSqlInBackground:queryContent];
}

- (void)upload:(YSummaryFields* )summary
{
    
    [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YSummaryListFields SET upload=%d,summaryId = '%@',timeStampList=%d, timeStampContent=%d WHERE postTime = %d",summary.upload, summary.summaryId, summary.timeStampList,summary.timeStampContent,summary.postTime]];
}

@end
