//
//  DownLoadBtn.m
//  Video
//
//  Created by User on 15/12/10.
//  Copyright © 2015年 FJY. All rights reserved.
//

#import "DownLoadBtn.h"


#define NOTI_CENTER [NSNotificationCenter defaultCenter]



@implementation DownLoadBtn

- (void)awakeFromNib{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, self.frame.size.height)];
    self.coverView.userInteractionEnabled = NO;
    
    self.coverView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.coverView];
    
    [NOTI_CENTER addObserver:self selector:@selector(hasNewProgress:) name:@"newProgresss" object:nil];
    
    [NOTI_CENTER addObserver:self selector:@selector(downloadFinish:) name:@"downloadFinishh" object:nil];
    
}




- (void)downloadFinish:(NSNotification *)noti
{
    if (self.fileDownloader == noti.object) {
        //如果是，就设置新进度
        self.downloadState = ButtonComplete;
    }
}


//- (void)setDownloadProgress:(CGFloat)progress
//{
////    //判断这个通知是否是属于自己的下载器发送的。
////    if (self.fileDownloader == noti.object) {
////        //如果是，就设置新进度
////        float progress = [[noti.userInfo objectForKey:@"progresss"] floatValue];
//        self.progress = progress;
////    }
//}

- (void)hasNewProgress:(NSNotification *)noti
{
    if (self.fileDownloader == noti.object) {
        //如果是，就设置新进度
        float progress = [[noti.userInfo objectForKey:@"progresss"] floatValue];
        
        self.progress = progress;
    }



}







- (void)setDownloadState:(ButtonState)downloadState
{
    _downloadState = downloadState;
    switch (downloadState) {
        case ButtonNormal:
        {
            self.progress = 0;
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
            self.progress = 1;
            [self setTitle:@"继续下载" forState:UIControlStateNormal];
            //
            [self setTitleColor:[UIColor colorWithRed:1/255.0 green:119/255.0 blue:249/255.0 alpha:1.0] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor whiteColor]];
        }
            break;
        case ButtonComplete:
        {
            self.progress = 1;
//            [self setTitle:@"查看" forState:UIControlStateNormal];
            [self setTitle:@"本地播放" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [self setBackgroundColor:[UIColor greenColor]];
            [self setBackgroundColor:[UIColor colorWithRed:13/255.0 green:112/255.0 blue:188/255.0 alpha:1.0]];

        }
            break;
            
        default:
            break;
    }
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    self.coverView.frame = CGRectMake(120 * progress, 0, 120 * (1-progress), 30);
    [self setTitle:[NSString stringWithFormat:@"%.f%%",progress*100] forState:UIControlStateNormal];
    
}

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];


}


@end
