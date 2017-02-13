//
//  YWAddReportsVC.h
//  SalesManager
//
//  Created by tianjing on 14-1-3.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWAddReportsVC : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView *addTextView;
    UILabel *holderLabel;
    UIAlertView* textLengthAlert;
}

@property(nonatomic,strong)NSMutableArray *defineReportsData;
@property(nonatomic,assign)BOOL prepareAdd;
@property(nonatomic,assign)int atIndex;
@property(nonatomic,strong)NSString *prepareEditString;

@end
