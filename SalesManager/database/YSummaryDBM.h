//
//  YSummaryDBM.h
//  业务点点通
//
//  Created by s k y on 12-12-23.
//  Copyright (c) 2012年 Sky. All rights reserved.
//

#import "baseDatabase.h"
#import "YSummaryFields.h"

@interface YSummaryDBM : baseDatabase{
}



/**
 *  保存一条信息汇报记录
 *
 *  @param summary 信息汇报对象
 *  @param success 是否上传成功
 */
- (void) saveSummaryList:(YSummaryFields *) summary;

/**
 *  保存一条信息汇报记录
 *
 *  @param summary 信息汇报单条对象  只传入日志ID  postTime formNAme  formValue
 */
- (void) saveSummaryContent:(YSummaryFields *) summary;


/**
 *  新增日志赋值ID
 *
 *  @param summaryID 传入的日志ID
 *  @param postTime 日志上传时间
 */
- (void)upDataSummaryID:(int)summaryID withPostTime:(int)postTime;

/**
 *  新增日志赋值ID
 *
 *  @param summaryID 传入的日志ID
 *  @param postTime 日志上传时间
 */


//删除一条信息汇报
- (void) deleteSummaryWithpostTime:(NSInteger ) postTime;


/**
 *  查找信汇报
 *
 *  @param summaryID      日志ID 如果为空 则为查找列表数据
 *  @param limit          长度
 *
 *  @return 返回的数组
 */
/**
 *
 *
 *  @param summaryID 日志的ID
 *  @param postTime  日志的日期
 *  @param sectionId 日志的表单类型ID
 *  @param limit     长度
 *  @param userID    需要查找的用户ID
 *
 *  @return 数组
 */
- (NSArray *) findWithsummaryID:(NSString *)summaryID BySummaryDate:(NSInteger )summaryDate inSectionID:(NSInteger )sectionId limit:(int) limit byUserID:(NSInteger )userID;
/**
 *  保存日志的图片URl
 *
 *  @param photoUrl 图片的Url
 *  @param postTime 信息汇报的上传时间
 */
-(void)savePhotoUrl:(NSString* )photoUrl byPostTime:(NSInteger )postTime;


/**
 *  获取信息汇报的详情
 *
 *  @param postTime 信息汇报上传时间
 *
 *  @return 内容以字典形式返回
 */
- (NSDictionary *) findWithsummaryPostTime:(NSInteger) postTime;


/**
 *  查找信息汇报的图片地址
 *
 *  @param postTime 信息汇报的上传时间
 *
 *  @return 信息汇报的图片地址数组
 */
-(NSArray* )findPhotoUrlWithPostTime:(NSInteger )postTime;

//清空summary数据
-(void)cleandataBase;


- (void)upload:(YSummaryFields* )summary;

@end

