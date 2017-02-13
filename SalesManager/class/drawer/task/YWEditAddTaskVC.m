//
//  YWEditAddTaskVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-6.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWEditAddTaskVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
#import "YWTaskSelectedVC.h"
#import "YTaskDBM.h"
#import "YTaskFieleds.h"
#import "YWTaskVC.h"

#define lineColor  [UIColor colorWithRed:201/255.0 green:199/255.0 blue:201/255.0 alpha:1.0]
@interface YWEditAddTaskVC ()
{
    YTaskDBM *taskDBM;
}

@end

@implementation YWEditAddTaskVC
extern NSString* userid;
extern NSString* randcode;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        taskDBM = [[YTaskDBM alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isSaveDraft = NO;
    
    self.selectedPPaField.text = self.selectedppString;
     if(!self.isAdd)
     {
     taskFilesd = [[taskDBM findautoIncremenID:self.autoIncremenID limit:0 isMine:9] objectAtIndex:0];
     self.titleField.text = taskFilesd.taskTitle;
     self.selectedPPaField.text = taskFilesd.toPersonName;
         if(taskFilesd.taskEndTime == 0)
         {
             self.deadLineLabel.text = @"请选择日期";
             self.littleTimeLabel.text = @"请选择时间";
         }
         else
         {
     self.deadLineLabel.text = [TOOL convertUnixTime:taskFilesd.taskEndTime timeType:1 ];
         self.littleTimeLabel.text = [TOOL convertUnixTime:taskFilesd.taskEndTime timeType:0];
         }
         self.sendUnixTime = [NSString stringWithFormat:@"%li",(long)taskFilesd.taskEndTime];
     self.contentTxet.text = taskFilesd.taskContent;
     self.selectedPID = taskFilesd.toPersonID;
     NSLog(@"taskid:%@ top:%@",self.taskID,taskFilesd.toPersonName);
     }
    self.totalBgView.backgroundColor = [UIColor clearColor];
    self.titleField.delegate = self;
    self.titleField.returnKeyType = UIReturnKeyDone;
    
    self.textViewBgV.backgroundColor = [UIColor whiteColor];
    
    
    self.contentTxet.delegate = self;
    self.view.backgroundColor = BGCOLOR;
    
//
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
   // [rightButton setBackgroundImage:[UIImage imageNamed:@"creatReport_done@2x"] forState:UIControlStateNormal ];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(endAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    UILabel *titleText;
    if(self.isAdd)
        titleText = [TOOL setTitleView:@"新建任务"];
    else
        titleText = [TOOL setTitleView:@"编辑任务"];
    self.navigationItem.titleView=titleText;
    /**
     <#Description#>
     */
    dateBgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 148, kDeviceWidth, 270)];
    
    dateBgView.backgroundColor = BGCOLOR;
    //dateBgView.backgroundColor = [UIColor blackColor];
    
    
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateButton setTitle:@"确定" forState:UIControlStateNormal];
    [dateButton setTitleColor:NAVIGATIONCOLOR forState:UIControlStateNormal];
    dateButton.frame = CGRectMake(kDeviceWidth - 85, -5, 100, 40);
    [dateButton addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* noDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noDateButton setTitle:@"不限定任务日期" forState:UIControlStateNormal];
    [noDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noDateButton.frame = CGRectMake(5, 230, kDeviceWidth - 10, 35);
    noDateButton.layer.cornerRadius = 5.0;
    noDateButton.clipsToBounds = YES;
    noDateButton.backgroundColor = NAVIGATIONCOLOR;
    [noDateButton addTarget:self action:@selector(noDateSelected) forControlEvents:UIControlEventTouchUpInside];
    
    
    dataPicker = [[UIDatePicker alloc]init];
    //dataPicker.frame = CGRectMake(0, 20, 0, 0);
    dataPicker.frame = CGRectMake(12, 30, kDeviceWidth - 24, 160);
    //
    
    //dataPicker.backgroundColor = [UIColor whiteColor];
    dataPicker.minimumDate = [NSDate date];
    
    [self.view addSubview:dataPicker];
    
    [dataPicker setTimeZone:[NSTimeZone localTimeZone]];
    [dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [dateBgView addSubview:dateButton];
    [dateBgView addSubview:noDateButton];
    [dateBgView addSubview:dataPicker];
    [self.view addSubview:dateBgView];
    dateBgView.hidden = YES;
    
    
    self.holderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, -5, 200, 40)];
    self.holderLabel.text = @"请输入任务内容";
    self.holderLabel.textColor = [UIColor colorWithRed:200/255.f  green:199/255.f  blue:204/255.f alpha:1];
    self.holderLabel.font = [UIFont systemFontOfSize:14];
    [self.contentTxet addSubview:self.holderLabel];
    if(![self.contentTxet.text isEqualToString:@""])
        self.holderLabel.text = 0;
    
    
    [self.lineImgV setFrame:CGRectMake(self.lineImgV.frame.origin.x, self.lineImgV.frame.origin.y - 1, kDeviceWidth, 0.5)];
    self.lineImgV.backgroundColor = lineColor;
    
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
            self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x,0,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
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
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x,0,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
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
                                                   cancelButtonTitle:@"知道了"
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
    if (textView == self.contentTxet) {
        if (textView.text.length == 0) {
            self.holderLabel.text = @"请输入任务内容";
        }else{
            self.holderLabel.text = @"";
        }
    }
