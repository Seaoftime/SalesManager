//
//  YSignInFields.h
//  DataBaseClass
//
//  Created by sky on 13-11-27.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSignInFields : NSObject

//@property (nonatomic, copy)   NSString* autoIncremenID;              //存储在本地数据库自增的ID （做本地处理）
@property (nonatomic, assign) NSInteger upload;                      //是否同步
@property (nonatomic, copy)   NSString* signInID;                    //签到ID



@property (nonatomic, copy)   NSString* longitude;                   //经度
@property (nonatomic, copy)   NSString* latitude;                    //维度
@property (nonatomic, copy)   NSString* signInContent;               //签到备注
@property (nonatomic, assign) NSInteger signInTime;                  //签到时间
@property (nonatomic, copy)   NSString* signInTitle;                 //签到标题
@property (nonatomic, copy)   NSString* myLocation;                  //位置信息
@property (nonatomic, copy)   NSString* signInPersonID;                //汇报人

@end
