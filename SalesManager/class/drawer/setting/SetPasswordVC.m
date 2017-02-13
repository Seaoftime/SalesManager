//
//  SetPasswordVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SetPasswordVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
extern NSString* userid;
extern NSString* randcode;
@interface SetPasswordVC ()

@end

@implementation SetPasswordVC

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
    // Do any additional setup after loading the view from its nib.
    //if(!IS_IOS7)
    self.totalBgView.frame = CGRectMake(0, 10, kDeviceWidth, 200);
    self.view.backgroundColor = BGCOLOR;
//
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton* rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
     [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    
    UILabel *titleText = [TOOL setTitleView:@"修改密码"];
    self.navigationItem.titleView=titleText;
    
    [self.oldPasswordField becomeFirstResponder];
}

-(void)gotoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)done
{
    if([self.oldPasswordField.text isEqualToString:@""]||[self.tnewPasswordField.text isEqualToString:@""]||[self.renewPasswordField.text isEqualToString:@""])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"输入不能为空，请检查"
                                                     message:Nil
                                                    delegate:nil
                                           cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [av show];
    }
    else if([self.tnewPasswordField.text isEqualToString:self.renewPasswordField.text])
    {
        NSString *stype = @"1";
        NSString *urls = API_resetPassword(API_headaddr,userID,randCode,self.oldPasswordField.text,self.tnewPasswordField.text,VERSIONS,stype);
        NSLog(@"%@",urls);
        
        [[YWNetRequest sharedInstance] requestSettingSetPasswordWithUrl:urls WithSuccess:^(id respondsData) {
            //
            if([[respondsData objectForKey:@"code"] integerValue]==50200)
            {
                [SVProgressHUD showSuccessWithStatus:@" 修改密码成功"];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                userDefaults.randCode = [respondsData objectForKey:@"rand_code"];
                randCode = userDefaults.randCode;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self checkCodeByJson:respondsData];
            }

            
        } failed:^(NSError *error) {
            //
            [SVProgressHUD showErrorWithStatus:@"密码修改失败"];
        }];
        
        
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"新密码不一致，请重新输入"
                                                     message:Nil
                                                    delegate:nil
                                           cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [av show];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
