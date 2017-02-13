//
//  YUserInfomationDBM.m
//  SalesManager
//
//  Created by sky on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YUserInfomationDBM.h"

@implementation YUserInfomationDBM

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}



-(void)saveUserInfomations:(YuserInfomationFileds* )userInfo{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    FMResultSet *rs = [_db executeQuery:@"select * from YUserInfo where userID = ? and companyCode = ?",userInfo.userID,userInfo.companyCode];
    NSLog(@"%@",rs);
    if ([rs next]) {
        [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YUserInfo SET name='%@',userID='%@',password='%@',randCode='%@',companyName='%@',department='%@',mobile='%@',logoURL='%@',positionName='%@',position=%d,sex=%d,userPicUrl ='%@'hdImage=%d,mapWithWifi=%d WHERE companyCode = '%@' and userID = '%@'",userInfo.name,userInfo.userID,userInfo.password,userInfo.randCode,userInfo.companyName,userInfo.department,userInfo.mobile,userInfo.logoURL,userInfo.positionName,userInfo.position,userInfo.sex,userInfo.userPicUrl,userInfo.hdImage,userInfo.mapWithWifi,userInfo.companyCode,userInfo.userID]];
        NSLog(@"%@",_db.lastErrorMessage);
    }else {
        
        
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YUserInfo"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (userInfo.userName) {
            [keys appendString:@"userName,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.userName];
        }
        if (userInfo.userID) {
            [keys appendString:@"userID,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.userID];
        }
        if (userInfo.name) {
            [keys appendString:@"name,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.name];
        }
        if (userInfo.userID) {
            [keys appendString:@"userID,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.userID];
        }
        if (userInfo.companyCode) {
            [keys appendString:@"companyCode,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.companyCode];
        }
        if (userInfo.password) {
            [keys appendString:@"password,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.password];
        }
        if (userInfo.randCode) {
            [keys appendString:@"randCode,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.randCode];
        }
        if (userInfo.companyName) {
            [keys appendString:@"companyName,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.companyName];
        }if (userInfo.department) {
            [keys appendString:@"department,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.department];
        }
        if (userInfo.mobile) {
            [keys appendString:@"mobile,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.mobile];
        }
        if (userInfo.logoURL) {
            [keys appendString:@"logoURL,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.logoURL];
        }
        if (userInfo.positionName) {
            [keys appendString:@"positionName,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.positionName];
        }if (userInfo.position) {
            [keys appendString:@"position,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:userInfo.position]]; 
        }
        if (userInfo.userPicUrl) {
            [keys appendString:@"userPicUrl,"];
            [values appendString:@"?,"];
            [arguments addObject:userInfo.userPicUrl];
        }
        if (userInfo.sex) {
            [keys appendString:@"sex,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:userInfo.sex]];
        }if (userInfo.hdImage) {
            [keys appendString:@"hdImage,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:userInfo.hdImage]];
        }
        if (userInfo.mapWithWifi) {
            [keys appendString:@"mapWithWifi,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:userInfo.mapWithWifi]];
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


-(YuserInfomationFileds* )getUSerInfomations:(NSString* )userID :(NSString* )comCode{
   __block YuserInfomationFileds* userInfo;

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

     FMResultSet * rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM YUserInfo where userID = '%@' and companyCode = '%@'",userID,comCode]];
    if ([rs next]) {
        userInfo = [YuserInfomationFileds new];
        userInfo.userName = [rs stringForColumn:@"userName"];
        userInfo.userID = [rs stringForColumn:@"userID"];
        userInfo.name = [rs stringForColumn:@"name"];
        userInfo.companyCode = [rs stringForColumn:@"companyCode"];
        userInfo.password = [rs stringForColumn:@"password"];
        userInfo.randCode = [rs stringForColumn:@"randCode"];
        userInfo.companyName = [rs stringForColumn:@"companyName"];
        userInfo.department = [rs stringForColumn:@"department"];
        userInfo.mobile = [rs stringForColumn:@"mobile"];
        userInfo.logoURL = [rs stringForColumn:@"logoURL"];
        userInfo.positionName = [rs stringForColumn:@"positionName"];
        userInfo.position = [rs intForColumn:@"position"];
        userInfo.sex = [rs intForColumn:@"sex"];
        userInfo.albumVersion = [rs intForColumn:@"albumVersion"];
        userInfo.formVersion = [rs intForColumn:@"formVersion"];
        userInfo.userPicUrl = [rs stringForColumn:@"userPicUrl"];
//        userInfo.optionsVersion = [rs intForColumn:@"optionsVersion"];
        userInfo.userVersion = [rs intForColumn:@"userVersion"];
        userInfo.hdImage = [rs intForColumn:@"hdImage"];
        userInfo.mapWithWifi = [rs intForColumn:@"mapWithWifi"];
    }
        [rs close];
        if (_db.lastError) NSLog(@"%@",_db.lastErrorMessage);

    }];
    return userInfo;
}


-(void)uploadPhotoUrl:(YuserInfomationFileds* )userInfo{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSMutableString* query = [NSMutableString stringWithString:@"UPDATE YUserInfo SET"];
    
    [query appendString:[NSString stringWithFormat:@" userPicUrl = '%@'",userInfo.userPicUrl]];
    [query stringByAppendingString:[NSString stringWithFormat:@" WHERE companyCode = '%@' and userID = '%@'",userInfo.companyCode,userInfo.userID]];
    
    [_db executeUpdate:query];
        
    if (_db.lastError) NSLog(@"%@",_db.lastErrorMessage);

    }];
}

-(void)upLoadVersions:(YuserInfomationFileds* )userInfo{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSMutableString* query = [NSMutableString stringWithString:@"UPDATE YUserInfo SET"];
    if (userInfo.albumVersion) {
        [query appendString:[NSString stringWithFormat:@" albumVersion = %d",userInfo.albumVersion]];
    }
    if (userInfo.formVersion) {
        [query appendString:[NSString stringWithFormat:@" formVersion = %d",userInfo.formVersion]];
    }
    if (userInfo.userVersion) {
        [query appendString:[NSString stringWithFormat:@" userVersion = %d",userInfo.userVersion]];
    }
    
    [query stringByAppendingString:[NSString stringWithFormat:@" WHERE companyCode = '%@' and userName = '%@'",userInfo.companyCode,userInfo.userName]];

    [_db executeUpdate:query];
        if (_db.lastError) NSLog(@"%@",[_db lastErrorMessage]);
    }];
    
}



@end
