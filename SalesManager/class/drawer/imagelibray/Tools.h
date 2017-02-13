//
//  Tools.h
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Video.h"
#import "Word.h"

@interface Tools : NSObject

/**
 *  Video 视频
 */

//文件下载路径(下载完)
+ (NSString *)downloadPath;

//临时下载路径（临时存放）
+ (NSString *)tempPath;

//判断一个文件是否下载完毕
+ (BOOL)isDownloadFinish:(Video *)file;

//判断一个文件是否下了一部分
+ (BOOL)isFileDownloading:(Video *)file;

+ (NSString *)getFilePath;

//自定义的数据对象归档路径
+ (NSString *)getCustomModelFilePath:(Video*)file;


/**
 *  Word 文档
 */

//
+ (NSString *)wordDownloadPath;

//
+ (NSString *)wordTempPath;

//
+ (BOOL)wordIsDownloadFinish:(Word *)file;

//
+ (BOOL)wordIsFileDownloading:(Word *)file;
//
+ (NSString *)wordGetFilePath;

//自定义的数据对象归档路径
+ (NSString *)wordGetCustomModelFilePath:(Word *)file;


@end
