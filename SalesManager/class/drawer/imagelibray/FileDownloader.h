//
//  FileDownloader.h
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"
#import "Tools.h"
#import "ASIHTTPRequest.h"
//
#import "Word.h"

//@protocol FileDownLoadDelegate <NSObject>
//
//- (void) setDownloadProgress:(CGFloat)progress;
//
//@end


@interface FileDownloader : NSObject<ASIProgressDelegate>


@property (nonatomic, strong) Video  *file;
//@property (nonatomic, strong) Word  *wordFile;
//
@property (nonatomic, strong) ASIHTTPRequest *request;

//@property (nonatomic, assign) id<FileDownLoadDelegate>delegate;


/**
 *  视频
 */
//初始化方法，把需要下载的文件对象传进来
- (id)initWithFile:(Video *)file;

//开始下载
- (void)startDownload;

//取消下载
- (void)cancelDownload;

//是否正在下载
- (BOOL)isDownloading;


///**
// *  文档
// */
//
//- (id)initWithWordFile:(Word *)wordFile;
//
//- (void)startDownloadWord;
//
//- (void)cancelDownloadWord;
//
//- (BOOL)isDownloadingWord;

@end








