//
//  YNoticDBM.m
//  业务点点通
//
//  Created by Sky on 13-11-07.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNoticFileds : NSObject

//@property (nonatomic, copy) NSString* autoIncremenID;               //数据自增ID


@property (nonatomic, copy)   NSString* noticID; //通知ID
@property (nonatomic, copy)   NSString* noticTitle; //通知标题
@property (nonatomic, assign) NSInteger   noticDate; //通知时间
@property (nonatomic, assign) NSInteger   noticIsread; //通知是否已读
@property (nonatomic, copy)   NSString* noticContent; //通知内容
@property (nonatomic, assign) NSInteger   upLoad; //是否上传成功


@property (nonatomic, copy)   NSString *wordpptUrl;//附件 Url



//更新列表只更改timeStampList  更新内容两个时间同时替换  做数据是否最新判断
//@property (nonatomic, assign) NSInteger   timeStampList; //通知列表更新时间
//@property (nonatomic, assign) NSInteger   timeStampContent; //通知内容更新时间




@property (nonatomic, assign)  NSInteger isMine;

//管理端
//@property (nonatomic, copy)   NSString* toDepartmentArray;       //通知部门内容
@property (nonatomic, copy)   NSString* toDepartmentName;     //通知部门名称
@property (nonatomic, copy)   NSString* toPersonName;        //通知人员名称
@property (nonatomic, copy)   NSString* toDepartmentID;     //通知部门ID
@property (nonatomic, copy)   NSString* toPersonID;        //通知人员ID
@property (nonatomic, copy)   NSString* fromUserID;         //发送人员ID
@property (nonatomic, copy)   NSString* fromUserName;         //发送人员名字




@end
