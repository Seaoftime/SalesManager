//
//  YManagerUserInfoDBM.h
//  DataBaseClass
//
//  Created by sky on 13-11-13.
//  Copyright (c) 2013年 sky. All rights reserved.
//


#import "baseDatabase.h"


@class YManagerUserInfoFileds;


@interface YManagerUserInfoDBM : baseDatabase{
}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的任务数据对象
 */
- (void) saveUser:(YManagerUserInfoFileds* ) user;


/**
 * @brief 保存一条部门数据
 *
 * @param user 需要保存的部门对象
 */

-(void)saveDepartment:(YManagerUserInfoFileds* )user;


/**
 * @brief 查询匹配人员
 *
 * @param likeString 匹配的字符串穿
 */
-(NSArray *)checkUserInfoByString:(NSString* )likeString;

/**
 * @brief 查找人员信息
 *
 * @param departmentID 需要返回的部门ID
 * @param departmentID为Nil 返回全部人员
 *
 * @param SortbyGroup 是否按组返回
 * @param sort YES按组返回 NO全部返回
 *
 * @param info 是否需要详细信息
 * @param info YES返回详细信息 NO只返回名字和ID
 *
 * @param status 是否过滤停用账号
 * @param status YES过滤 NO不过滤
 */
- (NSArray *) findWithDepartmentID:(NSString *)departmentID SortbyGroup:(BOOL)sort withInfo:(BOOL)info Status:(BOOL)status withMe:(BOOL)me;

///**
// * @brief 查找详细人员信息
// *
// * @param userID 需要查找的人员信息
// */
//- (YManagerUserInfoFileds* )getUserInfo:(NSString* )userID;


//清空summary数据
-(void) cleandataBase;

/**
 *  通过用户ID查找相关信息  (默认包含名字)
 *
 *  @param userID 用户ID
 *
 *  @return 用户信息对象
 */

-(YManagerUserInfoFileds* )getPersonInfoByUserID:(NSInteger )userID withPhotoUrl:(BOOL)photoUrl withDepartment:(BOOL)department withContacts:(BOOL)contacts;


-(void)upLoadMyPicture:(YManagerUserInfoFileds* )userInfo;

-(NSArray* )getManagersMembersIDByMyDepartMent;

@end


