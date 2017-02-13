//
//  YTaskDBM.m
//  业务点点通
//
//  Created by Sky on 13-1-12.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "YTaskDBM.h"
#import "TOOL.h"



@implementation YTaskDBM


- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
    }
    return self;
}



/**
 * @brief 保存一条用户记录
 *
 * @param task 需要保存的任务数据对象
 */
- (void) saveTask:(YTaskFieleds *)task{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString* query;
    if (task.taskID) {
        query = [NSString stringWithFormat:@"select * from YTaskFieleds where taskID = '%@'",task.taskID];

    }else{
        query  = [NSString stringWithFormat:@"select * from YTaskFieleds where taskTime = %d",task.taskTime];

    }
    
    FMResultSet *rs = [_db executeQuery:query];
    if ([rs next]) {
        [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YTaskFieleds SET taskTitle='%@',taskTime=%d,timeStampList=%d,taskWhetherFinished=%d,taskEndTime = %d, taskLocked = %d,isRead = %d ,toPersonID='%@',toPersonName='%@' WHERE taskID = '%@'",task.taskTitle,task.taskTime,task.timeStampList,task.taskWhetherFinished,task.taskEndTime,task.taskLocked,task.isRead,task.toPersonID,task.toPersonName,task.taskID]];
        
    }else {
        
        
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YTaskFieleds"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (task.taskID) {
            [keys appendString:@"taskID,"];
            [values appendString:@"?,"];
            [arguments addObject:task.taskID];
        }
        if (task.taskTime) {
            [keys appendString:@"taskTime,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.taskTime]];
        }
        if (task.toPersonID) {
            [keys appendString:@"toPersonID,"];
            [values appendString:@"?,"];
            [arguments addObject:task.toPersonID];
        }
        if (task.toPersonName) {
            [keys appendString:@"toPersonName,"];
            [values appendString:@"?,"];
            [arguments addObject:task.toPersonName];
        }
        if (task.isRead) {
            [keys appendString:@"isRead,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.isRead]];
        }
        if (task.taskWhetherFinished) {
            [keys appendString:@"taskWhetherFinished,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.taskWhetherFinished]];
        }
        if (task.taskEndTime) {
            [keys appendFormat:@"taskEndTime,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.taskEndTime]];
        }if (task.taskTitle) {
            [keys appendFormat:@"taskTitle,"];
            [values appendString:@"?,"];
            [arguments addObject:task.taskTitle];
        }if (task.taskLocked) {
            [keys appendFormat:@"taskLocked,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.taskLocked]];
        }if (task.taskFromPersonName) {
            [keys appendFormat:@"taskFromPersonName,"];
            [values appendString:@"?,"];
            [arguments addObject:task.taskFromPersonName];
        }if (task.taskFromPersonID) {
            [keys appendFormat:@"taskFromPersonID,"];
            [values appendString:@"?,"];
            [arguments addObject:task.taskFromPersonID];
        }if (task.taskTo) {
            [keys appendFormat:@"taskTo,"];
            [values appendString:@"?,"];
            [arguments addObject:task.taskTo];
        }if (task.isMine) {
            [keys appendFormat:@"isMine,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.isMine]];
        }
        if (task.upLoad) {
            [keys appendFormat:@"upLoad,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.upLoad]];
        }
        if (task.taskContent) {
            [keys appendFormat:@"taskContent,"];
            [values appendString:@"?,"];
            [arguments addObject:task.taskContent];
        }
        if (task.timeStampList) {
            [keys appendFormat:@"timeStampList,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:task.timeStampList]];
        }
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        NSLog(@"插入一条数据");
        [_db executeUpdate:query withArgumentsInArray:arguments];
        //    }
    }
        if (_db.lastError) NSLog(@"%@",[_db lastError]);
        [rs close];
    }];
    
}

-(void)uploadTaskContent:(YTaskFieleds *)task{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSMutableString * query = [NSMutableString stringWithFormat:@"UPDATE YTaskFieleds SET "];
    
    
    if (task.upLoad) {
        [query appendString:[NSString stringWithFormat:@"upLoad = %d",task.upLoad]];
    }
    
    if (task.taskContent) {
//        [query appendString:[NSString stringWithFormat:@",taskContent = '%@'",task.taskContent]];
        [query appendFormat:@",taskContent = '%@'",task.taskContent];
        
    }
    if (task.taskTo) {
        //        [query appendString:[NSString stringWithFormat:@",taskContent = '%@'",task.taskContent]];
        [query appendFormat:@",taskTo = '%@'",task.taskTo];
        
    }
    
    if (task.toPersonID) {
        [query appendString:[NSString stringWithFormat:@",toPersonID =  '%@'",task.toPersonID]];
        
    }
    if (task.toPersonName) {
        [query appendString:[NSString stringWithFormat:@",toPersonName = '%@'",task.toPersonName]];
        
    }
    if (task.taskEndTime) {
        [query appendString:[NSString stringWithFormat:@",taskEndTime = %i",task.taskEndTime]];
        
    }
 
    if (task.timeStampContent) {
        [query appendString:[NSString stringWithFormat:@",timeStampContent = %i",task.timeStampContent]];
        
    }
    if (task.timeStampList) {
        [query appendString:[NSString stringWithFormat:@",timeStampList = %i",task.timeStampList]];
        
    }
  
    if (task.taskTitle) {
        [query appendString:[NSString stringWithFormat:@",taskTitle = '%@'",task.taskTitle]];
        
    }
    if (task.isMine) {
        [query appendString:[NSString stringWithFormat:@",isMine = %d",task.isMine]];
        
    }
    if (task.taskWhetherFinished) {
        [query appendString:[NSString stringWithFormat:@",taskWhetherFinished = %d",task.taskWhetherFinished]];
        
    }

    if (task.isRead) {
        [query appendString:[NSString stringWithFormat:@",isRead = %d",task.isRead]];
        
    }
    if (task.taskLocked) {
        [query appendString:[NSString stringWithFormat:@",taskLocked = %d",task.taskLocked]];
        
    }
    if (task.taskFinishedTime) {
        [query appendString:[NSString stringWithFormat:@",taskFinishedTime = %d",task.taskFinishedTime]];
        
    }
    if (task.taskFinishedContent) {
        [query appendString:[NSString stringWithFormat:@",taskFinishedContent = '%@'",task.taskFinishedContent]];
        
    }
    if (task.taskFromPersonID) {
        [query appendString:[NSString stringWithFormat:@",taskFromPersonID = '%@'",task.taskFromPersonID]];
        
    }
    
    if (task.taskFromPersonName) {
        [query appendString:[NSString stringWithFormat:@",taskFromPersonName = '%@'",task.taskFromPersonName]];
        
    }

    if (task.taskID) {
          [query appendString:[NSString stringWithFormat:@",taskTime = %zi",task.taskTime]];
            [query appendString:[NSString stringWithFormat:@" WHERE taskID = '%@'",task.taskID]];
    }else{
        [query appendString:[NSString stringWithFormat:@" WHERE autoIncremenID = %i",task.autoIncremenID]];
    }

   
    
    
    NSLog(@"更新一条数据");
    
    [_db executeUpdate:query];
    
        if (_db.lastError) NSLog(@"%@",[_db lastError]);
    }];
}



-(void)uploadTaskRemark:(YTaskFieleds* )task{
    NSString* sql = [NSString stringWithFormat:@"UPDATE YTaskFieleds SET taskWhetherFinished = %ld, taskFinishedContent = '%@',taskFinishedTime = %d WHERE taskID = '%@'",task.taskWhetherFinished,task.taskFinishedContent,task.taskFinishedTime,task.taskID];
    [self executeSqlInBackground:sql];
    
}


-(void)uploadTaskIsRead:(YTaskFieleds* )task{
    NSString* sql = [NSString stringWithFormat:@"UPDATE YTaskFieleds SET isRead = 1 WHERE taskID = '%@'",task.taskID];
    [self executeSqlInBackground:sql];
}


//-(void)uploadTaskFinished:(YTaskFieleds* )task{
//    NSString* sql = [NSString stringWithFormat:@"UPDATE YTaskFieleds SET taskWhetherFinished = 1,taskFinishedContent = '%@',taskFinishedTime = %d WHERE taskID = '%@'",task.taskID];
//    [_db executeUpdate:sql];
//}


- (void) deleteTaskWithId:(NSString *)taskID{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM YTaskFieleds WHERE taskID = '%@'",taskID];
    NSLog(@"删除一条数据");
    [self executeSql:query];
    //    NSLog(@"%@",_db.lastError);
}
- (void) deleteTaskWithTime:(NSInteger) taskTime{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM YTaskFieleds WHERE taskTime = %ld",(long)taskTime];
    NSLog(@"删除一条数据");
    [self executeSql:query];
}


-(void)cleandataBase{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM YTaskFieleds"];
    NSLog(@"清空数据");
    [self executeSql:query];
}

- (NSArray *)findautoIncremenID:(NSInteger )autoIncremenID limit:(int)limit isMine:(NSInteger)ismine
{
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YTaskFieleds";
    //    uid,name,description,coordinate,bargain,worker,volumeOfBusiness,visitSummary,SignInName,data,checkAndApprove,summaryData,signInData,upload,SummaryId
    if (autoIncremenID) {
        
        query = [query stringByAppendingFormat:@" WHERE autoIncremenID= %d",autoIncremenID];
    }else{
        NSLog(@"%i  %i",limit,ismine);
        if (ismine) {
            query = [query stringByAppendingFormat:@" WHERE isMine= %d ORDER BY taskTime DESC limit %d",ismine,limit];
        }else{
            query = [query stringByAppendingFormat:@" WHERE isMine is null ORDER BY taskTime DESC limit %d",limit];
        }
    }


    NSString *showLocked;
    showLocked = [userDefaults objectForKey:@"showTaskLocked"];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
   // NSMutableArray * array3 = [[NSMutableArray alloc]init];
	while ([rs next]) {
        YTaskFieleds* task = [YTaskFieleds new];
        task.autoIncremenID = [rs intForColumn:@"autoIncremenID"];
        task.isRead = [rs intForColumn:@"isRead"];
        task.taskID = [rs stringForColumn:@"taskID"];
        task.taskTitle = [rs stringForColumn:@"taskTitle"];
        task.taskWhetherFinished = [rs intForColumn:@"taskWhetherFinished"];
        task.taskTo  = [rs stringForColumn:@"taskTo"];
        task.isMine = [rs intForColumn:@"isMine"];
        task.taskTime = [rs intForColumn:@"taskTime"];
        task.taskLocked = [rs intForColumn:@"taskLocked"];
        task.taskEndTime = [rs intForColumn:@"taskEndTime"];
        task.toPersonID = [rs stringForColumn:@"toPersonID"];
        task.toPersonName = [rs stringForColumn:@"toPersonName"];
        task.taskFromPersonID = [rs stringForColumn:@"taskFromPersonID"];
        task.taskFromPersonName = [rs stringForColumn:@"taskFromPersonName"];
        task.upLoad = [rs intForColumn:@"upLoad"];
        task.timeStampContent = [rs intForColumn:@"timeStampContent"];
        task.timeStampList = [rs intForColumn:@"timeStampList"];
         if(task.upLoad !=1)
             task.taskContent = [rs stringForColumn:@"taskContent"];
//查找列表
        if (autoIncremenID) {//如果有autoincreamnid查找此条task
            task.taskFinishedTime = [rs intForColumn:@"taskFinishedTime"];
            task.taskContent = [rs stringForColumn:@"taskContent"];
            task.taskFinishedContent= [rs stringForColumn:@"taskFinishedContent"];
            [array addObject:task];
        }else{
            if (task.taskWhetherFinished == 0) {
                 if(task.taskLocked)
                 {
                    if ([showLocked isEqualToString:@"1"])
                        [array1 addObject:task];
                 }
                else
                {
                    [array1 addObject:task];
                }
            }else if (task.taskWhetherFinished == 1){
                [array2 addObject:task];
            }
        }
	}
    if(!autoIncremenID){
        [array addObject:array1];
        [array addObject:array2];
       // [array addObject:array3];
    }
        if (_db.lastError) NSLog(@"%@",[_db lastError]);

	[rs close];
    }];
    return array;

}
- (NSInteger)findfieldwithtasktime:(NSInteger )tasktime
{
    __block   NSInteger autoIncremenIDa;;
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString * query = @"SELECT * FROM YTaskFieleds";
     query = [query stringByAppendingFormat:@" WHERE taskTime= %d",tasktime];
    FMResultSet * rs = [_db executeQuery:query];
   	while ([rs next]) {
     autoIncremenIDa =  [rs intForColumn:@"autoIncremenID"];
    }
    [rs close];
    }];
    
    return autoIncremenIDa;
}

