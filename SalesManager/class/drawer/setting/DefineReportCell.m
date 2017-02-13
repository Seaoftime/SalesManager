//
//  DefineReportCell.m
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "DefineReportCell.h"

@implementation DefineReportCell

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
   // [self addSubview:self.textView];
//    [self.contentView addSubview:self.deleteButton];
//    self.backgroundColor = [UIColor clearColor];
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0)) {
        [self.contentView addSubview:self.deleteButton];
    }
    
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)awakeFromNib
{
    self.defineLab.textColor = [UIColor blackColor];

    self.bgImageView.userInteractionEnabled = YES;
    self.defineLab.userInteractionEnabled = YES;

}

- (void)layoutSubviews
{
    [super layoutSubviews];



}

@end
