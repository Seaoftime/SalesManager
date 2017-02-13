//
//  YWErrorDBM.h
//  SalesManager
//
//  Created by sky on 14-1-9.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "baseDatabase.h"


@interface YWErrorDBM : baseDatabase{
}

/**
 *  保存一条错误信息
 *
 *  @param errorInfo 错误信息
 */
-(void)saveAnErrorInfo:(NSString* )errorInfo;

/**
 *  获取所有的错误信息
 *
 *  @return 错误信息 如果没有 返回空
 */
-(NSString* )getErrorinfo;

/**
 *  清空数据
 */
-(void)cleanDatabase;


@end
