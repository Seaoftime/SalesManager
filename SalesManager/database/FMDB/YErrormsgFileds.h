//
//  YErrormsgFileds.h
//  SalesManager
//
//  Created by sky on 14-1-8.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YErrormsgFileds : NSObject
@property (nonatomic, copy) NSString* errorFun;             //报错方法
@property (nonatomic, assign) NSInteger timeStamp;               //报错时间
@end
