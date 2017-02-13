//
//  VerifiCodeViewController.m
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "VerifiCodeViewController.h"

@interface VerifiCodeViewController ()

@end

@implementation VerifiCodeViewController

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
    
    [_VerifiCodeView.layer setCornerRadius:5];
    [_VerifiCodeView.layer setBorderWidth:0.5];
    [_VerifiCodeView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_ReVerifiBtn.layer setCornerRadius:5];
    [_ReVerifiBtn.layer setBorderWidth:0.5];
    [_ReVerifiBtn.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_TimeView.layer setCornerRadius:5];
    [_TimeView.layer setBorderWidth:0.5];
    [_TimeView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_SubmitBtn.layer setCornerRadius:5];
    [_SubmitBtn.layer setBorderWidth:0.5];
    [_SubmitBtn.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    _VerifiCodeField.placeholder = @"请输入手机验证码";
    [self StartReTimer];
	// Do any additional setup after loading the view.
}
-(void)StartReTimer
{
    _TimeView.hidden=NO;
    isOutTime=NO;
    _CallVerifiBtn.alpha=0.0;
    if (IS_IOS7) {
        [UIView animateWithDuration:0.5 animations:^{
            _SubmitBtn.frame = CGRectMake(10, 144, 300, 40);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _SubmitBtn.frame = CGRectMake(10, 124, 300, 40);
        }];
    }
    
    _ReVerifiBtn.hidden=YES;
    _VerifiCodeView.hidden=NO;
    secondsCountDown = 60;
    time = 120;
    _Timelbl.text = [NSString stringWithFormat:@"%d",secondsCountDown];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    _MessageLbl.text = [NSString stringWithFormat:@"密码已发送到%@,请查收并输入,序号%@",PhoneNum,XuLieNum];
    OutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(OutTime) userInfo:nil repeats:YES];
}
-(void)timeFireMethod{
    secondsCountDown--;
    _Timelbl.text = [NSString stringWithFormat:@"%d",secondsCountDown];
    if(secondsCountDown==30){
        _CallVerifiBtn.alpha=0.0;
        //_CallVerifiBtn.hidden=NO;
        [UIView animateWithDuration:0.5 animations:^{
            _CallVerifiBtn.alpha=1.0;
            if (IS_IOS7) {
                _SubmitBtn.frame = CGRectMake(10, 167, 300, 40);

            }else{
            _SubmitBtn.frame = CGRectMake(10, 147, 300, 40);
            }
        }];
        
    }
    if (secondsCountDown==0) {
        [countDownTimer invalidate];
        _TimeView.hidden=YES;
        _ReVerifiBtn.hidden=NO;
        _CallVerifiBtn.alpha=1.0;
        if (IS_IOS7) {
            _CallVerifiBtn.alpha=0.0;
            [UIView animateWithDuration:0.5 animations:^{
                _SubmitBtn.frame = CGRectMake(10, 144, 300, 40);
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                _SubmitBtn.frame = CGRectMake(10, 124, 300, 40);
            }];
        }
    }
}
-(void)OutTime
{
    time--;
    if (time==0) {
        [OutTimer invalidate];
        isOutTime=YES;
        _MessageLbl.text = @"您的验证码已经过期请重新获取";
        _CallVerifiBtn.alpha=1.0;
        [UIView animateWithDuration:0.5 animations:^{
            _CallVerifiBtn.alpha=0.0;
           // _CallVerifiBtn.hidden=YES;
            if (IS_IOS7) {
                _SubmitBtn.frame = CGRectMake(10, 144, 300, 40);
            }else{
            _SubmitBtn.frame = CGRectMake(10, 124, 300, 40);
            }
        }];
    }
}
//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
}

