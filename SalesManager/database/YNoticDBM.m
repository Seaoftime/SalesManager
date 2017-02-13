//
//  YNoticDBM.m
//  业务点点通
//
//  Created by Sky on 13-11-07.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "YNoticDBM.h"

@implementation YNoticDBM

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
    }
    return self;
}

- (void)upload:(YNoticFileds* )notic
{
    [self executeSql:[NSString stringWithFormat:@"UPDATE YNoticFileds SET upLoad = %ld,noticID = '%@'  WHERE noticDate = %ld",notic.upLoad, notic.noticID,notic.noticDate]];
    
}

-(void)upLoadNoticContent:(YNoticFileds *)notic{
    
    [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YNoticFileds SET noticContent='%@', noticTitle ='%@',toPersonName='%@',toDepartmentName='%@',noticIsread=%ld WHERE noticID = '%@'",notic.noticContent,notic.noticTitle,notic.toPersonName,notic.toDepartmentName,notic.noticIsread,notic.noticID]];
}

- (NSArray *)findWithNoticeTime:(int)noticeTime limit:(int)limit
{
    __block  NSMutableArray * array = [[NSMutableArray alloc]init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YNoticFileds";
    if (!noticeTime) {
        query = [query stringByAppendingFormat:@" ORDER BY noticDate DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE noticDate = %d",noticeTime];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
    
    NSLog(@"%@",_db.lastError);
    TOOL* getStartWeekDate = [[TOOL alloc]init];
    NSDate* beginNingMonthDate = [getStartWeekDate getStartOfMonth:[NSDate date]];
    NSString* beginningMothTimeString =  [NSString stringWithFormat:@"%ld",(long)[beginNingMonthDate timeIntervalSince1970]];
    NSString* lastMonthTimaeString = [NSString stringWithFormat:@"%li",[beginningMothTimeString integerValue]-1];
    NSDate* lastMonthDate = [NSDate dateWithTimeIntervalSince1970:[lastMonthTimaeString integerValue]];
    lastMonthDate = [getStartWeekDate getStartOfMonth:lastMonthDate];
    lastMonthTimaeString = [NSString stringWithFormat:@"%ld",(long)[lastMonthDate timeIntervalSince1970]];
    
    
    int thisMonth = (int)[beginningMothTimeString integerValue];
    
    int lastMonth = (int)[lastMonthTimaeString integerValue];
    
    
    
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    NSMutableArray * array3 = [[NSMutableArray alloc]init];
	while ([rs next]) {
        YNoticFileds* notic = [YNoticFileds new];
        notic.noticID = [rs stringForColumn:@"noticID"];
        notic.noticDate = [rs intForColumn:@"noticDate"];
        notic.noticIsread = [rs intForColumn:@"noticIsread"];
        notic.noticTitle = [rs stringForColumn:@"noticTitle"];
        notic.upLoad = [rs intForColumn:@"upLoad"];
        
        if (noticeTime) {
            notic.noticContent = [rs stringForColumn:@"noticContent"];
            notic.noticID =[rs stringForColumn:@"noticID"];
            notic.toDepartmentName = [rs stringForColumn:@"toDepartmentName"];
            notic.fromUserID = [rs stringForColumn:@"fromUserID"];
            notic.toPersonName = [rs stringForColumn:@"toPersonName"];
            notic.toDepartmentID = [rs stringForColumn:@"toDepartmentID"];
            notic.toPersonID = [rs stringForColumn:@"toPersonID"];
            notic.fromUserName = [rs stringForColumn:@"fromUserName"];
            
            [array addObject:notic];
            
        }else{
            if (notic.noticDate >= thisMonth) {
                [array1 addObject:notic];
            }else if (notic.noticDate < thisMonth && notic.noticDate >= lastMonth){
                [array2 addObject:notic];
            }else{
                [array3 addObject:notic];
            }
        }
        
	}
	[rs close];
    if (!noticeTime) {
        [array addObject:array1];
        [array addObject:array2];
        [array addObject:array3];
        
    }
    }];
    return array;

}


- (void)upLoadNoticIsread:(YNoticFileds *)notic{
    [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YNoticFileds SET noticIsread='1' WHERE noticID = '%@'",notic.noticID]];
    
}

-(void)cleandataBase{
   [self executeSqlInBackground:@"DELETE FROM YNoticFileds"];
    NSLog(@"清空数据");
}


- (void) saveNotic:(YNoticFileds* ) notic success:(BOOL)success{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString* query;
    if (notic.noticID) {
        query = [NSString stringWithFormat:@"select * from YNoticFileds where noticID = '%@'",notic.noticID];
        
    }else{
        query  = [NSString stringWithFormat:@"select * from YNoticFileds where noticDate = %ld",notic.noticDate];
        
    }
    FMResultSet *rs = [_db executeQuery:query];
    if ([rs next]) {
        [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YNoticFileds SET noticDate=%ld,noticIsread=%ld,noticTitle='%@' WHERE noticID = '%@'",notic.noticDate,notic.noticIsread,notic.noticTitle,notic.noticID]];
    }else {
        
        
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YNoticFileds"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (notic.noticTitle) {
            [keys appendString:@"noticTitle,"];
            [values appendString:@"?,"];
            [arguments addObject:notic.noticTitle];
            
            
        }
        if (notic.noticID) {
            [keys appendString:@"noticID,"];
            [values appendString:@"?,"];
            [arguments addObject:notic.noticID];
        }
        if (notic.noticIsread) {
            [keys appendString:@"noticIsread,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:notic.noticIsread]];
        }
        if (notic.noticDate) {
            [keys appendString:@"noticDate,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:notic.noticDate]];
        }
        if (notic.isMine) {
            [keys appendString:@"isMine,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:notic.isMine]];
        }
        if (notic.fromUserID) {
            [keys appendString:@"fromUserID,"];
            [values appendString:@"?,"];
            [arguments addObject:notic.fromUserID];
        }
        if (notic.fromUserName) {
            [keys appendString:@"fromUserName,"];
            [values appendString:@"?,"];
            [arguments addObject:notic.fromUserName];
        }
                
        
        if (!success) {
//            if (notic.timeStampContent) {
//                [keys appendString:@"timeStampContent,"];
//                [values appendString:@"?,"];
//                [arguments addObject:[NSNumber numberWithInteger:notic.timeStampContent]];
//            }
            
            if (notic.noticContent) {
                [keys appendString:@"noticContent,"];
                [values appendString:@"?,"];
                [arguments addObject:notic.noticContent];
            }
            if (notic.toDepartmentName) {
                [keys appendString:@"toDepartmentName,"];
                [values appendString:@"?,"];
                [arguments addObject:notic.toDepartmentName];
            }
            if (notic.toPersonName) {
                [keys appendString:@"toPersonName,"];
                [values appendString:@"?,"];
                [arguments addObject:notic.toPersonName];
            }
            if (notic.toDepartmentID) {
                [keys appendString:@"toDepartmentID,"];
                [values appendString:@"?,"];
                [arguments addObject:notic.toDepartmentID];
            }
            if (notic.toPersonID) {
                [keys appendString:@"toPersonID,"];
                [values appendString:@"?,"];
                [arguments addObject:notic.toPersonID];
            }
            
            
            
        }
        
        if (notic.upLoad) {
            [keys appendString:@"upLoad,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:notic.upLoad]];
        }
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
        [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
        [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        NSLog(@"插入一条数据");
        
        [_db executeUpdate:query withArgumentsInArray:arguments];
        NSLog(@"%@",_db.lastError) ;
        }
        [rs close];
    }];
    
}


- (NSArray *) findWithNoticID:(NSString *) noticID limit:(int) limit {
    
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YNoticFileds";
    if (!noticID) {
        query = [query stringByAppendingFormat:@" ORDER BY noticDate DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE noticID = %@",noticID];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
    
    NSLog(@"%@",_db.lastError);
    TOOL * getStartWeekDate = [[TOOL alloc] init];
    NSDate* beginNingMonthDate = [getStartWeekDate getStartOfMonth:[NSDate date]];
    NSString* beginningMothTimeString =  [NSString stringWithFormat:@"%ld",(long)[beginNingMonthDate timeIntervalSince1970]];
    NSString* lastMonthTimaeString = [NSString stringWithFormat:@"%i",(int)[beginningMothTimeString integerValue]-1];
    NSDate* lastMonthDate = [NSDate dateWithTimeIntervalSince1970:[lastMonthTimaeString integerValue]];
    lastMonthDate = [getStartWeekDate getStartOfMonth:lastMonthDate];
    lastMonthTimaeString = [NSString stringWithFormat:@"%ld",(long)[lastMonthDate timeIntervalSince1970]];
    
    
    int thisMonth = (int)[beginningMothTimeString integerValue];
    
    int lastMonth = (int)[lastMonthTimaeString integerValue];
    
    
    
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    NSMutableArray * array3 = [[NSMutableArray alloc]init];
	while ([rs next]) {
        YNoticFileds* notic = [YNoticFileds new];
        notic.noticID = [rs stringForColumn:@"noticID"];
        notic.noticDate = [rs intForColumn:@"noticDate"];
        notic.noticIsread = [rs intForColumn:@"noticIsread"];
        notic.noticTitle = [rs stringForColumn:@"noticTitle"];
        notic.upLoad = [rs intForColumn:@"upLoad"];
        notic.isMine = [rs intForColumn:@"isMine"];
        notic.toPersonID = [rs stringForColumn:@"toPersonID"];
        notic.toPersonName = [rs stringForColumn:@"toPersonName"];
        notic.toDepartmentName = [rs stringForColumn:@"toDepartmentName"];
        notic.toDepartmentID = [rs stringForColumn:@"toDepartmentID"];
        notic.fromUserID = [rs stringForColumn:@"fromUserID"];
        notic.fromUserName = [rs stringForColumn:@"fromUserName"];
         notic.noticContent = [rs stringForColumn:@"noticContent"];
//
        
        if (noticID) {
           
            [array addObject:notic];
            
        }else{
            if (notic.noticDate >= thisMonth) {
                [array1 addObject:notic];
            }else if (notic.noticDate < thisMonth && notic.noticDate >= lastMonth){
                [array2 addObject:notic];
            }else{
                [array3 addObject:notic];
            }
        }
        
	}
	[rs close];
    if (!noticID) {
        [array addObject:array1];
        [array addObject:array2];
        [array addObject:array3];
        
    }
    }];
    
    return array;
}


- (void) deleteNoticWithId:(int) noticDate{
    [self executeSqlInBackground:[NSString stringWithFormat:@"DELETE FROM YNoticFileds WHERE noticDate = '%i'",noticDate]];
    NSLog(@"删除一条数据");
}

- (void) deleteNoticWithNoticeId:(NSString*) noticID{
    [self executeSqlInBackground:[NSString stringWithFormat:@"DELETE FROM YNoticFileds WHERE noticID = %@",noticID]];
    NSLog(@"删除一条数据");
}

- (void) deleteNoticeWithTime:(NSInteger) noticeDate{
    [self executeSqlInBackground:[NSString stringWithFormat:@"DELETE FROM YNoticFileds WHERE noticDate = %ld",(long)noticeDate]];
    NSLog(@"删除一条数据");
}

@end
