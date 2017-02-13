//
//  DownLoadProgressView.h
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
@interface DownLoadProgressView : UIView
@property(nonatomic,strong) IBOutlet CERoundProgressView *progressView;
@property(nonatomic,strong) IBOutlet UIView *bgView;
@property(nonatomic,strong) IBOutlet UILabel *progressLabel;

@end
