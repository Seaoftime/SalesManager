//
//  YWEditAddTaskVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-6.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTaskSelectedVC.h"
#import "YTaskFieleds.h"
@protocol YWEditAddTaskVCDelegate <NSObject>

-(void)editTaskDatebyID:(NSString*)editTaskID;
-(void)addTaskDatebyID:(NSString*)addTaskID;

@end
@interface YWEditAddTaskVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,YWTaskSelectObjectsVCDelegate,UIAlertViewDelegate>
{
    UIDatePicker *dataPicker;
    id<YWEditAddTaskVCDelegate>delegate;
    YTaskFieleds* taskFilesd;
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
//@property (nonatomic,strong) IBOutlet UILabel *holderLabel;
@property (nonatomic,strong) IBOutlet UIView *totalBgView;
@property(nonatomic,strong) NSString* taskID;//编辑的taskid
@property(nonatomic,assign) NSInteger autoIncremenID;
@property(nonatomic,strong) NSString *isAdd;//是否进入新建任务列表
@property(nonatomic,strong)NSString *titleString;//
@property(nonatomic,strong)NSString *deadlineString;//
@property(nonatomic,strong)NSString *contentString;//
@property(nonatomic,strong)NSString *selectedppString;//
@property(nonatomic,strong) id<YWEditAddTaskVCDelegate>delegate;
@property(nonatomic,strong) NSString *addTaskID;//增加后请求得到的id
@property(nonatomic,strong)NSString *selectedPID;//
@property(nonatomic,strong)NSString *sendUnixTime;//
@property(nonatomic,strong)NSString *fromContacts;//如果是从通讯录来的，就为1；

@property(nonatomic,strong)IBOutlet UILabel *littleTimeLabel;
@property(nonatomic,strong)IBOutlet UIButton *selectLittleTimeBtn;
@property(nonatomic,strong)IBOutlet  UIImageView *littleTimeBgView;

@property (weak, nonatomic) IBOutlet UIImageView *textViewBgV;

@property (nonatomic, strong) UILabel *holderLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;






-(IBAction)selectPeople:(id)sender;

-(IBAction)selectTime:(id)sender;

-(IBAction)selectLittleTime:(id)sender;




@end
