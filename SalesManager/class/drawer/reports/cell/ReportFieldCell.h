//
//  FieldCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportFieldCell;
@class YformFileds;

@protocol ReportFieldCellDelegate <NSObject>

@optional
- (void)reportFieldCell:(ReportFieldCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportFieldCell : UITableViewCell<UITextFieldDelegate>
{
    UIToolbar *inputAccessoryView;
}

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak)  id<ReportFieldCellDelegate> delegate;
@property (assign, nonatomic) BOOL isDone;

@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;







@end


