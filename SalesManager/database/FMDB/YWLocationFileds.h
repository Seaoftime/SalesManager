//
//  YWLocationFileds.h
//  SalesManager
//
//  Created by sky on 14-1-25.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWLocationFileds : NSObject
@property (nonatomic, assign)NSInteger timeStampt;                              //定位时间
@property (nonatomic, copy) NSString* latitude;                        //经度
@property (nonatomic, copy) NSString* longtitude;                         //纬度

@end
