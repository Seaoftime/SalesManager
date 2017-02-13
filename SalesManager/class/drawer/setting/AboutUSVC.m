//
//  AboutUSVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "AboutUSVC.h"

@interface AboutUSVC ()

@end

@implementation AboutUSVC

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
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:244/255.0 blue:247/255.0 alpha:1.0];
    if(!IS_4INCH)
    {
        CGRect aframe = self.bottomBgView.frame;
        aframe.origin.y = KDeviceHeight - 154.0 - 64;
        self.bottomBgView.frame = aframe;
    }
    
//    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(10, 20, 50, 44)];
//    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UILabel *titleText = [TOOL setTitleView:@"关于业务云管家"];
    self.navigationItem.titleView=titleText;
    
    self.versionLabel.text = [NSString stringWithFormat:@"%@版",VERSIONS];
        
}

-(void)gotoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
