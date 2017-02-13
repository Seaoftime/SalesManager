//
//  YWNewNoticeViewController.m
//  SalesManager
//
//  Created by tianjing on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWNewNoticeViewController.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"

#import "SVProgressHUD.h"
#import "YWNoticeViewController.h"

#define lineColor  [UIColor colorWithRed:201/255.0 green:199/255.0 blue:201/255.0 alpha:1.0]
@interface YWNewNoticeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *lineV;
@property (nonatomic, strong) UILabel *lb;
@end

@implementation YWNewNoticeViewController
@synthesize  delegate;
extern NSString* userid;
extern NSString* randcode;
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
    titleIsFirst = NO;
    if(!IS_IOS7)
        self.totalBgView.frame = CGRectMake(0, 0, kDeviceWidth, 320);
    self.totalBgView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
//    self.contentText.layer.borderColor =[[UIColor colorWithRed:((float)((0x8B8B8B & 0xFF0000) >> 16))/255.0 green:((float)((0x8B8B8B & 0xFF00) >> 8))/255.0 blue:((float)(0x8B8B8B & 0xFF))/255.0 alpha:1.0]CGColor];
    
    self.titleText.frame = CGRectMake(self.titleText.frame.origin.x, self.titleText.frame.origin.y, self.titleText.frame.size.width,40.0);
    self.contentText.delegate = self;
    self.titleText.delegate = self;
    self.titleText.returnKeyType = UIReturnKeyNext;
    self.selectedPeople.delegate = self;
    self.view.backgroundColor = BGCOLOR;
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(endAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    
    UILabel *titleText = [TOOL setTitleView:@"发布通知"];
    self.navigationItem.titleView=titleText;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"%@%@%@",userID,company_Code,@"notice"];
    if(self.fromContacts)
        [self selectSendData:self.sendPeopleData];
    else
       [self selectSendData:[ud objectForKey:keyName]];
    
    [self.lineV setFrame:CGRectMake(self.lineV.frame.origin.x, self.lineV.frame.origin.y+ 1.5, kDeviceWidth, 0.5)];
    self.lineV.backgroundColor = lineColor;
    
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kDeviceWidth, 20)];
    self.lb.text = @"请输入通知内容";
    self.lb.textColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:210/255.0 alpha:1.0];
    self.lb.font = [UIFont systemFontOfSize:15];
    [self.contentText addSubview:self.lb];
    //self.holderLabel.textColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    //self.holderLabel.textColor = [UIColor redColor];
    //[self.holderLabel setTextColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];

}

#pragma mark -textfielddelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    titleIsFirst = YES;
   // [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 40, 14)];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setBackgroundImage:nil forState:UIControlStateNormal];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setTitle:@"确定" forState:UIControlStateNormal];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    titleIsFirst = NO;
  //  [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 50, 44)];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setTitle:@"完成" forState:UIControlStateNormal];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentText becomeFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.titleText == textField)
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

