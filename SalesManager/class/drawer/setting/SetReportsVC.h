//
//  SetReportsVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineReportCell.h"

@interface SetReportsVC : YWbaseVC<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIImageView *addBgView;
    UITextView *addTextView;
    UIButton *rightButton;
    UILabel *holderLabel;
    int willDelecteRow;
}
@property(nonatomic,strong)UITableView *defineReportsTb;
@property(nonatomic,strong)NSMutableArray *defineReportsData;

@end
