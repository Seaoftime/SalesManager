//
//  TaskCell.h
//  SalesManager
//
//  Created by tianjing on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTaskFieleds;

@interface TaskCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UIImageView *portraitView;
@property (nonatomic,strong)IBOutlet UILabel *titleLable;


//@property (nonatomic,strong)IBOutlet RTLabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;




@property (nonatomic,strong)IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)NSString *taskIDD;
@property (nonatomic,assign)NSInteger toMe;
@property (nonatomic,assign)NSInteger hasDone;
@property (nonatomic,assign)NSInteger islocked;
@property (nonatomic,assign)NSInteger upload;
@property (weak, nonatomic) IBOutlet UIImageView *line;


@property (nonatomic, strong) YTaskFieleds *taskFields;



@end
