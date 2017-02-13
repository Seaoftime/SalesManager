//
//  YWPersonalVC.m
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWPersonalVC.h"
#import "UIViewController+MMDrawerController.h"
@interface YWPersonalVC ()

@end

@implementation YWPersonalVC

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
    self.view.backgroundColor = NAVIGATIONCOLOR;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"个人" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(16,30, 120, 22);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
}
-(void)gotoback
{
    self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController: self.homeNavi
                                   withCloseAnimation:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
