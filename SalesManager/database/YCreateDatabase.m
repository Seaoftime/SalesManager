//
//  YCreateDatabase.m
//  DataBaseClass
//
//  Created by sky on 13-11-15.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import "YCreateDatabase.h"
#import "FMDatabaseQueue.h"

@implementation YCreateDatabase


/*
 数据库版本变动说明  如果要变动数据库 需要在HomePage里面更改判断
 
 
 V2 -- 3.0.2 V3初始数据库版本
 V3 -- 3.0.3 增加人员信息qq号字段  暂不使用-。-
 v4 -- 3.0.4 增加表单排序
 v5 -- 3.1.0 增加人员禁用字段 增加人员简拼、全拼字段 增加
 
 */


- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
    }
    return self;
}
/**
 * @brief 创建数据库
 */

- (void) createDataBaseisManager:(BOOL)isManager {

    
    NSLog(@"%@",userDefaults.dataBaseVersion);
    if (![userDefaults.dataBaseVersion isEqualToString:@"5"]) {
        [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
            FMResultSet* set = [_db executeQuery:@"select count(*) from sqlite_master where type ='table' and name = 'YMylocations'"];
            [set next];
            NSInteger count = [set intForColumnIndex:0];
            BOOL existTable = !!count;
            
            if (existTable) {
                
                NSLog(@"表已创建");
                
            }else {
                    //用户数据信息
                    NSString* userSql = @"CREATE TABLE IF NOT EXISTS YUserInfo (userID VARCHAR(50), companyCode VARCHAR(50),name VARCHAR(10),userName VARCHAR(50), password VARCHAR(20) ,randCode VARCHAR(50),companyName VARCHAR(20),department VARCHAR(20),mobile VARCHAR(20),logoURL VARCHAR(50),positionName VARCHAR(20),position INTEGER,sex INTEGER,albumVersion INTEGER,formVersion INTEGER,userVersion INTEGER,userPicUrl VARCHAR(50),mapWithWifi INTEGER,hdImage INTEGER)";
                
                    //表单
                    NSString * formSql = @"CREATE TABLE IF NOT EXISTS YformFileds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, formID INTEGER, area VARCHAR(50), sectionID INTEGER, sectionTitle VARCHAR(50) ,formName VARCHAR(50),formUnit VARCHAR(50),formReferName VARCHAR(50),need VARCHAR(10),formType VARCHAR(50),gps VARCHAR(50),overdue INTEGER,imageType VARCHAR(50),selectivity VARCHAR(50),isreply INTEGER,isImage INTEGER,idSort INTEGER)";
                    
                    
                    //日志列表
                    NSString * summaryListSql = @"CREATE TABLE IF NOT EXISTS YSummaryListFields (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,summaryId INTEGER,summaryTitle VARCHAR(30),postTime INTEGER, isread INTEGER, isreply INTEGER,timeStampList INTEGER, timeStampContent INTEGER,sectionID INTEGER,reciver VARCHAR(50),senderName VARCHAR(10),upload INTEGER,replyNum INTEGER,summaryPreview VARCHAR(50),isMine INTEGER,reciverID VARCHAR(50),senderUserID INTEGER,longitude VARCHAR(15),latitude VARCHAR(15),myLocation VARCHA(20))";
                    
                    //日志详情
                    NSString * summaryContentSql = @"CREATE TABLE IF NOT EXISTS YSummaryContentFields (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,summaryID VARCHAR(10),postTime INTEGER,  sectionID INTEGER, formName VARCHAR(50),formValue VARCHAR(50),photoUrl VARCHAR(50))";
                    
                    
                    //日志回复
                    NSString * summaryReplySql = @"CREATE TABLE YSummaryReplyFileds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,summaryID VARCHAR(50),replyDate INTEGER, isSelf VARCHAR(5), replyContent VARCHAR(50), replyPerson VARCHAR(10))";
                    
                    //通知
                    NSString * noticSql = @"CREATE TABLE IF NOT EXISTS YNoticFileds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,noticID INTEGER,noticTitle VARCHAR(20), noticDate INTEGER, noticIsread INTEGER ,noticContent VARCHAR(50),upLoad INTEGER,timeStampList INTEGER,timeStampContent INTEGER,toDepartmentName VARCHAR(20),toPersonName VARCHAR(20),toDepartmentID VARCHAR(20),toPersonID VARCHAR(50),fromUserID VARCHAR(20),fromUserName VARCHAR(20),isMine INTEGER)";
                    
                    //图库
                    NSString * pictureSql = @"CREATE TABLE IF NOT EXISTS YPcituresFileds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,albumID INTEGER,albumTitle VARCHAR(50), albumPhotoNumbers INTEGER, albumCoverUrl VARCHAR(50) ,albumContetn VARCHAR(50) ,photoTitle VARCHAR(50) ,photoID INTEGER ,photoUrl VARCHAR(50) ,phtotBigPhotoUrl VARCHAR(50) ,is_cover INTEGER, photoContent VARCHAR(50),localAlbumID INTEGER)";
                    
                    //签到
                    NSString * signInSql = @"CREATE TABLE IF NOT EXISTS YSignFileds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,upload INTEGER,signInID VARCHAR(50), longitude VARCHAR(50), latitude VARCHAR(50), signInContent VARCHAR(50), signInTitle VARCHAR(50), signInTime INTEGER,myLocation VARCHAR(50),signInPersonID VARCHAR(50))";
                    
                    //任务
                    NSString * taskSql = @"CREATE TABLE YTaskFieleds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,taskID ARCHAR(20),isRead INTEGER, taskTitle VARCHAR(20), taskTime INTEGER ,taskContent VARCHAR(50),taskWhetherFinished INTEGER,taskEndTime INTEGER,taskFinishedTime INTEGER,TaskFinishedContent VARCHAR(50),taskTo VARCHAR(50),taskLocked INTEGER,uoLoad INTEGER,timeStampList INTEGER,timeStampContent INTEGER,taskFromPersonID INTEGER,taskFromPersonName VARCHAR(20),isMine INTEGER,upLoad INTEGER,isReply INTEGER,toPersonID VARCHAR(50),toPersonName VARCHAR(20))";
                
                    //用户
                    NSString* userInfoSql = @"CREATE TABLE YUserInfomationFileds (autoIncremenID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,userID INTEGER,userName VARCHAR(20), userPhoneNumber VARCHAR(20), userDepartmentID VARCHAR(10) ,userDepartmentName VARCHAR(20),userEMail VARCHAR(20),userPhotoUrl VARCHAR(50),position VARCHAR(20), sex INTEGER,positionTitle VARCHAR(20),qqNumber VARCHAR(20),isCheck INTEGER,nameSimplicity VARCHAR(50),nameFullSpelling VARCHAR(50))";
                    
                    //错误搜集数据库
                    NSString* eroSql = @"CREATE TABLE IF NOT EXISTS YErrorMsg (errorFun VARCHAR(50), timeStamp VARCHAR(20))";
                    
                    
                    
                    BOOL res = [_db executeUpdate:userSql];
                    if (!res) {
                        NSLog(@"用户信息表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"用户信息表创建成功");
                    }
                    
                    res = [_db executeUpdate:userInfoSql];
                    if (!res) {
                        NSLog(@"管理端用户表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"管理端用户表创建成功");
                    }
                    
                    res = [_db executeUpdate:formSql];
                    if (!res) {
                        NSLog(@"表单表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"表单表创建成功");
                    }
                    res = [_db executeUpdate:summaryListSql];
                    if (!res) {
                        NSLog(@"日志列表表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"日志列表表创建成功");
                    }
                    
                    res = [_db executeUpdate:summaryContentSql];
                    if (!res) {
                        NSLog(@"日志详情表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"日志详情表创建成功");
                    }
                    
                    res = [_db executeUpdate:summaryReplySql];
                    if (!res) {
                        NSLog(@"回复表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"回复表创建成功");
                    }
                    
                    res = [_db executeUpdate:signInSql];
                    if (!res) {
                        NSLog(@"签到表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"签到表创建成功");
                    }
                    
                    res = [_db executeUpdate:taskSql];
                    if (!res) {
                        NSLog(@"任务表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"任务表创建成功");
                    }
                    
                    res = [_db executeUpdate:noticSql];
                    if (!res) {
                        NSLog(@"通知表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"通知表创建成功");
                    }
                    
                    res = [_db executeUpdate:pictureSql];
                    if (!res) {
                        NSLog(@"图库表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"图库表创建成功");
                    }
                    res = [_db executeUpdate:eroSql];
                    if (!res) {
                        NSLog(@"错误信息表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"错误信息表创建成功");
                    }
                    NSString* myLocation = @"CREATE TABLE IF NOT EXISTS YMylocations (longtitude VARCHAR(20),latitude VARCHAR(20), timeStamp INTEGER)";
                    res = [_db executeUpdate:myLocation];
                    if (!res) {
                        NSLog(@"用户位置信息表创建失败");
                        NSLog(@"%@",_db.lastErrorMessage);
                    } else {
                        NSLog(@"用户位置信息表表创建成功");
                    }
                }
                }];
            [userDefaults setDataBaseVersion:@"5"];

    }
}

@end
