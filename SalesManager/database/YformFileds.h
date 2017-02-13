//
//  YformFileds.h
//  业务点点通IPad
//
//  Created by sm on 13-6-6.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YformFileds : NSObject
@property (nonatomic, copy)NSString* area;                              //模块
@property (nonatomic, assign) NSInteger sectionID;                        //样式种类
@property (nonatomic, copy)NSString* sectionTitle;
@property (nonatomic, assign) NSInteger formID;                         //项目ID
@property (nonatomic, copy)NSString* formName;                          //项目标题
@property (nonatomic, copy)NSString* formUnit;                          //项目单位
@property (nonatomic, copy)NSString* formType;                          //输入项目类型
@property (nonatomic, copy)NSString* formReferName;                     //项目标识
@property (nonatomic, assign)NSInteger need;                            //是否必填
@property (nonatomic, assign)NSInteger gps;                             //是否需求位置信息
@property (nonatomic, assign)NSInteger isReply;                         //是否需要回复
@property (nonatomic, assign)NSInteger overdue;                         //是否过期
@property (nonatomic, assign)NSInteger imageType;                       //图片类型
@property (nonatomic, copy)NSString* selectivity;                       //选择项目
@property (nonatomic, assign)NSInteger isImage;                         //是否需要上传图片
@property (nonatomic, assign)NSInteger idSort;                         //排序ID

@end
