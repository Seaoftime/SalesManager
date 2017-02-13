//
//  YWLocationDBM.h
//  SalesManager
//
//  Created by sky on 14-1-25.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "baseDatabase.h"
#import "YWLocationFileds.h"

@interface YWLocationDBM : baseDatabase{
}




-(void)saveAnLocations:(YWLocationFileds* )locationFileds;

-(NSString* )getMyLocations;

-(void)cleanDatabase;


@end
