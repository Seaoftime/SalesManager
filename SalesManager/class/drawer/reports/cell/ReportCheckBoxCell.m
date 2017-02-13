//
//  CheckBoxCell.m
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ReportCheckBoxCell.h"
#import "YformFileds.h"
#import "InformationReportCreatViewController.h"

@implementation ReportCheckBoxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}




- (void)awakeFromNib
{
    self.bggImgV.backgroundColor = [UIColor whiteColor];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFormFiled:(YformFileds *)formFiled
{
    _formFiled = formFiled;
    
    self.label.text = [NSString stringWithFormat:@"%@",formFiled.formName];
    if (formFiled.need) {
        self.selectTextField.placeholder = @"必填";
    }
}


@end