//    if (textView.text.length == 0) {
//        self.holderLabel.text = @"请输入任务内容";
//    }else{
//        self.holderLabel.text = @"";
//    }
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
     self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-85,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    [UIView commitAnimations];
    //[(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 40, 14)];
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
    //[(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 50, 44)];
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
    if([self.isAdd isEqualToString:@"1"])
    {
    if((self.titleField.text.length == 0)&&(self.contentTxet.text.length == 0))
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
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
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
    else if( self.selectedPPaField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"发送人员不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
//
    else if([self.isAdd isEqualToString:@"1"])
    {
        [self addNewTask];
    }
    else
    {
        [self postEditTask];
    }
}
}

-(void)addNewTask
{
    if([self.deadLineLabel.text isEqualToString:@"请选择日期"]||[self.deadLineLabel.text isEqualToString:@"不限定任务日期"])
    {
        self.sendUnixTime = @"0";
    }
    else
    {
        self.sendUnixTime = [TOOL combinDate:self.deadLineLabel.text andTimeToUnixString:self.littleTimeLabel.text];
    }
    //保存数据库
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
    taskFileds.autoIncremenID = [taskDBM findfieldwithtasktime:taskFileds.taskTime];
   if(self.fromContacts)
   {
       if(taskFileds.upLoad ==5)
        [self.navigationController popToRootViewControllerAnimated:YES];
       else
       [self sendTaskData:taskFileds];//发送新建任务，如果是从通讯录里面来的
   }
    else
    {
    YWTaskVC *taskVC = (YWTaskVC *)[self.navigationController.viewControllers objectAtIndex:0];
    [taskVC addCell:taskFileds];
    [self.navigationController popToRootViewControllerAnimated:YES];

    }
}

