//
//  YWWordListTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/5/18.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWWordListTableViewCell.h"

#define lineColor  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]



@implementation YWWordListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5, kDeviceWidth, 0.5)];
    lineV.backgroundColor = lineColor;
    [self addSubview:lineV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
