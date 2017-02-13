//
//  GCDataBaseManager.h
//  baymax_marketing_iOS
//
//  Created by Sky on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface GCDataBaseManager : NSObject

+(instancetype)shareDatabase;

@property (nonatomic, strong)   FMDatabaseQueue* databaseQueue;

//打开数据库  name:唯一的用户标识
-(void)openDataBaseWithDatabaseName:(NSString* )name;

//断开数据库
-(void)close;

@end
