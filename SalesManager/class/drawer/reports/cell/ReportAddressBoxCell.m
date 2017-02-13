//
//  ReportAddressBoxCell.m
//  SalesManager
//
//  Created by Kris on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "ReportAddressBoxCell.h"
#import "YformFileds.h"
#import "CustomIOS7AlertView.h"
#import "ReportAddressBoxViewController.h"

@implementation ReportAddressBoxCell

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

    // Configure the view for the selected state
}

- (void)setFormFiled:(YformFileds *)formFiled
{
    _formFiled = formFiled;
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@:",formFiled.formName];
    NSLog(@"%@",formFiled);
    
    self.areaView.layer.cornerRadius = 5;
    self.areaView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
    self.areaView.layer.borderWidth = 0.5;

}

- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

- (IBAction)select:(id)sender
{
    UITableView *tableView;
    if ([self.superview class] != [UITableView class])
    {
        tableView = (UITableView *)self.superview.superview;
    }
    else
    {
        tableView = (UITableView *)self.superview;
    }
    
    [self resignKeyBoardInView:tableView];
    
    ReportAddressBoxViewController *addressBoxVC = [[ReportAddressBoxViewController alloc] initWithNibName:@"ReportAddressBoxViewController" bundle:nil];
    addressBoxVC.formFiled = _formFiled;
    addressBoxVC.addressBoxCell = self;
    [_informationReportCreatViewController.navigationController pushViewController:addressBoxVC animated:YES];
    
}

@end
