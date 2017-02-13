//
//  YWEditAfterSendFailVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsertTextField.h"
#import "YNoticDBM.h"
#import "YWSelectObjectsVC.h"
#import "YNoticFileds.h"
@interface YWEditAfterSendFailVC : UIViewController<UITextViewDelegate,UITextFieldDelegate,YWSelectObjectsVCDelegate,UIAlertViewDelegate>
{
    YNoticFileds *oldnoticeField;
     UIAlertView* textLengthAlert;
     BOOL isSaveDraft;
    BOOL titleIsFirst;
}
@property (nonatomic,strong)IBOutlet UITextField *selectedPeople;
@property (nonatomic,strong)IBOutlet InsertTextField *titleText;
@property (nonatomic,strong)IBOutlet UITextView *contentText;
@property (nonatomic,strong)IBOutlet UILabel *holderLabel;
@property (nonatomic,strong)IBOutlet UIView *totalBgView;
@property (nonatomic,strong)IBOutlet UIButton *selectedButton;
@property (nonatomic,strong)NSMutableDictionary *willSendNoticeData;
@property (nonatomic,strong)NSMutableDictionary *sendPeopleData;
@property (nonatomic,assign)NSInteger noticeDate;

-(IBAction)selectPeople:(id)sender;
@end
