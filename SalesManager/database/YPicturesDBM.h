//
//  YPicturesDBM.h
//  业务点点通
//
//  Created by Sky on 13-1-16.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "baseDatabase.h"
#import "YPcituresFileds.h"

@interface YPicturesDBM : baseDatabase{
}

/**
 *  存储一条数据
 *
 *  @param picture 数据内容
 *  @param pic     YES 图片信息  NO相册信息
 */
-(void)saveAlbumOrPhotos:(YPcituresFileds *)picture isPicture:(BOOL)pic;

//同步后的升级

//- (void) deleteTaskWithId:(NSString *) taskID;

- (NSArray *) findWithautoIncremenID:(NSString *) autoIncremenID limit:(int) limit;
- (NSArray *) findWithAllPhotos:(NSString *) autoIncremenID limit:(int) limit;

- (NSArray *) findWithAlbumID:(NSInteger ) albumID limit:(int) limit;
//- (NSArray *) findWithSummaryId:(NSString *) SummaryId limit:(int) limit;
//-(NSArray *)findUpdata;
//查找未签到的数据
-(void) cleandataBase;          //删除数据库


-(void) cleanListData;
-(void)cleanAlbum:(NSInteger )albumID;

@end
