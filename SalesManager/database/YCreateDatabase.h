//
//  YCreateDatabase.h
//  DataBaseClass
//
//  Created by sky on 13-11-15.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import "baseDatabase.h"

@interface YCreateDatabase : baseDatabase{
}

/*
 
 -------创建数据库！ 数据库根据用户名创建-------
 
 @param ismamager YES创建管理表  NO不创建
 */

- (void) createDataBaseisManager:(BOOL)isManager;
@end
