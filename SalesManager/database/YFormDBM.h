//
//  YFormDBM.h
//  业务点点通IPad
//
//  Created by sm on 13-6-6.
//  Copyright (c) 2013年 Sky. All rights reserved.
//
#import "baseDatabase.h"
#import "YformFileds.h"


@interface YFormDBM : baseDatabase{
        
}

/**
 * @brief 保存表单数据
 *
 * @param area 需要保存的表单数据
 */
- (void) saveArea:(YformFileds *)area;


/**
 *  获取section
 *
 *  @param area 填写信息汇报 后期可能增加类型
 *
 *  @return 信息汇报类型array
 */
- (NSArray *) getForm:(NSString *)area;

/**
 *  获取表单详细信息
 *
 *  @param area         填写信息汇报、后期可能增加类型
 *  @param sectionID    表单ID 和下者二填一即可
 *  @param sectionTitle 表单标题
 *
 *  @return 表单详细信息
 */
- (NSArray *) getFormDetails:(NSString *)area inSectionID:(NSInteger)sectionID orSectionTitle:(NSString* )sectionTitle check:(BOOL)YN;


-(int)getImageTypeBysectionID:(NSInteger )sectionID;


/**
 * @brief 检查表属性
 *
 * @param asd 需要检查的属性(gps/othersKey)    section 需要检查的表ID 或者title
 */

-(BOOL)checkWheatherNeed:(NSString* )gps InSectionID:(NSInteger )sectionID orSectionTitle:(NSString* )sectionTitle;



//清空表单数据
-(void)cleandataBase;
@end
