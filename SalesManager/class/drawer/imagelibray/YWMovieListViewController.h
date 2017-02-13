//
//  YWMovieListViewController.h
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWMovieListViewController : UIViewController

//2
@property (nonatomic,strong) NSMutableArray * remoteVideos;
@property (nonatomic,strong) NSMutableArray * localVideos;

@property (nonatomic,strong) NSMutableDictionary * downloaderManager;//下载管理器



+ (YWMovieListViewController *)sharedMovieListViewController;

@end
