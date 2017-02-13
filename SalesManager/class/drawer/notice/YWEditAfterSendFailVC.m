//
//  YWEditAfterSendFailVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWEditAfterSendFailVC.h"
#import "YNoticDBM.h"
#import "YNoticFileds.h"
#import "YWSelectObjectsVC.h"
#import "YWNoticeViewController.h"
@interface YWEditAfterSendFailVC ()

@end

@implementation YWEditAfterSendFailVC

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
    // Do any additional setup after loading the view from its nib.
    self.contentText.layer.borderColor =[[UIColor colorWithRed:((float)((0x8B8B8B & 0xFF0000) >> 16))/255.0 green:((float)((0x8B8B8B & 0xFF00) >> 8))/255.0 blue:((float)(0x8B8B8B & 0xFF))/255.0 alpha:1.0]CGColor];
    self.contentText.layer.borderWidth = 0.5;
    self.contentText.layer.cornerRadius = 5.0;
    
    self.titleText.layer.borderColor =[[UIColor colorWithRed:((float)((0x8B8B8B & 0xFF0000) >> 16))/255.0 green:((float)((0x8B8B8B & 0xFF00) >> 8))/255.0 blue:((float)(0x8B8B8B & 0xFF))/255.0 alpha:1.0]CGColor];
    self.titleText.layer.borderWidth = 0.5;
    self.titleText.layer.cornerRadius = 5.0;
    self.titleText.frame = CGRectMake(self.titleText.frame.origin.x, self.titleText.frame.origin.y, self.titleText.frame.size.width,40.0);
    self.contentText.delegate = self;
    self.titleText.delegate = self;
    self.titleText.returnKeyType = UIReturnKeyNext;
  
    self.view.backgroundColor = BGCOLOR;
    // Do any additional setup after loading the view from its nib.
//    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(10, 20, 50, 44)];
//    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal ];
//    UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"creatReport_done@2x"] forState:UIControlStateNormal ];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(endAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    
    UILabel *titleText = [TOOL setTitleView:@"发布通知"];
    self.navigationItem.titleView=titleText;
    
    [self setFirstView];
}

-(void)setFirstView
{
    YNoticDBM* noticDB = [[YNoticDBM alloc]init];
    oldnoticeField = [[noticDB findWithNoticeTime:(int)self.noticeDate limit:1]objectAtIndex:0];
//    [self.sendPeopleData setValue:noticeField.toPersonName forKey:@"peoplename"];
//    [self.sendPeopleData setValue:noticeField.toPersonID forKey:@"peopleid"];
//    [self.sendPeopleData setValue:noticeField.toDepartmentName forKey:@"partname"];
//    [self.sendPeopleData setValue:noticeField.toDepartmentID forKey:@"partname"];
    if(oldnoticeField.toDepartmentName.length == 0 )
    {
        oldnoticeField.toDepartmentName = @"";
    }
    if(oldnoticeField.toPersonName.length == 0)
    {
        oldnoticeField.toPersonName = @"";
    }
    
    self.selectedPeople.text = [NSString stringWithFormat:@"%@ %@",oldnoticeField.toDepartmentName,oldnoticeField.toPersonName];
    self.titleText.text = oldnoticeField.noticTitle;
    if(![oldnoticeField.noticContent isEqualToString:@""])
    {
    self.holderLabel.text = @"";
    self.contentText.text = oldnoticeField.noticContent;
    }
}
#pragma mark -textfielddelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    titleIsFirst = YES;
    //[(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 40, 14)];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setBackgroundImage:nil forState:UIControlStateNormal];
    [(UIButton*)self.navigationItem.rightBarButtonItem.customView setTitle:@"确定" forState:UIControlStateNormal];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    titleIsFirst = NO;
   // [(UIButton*)self.navigationItem.rightBarButtonItem.customView setFrame:CGRectMake(240, 20, 50, 44)];
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
        self.holderLabel.text = @"请输入通知详情";
    }else{
        self.holderLabel.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.contentText == textView)
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
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-110,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
    else
        self.totalBgView.frame = CGRectMake( self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y-40,  self.totalBgView.frame.size.width,  self.totalBgView.frame.size.height);
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
    [self.titleText resignFirstResponder];
    [self.contentText resignFirstResponder];
    [self.selectedPeople resignFirstResponder];
}

-(IBAction)selectPeople:(id)sender
{
    YWSelectObjectsVC *vc = [[YWSelectObjectsVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectSendData:(NSMutableDictionary *)sendDic
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
            if([self.selectedPeople.text isEqualToString:@""])
                self.selectedPeople.text = [NSString stringWithFormat:@"%@",peoplestring];
            else
                self.selectedPeople.text = [NSString stringWithFormat:@"%@,%@",self.selectedPeople.text,peoplestring];
        }
    }
}

