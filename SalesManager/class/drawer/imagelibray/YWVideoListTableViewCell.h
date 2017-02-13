//
//  YWVideoListTableViewCell.h
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownLoadBtn.h"

@interface YWVideoListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *videoNameLb;

@property (weak, nonatomic) IBOutlet UILabel *videoTimeLb;

@property (weak, nonatomic) IBOutlet UIButton *onlineWatchBtn;

@property (weak, nonatomic) IBOutlet DownLoadBtn *downloadBtn;




//- (void)showData:(NSDictionary *)data;



@end
