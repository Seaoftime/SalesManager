//
//  ReportAddressBoxCell.h
//  SalesManager
//
//  Created by Kris on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationReportCreatViewController.h"

@class ReportAddressBoxCell;
@class YformFileds;

@protocol ReportAddressBoxCellDelegate <NSObject>

@optional
- (void)reportAddressBoxCell:(ReportAddressBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportAddressBoxCell : UITableViewCell
{
    UIToolbar *inputAccessoryView;
}

@property (strong, nonatomic) IBOutlet UIView *areaView;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UITextField *areaTextField;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (weak)  id<ReportAddressBoxCellDelegate> delegate;

@property (strong, nonatomic) YformFileds *formFiled;
@property (strong, nonatomic) InformationReportCreatViewController *informationReportCreatViewController;

- (IBAction)select:(id)sender;


@end
