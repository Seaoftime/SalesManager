//
//  SelectCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class ReportSelectCell;

@protocol ReportSelectCellDelegate <NSObject>

- (void)reportSelectCell:(ReportSelectCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportSelectCell : UITableViewCell<UIPickerViewDataSource, UIPickerViewDelegate>
{
	UIPopoverController *popoverController;// For iPad
	UIToolbar *inputAccessoryView;
    NSArray *values;
}

@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;



@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *selectTextField;
@property (nonatomic, strong) UIPickerView *picker;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak) id<ReportSelectCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)showAlert:(UIButton *)aButton;

@end