-(void)sendTaskData:(YTaskFieleds*)aField
{
    [SVProgressHUD showWithStatus:@"任务发送中..."];
    aField.upLoad = 3;
    [taskDBM uploadTaskID:aField];
    NSString *urls =API_addTask(API_headaddr,userID,randCode,aField.taskTitle, (int)aField.taskEndTime,aField.taskContent,aField.toPersonID,VERSIONS,@"1");
    NSLog(@"%@",urls);
    [[YWNetRequest sharedInstance] requestSendTaskDataWithUrl:urls WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"]integerValue]==80200)
        {
        @try {
                aField.timeStampContent = [[respondsData objectForKey:@"lastdotime"]integerValue];
                aField.timeStampList = aField.timeStampContent;
                aField.taskID = [respondsData objectForKey:@"id"];
                aField.upLoad = 1;
                [taskDBM uploadTaskID:aField];
            [SVProgressHUD showSuccessWithStatus:@"任务新建成功！"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            }
            @catch (NSException *exception) {
                YWErrorDBM* ad = [[YWErrorDBM alloc]init];
                [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
            }
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"失败"
                                                         message:[respondsData objectForKey:@"msg"]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            aField.upLoad = 2;
            [taskDBM uploadTaskID:aField];
        }

    } failed:^(NSError *error) {
        //
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请求失败"  message:Nil
                                                                                                                               delegate:nil
                                                                                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                                   [av show];
                                                                                   aField.upLoad = 2;
                                                                                   [taskDBM uploadTaskID:aField];

    }];
    
    
    
}


-(void)postEditTask
{
    [SVProgressHUD showWithStatus:@"发送中。。。"];
    NSString *stype = @"1";
    //API_modifyTaskById(headaddr,userid,randcode,taskid,title,endtime,content,toid,versions,stype)
    NSString *urls =API_modifyTaskById(API_headaddr,userID,randCode,self.taskID,self.titleField.text,self.sendUnixTime,self.contentTxet.text,self.selectedPID,VERSIONS,stype);
    NSLog(@"%@",urls);
    
    [[YWNetRequest sharedInstance] requestPostEditTaskDataWithUrl:urls WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"]integerValue]==80200)
        {
#if 0
            if (delegate && [delegate respondsToSelector:@selector(editTaskDatebyID:)]) {
                [delegate performSelector:@selector(editTaskDatebyID) withObject:self.taskID];
            }
#endif
            //[self saveEditTask];
            taskFilesd.taskTitle = self.titleField.text;
            taskFilesd.toPersonName = self.selectedPPaField.text;
            taskFilesd.taskTo = [NSString stringWithFormat:@"我指派给%@",taskFilesd.toPersonName];
            taskFilesd.taskEndTime = [self.sendUnixTime integerValue];
            taskFilesd.taskContent  = self.contentTxet.text;
            taskFilesd.toPersonID = self.selectedPID;
            taskFilesd.upLoad = 1;
            taskFilesd.timeStampContent = [[respondsData objectForKey:@"lastdotime"]integerValue];
            taskFilesd.timeStampList = [[respondsData objectForKey:@"lastdotime"]integerValue];
            taskFilesd.taskFromPersonID = taskFilesd.taskFromPersonID;
            taskFilesd.taskFromPersonName = taskFilesd.taskFromPersonName;
            [taskDBM uploadTaskContent:taskFilesd];
            [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"失败"
                                                         message:[respondsData objectForKey:@"msg"]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            
        }
        [SVProgressHUD dismiss];

    } failed:^(NSError *error) {
        //
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    
//       
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveEditTask
{
    taskFilesd.taskTitle = self.titleField.text;
    taskFilesd.toPersonName = self.selectedPPaField.text;
    taskFilesd.taskTo = [NSString stringWithFormat:@"我指派给%@",taskFilesd.toPersonName];
    taskFilesd.taskEndTime = [self.sendUnixTime integerValue];
    taskFilesd.taskContent  = self.contentTxet.text;
    taskFilesd.toPersonID = self.selectedPID;
    taskFilesd.upLoad = 1;
    taskFilesd.timeStampContent =[[NSDate date]timeIntervalSince1970];
    taskFilesd.taskTime = [[NSDate date]timeIntervalSince1970];
    taskFilesd.taskFromPersonID = taskFilesd.taskFromPersonID;
    taskFilesd.taskFromPersonName = taskFilesd.taskFromPersonName;
    [taskDBM uploadTaskContent:taskFilesd];
    
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
