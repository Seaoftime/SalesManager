//
//  GCDataBaseManager.m
//  baymax_marketing_iOS
//
//  Created by Sky on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCDataBaseManager.h"

@interface GCDataBaseManager()

@property (nonatomic, copy)     NSString* databasePath;
@property (readonly) CIFormat format;

@end

@implementation GCDataBaseManager

static GCDataBaseManager* share = nil;

+ (GCDataBaseManager *) shareDatabase{
    if (!share) {
        share = [[GCDataBaseManager alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:share selector:@selector(close) name:@"logOut" object:nil];

    }
    return share;
}

-(void)openDataBaseWithDatabaseName:(NSString* )name{
    [self getdatabasepath:name];
    self.databaseQueue = [[FMDatabaseQueue alloc ] initWithPath:_databasePath];

}

-(void)close{
    [_databaseQueue close];
    self.databasePath = nil;
    self.databaseQueue = nil;
    share = nil;
}


-(BOOL)getdatabasepath:(NSString* )databaseName{
    if (!databaseName) {
        assert(@"传的是个求");  // 返回数据库创建失败
    }
    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docp%@",docp);
    self.databasePath = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@%@.sqlite",userDefaults.companyCode,userDefaults.userName]];
    NSLog(@"检查到数据库名%@",userDefaults.userName);
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:_databasePath];
    NSLog(exist?@"存在数据库":@"不存在数据库");
    return exist;
}
@end
