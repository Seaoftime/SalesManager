//
//  ViewCell.h
//  SalesManager
//
//  Created by Kris on 13-12-13.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class ReportViewCell;

@protocol ReportViewCellDelegate <NSObject>

@optional
- (void)reportViewCell:(ReportViewCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic;

@end

@interface ReportViewCell : UITableViewCell<UITextViewDelegate>
{
    UIToolbar *inputAccessoryView;
}

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) YformFileds *formFiled;
@property (weak)  id<ReportViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *placeholder;
@property (assign, nonatomic) BOOL isDone;


@property (weak, nonatomic) IBOutlet UIImageView *bggImgV;













@end
