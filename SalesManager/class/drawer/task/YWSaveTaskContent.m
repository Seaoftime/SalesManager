//
//  YWSaveTaskContent.m
//  SalesManager
//
//  Created by 碧天 杨 on 13-12-20.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWSaveTaskContent.h"

@implementation YWSaveTaskContent


-(void)saveTaskContent:(NSDictionary* )taskDic{
    YTaskDBM* taskDb = [[YTaskDBM alloc]init];
    YTaskFieleds* taskFileds = [YTaskFieleds new];
    
    NSLog(@"%@",taskDic);
    
    taskFileds.taskTime = [[[taskDic objectForKey:@"list_info"] objectForKey:@"posttime"] integerValue];
    taskFileds.taskContent = [[taskDic objectForKey:@"list_info"] objectForKey:@"content"];
    taskFileds.taskFinishedContent = [[taskDic objectForKey:@"list_info"] objectForKey:@"endcontent"];
    taskFileds.taskEndTime = [[[taskDic objectForKey:@"list_info"] objectForKey:@"endtime"] integerValue];
//    taskFileds.timeStampContent = [[[taskDic objectForKey:@"list_info"] objectForKey:@"newstime"] integerValue];
//    taskFileds.timeStampList = [[[taskDic objectForKey:@"list_info"] objectForKey:@"newstime"] integerValue]; 
    [taskDb uploadTaskContent:taskFileds];
    
//    taskFileds.
}



-(void)saveTask:(YTaskFieleds* )taskFileds isNew:(BOOL)isNew{
    
    YTaskDBM* taskDb = [[YTaskDBM alloc]init];

    [taskDb uploadTaskContent:taskFileds];

}

@end
