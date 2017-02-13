//
//  YWSetPassWordViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWSetPassWordViewController.h"
#import "YWLeftMenuViewController.h"
#import "MainViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface YWSetPassWordViewController ()

@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *repeatPasswordView;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordTextField;

- (IBAction)modifyPassword:(id)sender;

@end

@implementation YWSetPassWordViewController

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
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //修改样式
    [_passwordView.layer setCornerRadius:5];
    [_passwordView.layer setBorderWidth:0.5];
    [_passwordView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_repeatPasswordView.layer setCornerRadius:5];
    [_repeatPasswordView.layer setBorderWidth:0.5];
    [_repeatPasswordView.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                 message:[NSString stringWithFormat:@"首次登陆请先设置新密码"]
                                                delegate:nil
                                       cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [av show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifyPassword:(id)sender
{
    if (_passwordTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    else if (_repeatPasswordTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请再次输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        if ([_passwordTextField.text isEqualToString:_repeatPasswordTextField.text])
        {

            NSString *strUrl = [NSString stringWithFormat:@"%@?mod=user&fun=safe&user_id=%@&rand_code=%@&old_pwd=123456&new_pwd=%@&versions=%@&stype=1",API_headaddr,userDefaults.ID,userDefaults.randCode,_repeatPasswordTextField.text,VERSIONS];
            //NSLog(@"%@",strUrl);
            
            strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[YWNetRequest sharedInstance] requestModifyPasswordWithUrl:strUrl Success:^(id respondsData) {
                //
                if ([[respondsData objectForKey:@"code"] intValue] == 50200)
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:[NSString stringWithFormat:@"密码修改成功"]
                                                                delegate:nil
                                                       cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    
                    [av show];
                    
                    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                    userDefaults.randCode = [respondsData objectForKey:@"rand_code"];
                    [self succeed];
                }else{
                    [self checkCodeByJson:respondsData];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            } failed:^(NSError *error) {
                //
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
                      
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入不相同,请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

-(void)succeed
{
    YWLeftMenuViewController *leftVC = [[YWLeftMenuViewController alloc]
                                        init];
    MainViewController * drawerController = [[MainViewController alloc]
                                             initWithCenterViewController:leftVC.navSlideSwitchVC
                                             leftDrawerViewController:leftVC
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:220];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setShouldStretchDrawer:NO];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    drawerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:drawerController animated:YES completion:Nil];
}

@end
