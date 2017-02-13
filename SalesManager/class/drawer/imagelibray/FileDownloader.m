//
//  FileDownloader.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "FileDownloader.h"


#define FILE_M [NSFileManager defaultManager]

#define NOTI_CENTER [NSNotificationCenter defaultCenter]



@implementation FileDownloader



- (id)initWithFile:(Video *)file
{
    self = [super init];
    if (self) {
        self.file = file;
    }
    
    return self;
}


- (void)createPathIfNotExeists
{
    //创建下载文件夹
    if (![FILE_M fileExistsAtPath:[Tools downloadPath]]) {
        [FILE_M createDirectoryAtPath:[Tools downloadPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //创建临时文件夹
    if (![FILE_M fileExistsAtPath:[Tools tempPath]]) {
        [FILE_M createDirectoryAtPath:[Tools tempPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



- (void)startDownload
{
    //下载之前，先保证下载路径存在
    [self createPathIfNotExeists];
    
    
    //self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.file.videoURL]];
    
    
    
    
    
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.file.videoURL]];
    [self.request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.mp4",[Tools downloadPath],self.file.videoName]];
    [self.request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@.mp4",[Tools tempPath],self.file.videoName]];
    //支持断点下载
    [self.request setAllowResumeForFileDownloads:YES];
    self.request.downloadProgressDelegate = self;
    
    
    __weak __typeof (self)weakSelf = self;
    
    
//
    if (self.request) {
        //
        [self.request setCompletionBlock:^{
            
            weakSelf.request = nil;
            [NOTI_CENTER postNotificationName:@"downloadFinishh" object:weakSelf];
            
            NSLog(@"---------------------------执行 下载器下载完成");
            //weakSelf.request = nil;
            
        }];
    }
//    [self.request setCompletionBlock:^{
//        
//        [NOTI_CENTER postNotificationName:@"downloadFinishh" object:weakSelf
//         ];
//        NSLog(@"---------------------------执行 下载器下载完成");
//        weakSelf.request = nil;
//        
//    }];
    
    [self.request startAsynchronous];
    
    [self.request setFailedBlock:^{
        
        weakSelf.request = nil;
    }];
    
    
//    //离开页面时停止下载
//    [NOTI_CENTER addObserver:self selector:@selector(stopRequestt) name:@"stopRequesting" object:nil];
    
    
    
}


- (void)stopRequestt
{
    
    [self.request clearDelegatesAndCancel];
    
}


- (void)cancelDownload
{
    //停止下载
    [self.request clearDelegatesAndCancel];
    self.request = nil;
}


- (BOOL)isDownloading
{
    if (self.request) {
        return YES;
    }else{
        return NO;
    }
}


- (void)setProgress:(float)newProgress{
    
    //每次获得新的下载进度后，需要把这个进度传给属于这个文件的button，但是UITableView中button可能会重用，所以不能用指针写死一个button的内存地址。所以通过通知的形式发送给所有button，让button自己去判断这个进度属不属于自己

    
//    if (self.delegate && [self respondsToSelector:@selector(setDownloadProgress:)]) {
//        [self.delegate setDownloadProgress:newProgress];
//    }
    
    [NOTI_CENTER postNotificationName:@"newProgresss" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:newProgress],@"progresss", nil]];
    
    
    //[NOTI_CENTER postNotificationName:@"wordnewProgresss" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:newProgress],@"wordprogresss", nil]];
    

    
}




/**
 *  Word
 */

//- (id)initWithWordFile:(Word *)wordFile
//{
//    self = [super init];
//    if (self) {
//        self.wordFile = wordFile;
//    }
//    
//    return self;
//}
//
//
//- (void)createWordPathIfNotExeists
//{
//    //创建下载文件夹
//    if (![FILE_M fileExistsAtPath:[Tools wordDownloadPath]]) {
//        [FILE_M createDirectoryAtPath:[Tools wordDownloadPath] withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    //创建临时文件夹
//    if (![FILE_M fileExistsAtPath:[Tools wordTempPath]]) {
//        [FILE_M createDirectoryAtPath:[Tools wordTempPath] withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//}
//
//
//
//- (void)startDownloadWord
//{
//    //下载之前，先保证下载路径存在
//    [self createWordPathIfNotExeists];
//    
//    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.wordFile.wordUrl]];
//    
//    [self.request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.word",[Tools wordDownloadPath],self.wordFile.wordName]];
//    
//    [self.request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@.word",[Tools wordTempPath],self.wordFile.wordName]];
//    
//    [self.request setAllowResumeForFileDownloads:YES];
//    
//    self.request.downloadProgressDelegate = self;
//    
//    __weak __typeof (self)weakSelf = self;
//    
//    //
//    if (self.request) {
//        //
//        [self.request setCompletionBlock:^{
//            
//            weakSelf.request = nil;
//            [NOTI_CENTER postNotificationName:@"worddownloadFinishh" object:weakSelf
//             ];
//            NSLog(@"---------------------------执行 下载器下载完成");
//            NSLog(@"---------------------------文档下载完成");
//            //weakSelf.request = nil;
//            
//        }];
//    }
//    
//    [self.request startAsynchronous];
//    
//    [self.request setFailedBlock:^{
//        weakSelf.request = nil;
//    }];
//    
//}
//
//
//- (void)cancelDownloadWord
//{
//    [self.request clearDelegatesAndCancel];
//    self.request = nil;
//}
//
//
//- (BOOL)isDownloadingWord
//{
//    if (self.request) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//







@end














