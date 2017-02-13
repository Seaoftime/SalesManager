//
//  YWViewController.m
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//


#import "YWViewController.h"
#import "HomePageViewController.h"
#import "YWLeftMenuViewController.h"
#import "MainViewController.h"
#import "MMDrawerVisualState.h"
#import "NSUserDefaults+Additions.h"
#import "InsertTextField.h"
#import "YuserInfomationFileds.h"
#import "YUserInfomationDBM.h"
#import "YCreateDatabase.h"
#import "initApp.h"

#import "UIImageView+WebCache.h"
#import "XHLocationManager.h"
#import "CLLocation+YCLocation.h"

@interface YWViewController ()

@property (strong, nonatomic) IBOutlet InsertTextField *companyIDTextField;
@property (strong, nonatomic) IBOutlet InsertTextField *userTextField;
@property (strong, nonatomic) IBOutlet InsertTextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)login:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end

@implementation YWViewController

static const CGFloat kPublicLeftMenuWidth = 220.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //填充数据
    _companyIDTextField.text = userDefaults.companyCode;
    _userTextField.text = userDefaults.userName;
    
    
    [_ico setImageWithURL:[NSURL URLWithString:[userDefaults stringForKey:[NSString stringWithFormat:@"logoUrl%@",_companyIDTextField.text]]] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    
    
    
    //修改样式
    [_companyIDTextField.layer setCornerRadius:5];
    [_companyIDTextField.layer setBorderWidth:0.5];
    [_companyIDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_companyIDTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_userTextField.layer setCornerRadius:5];
    [_userTextField.layer setBorderWidth:0.5];
    [_userTextField setDelegate:self];
    [_userTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_passwordTextField.layer setCornerRadius:5];
    [_passwordTextField.layer setBorderWidth:0.5];
    [_passwordTextField setDelegate:self];
    [_passwordTextField.layer setBorderColor:[UIColor colorWithWhite:0.545 alpha:1.000].CGColor];
    
    [_loginButton.layer setCornerRadius:5];
    
    

    if (kDeviceWidth == 320.000000) {
        //监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    [self startLocation];
    
}


//#warning
- (void)startLocation
{
    
    [[XHLocationManager sharedManager] locationRequest:^(CLLocation *location, NSError *error) {
        
    } reverseGeocodeCurrentLocation:^(CLPlacemark *placemark, NSError *error) {
        
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)login:(id)sender
{
    if (_companyIDTextField.text.length == 0)
    {
        [_companyIDTextField shake];
    }
    else if (_userTextField.text.length == 0)
    {
        [_userTextField shake];
    }
    else if (_passwordTextField.text.length == 0)
    {
        [_passwordTextField shake];
    }
    else if(isNetWork)
    {
        [self backgroundTap:nil];
        [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
        NSString *weatherUrl = [NSString stringWithFormat:@"%@?mod=login&fun=login&user=%@&pwd=%@&com_code=%@&versions=%@&stype=1",API_headaddr,_userTextField.text,_passwordTextField.text,_companyIDTextField.text,VERSIONS];
        
        if ([userDefaults objectForKey:@"token"]) {
            weatherUrl = [weatherUrl stringByAppendingFormat:@"&token=%@",[userDefaults objectForKey:@"token"]];
        }
        
        NSLog(@"%@",weatherUrl);
        weatherUrl = [weatherUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestLoginDataWithUrl:weatherUrl Success:^(id respondsData) {
            //
            NSLog(@"%@",respondsData);
            [SVProgressHUD dismiss];
            if ([[respondsData objectForKey:@"code"] integerValue] == 20200) {
                [self saveUserInfo:respondsData];
            }else {
                
                [self checkCodeByJson:respondsData];
            }
            
        } failed:^(NSError *error) {
            //
            if (isNetWork) {
                [SVProgressHUD showErrorWithStatus:@"登陆失败"];
                
            }else {
                
                [SVProgressHUD dismiss];
            }
        }];

        
        
    }else{
        UIAlertView* aler = [[UIAlertView alloc]initWithTitle:nil message:@"无法连接到网络，请先设置网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [aler show];
    }
        
        
 }

- (IBAction)backgroundTap:(id)sender
{
    [_companyIDTextField resignFirstResponder];
    [_userTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


-(void)succeed
{
    YWLeftMenuViewController *leftVC = [[YWLeftMenuViewController alloc]
                                        init];
    MainViewController * drawerController = [[MainViewController alloc]
                                             initWithCenterViewController:leftVC.navSlideSwitchVC
                                             leftDrawerViewController:leftVC
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
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

-(void)saveUserInfo:(NSDictionary* )logDic
{
    userDefaults.companyCode = _companyIDTextField.text;
    userDefaults.ID = [[logDic objectForKey:@"user_info"] objectForKey:@"user_id"];
    userDefaults.randCode  = [logDic objectForKey:@"rand_code"];
    userDefaults.name = [[logDic objectForKey:@"user_info"] objectForKey:@"name"];
    userDefaults.userName = _userTextField.text;
    userDefaults.position = [[logDic objectForKey:@"user_info"] objectForKey:@"isadmin"];
        userDefaults.departMentID = [[logDic objectForKey:@"user_info"] objectForKey:@"partnameid"];
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
        [userDefaults setObject:userInfo.logoURL forKey:[NSString stringWithFormat:@"logoUrl%@",_companyIDTextField.text]];
    }

    userInfo.password = [[logDic objectForKey:@"user_info"] objectForKey:@"pwd"];
    userInfo.position = [[[logDic objectForKey:@"user_info"] objectForKey:@"position"] integerValue];
    userInfo.positionName = [[logDic objectForKey:@"user_info"] objectForKey:@"positiontitle"];
//    userInfo.albumVersion = [[[logDic objectForKey:@"user_info"] objectForKey:@"albumverson"] integerValue];
//    userInfo.formVersion = [[[logDic objectForKey:@"user_info"] objectForKey:@"formversion"] integerValue];
    userInfo.department = [[logDic objectForKey:@"user_info"] objectForKey:@"department"];
    userInfo.userPicUrl = [[logDic objectForKey:@"user_info"] objectForKey:@"userpic"];
//    userInfo.hdImage = [[[logDic objectForKey:@"user_info"] objectForKey:@"hdImage"] integerValue];
//    userInfo.mapWithWifi = [[[logDic objectForKey:@"user_info"] objectForKey:@"mapWithWifi"] integerValue];
    userInfo.userName = _userTextField.text;
    [asd saveUserInfomations:userInfo];
     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];

    if ([[[logDic objectForKey:@"user_info"] objectForKey:@"onelogin"] isEqualToString:@"0"])
    {
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"toSetPassword" sender:self];
    }else{
        //先进入到主界面 然后弹出修改密码界面
        [self performSelectorOnMainThread:@selector(succeed) withObject:nil waitUntilDone:YES];
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//管理键盘
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.size.height;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    float y = self.view.bounds.size.height-keyboardTop-_loginButton.frame.origin.y-_loginButton.frame.size.height;

    if (!IS_IOS7) {
        y += 20;
    }
    CGRect rect=CGRectMake(0.0f,y,width,height);
    self.view.frame=rect;
    
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y ;
    if (IS_IOS7) {
        Y = 0;
    }else{
        Y = 20.0f;
    }
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    
    [_ico setImageWithURL:[NSURL URLWithString:[userDefaults stringForKey:[NSString stringWithFormat:@"logoUrl%@",_field.text]]] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    
    
    NSLog(@"%@",[userDefaults stringForKey:[NSString stringWithFormat:@"logoUrl%@",_field.text]]);
    NSLog(@"%@",[_field text]);
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case 2:
            [_passwordTextField becomeFirstResponder];
            break;
        case 3:
            [self login:textField];
            break;
            
            
        default:
            break;
    }
    
    return YES;
}


@end
