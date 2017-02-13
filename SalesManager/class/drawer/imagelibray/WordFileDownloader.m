//
//  WordFileDownloader.m
//  SalesManager
//
//  Created by TonySheng on 16/5/19.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "WordFileDownloader.h"


#define FILE_M [NSFileManager defaultManager]

#define NOTI_CENTER [NSNotificationCenter defaultCenter]


@implementation WordFileDownloader




/**
 *  Word
 */

- (id)initWithWordFile:(Word *)wordFile
{
    self = [super init];
    if (self) {
        self.wordFile = wordFile;
    }
    
    return self;
}


- (void)createWordPathIfNotExeists
{
    //创建下载文件夹
    if (![FILE_M fileExistsAtPath:[Tools wordDownloadPath]]) {
        [FILE_M createDirectoryAtPath:[Tools wordDownloadPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //创建临时文件夹
    if (![FILE_M fileExistsAtPath:[Tools wordTempPath]]) {
        [FILE_M createDirectoryAtPath:[Tools wordTempPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



- (void)startDownloadWord
{
    //下载之前，先保证下载路径存在
    [self createWordPathIfNotExeists];
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.wordFile.wordUrl]];
    
    [self.request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.word",[Tools wordDownloadPath],self.wordFile.wordName]];
    
    [self.request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@.word",[Tools wordTempPath],self.wordFile.wordName]];
    
    [self.request setAllowResumeForFileDownloads:YES];
    
    self.request.downloadProgressDelegate = self;
    
    __weak __typeof (self)weakSelf = self;
    
    //
    if (self.request) {
        //
        [self.request setCompletionBlock:^{
            
            weakSelf.request = nil;
            [NOTI_CENTER postNotificationName:@"worddownloadFinishh" object:weakSelf
             ];
            NSLog(@"---------------------------执行 下载器下载完成");
            NSLog(@"---------------------------文档下载完成");
            //weakSelf.request = nil;
            
        }];
    }
    
    [self.request startAsynchronous];
    
    [self.request setFailedBlock:^{
        weakSelf.request = nil;
    }];
    
    
//    //
//    [NOTI_CENTER addObserver:self selector:@selector(stopRequest) name:@"stopWordRequesting" object:nil];
    
}

- (void)stopRequest
{

    [self cancelDownloadWord];


}


- (void)cancelDownloadWord
{
    [self.request clearDelegatesAndCancel];
    self.request = nil;
}


- (BOOL)isDownloadingWord
{
    if (self.request) {
        return YES;
    }else{
        return NO;
    }
}





- (void)setProgress:(float)newProgress
{

    [NOTI_CENTER postNotificationName:@"wordnewProgresss" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:newProgress],@"wordprogresss", nil]];

}



- (void)dealloc
{
    [NOTI_CENTER removeObserver:self];

}



@end
