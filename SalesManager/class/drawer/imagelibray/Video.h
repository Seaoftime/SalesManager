//
//  Video.h
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  视频数据模型
 */
@interface Video : NSObject

@property (nonatomic,copy) NSString * videoName;
@property (nonatomic,copy) NSString * videoTime;
@property (nonatomic,copy) NSString * videoURL;
@property (nonatomic,copy) NSString * videoImage;

@end
