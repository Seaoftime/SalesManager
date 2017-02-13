//
//  YTaskDBM.h
//  业务点点通
//
//  Created by Sky on 13-1-12.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "baseDatabase.h"
#import "YTaskFieleds.h"

@interface YTaskDBM : baseDatabase{
}

/**
 * @brief 保存一条用户记录
 *
 * @param task 需要保存的任务数据对象
 */
- (void) saveTask:(YTaskFieleds* ) task;

/**
 *  升级任务内容
 *
 *  @param task taskFileds对象  实现要求：必须传入两项value： upload  postTime
  *  @param 如果已经上传必须传入postTIme和ID 如果没只有传入POSTTIme

 */

- (void)uploadTaskContent:(YTaskFieleds* )task;

//同步后的升级

- (void) deleteTaskWithId:(NSString *) taskID;
- (void) deleteTaskWithTime:(NSInteger) taskTime;

//- (NSArray *) findWithSummaryId:(NSString *) SummaryId limit:(int) limit;
//-(NSArray *)findUpdata;
//查找未签到的数据
-(void) cleandataBase;
//清空summary数据
//-(NSArray *)findUnReadNotic;


/**
 *  升级任务ID
 *
 *  @param task taskFileds对象  实现要求：必须传入两项value： upload  postTime 和ID
 */
-(void)uploadTaskID:(YTaskFieleds *)task;
/**
 *  获取任务
 *
 *  @param taskTime 任务的时间
 *  @param taskID   任务的ID
 *  @param limit    长度
 * @param isMine NSInteger 1指派给我 0我指派的
 *      说明：如果有ID优先通过ID查找  如果没有则通过时间       ！！！！！！！如果请求列表  前两项都为空格
 *  @return 任务数组
 */
- (NSArray *)findautoIncremenID:(NSInteger )autoIncremenID limit:(int)limit isMine:(NSInteger)ismine;
- (NSInteger)findfieldwithtasktime:(NSInteger )tasktime;
- (NSInteger)findfieldAutoIDwithtaskId:(NSString*)taskid;
@end