-(IBAction)RegetVerifiClick:(id)sender
{
    
    if(isNetWork){
        if (isOutTime) {
            int num = [self getRandomNumber:1 to:100];
            int v1 = [self getRandomNumber:0 to:10];
            int v2 = [self getRandomNumber:0 to:10];
            int v3 = [self getRandomNumber:0 to:10];
            int v4 = [self getRandomNumber:0 to:10];
            XuLieNum = [NSString stringWithFormat:@"%d",num];
            Verifi = [NSString stringWithFormat:@"%d%d%d%d",v1,v2,v3,v4];
        }
        [SVProgressHUD showWithStatus:@"获取中" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *weatherUrl = [NSString stringWithFormat:@"%@?mod=register&fun=sendcode&mobile=%@&mobilecode=%@&codenum=%@&versions=%@&stype=1",API_headaddr,PhoneNum,Verifi,XuLieNum,VERSIONS];
        
        NSLog(@"%@",weatherUrl);
        //weatherUrl = [weatherUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:weatherUrl]];
        [request setTimeoutInterval:kTIMEOUT];
        
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//        AFJSONRequestOperation *operation =
//        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
//                                                            NSLog(@"%@",JSON);
//                                                            
//                                                            if ([[JSON objectForKey:@"code"] integerValue] == 11200)
//                                                            {
//                                                                [SVProgressHUD dismiss];
//                                                                [countDownTimer invalidate];
//                                                                [OutTimer invalidate];
//
//                                                                [self StartReTimer];
//                                                            }else{
//                                                                
//                                                                [SVProgressHUD dismiss];
//                                                                [SVProgressHUD showErrorWithStatus:@"获取失败"];
//                                                            }
//                                                        }
//                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                            NSLog(@"%@",error);
//                                                            
//                                                            if (isNetWork) {
//                                                                [SVProgressHUD dismiss];
//                                                                [SVProgressHUD showErrorWithStatus:@"请求失败"];
//                                                            }else{
//                                                                [SVProgressHUD dismiss];
//                                                            }
//                                                        }];
//        [operation start];
        
        
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无法连接到网络，请先设置网络"]];
    }

}
-(IBAction)CallVerifiClick:(id)sender
{
    [_VerifiCodeField resignFirstResponder];
    if (isNetWork) {
        NSString *weatherUrl = [NSString stringWithFormat:@"%@?mod=register&fun=sendcode&mobile=%@&mobilecode=%@&versions=%@&stype=1&isyy=1",API_headaddr,PhoneNum,Verifi,VERSIONS];
        
        NSLog(@"%@",weatherUrl);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:weatherUrl]];
        [request setTimeoutInterval:kTIMEOUT];
        
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//        AFJSONRequestOperation *operation =
//        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
//                                                            NSLog(@"%@",JSON);
//                                                            
//                                                            if ([[JSON objectForKey:@"code"] integerValue] == 11200)
//                                                            {
//                                                                [SVProgressHUD dismiss];
//                                                                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请稍等，你将会收到的验证码语音服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                                                                [av show];
//                                                            }else{
//                                                                
//                                                                
//                                                                [SVProgressHUD dismiss];
//                                                                [SVProgressHUD showErrorWithStatus:@"获取失败"];
//                                                            }
//                                                        }
//                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                            NSLog(@"%@",error);
//                                                            
//                                                            if (isNetWork) {
//                                                                [SVProgressHUD dismiss];
//                                                                [SVProgressHUD showErrorWithStatus:@"请求失败"];
//                                                            }else{
//                                                                [SVProgressHUD dismiss];
//                                                            }
//                                                        }];
//        [operation start];
//
    
    
    }else{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无法连接到网络，请先设置网络"]];
    }
}
-(IBAction)ResignDown:(id)sender
{
    [_VerifiCodeField resignFirstResponder];
}

-(IBAction)SubmitClick:(id)sender
{
    //[self performSegueWithIdentifier:@"toRegisSetting" sender:nil];
    if (!_VerifiCodeField.text.length>0){
        
        [_VerifiCodeView ShakeMyView];
        
    }else if([_VerifiCodeField.text isEqualToString:Verifi]){
        
        [self performSegueWithIdentifier:@"toRegisSetting" sender:nil];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"验证码输入错误"];
    }
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
        [self performSegueWithIdentifier:@"back2" sender:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitButtonClicked:(id)sender {
    
    if (!self.VerifiCodeField.text.length>0){
        
        [self.VerifiCodeField ShakeMyView];
        
    }else if([self.VerifiCodeField.text isEqualToString:Verifi]){
        
        [self performSegueWithIdentifier:@"toRegisSetting" sender:nil];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"验证码输入错误"];
    }
    
    
}







@end
