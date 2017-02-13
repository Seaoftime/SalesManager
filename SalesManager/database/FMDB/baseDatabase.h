//
//  baseDatabase.h
//  baymax_marketing_iOS
//
//  Created by sky on 15/12/17.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "GCDataBaseManager.h"

@interface baseDatabase : NSObject


/**
 *  执行一条sql
 *
 *  @param sql sql description
 */
- (void) executeSql:(NSString* )sql;
/**
 *  后台执行
 *
 *  @param Sql sql
 */
- (void) executeSqlInBackground:(NSString *)sql;


- (void) exBackgroundQueue:(void (^)())queue;

- (void) exMainQueue:(void (^)())queue;


//- (void) executeUpdateSqlWithResult:(NSString *)sql sucess:(result_BOOL)suc;

@end
