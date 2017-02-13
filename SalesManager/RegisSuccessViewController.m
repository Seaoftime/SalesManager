//
//  RegisSuccessViewController.m
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "RegisSuccessViewController.h"

@interface RegisSuccessViewController ()

@end

@implementation RegisSuccessViewController

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
    for (int i = 1; i <= 2; i++) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * i, 300, 0.5)];
		view.backgroundColor = [UIColor colorWithRed:210 / 255. green:210 / 255. blue:210 / 255. alpha:1];
		[contentBackgroundView addSubview:view];
	}
    
	contentBackgroundView.layer.cornerRadius = 5;
	contentBackgroundView.layer.borderWidth = 0.5;
	contentBackgroundView.layer.borderColor = [UIColor colorWithWhite:0.545 alpha:1.000].CGColor;
	contentBackgroundView.clipsToBounds = YES;
    
    LoginBtn.layer.cornerRadius = 5;
    
    CompanyNumlbl.text = [NSString stringWithFormat:@"%@",RegisCompanyNum];
    ManagerNumlbl.text = [NSString stringWithFormat:@"%@",RegisLoginNum];
    Passwordlbl.text =[NSString stringWithFormat:@"%@",RegisPassword];    // Do any additional setup after loading the view.
}

-(IBAction)LoginClick:(id)sender
{
    [self performSegueWithIdentifier:@"toSwitchType" sender:nil];
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
        [self performSegueWithIdentifier:@"back4" sender:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
