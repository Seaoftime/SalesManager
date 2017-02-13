//
//  YManagerUserInfoDBM.m
//  DataBaseClass
//
//  Created by sky on 13-11-13.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"

@implementation YManagerUserInfoDBM

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)saveDepartment:(YManagerUserInfoFileds* )user{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"select * from YUserInfomationFileds WHERE userDepartmentID = '%@'",user.userDepartmentID]];
    if ([rs next]) {
        [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YUserInfomationFileds SET userDepartmentID='%@',userDepartmentName='%@' WHERE userDepartmetnID = '%@' and userID is null",user.userDepartmentID,user.userDepartmentName,user.userDepartmentID]];
        NSLog(@"%@",_db.lastErrorMessage);
    }else {
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YUserInfomationFileds"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (user.userDepartmentID) {
            [keys appendString:@"userDepartmentID,"];
            [values appendString:@"?,"];
            [arguments addObject:user.userDepartmentID];
        }
        if (user.userDepartmentName) {
            [keys appendString:@"userDepartmentName,"];
            [values appendString:@"?,"];
            [arguments addObject:user.userDepartmentName];
        }
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];

        [_db executeUpdate:query withArgumentsInArray:arguments];
        NSLog(@"%@",_db.lastError) ;
    };
        [rs close];
    }];


}

- (void)saveUser:(YManagerUserInfoFileds *)user{
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    FMResultSet * rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM YUserInfomationFileds WHERE userID = %ld",user.userID]];
    if ([rs next]) {
        [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YUserInfomationFileds SET userName='%@',userEMail='%@',userPhoneNumber='%@',userDepartmentID='%@',userDepartmentName='%@',userPhotoUrl='%@',sex=%ld,position='%@',positionTitle ='%@',isCheck = %ld,nameSimplicity = '%@',nameFullSpelling = '%@' WHERE userID = %ld",user.userName,user.userEMail,user.userPhoneNumber,user.userDepartmentID,user.userDepartmentName,user.userPhotoUrl,user.sex,user.position,user.positionTitle,user.isCheck,user.nameSimplicity,user.nameFullSpelling,user.userID]];
        NSLog(@"%@",_db.lastErrorMessage);
    }else {

    
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YUserInfomationFileds"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
    if (user.userID) {
        [keys appendString:@"userID,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:user.userID]];
    }
    if (user.userName) {
        [keys appendString:@"userName,"];
        [values appendString:@"?,"];
        [arguments addObject:user.userName];
    }if (user.userEMail) {
        [keys appendString:@"userEMail,"];
        [values appendString:@"?,"];
        [arguments addObject:user.userEMail];
    }
    if (user.userPhoneNumber) {
        [keys appendString:@"userPhoneNumber,"];
        [values appendString:@"?,"];
        [arguments addObject:user.userPhoneNumber];
    }
    if (user.userDepartmentID) {
        [keys appendString:@"userDepartmentID,"];
        [values appendString:@"?,"];
        [arguments addObject:user.userDepartmentID];
    }
    if (user.userDepartmentName) {
        [keys appendString:@"userDepartmentName,"];
        [values appendString:@"?,"];
        [arguments addObject:user.userDepartmentName];
    }
    if (user.userPhotoUrl) {
        [keys appendString:@"userPhotoUrl,"];
        [values appendString:@"?,"];
        [arguments addObject:user.userPhotoUrl];
    }
    if (user.sex) {
        [keys appendString:@"sex,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:user.sex]];
    }
    if (user.position) {
        [keys appendString:@"position,"];
        [values appendString:@"?,"];
        [arguments addObject:user.position];
    }

    if (user.positionTitle)  {
        [keys appendString:@"positiontitle,"];
        [values appendString:@"?,"];
        [arguments addObject:user.positionTitle];
    }
        if (user.isCheck) {
            [keys appendString:@"isCheck,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:user.isCheck]];
        }
        if (user.nameSimplicity)  {
            [keys appendString:@"nameSimplicity,"];
            [values appendString:@"?,"];
            [arguments addObject:user.nameSimplicity];
        }if (user.nameFullSpelling)  {
            [keys appendString:@"nameFullSpelling,"];
            [values appendString:@"?,"];
            [arguments addObject:user.nameFullSpelling];
        }
        
    
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"插入一条数据");
    [_db executeUpdate:query withArgumentsInArray:arguments];
    NSLog(@"%@",_db.lastError) ;
    };
        [rs close];
    }];
    
}

-(void)upLoadMyPicture:(YManagerUserInfoFileds* )userInfo{
    [self executeSqlInBackground:[NSString stringWithFormat:@"UPDATE YUserInfomationFileds SET userPhotoUrl='%@' WHERE userID =%ld",userInfo.userPhotoUrl,userInfo.userID ]];
}

-(NSArray *)checkUserInfoByString:(NSString* )likeString{
    
    __block NSMutableArray * array = [[NSMutableArray alloc]init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

     NSString* query = [NSString stringWithFormat:@"SELECT * from YUserInfomationFileds WHERE nameSimplicity LIKE '%%%@%%' or userName LIKE '%%%@%%'",likeString,likeString];
    if ([likeString length] > 1) {
       query = [query stringByAppendingString:[NSString stringWithFormat:@" or nameFullSpelling LIKE '%%%@%%'",likeString]];
    }
   
    query = [query stringByAppendingFormat:@" and userID is not %@",userID];
    
    
    FMResultSet * rs2 = [_db executeQuery:query];
    NSLog(@"%@",_db.lastError);
    while ([rs2 next]) {
        YManagerUserInfoFileds* userInfo = [YManagerUserInfoFileds new];
        userInfo.userID = [rs2 intForColumn:@"userID"];
        userInfo.userName = [rs2 stringForColumn:@"userName"];
        userInfo.userDepartmentID = [rs2 stringForColumn:@"userDepartmentID"];
        userInfo.userDepartmentName = [rs2 stringForColumn:@"userDepartmentName"];
        userInfo.positionTitle = [rs2 stringForColumn:@"positionTitle"];
        
        [array containsObject:userInfo]?nil:[array addObject:userInfo];
    }
    [rs2 close];
 
    //NSLog(@"%d",array.count);
    }];
    return array;
}


