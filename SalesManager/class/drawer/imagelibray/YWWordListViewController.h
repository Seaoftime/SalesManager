//
//  YWWordListViewController.h
//  SalesManager
//
//  Created by TonySheng on 16/5/18.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWWordListViewController : UIViewController



//
@property (nonatomic, strong) NSMutableArray * remoteWords;
@property (nonatomic, strong) NSMutableArray * locationWords;

@property (nonatomic, strong) NSMutableDictionary * wordDownloaderManager;//下载管理器


@end
