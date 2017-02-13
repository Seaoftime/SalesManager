//
//  initApp.m
//  baymax_marketing_iOS
//
//  Created by Sky on 16/1/26.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "initApp.h"
#import "YCreateDatabase.h"


@implementation initApp


+(void)appStart{
    [[GCDataBaseManager shareDatabase] openDataBaseWithDatabaseName:userDefaults.ID];
    [[[YCreateDatabase alloc]init] createDataBaseisManager:NO];
}

@end
