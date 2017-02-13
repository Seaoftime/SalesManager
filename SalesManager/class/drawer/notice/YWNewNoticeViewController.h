//
//  YWNewNoticeViewController.h
//  SalesManager
//
//  Created by tianjing on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWSelectObjectsVC.h"
#import "InsertTextField.h"
#import "YNoticDBM.h"
@protocol YWAddNoticeVCDelegate <NSObject>

-(void)addNoticeDatebyID:(NSString*)addTaskID;

@end

@interface YWNewNoticeViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,YWSelectObjectsVCDelegate,UIAlertViewDelegate>
{
    id<YWAddNoticeVCDelegate>delegate;
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
@property (nonatomic,strong)NSMutableDictionary *sendPeopleData;
@property(nonatomic,strong)NSString *addNoticeID;
@property (nonatomic,strong) id<YWAddNoticeVCDelegate>delegate;
@property(nonatomic,strong)NSString *fromContacts;//如果是从通讯录来的，就为1；


-(IBAction)selectPeople:(id)sender;
@end