#pragma mark -textviewdelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.lb.text = @"请输入通知内容";
    }else{
         self.lb.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.contentText == textView)
    {
        if ([aString length] > 2000) {
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
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-110,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    else
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-40,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    [UIView commitAnimations];
  //  [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 40, 14)];
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
 //   [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 50, 44)];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setTitle:@"完成" forState:UIControlStateNormal];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleText resignFirstResponder];
    [self.contentText resignFirstResponder];
    [self.selectedPeople resignFirstResponder];
}
#pragma mark- 选择人员及选择之后的代理
-(IBAction)selectPeople:(id)sender
{
    YWSelectObjectsVC *vc = [[YWSelectObjectsVC alloc]init];
    vc.hasBeenSelectedData = [NSMutableDictionary dictionaryWithDictionary:self.sendPeopleData];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)selectSendData:(NSMutableDictionary *)sendDic//选着人员部门之后的代理
{
    self.sendPeopleData = [NSMutableDictionary dictionaryWithDictionary:sendDic];
    NSLog(@"delegate:%@",self.sendPeopleData);
    if([[self.sendPeopleData objectForKey:@"all"]isEqualToString:@"1"])
    {
        self.selectedPeople.text = [NSString stringWithFormat:@"%@",@"全公司"];
    }
    else
    {
    if([[sendDic objectForKey:@"partname"]count])
    {
        NSString *partstring = [NSString stringWithFormat:@"%@",[[sendDic objectForKey:@"partname"]objectAtIndex:0]];
        for (int i=1; i<[[sendDic objectForKey:@"partname"]count]; i++) {
            partstring = [NSString stringWithFormat:@"%@,%@",partstring,[[sendDic objectForKey:@"partname"]objectAtIndex:i]];
        }
        NSLog(@"pe::%@",partstring);
        self.selectedPeople.text = [NSString stringWithFormat:@"%@",partstring];
    }
    else
    {
        self.selectedPeople.text = @"";
    }
    if([[sendDic objectForKey:@"peoplename"]count])
    {
        NSString *peoplestring = [NSString stringWithFormat:@"%@",[[sendDic objectForKey:@"peoplename"]objectAtIndex:0]];
        for (int i=1; i<[[sendDic objectForKey:@"peoplename"]count]; i++) {
            peoplestring = [NSString stringWithFormat:@"%@,%@",peoplestring,[[sendDic objectForKey:@"peoplename"]objectAtIndex:i]];
        }
        NSLog(@"pe::%@",peoplestring);
        if(self.selectedPeople.text.length == 0)
            self.selectedPeople.text = [NSString stringWithFormat:@"%@",peoplestring];
        else
        self.selectedPeople.text = [NSString stringWithFormat:@"%@,%@",self.selectedPeople.text,peoplestring];
    }
    }
}
#pragma mark- 完成通知开始发送
-(void)endAdd
{
    if(self.totalBgView.frame.origin.y!=0)
    {
        NSLog(@"yyy%f",self.totalBgView.frame.origin.y);
        [self.contentText resignFirstResponder];
    }
    else if(titleIsFirst)
    {
        [self.titleText resignFirstResponder];
    }
    else
    {
    if(self.titleText.text.length<3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"通知标题字数不能小于2"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];

    }
   else if(self.contentText.text.length ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"通知详情不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else  if(self.selectedPeople.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"发送人员不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
   else
   {
    [self sendNewNoticeData];
   }
}
}



-(void)sendNewNoticeData
{
    //保存数据库
    YNoticDBM* noticDB = [[YNoticDBM alloc]init];
    YNoticFileds* noticFileds = [YNoticFileds new];
    if([self.selectedPeople.text isEqualToString:@"全公司"])
    {
        noticFileds.toDepartmentID =[NSString stringWithFormat:@"all"];
        noticFileds.toDepartmentName =[NSString stringWithFormat:@"全公司"];
    }
    else
    {
        noticFileds.toPersonID = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"peopleid"]];
        noticFileds.toDepartmentID = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"partid"]];
        noticFileds.toDepartmentName = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"partname"]];
        noticFileds.toPersonName = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"peoplename"]];
    }
   
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"%@%@%@",userID,company_Code,@"notice"];
    [userDefaults setObject:self.sendPeopleData forKey:keyName];
    NSLog(@"%@",[userDefaults objectForKey:keyName]);
    noticFileds.fromUserName = userDefaults.name;
    noticFileds.fromUserID = userID;
    noticFileds.noticDate = [[NSDate date] timeIntervalSince1970];
    noticFileds.noticTitle = self.titleText.text;
    noticFileds.noticContent = self.contentText.text;
    if(isSaveDraft == YES)
        noticFileds.upLoad = 5;
    else
    noticFileds.upLoad = 0;
    noticFileds.isMine =1;
    [noticDB saveNotic:noticFileds success:NO];
    
   if(self.fromContacts)
   {
       if(noticFileds.upLoad ==5)
           ;
       else
           [self sendNoticeData:noticFileds];//发送新建任务，如果是从通讯录里面来的
   }
    else
    {
    YWNoticeViewController *noticeViewController = (YWNoticeViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [noticeViewController addCell:noticFileds];//增加新通知返回列表
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)sendNoticeData:(YNoticFileds*)aField
{
    YNoticDBM* noticDB = [[YNoticDBM alloc]init];
    aField.upLoad = 3;
    [noticDB upload:aField];
    
    if (!aField.toDepartmentID) {
        aField.toDepartmentID = @"";
    }
    if (!aField.toPersonID) {
        aField.toPersonID = @"";
    }
    NSString *startTime =  [NSString stringWithFormat:@"%li",(long)aField.noticDate];
    NSString *urls =API_addNotice(API_headaddr, userID, randCode, aField.noticTitle,startTime, aField.noticContent, aField.toPersonID, aField.toDepartmentID, VERSIONS, @"1");
    
    [[YWNetRequest sharedInstance] requestSendNoticeDataWithUrl:urls WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"] integerValue]==60200)
        {
            aField.noticID = [respondsData objectForKey:@"noticeid"];
            aField.upLoad = 1;
            [noticDB upload:aField];
        }
        else
        {
            aField.upLoad = 2;
            [noticDB upload:aField];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                         message:[respondsData objectForKey:@"msg"]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
        
    } failed:^(NSError *error) {
        //
        [SVProgressHUD dismiss];
        aField.upLoad = 2;
        [noticDB upload:aField];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];

    
}
-(void)gotoback
{
    if((self.titleText.text.length == 0) &&(self.contentText.text.length ==0) )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.view endEditing:YES];
        
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
            [self sendNewNoticeData];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
