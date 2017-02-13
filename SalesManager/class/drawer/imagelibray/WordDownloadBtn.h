//
//  WordDownloadBtn.h
//  SalesManager
//
//  Created by TonySheng on 16/5/18.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Word.h"
//#import "FileDownloader.h"
#import "Tools.h"
#import "WordFileDownloader.h"

@interface WordDownloadBtn : UIButton

typedef NS_ENUM(NSInteger, ButtonState){
    ButtonNormal,
    ButtonDownloading,
    ButtonPause,
    ButtonComplete,
};




@property (nonatomic, strong) UIView  *coverView;

@property (nonatomic, assign) ButtonState downloadState;

@property (nonatomic, assign) float wordProgress;

@property (nonatomic, strong) Word  *wordFile;

@property (nonatomic, strong) WordFileDownloader *fileDownloader;




@end