-(void)endAdd
{
  if(self.totalBgView.frame.origin.y!=0)
  {
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
    else if(self.contentText.text.length ==0 )
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


-(void)gotoback
{
    if((self.titleText.text.length == 0)&&(self.contentText.text.length == 0))
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

-(void)sendNewNoticeData//点击保存草稿和重新发送才走这个
{
    //保存数据库
    YNoticDBM* noticDB = [[YNoticDBM alloc]init];
    YNoticFileds* noticFileds = [YNoticFileds new];
    
    if([self.selectedPeople.text isEqualToString:@"全公司"])
    {
        noticFileds.toDepartmentID =[NSString stringWithFormat:@"all"];
        noticFileds.toDepartmentName =[NSString stringWithFormat:@"全公司"];
        [self.sendPeopleData setValue:@"1" forKey:@"all"];
    }
    else
    {
        if(self.sendPeopleData == Nil)
        {
            noticFileds.toPersonID = oldnoticeField.toPersonID;
            noticFileds.toDepartmentID = oldnoticeField.toDepartmentID;
            noticFileds.toDepartmentName = oldnoticeField.toDepartmentName;
            noticFileds.toPersonName = oldnoticeField.toPersonName;
            [self.sendPeopleData setValue:@"0" forKey:@"all"];//如果没有选择人员，sendpeopledata为空，则把原来的数据赋值给sendpeople存进userdefault里面
            [self.sendPeopleData setValue:[noticFileds.toPersonID componentsSeparatedByString:@","] forKey:@"peopleid"];
             [self.sendPeopleData setValue:[noticFileds.toDepartmentID componentsSeparatedByString:@","] forKey:@"partid"];
             [self.sendPeopleData setValue:[noticFileds.toDepartmentName componentsSeparatedByString:@","] forKey:@"partname"];
             [self.sendPeopleData setValue:[noticFileds.toPersonName componentsSeparatedByString:@","] forKey:@"peoplename"];
        }
        else
        {
        noticFileds.toPersonID = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"peopleid"]];
        noticFileds.toDepartmentID = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"partid"]];
        noticFileds.toDepartmentName = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"partname"]];
        noticFileds.toPersonName = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"peoplename"]];
        }
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"%@%@%@",userID,company_Code,@"notice"];
    [userDefaults setObject:self.sendPeopleData forKey:keyName];
    noticFileds.fromUserName = userDefaults.name;
    noticFileds.fromUserID = userID;
    noticFileds.noticDate = [[NSDate date] timeIntervalSince1970];
    noticFileds.noticTitle = self.titleText.text;
    noticFileds.noticContent = self.contentText.text;
    if(isSaveDraft)
        noticFileds.upLoad = 5;
    else
    noticFileds.upLoad = 0;
    noticFileds.isMine =1;
    [noticDB saveNotic:noticFileds success:NO];
    [noticDB deleteNoticeWithTime:self.noticeDate];
    YWNoticeViewController *noticeViewController = (YWNoticeViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [noticeViewController addCell:noticFileds];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    //    NSString *selectedPeopleID;
    //    NSString *selectedPartmentID;
    //    [SVProgressHUD showWithStatus:@"发送中。。。"];
    //    NSString *stype = @"1";
    //    if([self.selectedPeople.text isEqualToString:@"全公司"])
    //    {
    //        selectedPartmentID =[NSString stringWithFormat:@"all"];
    //    }
    //    else
    //    {
    //        selectedPeopleID = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"peopleid"]];
    //        selectedPartmentID = [TOOL stringWithArray:[self.sendPeopleData objectForKey:@"partid"]];
    //        //selectedPartmentID = [[TOOL stringWithArray:[self.sendPeopleData objectForKey:@"partid"]];
    //    }
    //    NSString *sendTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    //   API_addNotice(headaddr,userid,randcode,title,starttime,content,toid,topartname,versions,stype)
    //
    //    NSString *urls =API_addNotice(API_headaddr,userID,randCode,self.titleText.text,sendTime,self.contentText.text,selectedPeopleID,selectedPartmentID,VERSIONS,stype);
    //    NSLog(@"%@",urls);
    //    NSURL *url = [NSURL URLWithString:urls];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    //    AFJSONRequestOperation *operation =
    //    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    //                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    //                                                        NSLog(@"json:%@", (NSDictionary *)JSON);
    //                                                        if([[JSON objectForKey:@"code"]integerValue]==60200)
    //                                                        {
    //                                                            if (delegate && [delegate respondsToSelector:@selector(addNoticeDatebyID:)]) {
    //                                                                [delegate performSelector:@selector(addNoticeDatebyID:)withObject:self.addNoticeID];
    //                                                            }
    //
    //                                                            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    //                                                        }
    //                                                        else
    //                                                        {
    //                                                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"失败"
    //                                                                                                         message:[JSON objectForKey:@"msg"]
    //                                                                                                        delegate:nil
    //                                                                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //                                                            [av show];
    //
    //                                                        }
    //                                                        [SVProgressHUD dismiss];
    //                                                    }
    //                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    //                                                        [SVProgressHUD dismiss];
    //                                                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
    //                                                                                                     message:@"Error"
    //                                                                                                    delegate:nil
    //                                                                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //                                                        [av show];
    //                                                    }];
    //    [operation start];
    //    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

@end