- (NSArray *) findWithDepartmentID:(NSString *)departmentID SortbyGroup:(BOOL)sort withInfo:(BOOL)info Status:(BOOL)status withMe:(BOOL)me{
    __block NSMutableArray * array = [[NSMutableArray alloc]init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    if (!sort) {
        NSString * query = @"SELECT * FROM YUserInfomationFileds";
        if (!departmentID)   query = [query stringByAppendingFormat:@" where userName is not null"];
        
        else query = [query stringByAppendingFormat:@" WHERE departmentID = %@",departmentID];
      
        if (status) query = [query stringByAppendingString:@" and isCheck = 1"];
        
        if (!me) query = [query stringByAppendingFormat:@" and userID is not '%@'",userID];
        
        query = [query stringByAppendingString:@" ORDER BY autoIncremenID DESC"];
        
        NSLog(@"%@",query);
        FMResultSet * rs = [_db executeQuery:query];
        
        
        while ([rs next]) {
            YManagerUserInfoFileds* userInfo = [YManagerUserInfoFileds new];
            userInfo.userID = [rs intForColumn:@"userID"];
            userInfo.userName = [rs stringForColumn:@"userName"];
            userInfo.userDepartmentID = [rs stringForColumn:@"userDepartmentID"];
            userInfo.userDepartmentName = [rs stringForColumn:@"userDepartmentName"];
            userInfo.positionTitle = [rs stringForColumn:@"positionTitle"];
            userInfo.nameFullSpelling = [rs stringForColumn:@"nameFullSpelling"];
            userInfo.nameSimplicity = [rs stringForColumn:@"nameSimplicity"];
            if (info) {
                userInfo.sex = [rs intForColumn:@"sex"];
                userInfo.userPhotoUrl = [rs stringForColumn:@"userPhotoUrl"];
                userInfo.position = [rs stringForColumn:@"position"];
                userInfo.userEMail = [rs stringForColumn:@"userEMail"];
                userInfo.userPhoneNumber = [rs stringForColumn:@"userPhoneNumber"];
                
            }
            
            [array addObject:userInfo];
            
            
        }
        [rs close];
    }else{
        NSMutableArray* group = [[NSMutableArray alloc]init];
        NSString * query = [NSString stringWithFormat:@"SELECT * FROM YUserInfomationFileds WHERE userName is null"];
        
        query = [query stringByAppendingString:@" ORDER BY userDepartmentID DESC"];
        FMResultSet * rs = [_db executeQuery:query];
        NSMutableArray* asd = [[NSMutableArray alloc]init  ];
        while ([rs next]) {
            YManagerUserInfoFileds* userInfo = [YManagerUserInfoFileds new];
            userInfo.userDepartmentID = [rs stringForColumn:@"userDepartmentID"];
            userInfo.userDepartmentName = [rs stringForColumn:@"userDepartmentName"];
            if (![asd containsObject:userInfo.userDepartmentID]) {
                 [group addObject:userInfo];
                [asd addObject:userInfo.userDepartmentID];
            }
        }
        [rs close];
        
        for (int i = 0; i < group.count ; i++) {
            NSString* query = [NSString stringWithFormat:@"SELECT * FROM YUserInfomationFileds WHERE userDepartmentID = '%@' and userName is not null and isCheck = 1",[[group objectAtIndex:i] userDepartmentID]];
            
            if (status) query = [query stringByAppendingString:@" and isCheck = 1"];
            
            if (!me) {
               query = [query stringByAppendingFormat:@" and userID is not '%@'",userID];
            }
            query = [query stringByAppendingString:@" ORDER BY position DESC"];
            NSMutableArray* groupMembers = [[NSMutableArray alloc]init];
            FMResultSet * rs1 = [_db executeQuery:query];
            while ([rs1 next]) {
                YManagerUserInfoFileds* userInfo = [YManagerUserInfoFileds new];
                userInfo.userID = [rs1 intForColumn:@"userID"];
                userInfo.userName = [rs1 stringForColumn:@"userName"];
                userInfo.userDepartmentID = [rs1 stringForColumn:@"userDepartmentID"];
                userInfo.userDepartmentName = [rs1 stringForColumn:@"userDepartmentName"];
                userInfo.positionTitle = [rs1 stringForColumn:@"positionTitle"];
                userInfo.nameFullSpelling = [rs1 stringForColumn:@"nameFullSpelling"];
                userInfo.nameSimplicity = [rs1 stringForColumn:@"nameSimplicity"];
                if (info) {
                    userInfo.sex = [rs1 intForColumn:@"sex"];
                    userInfo.userPhotoUrl = [rs1 stringForColumn:@"userPhotoUrl"];
                    userInfo.position = [rs1 stringForColumn:@"position"];
                    userInfo.userEMail = [rs1 stringForColumn:@"userEMail"];
                    userInfo.userPhoneNumber = [rs1 stringForColumn:@"userPhoneNumber"];
                }
                
                [groupMembers addObject:userInfo];
            }
            [array addObject:groupMembers];
        }
        
        [rs close];
        
    }
    NSLog(@"%@",[_db lastErrorMessage]);
    }];
    return array;
}

