//
//  NameBoxCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportNameBoxCell;
@class YformFileds;

@protocol ReportNameBoxCellDelegate <NSObject>

@optional
- (void)reportNameBoxCell:(ReportNameBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportNameBoxCell : UITableViewCell<UITextFieldDelegate>
{
    UIToolbar *inputAccessoryView;
}

@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;



@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak)  id<ReportNameBoxCellDelegate> delegate;
@property (assign, nonatomic) BOOL isDone;

@end