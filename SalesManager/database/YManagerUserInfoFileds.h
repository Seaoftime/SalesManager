//
//  YManagerUserInfoFileds.h
//  DataBaseClass
//
//  Created by sky on 13-11-13.
//  Copyright (c) 2013年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YManagerUserInfoFileds : NSObject


//@property (nonatomic, assign) NSInteger autoIncremenID;
@property (nonatomic, assign) NSInteger userID;                         //业务员ID
@property (nonatomic, copy) NSString* userName;                         //业务员名字
@property (nonatomic, copy) NSString* userPhoneNumber;                  //业务员手机号
@property (nonatomic, copy) NSString* userEMail;                        //业务员邮箱
@property (nonatomic, copy) NSString* userDepartmentID;                 //部门ID
@property (nonatomic, copy) NSString* userDepartmentName;               //部门ID
@property (nonatomic, copy) NSString* userPhotoUrl;                     //头像URl
@property (nonatomic, assign) NSInteger sex;                            //性别
@property (nonatomic, copy) NSString* position;                         //职位权限
@property (nonatomic, copy) NSString* positionTitle;                    //职位名称
@property (nonatomic, strong) NSString *pinYin;                         //姓名拼音

//v4
@property (nonatomic, strong) NSString* qqNumber;                       //QQ号码

//v5
@property (nonatomic, assign) NSInteger isCheck;                        //是否启用
@property (nonatomic, strong) NSString* nameSimplicity;                 //姓名简拼
@property (nonatomic, strong) NSString* nameFullSpelling;               //姓名全拼
@end