-(YManagerUserInfoFileds* )getPersonInfoByUserID:(NSInteger )userID withPhotoUrl:(BOOL)photoUrl withDepartment:(BOOL)department withContacts:(BOOL)contacts{
    
    __block YManagerUserInfoFileds* userInfo = [[YManagerUserInfoFileds alloc] init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    FMResultSet * rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM YUserInfomationFileds WHERE userID = %ld",userID]];
    
    while ([rs next]) {
        userInfo.userID = [rs intForColumn:@"userID"];
        userInfo.userName = [rs stringForColumn:@"userName"];
        
        if (photoUrl) {
            
            userInfo.userPhotoUrl = [rs stringForColumn:@"userPhotoUrl"];
            userInfo.sex = [rs intForColumn:@"sex"];
        }
        
        if (department) {
            userInfo.position = [rs stringForColumn:@"position"];
            userInfo.positionTitle = [rs stringForColumn:@"positionTitle"];
            userInfo.userDepartmentID = [rs stringForColumn:@"userDepartmentID"];
            userInfo.userDepartmentName = [rs stringForColumn:@"userDepartmentName"];
        }
        
        if (contacts) {
            userInfo.userEMail = [rs stringForColumn:@"userEMail"];
            userInfo.userPhoneNumber = [rs stringForColumn:@"userPhoneNumber"];
        }

    }
	[rs close];
    }];
    return userInfo;
}


- (void)cleandataBase{
    [self executeSqlInBackground:@"DELETE FROM YUserInfomationFileds"];
    NSLog(@"清空数据");
}

- (NSArray *)getManagersMembersIDByMyDepartMent
{
    __block NSMutableArray *positionIDs = [[NSMutableArray alloc] init];
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    //获取部门名称
   __block NSString* myDepartmentName;

    dispatch_async(dispatch_get_main_queue(), ^{
        myDepartmentName = [[self getPersonInfoByUserID:[userID integerValue] withPhotoUrl:NO withDepartment:YES withContacts:NO] userDepartmentName];

    });
    //获取部门架构
    NSMutableArray *departmentArray = [[NSMutableArray alloc] initWithArray:[myDepartmentName componentsSeparatedByString:@"--"]];
    
    int times = (int)departmentArray.count;
    
    for (int i=0; i<times; i++)
    {
        //获取上级部门(第一次获取本部门)
        NSString *topDepartmentName = [departmentArray componentsJoinedByString:@"--"];
        NSLog(@"%@",topDepartmentName);
        
        //数据库查找
        NSString * query = [NSString stringWithFormat:@"SELECT * FROM YUserInfomationFileds WHERE userDepartmentName = '%@' and position = 1 and userID is not %@ ORDER BY userID ASC", topDepartmentName, userID];
        FMResultSet * rs = [_db executeQuery:query];
        
        while ([rs next])
        {
            NSInteger  aa = [rs intForColumn:@"userID"];
            [positionIDs insertObject:[NSString stringWithFormat:@"%ld",aa] atIndex:0];
        }
        [rs close];
        //移除本级部门
        [departmentArray removeLastObject];
    }
    }];
    
    return positionIDs;
}

@end
