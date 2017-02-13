//
//  WordDownloadBtn.m
//  SalesManager
//
//  Created by TonySheng on 16/5/18.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "WordDownloadBtn.h"

#define NOTI_CENTER [NSNotificationCenter defaultCenter]



@implementation WordDownloadBtn

- (void)awakeFromNib
{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, self.frame.size.height)];
    self.coverView.userInteractionEnabled = NO;
    
    self.coverView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.coverView];
    
    [NOTI_CENTER addObserver:self selector:@selector(wordhasNewProgress:) name:@"wordnewProgresss" object:nil];
    
    [NOTI_CENTER addObserver:self selector:@selector(worddownloadFinish:) name:@"worddownloadFinishh" object:nil];
    
}

- (void)worddownloadFinish:(NSNotification *)noti
{
    if (self.fileDownloader == noti.object) {
        //如果是，就设置新进度
        self.downloadState = ButtonComplete;
    }
}

- (void)wordhasNewProgress:(NSNotification *)noti
{
    //判断这个通知是否是属于自己的下载器发送的。
    if (self.fileDownloader == noti.object) {
        //如果是，就设置新进度
        float wordprogress = [[noti.userInfo objectForKey:@"wordprogresss"] floatValue];
        
        self.wordProgress = wordprogress;
    }
}

- (void)setDownloadState:(ButtonState)downloadState
{
    _downloadState = downloadState;
    switch (downloadState) {
        case ButtonNormal:
        {
            self.wordProgress = 0;
            [self setTitle:@"下载" forState:UIControlStateNormal];
            //[self setBackgroundColor:[UIColor blueColor]];
            [self setBackgroundColor:[UIColor whiteColor]];
            
        }
            break;
        case ButtonDownloading:
        {
            [self setTitle:@"下载中" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithRed:1/255.0 green:119/255.0 blue:249/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case ButtonPause:
        {
            
            //            NSDictionary *attr = [FILE_M attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",[Tools tempPath],self.file.videoName] error:nil];
            //            unsigned long long tempSize = [attr fileSize];
            //self.progress = (double)tempSize/(double)[self.file.length longLongValue];
            self.wordProgress = 1;
            [self setTitle:@"继续下载" forState:UIControlStateNormal];
            //
            [self setTitleColor:[UIColor colorWithRed:1/255.0 green:119/255.0 blue:249/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor whiteColor]];
        }
            break;
        case ButtonComplete:
        {
            self.wordProgress = 1;
            //            [self setTitle:@"查看" forState:UIControlStateNormal];
            [self setTitle:@"本地查看" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [self setBackgroundColor:[UIColor greenColor]];
            [self setBackgroundColor:[UIColor colorWithRed:13/255.0 green:112/255.0 blue:188/255.0 alpha:1.0]];
            
        }
            break;
            
        default:
            break;
    }
}



- (void)setWordProgress:(float)wordProgress
{
    _wordProgress = wordProgress;
    self.coverView.frame = CGRectMake(120 * wordProgress, 0, 120 * (1-wordProgress), 30);
    [self setTitle:[NSString stringWithFormat:@"%.f%%",wordProgress*100] forState:UIControlStateNormal];

}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}





@end
