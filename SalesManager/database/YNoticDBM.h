//
//  YNoticDBM.m
//  业务点点通
//
//  Created by Sky on 13-11-07.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "baseDatabase.h"
#import "YNoticFileds.h"

@interface YNoticDBM : baseDatabase{
}

/**
 * @brief 保存一条通知
 *
 * @param notic 需要保存的通知数据对象
 * @param success 如果网络保存为真  发布后保存为NO
 */
- (void) saveNotic:(YNoticFileds* ) notic success:(BOOL)success;

/**
 * @brief 同步后的升级
 *
 * @param notic 需要升级的通知数据对象
 */
//升级详情内容
-(void)upLoadNoticContent:(YNoticFileds *)notic;


/**
 *  给通知添加ID
 *
 *  @param noticID           日志ID
 *  @param upLoadTime        服务器最后操作时间
 *  @param uploadNoticIsread 服务器最后操作时间
 *  @param notic             日志的日期
 */
//-(void)upDateNoticID:(NSString* )noticID upLoadTime:(int)upLoadTime noticDate:(int)noticDate;


/**
 *  修改通知的同步状态
 *
 *  @param notic 传入的id、PostTime 、upload
 */
- (void)upload:(YNoticFileds* )notic;


/**
 *  查找通知信息
 *
 *  @param autoIncremenID 通知时间
 *  @param limit          范围
 *
 *  @return 包含对象的数组
 */
- (NSArray *)findWithNoticeTime:(int)noticeTime limit:(int)limit;




//标记已读
- (void)uploadNoticIsread:(YNoticFileds* )notic;

/**
 * @brief 删除一条通知
 *
 * @param noticID 需要删除的通知的id
 */
- (void) deleteNoticWithId:(int) noticDate;


/**
 * @brief 获取列表数据
 * @param noticID 通知的ID
 * @param limit 每页取多少个
 * @param 如果获取单条通知只需要ID 如果获取列表NoticID为nil 
 */
- (NSArray *) findWithNoticID:(NSString *) noticID limit:(int) limit;


//清空数据
-(void) cleandataBase;

//-(NSArray *)findUnReadNotic;

- (void) deleteNoticeWithTime:(NSInteger) noticeDate;//根据发送时间删除未发送成功的通知

- (void) deleteNoticWithNoticeId:(NSString*) noticID;
@end
