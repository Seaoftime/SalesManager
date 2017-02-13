//
//  YWResendTaskAfterFailVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWResendTaskAfterFailVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"

#import "SVProgressHUD.h"
#import "YWTaskSelectedVC.h"
#import "YTaskDBM.h"
#import "YTaskFieleds.h"
#import "YWTaskVC.h"


@interface YWResendTaskAfterFailVC ()
{
    YTaskDBM *taskDBM;
}

@end

@implementation YWResendTaskAfterFailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     isSaveDraft = NO;
    if(!IS_IOS7)
    self.totalBgView.frame = CGRectMake(0, 0, 320, 380);
    //NSLog(@"%i",self.autoIncremenID);
    taskDBM = [[YTaskDBM alloc] init];
    firsttaskFilesd = [[taskDBM findautoIncremenID:self.autoIncremenID limit:0 isMine:9] objectAtIndex:0];
    self.titleField.text = firsttaskFilesd.taskTitle;
    self.selectedPPaField.text = firsttaskFilesd.toPersonName;
    NSLog(@"%ld",(long)firsttaskFilesd.taskEndTime);
    if(firsttaskFilesd.taskEndTime == 0)
    {
        self.deadLineLabel.text = @"请选择日期";
        self.littleTimeLabel.text = @"请选择时间";
    }
    else
    {
        self.deadLineLabel.text = [TOOL convertUnixTime:firsttaskFilesd.taskEndTime timeType:1];
        self.littleTimeLabel.text = [TOOL convertUnixTime:firsttaskFilesd.taskEndTime timeType:0];
    }

    self.sendUnixTime = [NSString stringWithFormat:@"%li",(long)firsttaskFilesd.taskEndTime];
    self.contentTxet.text = firsttaskFilesd.taskContent;
    self.selectedPID = firsttaskFilesd.toPersonID;
    self.totalBgView.backgroundColor = [UIColor clearColor];
    self.titleField.delegate = self;
    self.titleField.returnKeyType = UIReturnKeyDone;
    if(![self.contentTxet.text isEqualToString:@""])
        self.holderLabel.text = 0;
    // Do any additional setup after loading the view from its nib.
    self.titlebgView.layer.borderWidth = 0.5;
    self.titlebgView.layer.cornerRadius = 5.0;
    self.titlebgView.layer.borderColor = [BORDERCOLOR CGColor];
    
    self.deadbgView.layer.borderWidth = 0.5;
    self.deadbgView.layer.cornerRadius = 5.0;
    self.deadbgView.layer.borderColor = [BORDERCOLOR CGColor];
    
    self.littleTimeBgView.layer.borderWidth = 0.5;
    self.littleTimeBgView.layer.cornerRadius = 5.0;
    self.littleTimeBgView.layer.borderColor = [BORDERCOLOR CGColor];

    self.contentTxet.layer.borderWidth = 0.5;
    self.contentTxet.layer.cornerRadius = 5.0;
    self.contentTxet.layer.borderColor = [BORDERCOLOR CGColor];
    self.contentTxet.delegate = self;
    self.view.backgroundColor = BGCOLOR;
