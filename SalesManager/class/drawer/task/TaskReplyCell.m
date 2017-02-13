//
//  TaskReplyCell.m
//  SalesManager
//
//  Created by tianjing on 14-3-11.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "TaskReplyCell.h"

#import "YSummaryReplyFileds.h"

@implementation TaskReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //if(IS_IOS7)
      //  [self.contentView addSubview:self.replyContent];
    // Configure the view for the selected state
}


- (void)setFileds:(YSummaryReplyFileds *)fileds
{
    self.replyContent.text = [NSString stringWithFormat:@" %@",fileds.replyContent];
    self.replyContent.font = [UIFont systemFontOfSize:17];
    
    //self.replyContent.frame = CGRectMake(self.replyContent.frame.origin.x, self.replyContent.frame.origin.y, 290.0, self.replyContent.frame.size.height);
//    CGRect frame = self.replyContent.frame;
//    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, frame.origin.y + frame.size.height, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:fileds.replyDate]];
    self.nameLabel.text = [NSString stringWithFormat:@" %@  %@",fileds.replyPerson,confromTimespStr];
    
    self.nameLabel.font = [UIFont systemFontOfSize:15];
//    frame = self.frame;
//    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height +9)];

    //
    CGRect frame1 = self.replyContent.frame;
    frame1.size.height = [TOOL getText:fileds.replyContent MinHeightWithBoundsWidth:kDeviceWidth- 24 fontSize:17];
    [self.replyContent setFrame:CGRectMake(self.replyContent.frame.origin.x, self.replyContent.frame.origin.y, self.replyContent.frame.size.width, frame1.size.height)];
    
    
    CGRect frame = self.replyContent.frame;
    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, frame.origin.y + frame.size.height + 5, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    frame = self.frame;
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10)];


}



@end
