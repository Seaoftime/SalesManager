//
//  YWFogetPassWordViewController.m
//  SalesManager
//
//  Created by sky on 13-12-23.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWFogetPassWordViewController.h"
#import "InsertTextField.h"
#import "YWResetPasswordViewController.h"

@interface YWFogetPassWordViewController ()

@property (strong, nonatomic) IBOutlet InsertTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet InsertTextField *captchaTextField;
@property (strong, nonatomic) IBOutlet UIButton *captchaButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;



- (IBAction)back:(id)sender;
- (IBAction)changePassWord:(id)sender;
- (IBAction)getCaptcha:(id)sender;


@end

@implementation YWFogetPassWordViewController

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

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //修改样式
    [_phoneTextField.layer setCornerRadius:5];
    [_phoneTextField.layer setBorderWidth:0.5];
    [_phoneTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_captchaTextField.layer setCornerRadius:5];
    [_captchaTextField.layer setBorderWidth:0.5];
    [_captchaTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_captchaButton.layer setCornerRadius:5];
    [_captchaButton.layer setBorderWidth:0.5];
    [_captchaButton.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_doneButton.layer setCornerRadius:5];
    [_doneButton.layer setBorderWidth:0.5];
    [_doneButton.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确定
- (IBAction)changePassWord:(id)sender
{
    if (_captchaTextField.text.length > 0)
    {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@?mod=getpwd&fun=getcode&user_id=%@&codenum=%@&mobilecode=%@&versions=%@&stype=1",API_headaddr,self.userID,self.codenum,self.captchaTextField.text,VERSIONS];
        NSLog(@"%@",strUrl);
        
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestChangePasswordWithUrl:strUrl Success:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] intValue] == 70200)
            {
                self.randomCode = [NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"list_info"] objectForKey:@"rand_code"]];
                [self performSegueWithIdentifier:@"toResetPassword" sender:self];
                
            }else{
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[NSString stringWithFormat:@"验证码校验失败，请检查输入"]
                                                            delegate:nil
                                                   cancelButtonTitle:@"确认" otherButtonTitles:nil];
                
                [av show];
            }
            
        } failed:^(NSError *error) {
            //
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"加载失败"
                                                         message:[NSString stringWithFormat:@"因数据环境不稳定，加载失败，请稍后重试"]
                                                        delegate:nil
                                               cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [av show];
            
        }];

    }else{
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:[NSString stringWithFormat:@"请输入验证码"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确认" otherButtonTitles:nil];
        
        [av show];
    }
}

//获取验证码
- (IBAction)getCaptcha:(id)sender
{
    if (self.phoneTextField.text.length == 11)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@?mod=getpwd&fun=sendcode&mobile=%@&versions=%@&stype=1",API_headaddr,self.phoneTextField.text,VERSIONS];
        NSLog(@"%@",strUrl);
        
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestForgotPasswordWithUrl:strUrl Success:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] intValue] == 70200)
            {
                [self.phoneTextField resignFirstResponder];
                self.codenum = [NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"list_info"] objectForKey:@"codenum"]];
                self.userID = [NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"list_info"] objectForKey:@"user_id"]];
                
                self.user = [NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"list_info"] objectForKey:@"user"]];
                self.companyCode = [NSString stringWithFormat:@"%@",[[respondsData objectForKey:@"list_info"] objectForKey:@"com_code"]];
                
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[NSString stringWithFormat:@"已发送到您手机，请注意查收"]
                                                            delegate:nil
                                                   cancelButtonTitle:@"确认" otherButtonTitles:nil];
                
                [av show];
                
                
            }else{
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[NSString stringWithFormat:@"没有查到此用户，请输入注册的手机号"]
                                                            delegate:nil
                                                   cancelButtonTitle:@"确认" otherButtonTitles:nil];
                
                [av show];
            }

            
        } failed:^(NSError *error) {
            //
        }];
        
        
    }else{
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:[NSString stringWithFormat:@"请输入有效手机号码"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [av show];
    }

}

//返回
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toResetPassword"])
    {
        YWResetPasswordViewController *resetPasswordViewController = [segue destinationViewController];
        resetPasswordViewController.fogetPasswordVC = sender;
    }
}


@end