- (NSInteger)findfieldAutoIDwithtaskId:(NSString*)taskid
{
    __block   NSInteger autoIncremenIDa;;
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString * query = @"SELECT * FROM YTaskFieleds";
    query = [query stringByAppendingFormat:@" WHERE taskID = '%@'",taskid];
    FMResultSet * rs = [_db executeQuery:query];
   	while ([rs next]) {
        autoIncremenIDa =  [rs intForColumn:@"autoIncremenID"];
    }
    [rs close];
    }];
    return autoIncremenIDa;
}

//-(NSArray *)findUnReadNotic{
//    NSString * query = @"SELECT * FROM YTaskFieleds where isRead = '0'";
//    
//    
//    FMResultSet * rs = [_db executeQuery:query];
//    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
//	while ([rs next]) {
//        YTaskFieleds* task = [YTaskFieleds new];
//        //        signIn.autoIncremenID = [rs stringForColumn:@"autoIncremenID"];
//        task.taskID  = [rs stringForColumn:@"taskID"];
//        
//        [array addObject:task];
//	}
//	[rs close];
//    NSLog(@"%i",[array count]);
//    if ([array count] != 0) {
//        getTaskNew2 = 1;
//        
//    }else{
//        getTaskNew2 = 0;
//
//    }
//    return nil;
//}
-(void)uploadTaskID:(YTaskFieleds *)task{
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"UPDATE YTaskFieleds SET "];
    
    
    if (task.upLoad) {
        [query appendString:[NSString stringWithFormat:@"upLoad = %d",task.upLoad]];
    }
    
    if (task.timeStampList) {
        [query appendString:[NSString stringWithFormat:@",timeStampList = %d",task.timeStampList]];
    }
    if (task.timeStampContent) {
        [query appendString:[NSString stringWithFormat:@",timeStampContent = %d",task.timeStampContent]];
    }
    if (task.taskTime) {
        [query appendString:[NSString stringWithFormat:@",taskTime = %d",task.taskTime]];
    }

    if (task.taskID) {
        [query appendFormat:@",taskID = '%@'",task.taskID];
    }
    [query appendFormat:@" where autoIncremenID = %d",task.autoIncremenID];
    [self  executeSqlInBackground:query];
}






@end
