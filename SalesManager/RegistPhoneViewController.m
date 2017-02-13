//
//  RegistPhoneViewController.m
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "RegistPhoneViewController.h"
#import "VerifiCodeViewController.h"
@interface RegistPhoneViewController ()

@end

@implementation RegistPhoneViewController

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
    _BackImgView.image = [UIImage imageNamed:@"ResignBack.png"];
    _BackView.hidden=YES;
    [_PhoneNumView.layer setCornerRadius:5];
    [_PhoneNumView.layer setBorderWidth:0.5];
    [_PhoneNumView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_ConfirmBtn.layer setCornerRadius:5];
    [_ConfirmBtn.layer setBorderWidth:0.5];
    [_ConfirmBtn.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    // Do any additional setup after loading the view.
}
#pragma mark- 验证手机号

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

-(IBAction)ResignDown:(id)sender
{
    [_PhoneNumField resignFirstResponder];
}


- (IBAction)registerBtnClicked:(id)sender {
    
    [_PhoneNumField resignFirstResponder];
    if (![self isValidateMobile:_PhoneNumField.text]) {
        //_BackView.hidden=NO;
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                     message:[NSString stringWithFormat:@"请输入正确的手机号"]
                                                    delegate:nil
                                           cancelButtonTitle:@"确认" otherButtonTitles:nil];
        
        [av show];
        
    }else if(isNetWork){
        
        [SVProgressHUD showWithStatus:@"获取中" maskType:SVProgressHUDMaskTypeBlack];
        int num = [self getRandomNumber:1 to:99];
        int v1 = [self getRandomNumber:0 to:9];
        int v2 = [self getRandomNumber:0 to:9];
        int v3 = [self getRandomNumber:0 to:9];
        int v4 = [self getRandomNumber:0 to:9];
        
        XuLieNum = [NSString stringWithFormat:@"%d",num];
        Verifi =  [NSString stringWithFormat:@"%d%d%d%d",v1,v2,v3,v4];
        PhoneNum = [NSString stringWithFormat:@"%@",_PhoneNumField.text];
        NSString *weatherUrl = [NSString stringWithFormat:@"%@?mod=register&fun=sendcode&mobile=%@&mobilecode=%@&codenum=%@&versions=%@&stype=1",API_headaddr,PhoneNum,Verifi,XuLieNum,VERSIONS];
        //_PhoneNumField.text
        NSLog(@"%@",weatherUrl);
        weatherUrl = [weatherUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestRegisterWithUrl:weatherUrl Success:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 11200)
            {
                [SVProgressHUD dismiss];
                [self performSegueWithIdentifier:@"toVerifiCode" sender:nil];
                
            }else{
                
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:[respondsData objectForKey:@"msg"]];
            }
            
            
        } failed:^(NSError *error) {
            
            if (isNetWork) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无法连接到网络，请先设置网络"]];
    }

}



//获取一个随机整数
-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
}



- (IBAction)_back:(id)sender {
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要放弃注册吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    av.delegate=self;
    [av show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self performSegueWithIdentifier:@"back1" sender:nil];
    }
}




//-(IBAction)HidenClick:(id)sender
//{
//    _BackView.hidden=YES;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
