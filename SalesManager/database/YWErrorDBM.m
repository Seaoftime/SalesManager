//
//  YWErrorDBM.m
//  SalesManager
//
//  Created by sky on 14-1-9.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "YWErrorDBM.h"

@implementation YWErrorDBM



- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}




-(void)saveAnErrorInfo:(NSString* )errorInfo{

    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

   NSDateFormatter* YMD = [[NSDateFormatter alloc] init];
    [YMD setDateFormat:@"yyyy.MM.dd HH:mm:ss"];

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO YErrorMsg(errorFun, timeStamp) VALUES ( '%@', '%@')", errorInfo,[YMD stringFromDate:[NSDate date]]];
    BOOL res = [_db executeUpdate:sql];
    }];


}

/**
 *  获取所有的错误信息
 *
 *  @return 错误信息 如果没有 返回空
 */
-(NSString* )getErrorinfo{
    __block NSString* errMsg;
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString * query = @"SELECT * FROM YErrorMsg";
      FMResultSet * rs = [_db executeQuery:query];
    while ([rs next]) {
        if (!errMsg) {
            errMsg = [[NSString alloc]initWithFormat:@"%@,%@,",[rs stringForColumn:@"errorFun"],[rs stringForColumn:@"timeStamp"]];
        }else{
            errMsg = [errMsg stringByAppendingString:[NSString stringWithFormat:@"%@,%@",[rs stringForColumn:@"errorFun"],[rs stringForColumn:@"timeStamp"]]];
        }
    }
    [rs close];
    }];
    return errMsg;
    
}

/**
 *  清空数据
 */
-(void)cleanDatabase{
    [self executeSqlInBackground:@"DELETE FROM YErrorMsg"];
}


@end
