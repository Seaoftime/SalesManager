//
//  YDateBaseManager.m
//  业务点点通
//
//  Created by s k y on 12-12-23.
//  Copyright (c) 2012年 Sky. All rights reserved.
//

#import "YDateBaseManager.h"
#import "FMDatabase.h"
#import "NSUserDefaults+Additions.h"


@interface YDateBaseManager ()

@end

@implementation YDateBaseManager
static YDateBaseManager* _sharedDBmanager;

+ (YDateBaseManager *) defaultDBManager{
    if (!_sharedDBmanager) {
        _sharedDBmanager = [[YDateBaseManager alloc]init];
    }
    return _sharedDBmanager;
}

- (void) dealloc{
    [self close];
}

- (id) init {
    self = [super init];
    if (self) {
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        
        /**
         *  V3.0 数据库名字   --- 公司编码 用户名  .sqlite
         */
        
        int state = [self initializeDBWithName:[NSString stringWithFormat:@"%@%@.sqlite",userDefaultes.companyCode,userDefaultes.userName]];
        NSLog(@"检查到数据库名%@",userDefaultes.userName);
        if (state == -1) {
            NSLog(@"数据库初始化失败");
        } else {
            NSLog(@"数据库初始化成功");
        }
       
        }
    return self;
}

/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 * @return 返回数据库初始化状态， 0 为 已经存在，1 为创建成功，-1 为创建失败
 */

- (int) initializeDBWithName : (NSString *) name {
    if (!name) {
		return -1;  // 返回数据库创建失败
	}
    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",docp);
	dataBasePath = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
	NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:dataBasePath];
    [self connect];
    if (!exist) {
        return 0;
    } else {
        return 1;          // 返回 数据库已经存在
        
	}
    
}

/// 连接数据库
- (void) connect {
	if (!_dataBase) {
		_dataBase = [[FMDatabase alloc] initWithPath:dataBasePath];
	}
	if (![_dataBase open]) {
		NSLog(@"不能打开数据库");
	}
}
/// 关闭连接
- (void) close {
    if ([_dataBase open]) {
        [_dataBase close];
    }
    _sharedDBmanager = nil;
    NSLog(@"已关闭");
}



@end
