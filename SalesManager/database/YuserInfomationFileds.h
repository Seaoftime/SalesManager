//
//  YuserInfomationFileds.h
//  SalesManager
//
//  Created by sky on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuserInfomationFileds : NSObject
@property (nonatomic, copy) NSString* userID;                   //用户ID
@property (nonatomic, copy) NSString* name;                     //用户名字
@property (nonatomic, copy) NSString* companyCode;              //公司编码
@property (nonatomic, copy) NSString* userName;                 //登陆用户名
@property (nonatomic, copy) NSString* password;                 //密码
@property (nonatomic, copy) NSString* randCode;                 //随机数
@property (nonatomic, copy) NSString* companyName;              //公司名称
@property (nonatomic, copy) NSString* department;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* logoURL;
@property (nonatomic, copy) NSString* userPicUrl;
@property (nonatomic, copy) NSString* positionName;             //职位名称
@property (nonatomic, assign) NSInteger position;               //是否管理
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger albumVersion;           //图库版本
@property (nonatomic, assign) NSInteger formVersion;            //表单版本
//@property (nonatomic, assign) NSInteger optionsVersion;         //选项版本
@property (nonatomic, assign) NSInteger userVersion;            //人员版本
@property (nonatomic, assign) NSInteger hdImage;                //非Wifi上传高清图片
@property (nonatomic, assign) NSInteger mapWithWifi;            //非Wifi显示地图




@end
