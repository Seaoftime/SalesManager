//
//  TaskCell.m
//  SalesManager
//
//  Created by tianjing on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "TaskCell.h"


#import "YTaskFieleds.h"

@implementation TaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



//- (void)setTaskFields:(YTaskFieleds *)taskFields
//{
//    //_taskFields = taskFields;
//    
////    self.contentLable.textColor = SMALLTITLECOLOR;
////    self.taskIDD = taskFields.taskID;
////    self.titleLable.text = [NSString stringWithFormat:@"%@",taskFields.taskTo];
////    self.contentLable.text = taskFields.taskTitle;
//
//
////    self.hasDone = taskFields.taskWhetherFinished;
////    self.toMe = taskFields.isMine;
////    self.islocked = taskFields.taskLocked;
//
//    self.line.frame = CGRectMake(0, 50.5f, 320, .5f);
//
//}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.titleLable.textColor = BIGTITLECOLOR;
    self.contentLable.font =[UIFont systemFontOfSize:15];
    self.timeLabel.textColor = SMALLTITLECOLOR;
    self.portraitView.layer.cornerRadius = 5.0;
   // self.portraitView.layer.borderWidth = 0.3;
    [self.portraitView setClipsToBounds:YES];
    self.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
    
    [self.line setFrame:CGRectMake(0, self.line.frame.origin.y, kDeviceWidth, 0.6)];
    
}

@end
