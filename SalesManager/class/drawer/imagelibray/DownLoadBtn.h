//
//  DownLoadBtn.h
//  Video
//
//  Created by User on 15/12/10.
//  Copyright © 2015年 FJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "FileDownloader.h"
#import "Tools.h"

@interface DownLoadBtn : UIButton//<FileDownLoadDelegate>

typedef NS_ENUM(NSInteger, ButtonState){
    ButtonNormal,
    ButtonDownloading,
    ButtonPause,
    ButtonComplete,
};




@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) ButtonState downloadState;

@property (nonatomic, assign) float progress;

@property (nonatomic, strong) Video *file;

@property (nonatomic, strong) FileDownloader *fileDownloader;


@end
