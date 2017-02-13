//
//  YWReportDetailsReplyTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/4/12.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWReportDetailsReplyTableViewCell.h"

#import "YSummaryReplyFileds.h"
#import "YSummaryReplyDBM.h"
#import "YSummaryFields.h"


@interface YWReportDetailsReplyTableViewCell ()
{
    YSummaryReplyDBM *reportReplyDB;


}


@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;


@property (weak, nonatomic) IBOutlet UILabel *replyPeopleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;


@property(nonatomic, strong) YSummaryFields *summaryListField;//列表的显示数据



@end


@implementation YWReportDetailsReplyTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}


- (void)setReplyFields:(YSummaryReplyFileds *)replyFields
{
    
    
    self.replyContentLabel.text = replyFields.replyContent;
    
    
    CGRect frame = self.replyContentLabel.frame;

    frame.size.height = [TOOL getText:replyFields.replyContent MinHeightWithBoundsWidth:kDeviceWidth fontSize:17];
    [self.replyContentLabel setFrame:CGRectMake(self.replyContentLabel.frame.origin.x, self.replyContentLabel.frame.origin.y, self.replyContentLabel.frame.size.width, frame.size.height)];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate: [NSDate dateWithTimeIntervalSince1970:replyFields.replyDate]];
    
    self.replyPeopleLabel.text = [NSString stringWithFormat:@"%@  %@", replyFields.replyPerson, confromTimespStr];
    self.replyPeopleLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
    
    
    CGRect frame1 = self.replyContentLabel.frame;
    self.replyPeopleLabel.frame = CGRectMake(self.replyPeopleLabel.frame.origin.x, frame1.origin.y + frame1.size.height + 5, self.replyPeopleLabel.frame.size.width, self.replyPeopleLabel.frame.size.height);
    frame1 = self.frame;
    [self setFrame:CGRectMake(frame1.origin.x, frame1.origin.y, frame1.size.width, self.replyPeopleLabel.frame.origin.y + self.replyPeopleLabel.frame.size.height + 10)];
    
    
    
    //[self.replyContentLabel sizeToFit];

    [self.replyPeopleLabel sizeToFit];

}







- (void)awakeFromNib {
    // Initialization code
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}





@end
