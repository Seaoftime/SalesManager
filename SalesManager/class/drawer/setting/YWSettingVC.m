//
//  YWSettingVC.m
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWSettingVC.h"
#import "UIViewController+MMDrawerController.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
#import "SetReportsVC.h"
#import "SetPasswordVC.h"
#import "SetSuggestionVC.h"
#import "AboutUSVC.h"
#import "UINavigationBar+customBar.h"
#import "YWSwitchCell.h"
#import "YWSettingNormalCell.h"

@interface YWSettingVC ()<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) UIButton *lgoutBtn;
@property (nonatomic, strong) NSMutableArray* baseDataArr;



@end

@implementation YWSettingVC

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
    
    _baseDataArr = [[NSMutableArray alloc]initWithArray:@[@[@"自定义快捷回复",@"修改密码"],@[@"仅在WIFI环境下上传高清图片",@"仅在WIFI环境下加载地图"],@[@"意见反馈",@"关于业务云管家"]]];

    self.setttingTV.backgroundColor = [UIColor colorWithRed:240/255. green:244/255. blue:246/255. alpha:1];
  
//    
    [self.setttingTV addSubview:self.lgoutBtn];
//
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(gotoback)];
    self.navigationItem.titleView=[TOOL setTitleView:@"设置"];
    
    updateView = [[UpdateView alloc]initWithFrame:CGRectMake(0, 0, 320, 560)];
    //if(!IS_IOS7)
        updateView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    [self.view addSubview:updateView];
    [updateView.updateButton addTarget:self action:@selector(updateNow) forControlEvents:UIControlEventTouchUpInside];
    [updateView.delayButton addTarget:self action:@selector(delayUpdate) forControlEvents:UIControlEventTouchUpInside];
    updateView.hidden =YES;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (kDeviceWidth == 320.000000) {
        
        //[self.setttingTV setFrame:CGRectMake(0, 0, kDeviceWidth, 2*KDeviceHeight)];
        [self.setttingTV setContentSize:CGSizeMake(kDeviceWidth, KDeviceHeight + 100)];
    }
    

}

-(void)saveDefaultHdImageValue:(UISwitch*)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (sender.on) {
        userDefaults.hdImage = @"1";
        //userDefaults.mapWithWifi = @"1";
        
    }else {
    
        userDefaults.hdImage = nil;
        //userDefaults.mapWithWifi = nil;
    }
}


-(void)saveDefaultMapWifiValue:(UISwitch*)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (sender.on) {
        userDefaults.mapWithWifi = @"1";
        
    }else {
        
        userDefaults.mapWithWifi = nil;
    }
}





- (UIButton *)lgoutBtn
{
    if (_lgoutBtn == nil) {
        _lgoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 370, kDeviceWidth , 45)];
        
        _lgoutBtn.backgroundColor = [UIColor redColor];
        [_lgoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_lgoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _lgoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_lgoutBtn addTarget:self action:@selector(logOutt) forControlEvents:UIControlEventTouchUpInside];
        
    }

    return _lgoutBtn;
}





#pragma mark - delegate && dataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _baseDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_baseDataArr[section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        YWSwitchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        cell.title.text = _baseDataArr[indexPath.section][indexPath.row];
        
        
        //判断 switch on/off
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (indexPath.row == 0) {
            if (userDefaults.hdImage) {
                
                cell.switchBtn.on = YES;
                [cell.switchBtn addTarget:self action:@selector(saveDefaultHdImageValue:) forControlEvents:UIControlEventValueChanged];

            }
        }else {
        
            
                cell.switchBtn.on = NO;
                [cell.switchBtn addTarget:self action:@selector(saveDefaultMapWifiValue:) forControlEvents:UIControlEventValueChanged];
        }
        
        
        return cell;

    }else{
        
        YWSettingNormalCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.title.text = _baseDataArr[indexPath.section][indexPath.row];
        
        
        return cell;

    }
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击后清除选中效果
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                
                SetReportsVC *vc = [[SetReportsVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
            
                SetPasswordVC *vc = [[SetPasswordVC alloc]initWithNibName:@"SetPasswordVC" bundle:Nil];
                [self.navigationController pushViewController:vc animated:YES];

            }
        }
            break;
            
        case 2:{
        
            if (indexPath.row == 0) {
                
                SetSuggestionVC *vc = [[SetSuggestionVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];

            }else {
            
                AboutUSVC *vc = [[AboutUSVC alloc]initWithNibName:@"AboutUSVC" bundle:Nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        
        }
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}


- (UIView* )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {

    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        //return 100;
    }
    return 0;
}







-(void)updateNow
{
    //.....
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ye-wu-dian-dian-tong/id592930826"]];
//     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:mostVersion forKey:@"appVersion"];
//    NSLog(@"%@",mostVersion);
}

-(void)detectUpdate
{
    //NSString *urls =APP_URL;
    //NSLog(@"%@",urls);
    
    //urls = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urls]];
//    [request setTimeoutInterval:kTIMEOUT];
    
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                                                        [SVProgressHUD dismiss];
//                                                        NSLog(@"%@",JSON);
//                                                      //  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                                                        
//                                                        if(![[[[JSON objectForKey:@"results"]objectAtIndex:0]objectForKey:@"version"]isEqualToString:VERSIONS])
//                                                        {
//                                                            updateView.hidden = NO;
//                                                            updateView.versionLabel.text = [[[JSON objectForKey:@"results"]objectAtIndex:0]objectForKey:@"version"];
//                                                            updateView.contentView.text = [[[JSON objectForKey:@"results"]objectAtIndex:0]objectForKey:@"releaseNotes"];
//                                                            mostVersion = [[[JSON objectForKey:@"results"]objectAtIndex:0]objectForKey:@"version"];
//                                                        }
//                                                        else
//                                                            [SVProgressHUD showSuccessWithStatus:@"已是最新版本"];
//                                                                                                          }
//                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                        
//                                                        [SVProgressHUD showErrorWithStatus:@"检测失败"];
//                                                    }];
//    [operation start];
//    
    
}

-(void)delayUpdate
{
    updateView.hidden = YES;
}

-(void)gotoback
{
    if(updateView.hidden == NO)
    {
        updateView.hidden = YES;
    }
    else
    {
        if(self.fromPush)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
    self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController: self.homeNavi
                                   withCloseAnimation:YES completion:nil];
        }
    }
}




- (void)logOutt
{
    
    
    
    
    UIActionSheet* logOut = [[UIActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据，下次登陆依然可以使用本账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登陆" otherButtonTitles:nil, nil];
    
    //UIWindow *asd = [[[UIApplication sharedApplication] delegate] window];
    
    [logOut showInView:self.view];


}



- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{



}



#pragma mark - actionSheetDelegate -

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        /*-----注销用户start------*/
        
        [[YWNetRequest sharedInstance] requestSettingWithSuccess:^(id respondsData) {
            //
        } failed:^(NSError *error) {
            //
        }];
        
        /*-----注销用户end------*/
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logOutt" object:nil];
        
        
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
