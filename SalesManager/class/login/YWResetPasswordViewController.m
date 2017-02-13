//
//  YWResetPasswordViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWResetPasswordViewController.h"
#import "InsertTextField.h"
#import "YWFogetPassWordViewController.h"

@interface YWResetPasswordViewController ()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UIView *infromationBackgroundView;
@property (strong, nonatomic) IBOutlet InsertTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet InsertTextField *reinputPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)done:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation YWResetPasswordViewController

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
	//修改样式
    [_infromationBackgroundView.layer setCornerRadius:5];
    [_infromationBackgroundView.layer setBorderWidth:0.5];
    [_infromationBackgroundView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_passwordTextField.layer setCornerRadius:5];
    [_passwordTextField.layer setBorderWidth:0.5];
    [_passwordTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    [_passwordTextField setDelegate:self];
    
    [_reinputPasswordTextField.layer setCornerRadius:5];
    [_reinputPasswordTextField.layer setBorderWidth:0.5];
    [_reinputPasswordTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    [_reinputPasswordTextField setDelegate:self];
    
    [_doneButton.layer setCornerRadius:5];
    [_doneButton.layer setBorderWidth:0.5];
    [_doneButton.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 35, kDeviceWidth - 20, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [_infromationBackgroundView addSubview:line1];
    
    [_companyLabel setText:[NSString stringWithFormat:@"企业账户:%@",_fogetPasswordVC.companyCode]];
    [_personLabel setText:[NSString stringWithFormat:@"企业账户:%@",_fogetPasswordVC.user]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
//http://rest.yewu.feesun.cn/?mod=getpwd&fun=setpwd&user_id=373&rand_code=d76b8a3d38e45e3b2b8a95ec493d0620&new_pwd=234561&versions=2.1.2&stype=1
    
    [self.passwordTextField resignFirstResponder];
    [self.reinputPasswordTextField resignFirstResponder];

    if (self.passwordTextField.text.length!=0 && self.reinputPasswordTextField.text.length!=0 && self.passwordTextField.text.length == self.reinputPasswordTextField.text.length)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@?mod=getpwd&fun=setpwd&user_id=%@&rand_code=%@&new_pwd=%@&versions=%@&stype=1",API_headaddr,_fogetPasswordVC.userID,_fogetPasswordVC.randomCode,self.reinputPasswordTextField.text,VERSIONS];
        NSLog(@"%@",strUrl);
        
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestResetPasswordWithUrl:strUrl Success:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] intValue] == 70200)
            {
                [self performSegueWithIdentifier:@"setPasswordToLogin" sender:Nil];
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[NSString stringWithFormat:@"修改成功，请重新登录"]
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
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"加载失败"
                                                         message:[NSString stringWithFormat:@"因数据环境不稳定，加载失败，请稍后重试"]
                                                        delegate:nil
                                               cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [av show];
            
        }];
//        
        
    }else{
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:[NSString stringWithFormat:@"两次输入不一致，请重新输入"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [av show];
    }

}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
