//
//  YTaskFieleds.h
//  业务点点通
//
//  Created by Sky on 13-1-12.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTaskFieleds : NSObject


@property (nonatomic, assign) NSInteger autoIncremenID;
@property (nonatomic, assign) NSInteger isRead;                       //是否已读 本地数据
@property (nonatomic, copy) NSString* taskID;                       //任务ID
@property (nonatomic, copy) NSString* taskTitle;                        //任务标题
@property (nonatomic, assign) NSInteger taskTime;                     //任务发布时间
@property (nonatomic, assign) NSInteger taskFinishedTime;             //任务完成的时间
@property (nonatomic, copy) NSString* taskContent;                      //任务内容
@property (nonatomic, assign) NSInteger taskWhetherFinished;          //任务是否完成
@property (nonatomic, copy) NSString* taskTo;                           //任务对象
@property (nonatomic, assign) NSInteger taskLocked;                   //是否锁定
@property (nonatomic, assign) NSInteger taskEndTime;                  //任务要求完成时间
@property (nonatomic, copy) NSString* taskFinishedContent;              //任务完成说明

@property (nonatomic, assign) NSInteger upLoad;                       //是否已上传
//更新列表只更改timeStampList  更新内容两个时间同时替换  做数据是否最新判断
@property (nonatomic, assign) NSInteger timeStampList;                //通知列表更新时间
@property (nonatomic, assign) NSInteger timeStampContent;             //通知内容更新时间


@property (nonatomic, assign) NSInteger isMine;                       //是否我发送
@property (nonatomic, copy) NSString* taskFromPersonID;               //发送任务人ID
@property (nonatomic, copy) NSString* taskFromPersonName;              //发送人
@property (nonatomic,copy) NSString *toPersonID;
@property(nonatomic,copy) NSString *toPersonName;
//@property (nonatomic, copy) NSString*



@end
