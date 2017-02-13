//
//  baseDatabase.m
//  baymax_marketing_iOS
//
//  Created by sky on 15/12/17.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "baseDatabase.h"

@implementation baseDatabase

-(void)executeSql:(NSString* )sql{
    [[[GCDataBaseManager shareDatabase] databaseQueue]inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
        NSLog(@"%@",db.lastErrorMessage);
    }];
}

-(void)executeSqlInBackground:(NSString* )Sql{
    [self exBackgroundQueue:^{
        [self executeSql:Sql];
    }];
}

- (void)exBackgroundQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(0, 0), queue);
}



- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}


@end
