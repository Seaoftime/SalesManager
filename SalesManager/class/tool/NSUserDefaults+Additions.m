//
//  NSUserDefaults+Additions.m
//  业务员管家iPhone
//
//  Created by Kris on 13-11-1.
//  Copyright (c) 2013年 郑州悉知信息技术有限公司. All rights reserved.
//

#import "NSUserDefaults+Additions.h"



NSString *const XHDefaultsCompanyCode = @"companycode";
NSString *const XHDefaultsUserName = @"username";
NSString *const XHDefaultsRandCode = @"randCode";
NSString *const XHDefaultsName = @"name";
NSString *const XHDefaultsID = @"id";
NSString *const XHDefaultsHDImage = @"hdImage";
NSString *const XHDefaultsMapWithWifi = @"mapWithWifi";
NSString *const XHDefaultsDepartmentID = @"departmentID";
NSString *const XHDefaultsPosition = @"position";
NSString *const XHDefaultsDataBaseVersion = @"dataBaseVersion";
NSString *const XHDefaultReciveSummaryPerson = @"defaultReciveSummaryPerson";
NSString *const XHHomePage = @"homepage";

@implementation NSUserDefaults (Additions)


/*------------以下是登陆所需的信息（公司编码、用户名、密码）--------------*/

#pragma mark - companyCode

- (void)setCompanyCode:(NSString *)companyCode
{
    [self saveObject:companyCode forKey:XHDefaultsCompanyCode];
}

- (NSString *)companyCode
{
    return [self stringForKey:XHDefaultsCompanyCode];
}

#pragma mark - userName

- (void)setUserName:(NSString *)userName
{
    [self saveObject:userName forKey:XHDefaultsUserName];
}

- (NSString *)userName
{
    return [self stringForKey:XHDefaultsUserName];

}

#pragma mark - dataBaseVersion

- (void)setDataBaseVersion:(NSString *)dataBaseVersion
{
    [self saveObject:dataBaseVersion forKey:[XHDefaultsDataBaseVersion stringByAppendingFormat:@"%@%@",self.userName,self.companyCode]];
}

- (NSString *)dataBaseVersion
{
    return [self stringForKey:[XHDefaultsDataBaseVersion stringByAppendingFormat:@"%@%@",self.userName,self.companyCode]];

}



#pragma mark - position

- (void)setPosition:(NSString *)position
{
    [self saveObject:position forKey:XHDefaultsPosition];
}

- (NSString *)position
{
    return [self stringForKey:XHDefaultsPosition];
    
}

#pragma mark - randCode

- (void)setRandCode:(NSString *)randCode
{
    [self saveObject:randCode forKey:XHDefaultsRandCode];
}

- (NSString *)randCode
{
    return [self stringForKey:XHDefaultsRandCode];
}



/*------------以下是登陆后得到的用户信息（名字、id、公司名称、部门、手机号、图标url）--------------*/

#pragma mark - name

- (void)setName:(NSString *)name
{
    [self saveObject:name forKey:XHDefaultsName];
}

- (NSString *)name
{
    return [self stringForKey:XHDefaultsName];
}

#pragma mark - ID

- (void)setID:(NSString *)ID
{
    [self saveObject:ID forKey:XHDefaultsID];

}

- (NSString *)ID
{
    return [self stringForKey:XHDefaultsID];
}
#pragma mark - mapWithWifi
- (void)setMapWithWifi:(NSString *)mapWithWifi
{
    [self saveObject:mapWithWifi forKey:[XHDefaultsMapWithWifi stringByAppendingString:userID]];

}

- (NSString *)mapWithWifi
{
    return [self stringForKey:[XHDefaultsMapWithWifi stringByAppendingString:userID]];
}

#pragma mark - hdImage
- (void)setHDImage:(NSString *)hdImage
{

    [self saveObject:hdImage forKey:[XHDefaultsHDImage stringByAppendingString:userID]];

}

- (NSString *)hdImage
{
    return [self stringForKey:[XHDefaultsHDImage stringByAppendingString:userID]];
}

#pragma mark - deparoMentID
- (void)setDepartMentID:(NSString *)departMentID
{
    [self saveObject:departMentID forKey:XHDefaultsDepartmentID];

}

- (NSString *)departMentID
{
    return [self stringForKey:XHDefaultsDepartmentID];
}

#pragma mark - homepage
- (void)setHomePage:(NSMutableArray *)homepage
{
    [self saveObjectInBackground:homepage forKey:[XHHomePage stringByAppendingString:userDefaults.ID]];
    
}

- (NSMutableArray *)homepage
{
    return [self objectForKey:[XHHomePage stringByAppendingString:userDefaults.ID]];
}

-(void)saveObject:(id)obj forKey:(NSString* )key{
    [self setObject:obj forKey:key];
    [self synchronize];
}

-(void)saveObjectInBackground:(id)obj forKey:(NSString* )key{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self saveObject:obj forKey:key];
    });
}




@end
