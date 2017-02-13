//
//  YUserInfomationDBM.h
//  SalesManager
//
//  Created by sky on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "baseDatabase.h"
#import "YuserInfomationFileds.h"


@interface YUserInfomationDBM : baseDatabase{
}

/**
 *  保存一条用户信息
 *
 *  @param userInfo 用户信息
 */
-(void)saveUserInfomations:(YuserInfomationFileds* )userInfo;
/**
 *  更新图片Url
 *
 *  @param userInfo 用户信息
 */
-(void)uploadPhotoUrl:(YuserInfomationFileds* )userInfo;


-(void)upLoadVersions:(YuserInfomationFileds* )userInfo;

/**
 *  获取用户资料
 *
 *  @param userName 用户名
 *  @param comCode  用户所在公司ID
 *
 *  @return 用户信息
 */

-(YuserInfomationFileds* )getUSerInfomations:(NSString* )userID :(NSString* )comCode;

@end
