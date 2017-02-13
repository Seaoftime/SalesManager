//
//  ReportAddressBoxViewController.h
//  SalesManager
//
//  Created by Kris on 14-3-24.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
#import "YformFileds.h"
#import "ReportAddressBoxCell.h"

@interface ReportAddressBoxViewController : UIViewController<HZAreaPickerDelegate>

@property (strong, nonatomic) IBOutlet UIView *areaView;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UITextField *areaTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (strong, nonatomic) YformFileds *formFiled;
@property (strong, nonatomic) NSString *tempString;
@property (strong, nonatomic) ReportAddressBoxCell *addressBoxCell;


@end
