//
//  YWPrepareDoneVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-6.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTaskDBM.h"
#import "YTaskFieleds.h"
@interface YWPrepareDoneVC : YWbaseVC<UITextViewDelegate>
{
    UILabel *holderLabel;
    YTaskDBM *taskDBM;
    YTaskFieleds *taskFields;
}
@property(nonatomic,strong)  UITextView *contentView;
@property(nonatomic,assign) NSString* taskID;
@property(nonatomic,assign) NSInteger autoIncremenID;
@property(nonatomic,strong) NSString *receiver;

@end
