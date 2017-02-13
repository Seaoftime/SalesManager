//
//  CheckBoxCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class ReportCheckBoxCell;
@class InformationReportCreatViewController;

@protocol ReportCheckBoxCellDelegate <NSObject>

- (void)reportCheckBoxCell:(ReportCheckBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportCheckBoxCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;


@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *selectTextField;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak) id<ReportCheckBoxCellDelegate> delegate;
@property (strong, nonatomic) InformationReportCreatViewController *informationReportCreatViewController;

@end
