//
//  YSignInDBM.m
//  业务点点通
//
//  Created by s k y on 12-12-23.
//  Copyright (c) 2012年 Sky. All rights reserved.
//

#import "YSignInDBM.h"
@implementation YSignInDBM


- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)upload:(YSignInFields* )signIn {
    
    [self executeSql:[NSString stringWithFormat:@"UPDATE YSignFileds SET upload=%d,SignInID = '%@' WHERE signInTime = %ld",signIn.upload, signIn.signInID,signIn.signInTime]];
}


- (void) saveSignIn:(YSignInFields *)signIn{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString* query;
    if (signIn.signInID) {
        query = [NSString stringWithFormat:@"select * from YSignFileds where signInID = '%@'",signIn.signInID];
    }else{
        query = [NSString stringWithFormat:@"select * from YSignFileds where signInTime = %d",signIn.signInTime];
    }
    
    
//    FMResultSet *rs = [_db executeQuery:@"select * from YSignFileds where signInTime = ?",[NSString stringWithFormat:@"%d",signIn.signInTime]];
    FMResultSet *rs = [_db executeQuery:query];

    
    if ([rs next]) {
        [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YSignFileds SET signInTime=%i,myLocation='%@' WHERE signInTime = %i",signIn.signInTime,signIn.myLocation,signIn.signInTime]];
        NSLog(@"存在");
    }else {
        
        NSMutableString * query    = [NSMutableString stringWithFormat:@"INSERT INTO YSignFileds"];
        NSMutableString * keys     = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values   = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (signIn.signInID) {
            [keys appendString:@"signInID,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.signInID];
            
        }
        if (signIn.longitude) {
            [keys appendString:@"longitude,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.longitude];
        }
        if (signIn.latitude) {
            [keys appendString:@"latitude,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.latitude];
        }
        if (signIn.signInTime) {
            [keys appendString:@"signInTime,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInt:signIn.signInTime]];
        }
        if (signIn.signInTitle) {
            [keys appendString:@"signInTitle,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.signInTitle];
        }
        if (signIn.upload) {
            [keys appendString:@"upload,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:signIn.upload]];
        }
        
        if (signIn.myLocation) {
            [keys appendString:@"myLocation,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.myLocation];
        }
        
        if (signIn.signInContent) {
            [keys appendString:@"signInContent,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.signInContent];
        }
        
        if (signIn.signInPersonID) {
            [keys appendString:@"signInPersonID,"];
            [values appendString:@"?,"];
            [arguments addObject:signIn.signInPersonID];
        }
        
        
        
        
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",[keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],[values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        [_db executeUpdate:query withArgumentsInArray:arguments];
    }
        if (_db.lastError) NSLog(@"%@",[_db lastError]);
        [rs close];

    }];
}

- (void) upLoadSignIn:(YSignInFields* )signIn{
    
    if (signIn.signInID) {
        [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YSignFileds SET signInContent='%@',latitude = %@,longitude = %@ WHERE signInID = '%@'",signIn.signInContent,signIn.latitude,signIn.longitude,signIn.signInID]];
    }else{
        [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YSignFileds SET signInContent='%@',latitude = %@,longitude = %@ WHERE signInTime = %ld",signIn.signInContent,signIn.latitude,signIn.longitude,(long)signIn.signInTime]];
    }

    
}

/**
 * @brief 模拟分页查找数据。取autoIncremenID大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
- (NSArray *) findWithSignInTime:(YSignInFields* )signIna limit:(int)limit{
    
    __block NSMutableArray * array =  [[NSMutableArray alloc]init];
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YSignFileds";
    if (!signIna) {
        query = [query stringByAppendingFormat:@" ORDER BY signInTime DESC limit %d",limit];
    } else {
        
        if (signIna.signInID) {
            query = [query stringByAppendingFormat:@" WHERE signInID = '%@'",signIna.signInID];
        }else{
            query = [query stringByAppendingFormat:@" WHERE signInTime = %li",(long)signIna.signInTime];
        }
        
        
    }
        
    FMResultSet * rs = [_db executeQuery:query];
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
        YSignInFields* signIn = [YSignInFields new];
        signIn.signInID = [rs stringForColumn:@"signInID"] ;
        signIn.signInTime = [rs intForColumn:@"signInTime"];
        signIn.signInTitle = [rs stringForColumn:@"signInTitle"];
        signIn.upload = [rs intForColumn:@"upload"];
        signIn.myLocation = [rs stringForColumn:@"myLocation"];
        signIn.signInPersonID = [rs stringForColumn:@"signInPersonID"];
        
        if (!signIna) {
            
            if (signIn.signInTime >= thisMonth) {
                [array1 addObject:signIn];
            }else if (signIn.signInTime < thisMonth && signIn.signInTime >= lastMonth){
                [array2 addObject:signIn];
            }else{
                [array3 addObject:signIn];
            }
            
        }else{
            
            signIn.signInContent = [rs stringForColumn:@"signInContent"];
            signIn.longitude = [rs stringForColumn:@"longitude"];
            signIn.latitude= [rs stringForColumn:@"latitude"];
            
            [array addObject:signIn];
            
        }
	}
    
    if (!signIna) {
        
        [array addObject:array1];
        [array addObject:array2];
        [array addObject:array3];
    }

	[rs close];
        
    if (_db.lastError) NSLog(@"%@",[_db lastError]);
    }];
    
    return array;
    
}

#pragma mark - find!Updata

-(NSArray *)findUpdata
{
    
    __block NSMutableArray * array =  [[NSMutableArray alloc] init];
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YSignFileds where upload = 0";
        
    FMResultSet * rs = [_db executeQuery:query];
        
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
        
        
	while ([rs next]) {
        YSignInFields * signIn = [YSignInFields new];
        
        signIn.latitude = [rs stringForColumn:@"latitude"];
        signIn.longitude = [rs stringForColumn:@"longitude"];
        signIn.signInTime = [rs intForColumn:@"signInTime"];
        signIn.upload = [rs intForColumn:@"upload"];
        signIn.signInTitle = [rs stringForColumn:@"signInTitle"];
        signIn.myLocation = [rs stringForColumn:@"myLocation"];
        signIn.signInContent = [rs stringForColumn:@"signInContent"];
        
        
        [array addObject:signIn];
	}
    
	[rs close];
    }];
    return array;
    
}


-(void)cleandataBase{
    [self executeSqlInBackground:@"DELETE FROM YSignFileds"];
    NSLog(@"清空数据");
}

-(NSString* )getUnUploadDAtaUrl:(NSInteger )postTime{
    
    __block NSString* str;
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = [NSString stringWithFormat:@"SELECT * FROM YSignFileds where postTime=%d",postTime];
    
    FMResultSet * rs = [_db executeQuery:query];
    
    str = [NSString stringWithFormat:@"http://%@?mod=location&fun=addsign&user_id=%@&rand_code=%@&&location_value[title]=%@&location_value[time]=%d&location_value[latitude]=%@&location_value[longitude]=%@&location_value[address]=%@&location_value[content]=%@&versions=%@&stype=1",API_headaddr,userDefaults.ID,userDefaults.randCode,[rs stringForColumn:@"signInTitle"],[rs intForColumn:@"signInTime"],[rs stringForColumn:@"latitude"],[rs stringForColumn:@"longitude"],[rs stringForColumn:@"myLocation"],[rs stringForColumn:@"signInContent"],VERSIONS];
    
	[rs close];
    }];
    return str;
    
}


- (YSignInFields *)getField:(int)postTime
{

    __block  YSignInFields * signIn = [[YSignInFields alloc]init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    FMResultSet * rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM YSignFileds WHERE signInTime = %d",postTime]];
    
    signIn.latitude = [rs stringForColumn:@"latitude"];
    signIn.longitude = [rs stringForColumn:@"longitude"];
    signIn.signInTime = [rs intForColumn:@"signInTime"];
    signIn.upload = [rs intForColumn:@"upload"];
    signIn.signInTitle = [rs stringForColumn:@"signInTitle"];
    signIn.myLocation = [rs stringForColumn:@"myLocation"];
    signIn.signInContent = [rs stringForColumn:@"signInContent"];
    
    [rs close];
    if (_db.lastError) NSLog(@"%@",[_db lastError]);

    }];
    
    return signIn;
}

- (void) deleteSignInWithpostTime:(NSInteger ) signInTime{
    NSLog(@"删除一条签到数据");
    [self executeSqlInBackground:[NSString stringWithFormat:@"DELETE FROM YSignFileds WHERE signInTime = %ld",(long)signInTime]];
}


@end