// 
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
   // [rightButton setBackgroundImage:[UIImage imageNamed:@"creatReport_done@2x"] forState:UIControlStateNormal ];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(endAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    UILabel *titleText;
    titleText = [TOOL setTitleView:@"新建任务"];
    self.navigationItem.titleView=titleText;
    dateBgView  = [[UIView alloc]initWithFrame:CGRectMake(0, 148, 320, 270)];
    dateBgView.backgroundColor = BGCOLOR;
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateButton setTitle:@"确定" forState:UIControlStateNormal];
    [dateButton setTitleColor:NAVIGATIONCOLOR forState:UIControlStateNormal];
    dateButton.frame = CGRectMake(220, 0, 100,40);
    [dateButton addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* noDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noDateButton setTitle:@"不限定任务日期" forState:UIControlStateNormal];
    [noDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noDateButton.frame = CGRectMake(5, 230, 310, 35);
    noDateButton.layer.cornerRadius = 5.0;
    noDateButton.backgroundColor = NAVIGATIONCOLOR;
    [noDateButton addTarget:self action:@selector(noDateSelected) forControlEvents:UIControlEventTouchUpInside];

    dataPicker = [[UIDatePicker alloc]init];
    dataPicker.frame = CGRectMake(0, 20, 0, 0);
    if(!IS_IOS7)
    {
        dateBgView.frame = CGRectMake(0, 133, 320, 290);
        dateButton.frame = CGRectMake(220, 0, 100, 30);
        noDateButton.frame = CGRectMake(5, 247, 310, 35);
        dataPicker.frame = CGRectMake(0, 30, 0, 0);
    }

    [self.view addSubview:dataPicker];
    [dataPicker setTimeZone:[NSTimeZone localTimeZone]];
    [dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [dateBgView addSubview:dateButton];
    [dateBgView addSubview:dataPicker];
    [dateBgView addSubview:noDateButton];
    [self.view addSubview:dateBgView];
    dateBgView.hidden = YES;
}
-(void)dateSelected
{
    if(dateBgView.hidden == NO)
    {
        NSString *dateString;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:localTimeZone];
        if(isDate)
        {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            dateString = [dateFormatter stringFromDate:dataPicker.date];
            self.deadLineLabel.text = dateString;
        }
        else
        {
            [dateFormatter setDateFormat:@"HH:mm"];
            dateString = [dateFormatter stringFromDate:dataPicker.date];
            self.littleTimeLabel.text = dateString;
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, 0,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
            [UIView commitAnimations];
        }
        
        // self.sendUnixTime = [NSString stringWithFormat:@"%ld",(long)[dataPicker.date timeIntervalSince1970]];
        dateBgView.hidden = YES;
    }
}
-(void)noDateSelected
{
    if(dateBgView.hidden == NO)
    {
        self.deadLineLabel.text = @"不限定任务日期";
        self.littleTimeLabel.text = @"不限定任务日期";
        dateBgView.hidden = YES;
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, 0,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
        [UIView commitAnimations];
    }
}
-(void)dateChanged:(id)sender{
    NSString *dateString;
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    if(isDate)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateString = [dateFormatter stringFromDate:control.date];
        self.deadLineLabel.text = dateString;
    }
    else
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString = [dateFormatter stringFromDate:control.date];
        self.littleTimeLabel.text = dateString;
    }
    NSLog(@"%@",dateString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -textfielddelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.titleField == textField)
    {
        if ([aString length] > 20) {
            textField.text = [aString substringToIndex:20];
            if (!textLengthAlert) {
                textLengthAlert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"超过最大字数不能输入了"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil, nil];
                
                [textLengthAlert show];
            }
            return NO;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleField resignFirstResponder];
    return YES;
}

#pragma mark -textviewdelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.holderLabel.text = @"请输入任务内容";
    }else{
        self.holderLabel.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.contentTxet == textView)
    {
        if ([aString length] > 2000) {
            textView.text = [aString substringToIndex:2000];
            if (!textLengthAlert) {
                textLengthAlert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"超过最大字数不能输入了"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil, nil];
                
                [textLengthAlert show];
            }
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if(KDeviceHeight <500.0)
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-150,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    else
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-95,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    [UIView commitAnimations];
   // [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 40, 14)];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setBackgroundImage:nil forState:UIControlStateNormal];
     [(UIButton*)self.navigationItem.rightBarButtonItem.customView setTitle:@"确定" forState:UIControlStateNormal];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    if(IS_IOS7)
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, 0,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    else
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x,0,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    [UIView commitAnimations];
   // [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 50, 44)];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setTitle:@"完成" forState:UIControlStateNormal];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleField resignFirstResponder];
    [self.contentTxet resignFirstResponder];
    [self.selectedPPaField resignFirstResponder];
}

