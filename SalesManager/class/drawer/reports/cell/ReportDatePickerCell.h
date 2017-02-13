//
//  DatePickerCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class ReportDatePickerCell;

@protocol ReportDatePickerCellDelegate <NSObject>

- (void)reportDatePickerCell:(ReportDatePickerCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportDatePickerCell : UITableViewCell<UIPopoverControllerDelegate>
{
	UIPopoverController *popoverController; // For iPad
	UIToolbar *inputAccessoryView;
}

@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;






@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak) id<ReportDatePickerCellDelegate> delegate;
@property (strong, nonatomic) UIDatePicker *datePicker;
//@property (assign, nonatomic) BOOL isDone;

- (IBAction)showAlert:(UIButton *)aButton;

@end
