//
//  RegisSettingViewController.m
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "RegisSettingViewController.h"
#import "UIView+ShakeView.h"
#import "YuserInfomationFileds.h"
#import "YUserInfomationDBM.h"
#import "initApp.h"
@interface RegisSettingViewController ()

@end

@implementation RegisSettingViewController

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
    [_CompanyView.layer setCornerRadius:5];
    [_CompanyView.layer setBorderWidth:0.5];
    [_CompanyView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_MessageView.layer setCornerRadius:5];
    [_MessageView.layer setBorderWidth:0.5];
    [_MessageView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_NameView.layer setCornerRadius:5];
    [_NameView.layer setBorderWidth:0.5];
    [_NameView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_ManagerView.layer setCornerRadius:5];
    [_ManagerView.layer setBorderWidth:0.5];
    [_ManagerView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_PasswordView.layer setCornerRadius:5];
    [_PasswordView.layer setBorderWidth:0.5];
    [_PasswordView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_ConfirmPassView.layer setCornerRadius:5];
    [_ConfirmPassView.layer setBorderWidth:0.5];
    [_ConfirmPassView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];

    
    [_submitBtn.layer setCornerRadius:5];
    [_submitBtn.layer setBorderWidth:0.5];
    [_submitBtn.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];

    _companyField.textAlignment = NSTextAlignmentRight;
    _messageField.textAlignment = NSTextAlignmentRight;
    _nameField.textAlignment = NSTextAlignmentRight;
    _managerField.textAlignment = NSTextAlignmentRight;
    _passwordField.textAlignment = NSTextAlignmentRight;
    _confirmPassField.textAlignment = NSTextAlignmentRight;
    _companyField.placeholder = @"必填";
    _messageField.placeholder = @"必填";
    _nameField.placeholder = @"必填";
    _managerField.placeholder = @"必填";
    _passwordField.placeholder = @"必填";
    _confirmPassField.placeholder = @"必填";
    
    if (IS_IOS7) {
        _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
    }
    else{
        _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
    }
    UITapGestureRecognizer *panGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignDd)];
    
    [_MyScrollView addGestureRecognizer:panGes];
	// Do any additional setup after loading the view.
}
-(void)resignDd{
    if (IS_IOS7) {
        _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
    }
    else{
        _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
    }
    [_companyField resignFirstResponder];
    [_messageField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_managerField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_confirmPassField resignFirstResponder];
    if (IS_IOS7) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height);
        }];
    }}

//验证邮箱的合法性
-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

-(IBAction)SubmitClick:(id)sender
{
    [self submitt];
}


