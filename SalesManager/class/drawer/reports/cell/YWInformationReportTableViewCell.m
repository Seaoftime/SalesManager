//
//  YWInformationReportTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/4/12.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWInformationReportTableViewCell.h"



@interface YWInformationReportTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *usrImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;





@end


@implementation YWInformationReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
