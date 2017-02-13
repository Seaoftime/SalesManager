//
//  YSummaryFields.h
//  业务点点通
//
//  Created by Sky on 12-12-12.
//  Copyright (c) 2012年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSummaryFields : NSObject

//@property (nonatomic, assign) NSInteger autoIncremenID;                   //存储在本地数据库自增的ID （做本地处理）
@property (nonatomic, copy) NSString* summaryId;                            //上传成功后返回的日志ID
@property (nonatomic, assign) NSInteger postTime;                           //上传日志的时间
//@property (nonatomic, assign) NSInteger summaryDate;                        //日志的日期
@property (nonatomic, copy) NSString* summaryTitle;                         //日志标题
@property (nonatomic, copy) NSString* myLocation;                           //位置信息
@property (nonatomic, assign)NSInteger replyNum;                           //回复条数
@property (nonatomic, assign)NSInteger isMine;                             //是否是我发送的
@property (nonatomic, copy) NSString* summaryPreview;                      //预览
//时间对比
@property (nonatomic, assign) NSInteger timeStampList;                      //判断是否有新批复内容 -- 列表
@property (nonatomic, assign) NSInteger timeStampContent;                   //判断是否有新批复内容 -- 详情
@property (nonatomic, assign) NSInteger upload;                             //是否上传成功   0未成功 1成功
/*
 是否查阅
 */
@property (nonatomic, assign) NSInteger isread;                             //是否阅读
@property (nonatomic, assign) NSInteger isreply;                            //是否审批
/*
 日志内容
 */
@property (nonatomic, assign) NSInteger sectionID;                          //汇报类型ID
@property (nonatomic, copy) NSString* formName;                             //汇报表单Key
@property (nonatomic, copy) NSString* formValue;                            //汇报内容
@property (nonatomic, copy) NSString* reciver;                              //接收人
@property (nonatomic, copy) NSString* reciverID;                            //接收人ID
@property (nonatomic, copy) NSString* senderName;                           //发送人
@property (nonatomic, copy) NSString* senderUserID;                         //发送人ID
@property (nonatomic, copy) NSString* photoUrl;                             //图片地址
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic, copy) NSString* latitude;                             //经纬度



@end