- (void)submitt
{
   // [self performSegueWithIdentifier:@"toRegisSuccess" sender:nil];
    [_companyField resignFirstResponder];
    [_messageField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_managerField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_confirmPassField resignFirstResponder];
    
    
    if (_companyField.text.length == 0) {
        
        [_CompanyView ShakeMyView];
    }else if (_messageField.text.length==0){
        [_MessageView ShakeMyView];
        
    }else if (![self isValidateEmail:_messageField.text]){
      
        [SVProgressHUD showErrorWithStatus:@"请输入合法邮箱"];
    }
    else if (_nameField.text.length==0)
    {
        [_NameView ShakeMyView];
    }else if (_managerField.text.length==0)
    {
        [_ManagerView ShakeMyView];
    }else if (_passwordField.text.length==0)
    {
        [_PasswordView ShakeMyView];
    }else if(_passwordField.text.length<6){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入不少于六位的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }else if (![_passwordField.text isEqualToString:_confirmPassField.text]){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
    else if(isNetWork)  {
    
        [SVProgressHUD showWithStatus:@"提交中" maskType:SVProgressHUDMaskTypeBlack];
        NSString *RegisUrl = [NSString stringWithFormat:@"%@?mod=register&fun=register&register_value[company]=%@&register_value[email]=%@&register_value[phone]=%@&register_value[truename]=%@&register_value[admin]=%@&register_value[pwd]=%@&versions=%@&stype=1",API_headaddr,_companyField.text,_messageField.text,PhoneNum,_nameField.text,_managerField.text,_passwordField.text,VERSIONS];
        
       
        NSLog(@"%@",RegisUrl);
        RegisUrl = [RegisUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        [[YWNetRequest sharedInstance] requestRegisterSubmitZiliaoWithUrl:RegisUrl Success:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 10200){
                
               [SVProgressHUD dismiss];

                RegisCompanyNum =[NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"user_info"] objectForKey:@"com_code"]];
                
                RegisLoginNum =[NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"user_info"]objectForKey:@"user"]];
                
                RegisPassword =[NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"user_info"]objectForKey:@"pwd"]];
                
                RegisUserID =[NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"user_info"]objectForKey:@"user_id"]];
                
                RegisRandcode = [NSString stringWithFormat:@"%@",[respondsData objectForKey:@"rand_code"]];
                
                [self saveUserInfo:respondsData];
                
                [self performSegueWithIdentifier:@"toRegisSuccess" sender:nil];
                

            }else{
                
                NSString *ss =  [respondsData objectForKey:@"msg"];
                [SVProgressHUD dismiss];
               [SVProgressHUD showErrorWithStatus:ss];
                
            }

        } failed:^(NSError *error) {
            //
            if (isNetWork) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"登陆失败"];
            }else{
                [SVProgressHUD dismiss];
            }
            
        }];
        
        
    }else{
        UIAlertView* aler = [[UIAlertView alloc]initWithTitle:nil message:@"无法连接到网络，请先设置网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
       [aler show];
    }

}
-(void)saveUserInfo:(NSDictionary* )logDic
{

        userDefaults.companyCode = [[logDic objectForKey:@"user_info"]objectForKey:@"com_code"];
        userDefaults.ID = [[logDic objectForKey:@"user_info"] objectForKey:@"user_id"];
        userDefaults.randCode  = [logDic objectForKey:@"rand_code"];
        userDefaults.name = [[logDic objectForKey:@"user_info"] objectForKey:@"name"];
        userDefaults.userName = [[logDic objectForKey:@"user_info"]objectForKey:@"user"];
        userDefaults.position = [[logDic objectForKey:@"user_info"] objectForKey:@"isadmin"];
        [initApp appStart];
        YUserInfomationDBM* asd = [[YUserInfomationDBM alloc]init];
        YuserInfomationFileds* userInfo = [YuserInfomationFileds new];
        
        
        
        userInfo.userID = [[logDic objectForKey:@"user_info"] objectForKey:@"user_id"];
        userInfo.randCode = [logDic objectForKey:@"rand_code"];
        userInfo.companyCode = [[logDic objectForKey:@"user_info"] objectForKey:@"com_code"];
        userInfo.companyName = [[logDic objectForKey:@"user_info"] objectForKey:@"com_name"];
        userInfo.name = [[logDic objectForKey:@"user_info"] objectForKey:@"name"];
        userInfo.sex = [[[logDic objectForKey:@"user_info"] objectForKey:@"sex"] integerValue];
        userInfo.mobile = [[logDic objectForKey:@"user_info"] objectForKey:@"mobile"];
        userInfo.logoURL = [[logDic objectForKey:@"user_info"] objectForKey:@"logo"];
        if (userInfo.logoURL) {
            [userDefaults setObject:userInfo.logoURL forKey:[NSString stringWithFormat:@"logoUrl%@",[logDic objectForKey:@"com_code"]]];
        }
        
        userInfo.password = [[logDic objectForKey:@"user_info"] objectForKey:@"pwd"];
        userInfo.position = [[[logDic objectForKey:@"user_info"] objectForKey:@"position"] integerValue];
        userInfo.positionName = [[logDic objectForKey:@"user_info"] objectForKey:@"positiontitle"];
        userInfo.department = [[logDic objectForKey:@"user_info"] objectForKey:@"department"];
        userInfo.userPicUrl = [[logDic objectForKey:@"user_info"] objectForKey:@"userpic"];
        userInfo.userName =  [[logDic objectForKey:@"user_info"]objectForKey:@"user"];
        [asd saveUserInfomations:userInfo];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
}
-(IBAction)ResignDown:(id)sender
{
    if (IS_IOS7) {
        _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
    }
    else{
        _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
    }
    [_companyField resignFirstResponder];
    [_messageField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_managerField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_confirmPassField resignFirstResponder];
    if (IS_IOS7) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height);
        }];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case 500:
            [_messageField becomeFirstResponder];
            break;
        case 501:
            if ([UIScreen mainScreen].bounds.size.height==480){
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = CGRectMake(0, -60, 320, [UIScreen mainScreen].bounds.size.height);
                }];
            }
            [_nameField becomeFirstResponder];
            break;
        case 502:
            [_managerField becomeFirstResponder];
            if ([UIScreen mainScreen].bounds.size.height==480){
            [self ViewUp];
    }
            break;
        case 503:
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-40);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-40);
            }
            [_passwordField becomeFirstResponder];
            if ([UIScreen mainScreen].bounds.size.height==480){
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = CGRectMake(0, -140, 320, [UIScreen mainScreen].bounds.size.height);
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = CGRectMake(0, -60, 320, [UIScreen mainScreen].bounds.size.height);
                }];
            }
            break;
        case 504:
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-60);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-60);
            }

            [_confirmPassField becomeFirstResponder];
            if ([UIScreen mainScreen].bounds.size.height==480){
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = CGRectMake(0, -180, 320, [UIScreen mainScreen].bounds.size.height);
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.frame = CGRectMake(0, -100, 320, [UIScreen mainScreen].bounds.size.height);
                }];
            }

            break;
        case 505:
            [self submitt];
            
            break;
        default:
            break;
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([UIScreen mainScreen].bounds.size.height==480){
        if (textField==_companyField) {
            
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
        if (textField==_messageField) {
            
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
        
    if (textField==_nameField) {
        
        if (IS_IOS7) {
            _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
        }
        else{
            _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, -60, 320, [UIScreen mainScreen].bounds.size.height);
        }];
    }
        if (textField==_managerField) {
            
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-64);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-44);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -100, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
        if (textField==_passwordField) {
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-40);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-40);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -140, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
        if (textField==_confirmPassField) {
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-60);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-60);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -180, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
    }else{
        if (textField==_passwordField) {
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-40);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-40);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -60, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
        if (textField==_confirmPassField){
            if (IS_IOS7) {
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-60);
            }
            else{
                _MyScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height-60);
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -100, 320, [UIScreen mainScreen].bounds.size.height);
            }];
        }
    }
    
}
-(void)ViewUp0
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, -80, 320, [UIScreen mainScreen].bounds.size.height);
    }];
}
-(void)ViewUp
{
    [UIView animateWithDuration:0.2 animations:^{
                         self.view.frame = CGRectMake(0, -100, 320, [UIScreen mainScreen].bounds.size.height);
                    }];
}
-(IBAction)bck:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要放弃注册吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    av.delegate=self;
    [av show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self performSegueWithIdentifier:@"back3" sender:nil];
        [[GCDataBaseManager shareDatabase] close];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