-(void)gotoback
{
          if((self.titleField.text.length ==0)&&(self.contentTxet.text.length == 0))
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"是否存草稿?"
                                                          message:Nil
                                                         delegate:self
                                                cancelButtonTitle:@"不保存" otherButtonTitles:@"保存",nil];
            [avv show];
        }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView ==textLengthAlert)
    {
        textLengthAlert = Nil;}
    else
    {
        //NSLog(@"%d",buttonIndex);
        if(buttonIndex == 1)
        {
            isSaveDraft = YES;
            [self addNewTask];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


-(void)endAdd
{
    if(self.totalBgView.frame.origin.y!=0)
    {
        [self.contentTxet resignFirstResponder];
    }
    else
    {
        if([self.deadLineLabel.text isEqualToString:@"请选择日期"]||[self.deadLineLabel.text isEqualToString:@"不限定任务日期"])
        {
            self.sendUnixTime = @"0";
        }
        else
        {
            self.sendUnixTime = [TOOL combinDate:self.deadLineLabel.text andTimeToUnixString:self.littleTimeLabel.text];
        }

    if(self.titleField.text.length<3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"通知标题字数不能小于2"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if(self.contentTxet.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"通知详情不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(self.selectedPPaField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"发送人员不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
//    else if([self.deadLineLabel.text isEqualToString:@"请选择时间"])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"请选择时间"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
    else
    {
        [self addNewTask];
    }
    }
}

-(void)addNewTask
{
    //保存数据库
    if([self.deadLineLabel.text isEqualToString:@"请选择日期"]||[self.deadLineLabel.text isEqualToString:@"不限定任务日期"])
    {
        self.sendUnixTime = @"0";
    }
    else
    {
        self.sendUnixTime = [TOOL combinDate:self.deadLineLabel.text andTimeToUnixString:self.littleTimeLabel.text];
    }
    YTaskFieleds* taskFileds = [YTaskFieleds new];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    taskFileds.taskTitle = self.titleField.text;
    taskFileds.taskEndTime = [self.sendUnixTime integerValue];
    taskFileds.taskContent = self.contentTxet.text;
    taskFileds.toPersonID = self.selectedPID;
    taskFileds.toPersonName = self.selectedPPaField.text;
    taskFileds.taskFromPersonName = userDefaults.name;
    taskFileds.taskFromPersonID = userDefaults.ID;
    taskFileds.taskTime = [[NSDate date] timeIntervalSince1970];
    taskFileds.taskTo = [NSString stringWithFormat:@"我指派给%@",self.selectedPPaField.text];
    taskFileds.isMine = 0;
    taskFileds.taskWhetherFinished = 0;
    taskFileds.taskLocked = 0;
    if(isSaveDraft)
        taskFileds.upLoad = 5;
    else
    taskFileds.upLoad = 0;
    
    [taskDBM saveTask:taskFileds];
    [taskDBM deleteTaskWithTime:firsttaskFilesd.taskTime];
    YWTaskVC *taskVC = (YWTaskVC *)[self.navigationController.viewControllers objectAtIndex:0];
    taskFileds.autoIncremenID = [taskDBM findfieldwithtasktime:taskFileds.taskTime];
    [taskVC addCell:taskFileds];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)selectPeople:(id)sender
{
    YWTaskSelectedVC *vc = [[YWTaskSelectedVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectTaskSendData:(NSMutableDictionary *)sendDic
{
    NSLog(@"%@",sendDic);
    self.selectedPPaField.text = [sendDic objectForKey:@"name"];
    self.selectedPID = [sendDic objectForKey:@"id"];
}
-(IBAction)selectTime:(id)sender
{
    [self.selectedPPaField resignFirstResponder];
    [self.contentTxet resignFirstResponder];
    [self.titleField resignFirstResponder];
    dataPicker.minimumDate = [NSDate date];
    dataPicker.datePickerMode = UIDatePickerModeDateAndTime;
    isDate = YES;
    dateBgView.hidden = NO;
}
-(IBAction)selectLittleTime:(id)sender
{
    [self.selectedPPaField resignFirstResponder];
    [self.contentTxet resignFirstResponder];
    [self.titleField resignFirstResponder];
    if([self.deadLineLabel.text isEqualToString:@"请选择日期"]||[self.deadLineLabel.text isEqualToString:@"不限定任务日期"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请先选择日期"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        dataPicker.datePickerMode = UIDatePickerModeTime;
        dataPicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        isDate = NO;
        if([self.deadLineLabel.text isEqualToString:[TOOL convertUnixTime:[[NSDate date]timeIntervalSince1970] timeType:3]])
        {
            dataPicker.minimumDate = [NSDate date];
        }
        dateBgView.hidden = NO;
        [UIView beginAnimations:@"srcollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-60,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
        [UIView commitAnimations];

    }
}
@end
