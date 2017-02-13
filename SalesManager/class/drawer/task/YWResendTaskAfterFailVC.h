//
//  YWResendTaskAfterFailVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTaskSelectedVC.h"
#import "YTaskFieleds.h"
@interface YWResendTaskAfterFailVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,YWTaskSelectObjectsVCDelegate,UIAlertViewDelegate>
{
    UIDatePicker *dataPicker;
    YTaskFieleds* firsttaskFilesd;
    UIView *dateBgView;
    UIButton *dateButton;
      UIAlertView* textLengthAlert;
    BOOL isSaveDraft;
    BOOL isDate;
}

@property (nonatomic,strong)IBOutlet UITextField *selectedPPaField;
@property (nonatomic,strong)IBOutlet UITextField *titleField;
@property (nonatomic,strong) IBOutlet UILabel *deadLineLabel;
@property (nonatomic,strong) IBOutlet UITextView *contentTxet;
@property (nonatomic,strong) IBOutlet UIImageView *titlebgView;
@property (nonatomic,strong) IBOutlet UIImageView *deadbgView;
@property (nonatomic,strong) IBOutlet UILabel *holderLabel;
@property (nonatomic,strong) IBOutlet UIView *totalBgView;
@property(nonatomic,assign) NSInteger autoIncremenID;
@property(nonatomic,strong)NSString *selectedPID;
@property(nonatomic,strong)NSString *sendUnixTime;//

@property(nonatomic,strong)IBOutlet UILabel *littleTimeLabel;
@property(nonatomic,strong)IBOutlet  UIImageView *littleTimeBgView;

-(IBAction)selectPeople:(id)sender;
-(IBAction)selectTime:(id)sender;
-(IBAction)selectLittleTime:(id)sender;


@end
