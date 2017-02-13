//
//  NumberCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportNumberCell;
@class YformFileds;

@protocol ReportNumberCellDelegate <NSObject>

@optional
- (void)reportNumberCell:(ReportNumberCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportNumberCell : UITableViewCell<UITextFieldDelegate>
{
    UIToolbar *inputAccessoryView;
}


@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;



@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak)  id<ReportNumberCellDelegate> delegate;
@property (assign, nonatomic) BOOL isDone;

@end