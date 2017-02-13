//
//  YSignInDBM.h
//  业务点点通
//
//  Created by s k y on 12-12-23.
//  Copyright (c) 2012年 Sky. All rights reserved.
//

#import "baseDatabase.h"
#import "YSignInFields.h"

@interface YSignInDBM : baseDatabase{
}

/**
 * @brief 保存一条签到信息
 *
 * @param signIn 需要保存的签到数据
 */
- (void) saveSignIn:(YSignInFields *) signIn;


/**
 *  获取签到详情后，存储内容
 *
 *  @param signIn 传入SignInID和Content即可
 */
- (void) upLoadSignIn:(YSignInFields* )signIn;



/**
 *  修改签到的同步状态
 *
 *  @param signIn 传入的日志ID 和PostTime
 */


- (void)upload:(YSignInFields* )signIn;



/**
 *  查找定位信息
 *
 *  @param autoIncremenID 签到ID
 *  @param limit          范围
 *
 *  @return 包含对象的数组
 */
- (NSArray *) findWithSignInTime:(YSignInFields* )signIna limit:(int)limit;

/**
 *  查找所有未同步的签到数据
 *
 *  @return 找到的未同步的签到数据
 */
//-(NSArray *)findUpdata;
////查找未签到的数据

//删除一条签到数据
- (void) deleteSignInWithpostTime:(NSInteger ) signInTime;
/**
 *  清空数据库
 */
-(void) cleandataBase;


//通过上传时间获取到定位信息的URl

-(NSString* )getUnUploadDAtaUrl:(NSInteger )postTime;

- (YSignInFields *)getField:(NSInteger)postTime;

@end
