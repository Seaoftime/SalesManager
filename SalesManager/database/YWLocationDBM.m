//
//  YWLocationDBM.m
//  SalesManager
//
//  Created by sky on 14-1-25.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "YWLocationDBM.h"

@implementation YWLocationDBM

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)saveAnLocations:(YWLocationFileds* )locationFileds{
    
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString* query = [NSString stringWithFormat:@"select * from YMylocations where timeStamp = %d",locationFileds.timeStampt];
    FMResultSet *rs = [_db executeQuery:query];
    if (![rs next]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO YMylocations(longtitude, latitude, timeStamp) VALUES ( '%@', '%@', '%i')", locationFileds.longtitude,locationFileds.latitude,locationFileds.timeStampt];
        BOOL res = [_db executeUpdate:sql];
        if (!res) NSLog(@"%@",[_db lastError]);
    }else{
        NSLog(@"已经存在");
    }
        [rs close];
    }];
}

-(NSString* )getMyLocations{
     __block NSMutableString* locationStrings = [[NSMutableString alloc] init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString *sql = @"select * from YMylocations ORDER BY timeStamp ASC";
    FMResultSet * rs = [_db executeQuery:sql];
    
    
    while ([rs next])
    {
        [locationStrings appendString:[NSString stringWithFormat:@"%d|%@|%@,",[rs intForColumn:@"timeStamp"],[rs stringForColumn:@"longtitude"],[rs stringForColumn:@"latitude"]]];
	}
	[rs close];
    }];
    return locationStrings;

}
-(void)cleanDatabase{
    [self executeSqlInBackground:@"DELETE FROM YMylocations"];
    NSLog(@"清空数据");
}


@end
