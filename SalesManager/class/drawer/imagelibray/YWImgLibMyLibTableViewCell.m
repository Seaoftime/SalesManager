//
//  YWImgLibMyLibTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/5/10.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWImgLibMyLibTableViewCell.h"

@implementation YWImgLibMyLibTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
    [self.lineV setFrame:CGRectMake(0, self.lineV.frame.origin.y, kDeviceWidth, 0.5)];
    self.lineV.backgroundColor = [UIColor colorWithRed:200/255.f  green:199/255.f  blue:204/255.f alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //
       
}

@end
