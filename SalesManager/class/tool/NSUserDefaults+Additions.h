//
//  NSUserDefaults+Additions.h
//  业务员管家iPhone
//
//  Created by Kris on 13-11-1.
//  Copyright (c) 2013年 郑州悉知信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Additions)

@property (nonatomic, strong, setter = setCompanyCode:, getter = companyCode) NSString *companyCode;//公司编码
@property (nonatomic, strong, setter = setUserName:, getter = userName) NSString *userName;         //用户名
//@property (nonatomic, strong, setter = setPassword:, getter = password) NSString *password;         //密码
@property (nonatomic, strong, setter = setRandCode:, getter = randCode) NSString *randCode;         //验证随机码
@property (nonatomic, strong, setter = setName:, getter = name) NSString *name;                     //名字
@property (nonatomic, strong, setter = setID:, getter = ID) NSString *ID;                           //id
//@property (nonatomic, strong, setter = setCompanyName:, getter = companyName) NSString *companyName;//公司名字
//@property (nonatomic, strong, setter = setDepartment:, getter = department) NSString *department;   //部门
//@property (nonatomic, strong, setter = setMobile:, getter = mobile) NSString *mobile;               //手机号
//@property (nonatomic, strong, setter = setLogoURL:, getter = logoURL) NSString *logoURL;            //图标url
@property (nonatomic, strong, setter = setPosition:, getter = position) NSString *position;             //职位
@property (nonatomic, strong, setter = setHDImage:, getter = hdImage) NSString *hdImage;                //非wifi高清图片
@property (nonatomic, strong, setter = setMapWithWifi:, getter = mapWithWifi) NSString *mapWithWifi;    //非wifi显示地图
@property (nonatomic, strong, setter = setDepartMentID:, getter = departMentID) NSString *departMentID;    //部门ID
//@property (nonatomic, strong, setter = setMyPhotoUrl:, getter = myPhotoUrl) NSString *myPhotoUrl;   //我的头像Logo
//@property (nonatomic, strong, setter = setSex:, getter = sex) NSString *sex;                        //我的性别
//@property (nonatomic, strong, setter = setUserVersion:, getter = userVersion) NSString* userVersion;//用户列表版本

//@property (nonatomic, strong, setter = setDefaultReciveSummaryPerson:, getter = defaultReciveSummaryPerson) NSString* defaultReciveSummaryPerson;//用户列表版本

@property (nonatomic, strong, setter = setHomePage:, getter = homepage) NSMutableArray *homepage;//首页数据


@property (nonatomic, strong, setter = setDataBaseVersion:, getter = dataBaseVersion) NSString* dataBaseVersion;//用户列表版本

@end
