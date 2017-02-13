//
//  HomePageViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-9.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "HomePageViewController.h"
#import "UITableViewController+MMDrawerController.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "MKNumberBadgeView.h"
#import "YFormDBM.h"
#import "YformFileds.h"
#import "SVProgressHUD.h"
#import "YUserInfomationDBM.h"
#import "YuserInfomationFileds.h"
#import "SignInDetailViewController.h"
#import "YSignInDBM.h"
#import "YWLeftMenuViewController.h"
#import "UINavigationBar+customBar.h"
#import "ILBarButtonItem.h"
#import "YWErrorDBM.h"
#import "JDStatusBarNotification.h"
#import "pinyin.h"
#import "YSummaryFields.h"
#import "InformationReportDetailViewController.h"
#import "YWNoticeByIdVC.h"
#import "initApp.h"

#import "XHLocationManager.h"
#import "CLLocation+YCLocation.h"
#import "UIImageView+WebCache.h"

@interface HomePageViewController ()
{
    NSString *longitude;
    NSString *latitude;

}

@property (nonatomic, strong) NSMutableArray *diaryArray;
@property (nonatomic, strong) NSMutableArray *locationArray;//不仅包括签到 还包括其他

@property (strong, nonatomic) IBOutlet UIView *locationView;

- (IBAction)showMenu:(id)sender;

@end

@implementation HomePageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _diaryArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//判断是否有内容，如果没有内容则添加无内容图片
-(void)noContent:(BOOL)YN
{
//
    UIImageView* hold = (UIImageView* )[self.tableView viewWithTag:2077];
    if (hold)
    {
        if (!YN)
        {
            [hold removeFromSuperview];
            hold = nil;
        }
    }else{
        if (YN)
        {
            if (!hold)
            {
                hold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"StatueLogo@2x"]];
                hold.tag = 2077;
                hold.frame = CGRectMake(0, 0, 300, 300);
                int y;
                if (IS_4INCH) {
                    y = 85;
                }else{
                    y = 55;
                }
                
                hold.center = CGPointMake(self.tableView.center.x, self.tableView.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                [self.tableView addSubview:hold];
            }
        }
    }

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _locationArray = [[NSMutableArray alloc] initWithArray:userDefaults.homepage];
    [self.tableView reloadData];

    
    /* Left bar button item */
    
    
    ILBarButtonItem *leftBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"home_list"]
                                                   selectedImage:nil
                                                          target:self
                                                          action:@selector(showMenu:)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = BGCOLOR;

    [[GCDataBaseManager shareDatabase] openDataBaseWithDatabaseName:userDefaults.ID];

    [initApp appStart];
    NSLog(@"%@,%@,%@",userDefaults.userName,userDefaults.ID,userDefaults.companyCode);
    
    userID = [userDefaults ID];
    randCode = [userDefaults randCode];
    company_Code = [userDefaults companyCode];
    userName = [userDefaults userName];
    
    
    if (_diaryArray.count == 0 && _locationArray.count == 0)
    {
        [self noContent:YES];
    }else{
        [self noContent:NO];
    }
    
    checkNew = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(getHomeDate) userInfo:nil repeats:YES];
    [checkNew fire];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutRemoveNotic) name:@"removeTimer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetConection:) name:@"checkNetWork" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeDate) name:@"getNews" object:nil];
    
    //去掉多余的cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch-V3.1.0"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"firstLaunch-V3.1.0"];
        GestureView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        GestureView.backgroundColor = [UIColor blackColor];
        GestureView.alpha=0.5;
        [[[[UIApplication sharedApplication]delegate]window]  addSubview:GestureView];
        [[[[UIApplication sharedApplication]delegate]window]  bringSubviewToFront:GestureView];
        
        
        
        gifImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,250,119,117)];
        
        NSMutableArray *images = [NSMutableArray array];
        for (int i=0; i<=4; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"main_hand%d.png",i]]];
        }
        gifImage.animationImages = images;
        gifImage.animationDuration=1;
        gifImage.animationRepeatCount = -1;
        [GestureView addSubview:gifImage];
        [gifImage startAnimating];
        [self swipView];
        
    }
    
    [self startLocation];
    
    //NSLog(@"%f%f",SCREENW,SCREENH);//9.7  1024*768
    
}


//#warning
- (void)startLocation
{
    UILabel *gpsLabel = (UILabel *)[_locationView viewWithTag:100];
    
    [[XHLocationManager sharedManager] locationRequest:^(CLLocation *location, NSError *error) {
        if (error == nil) {
            NSLog(@"%@",location);
            
            CLLocation *baidulocation = [location locationBaiduFromMars];
            latitude = [NSString stringWithFormat:@"%f",baidulocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",baidulocation.coordinate.longitude];
            
        } else {
            NSLog(@"%@",error);
            gpsLabel.text = @"";
        }
    } reverseGeocodeCurrentLocation:^(CLPlacemark *placemark, NSError *error) {
        
    }];
}




-(void)swipView{
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [GestureView addGestureRecognizer:recognizer];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    switch (recognizer.direction){
        case UISwipeGestureRecognizerDirectionRight:
            [gifImage stopAnimating];
            [gifImage removeFromSuperview];
            [GestureView removeFromSuperview];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        default:
            break;
    }
}
-(void)noNetConection:(NSNotification* )YN {
    
    //NSLog(@"%@",YN.object);
    UIImageView* asd = (UIImageView* )[self.view viewWithTag:777];
    if ([YN.object isEqual:@"1"]) {
        [self getHomeDate];
        if (asd) {
            self.tableView.tableHeaderView = nil;
        }
    }else{
        if (!asd) {
            asd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
            asd.backgroundColor = [UIColor blackColor];
            asd.alpha = .7f;
            asd.tag = 777;
            UILabel* aaa = [[UILabel alloc]init];
            aaa.frame = CGRectMake(kDeviceWidth/2 - 60, 0, 120, 30);
            aaa.text = @"失去网络链接";
            aaa.font = [UIFont systemFontOfSize:14];
            [aaa setTextAlignment:NSTextAlignmentCenter];
            aaa.textColor = [UIColor whiteColor];
            aaa.backgroundColor = [UIColor clearColor];
            [asd addSubview:aaa];
            self.tableView.tableHeaderView = asd;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YWLeftMenuViewController *leftVC = (YWLeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
    leftVC.isShowSelect = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self getHomeDate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = @[@"待办事项",@"最新动态"];
    return [titleArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return _diaryArray.count;
    }
    return _locationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //个数  红点
    MKNumberBadgeView *badge = (MKNumberBadgeView *)[cell.contentView viewWithTag:99];
    [badge setHideWhenZero:YES];
    //头像
    UIImageView *photoImageView = (UIImageView *)[cell.contentView viewWithTag:100];
    [photoImageView.layer setCornerRadius:5];
    [photoImageView.layer setMasksToBounds:YES];
    //标题
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    //摘要
    UILabel *abstractLabel = (UILabel *)[cell.contentView viewWithTag:102];
    //时间
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:103];
    
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            [badge setValue:[[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"num"] intValue]];
            if([[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"diary"])
            {
                
                YFormDBM* formDB = [[YFormDBM alloc]init];
                NSString* imageName = [NSString stringWithFormat:@"M%d.png",[formDB getImageTypeBysectionID:[[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"formtypeid"] integerValue]] ];

                [photoImageView setImage:[UIImage imageNamed:imageName]];
                [titleLabel setText:[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"formtypetitle"]];
            }
            else if([[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"task"])
            {
                [photoImageView setImage:[UIImage imageNamed:@"M任务@2x"]];
                [titleLabel setText:@"我的任务"];
            }
            else if ([[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"notice"])
            {
                [photoImageView setImage:[UIImage imageNamed:@"M通知@2x"]];
                [titleLabel setText:@"通知公告"];
            }
            [abstractLabel setText:[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
            [timeLabel setText:[TOOL ttimeUptoNowFrom:[[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"posttime"] integerValue]]];
            
        }
            break;
        case 1:
        {
            YManagerUserInfoDBM *managerUser = [[YManagerUserInfoDBM alloc] init];
            YManagerUserInfoFileds *user = [managerUser getPersonInfoByUserID:[[[_locationArray objectAtIndex:indexPath.row] objectForKey:@"fromuserid"] integerValue] withPhotoUrl:YES withDepartment:NO withContacts:NO];
            [badge setValue:0];
            
            
            [photoImageView setImageWithURL:[NSURL URLWithString:user.userPhotoUrl] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
            
            
            [titleLabel setText:user.userName];
            [abstractLabel setText:[[_locationArray objectAtIndex:indexPath.row] objectForKey:@"msg"]];
            [timeLabel setText:[TOOL ttimeUptoNowFrom:[[[_locationArray objectAtIndex:indexPath.row] objectForKey:@"lastdotime"] integerValue]]];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _diaryArray.count == 0) {
        return 0;
    }
    if (section == 1 && _locationArray.count == 0) {
        return 0;
        
    }
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //背景
    UIView *sectionHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    sectionHeadBackgroundView.backgroundColor = [UIColor colorWithRed:0.941 green:0.957 blue:0.969 alpha:0.9];
    //
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    
    
    
    [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [sectionHeadBackgroundView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kDeviceWidth, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [sectionHeadBackgroundView addSubview:line2];
    
    //文字
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5.5, 310, 20)];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.font = [UIFont systemFontOfSize:13];
    headLabel.textColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
    headLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionHeadBackgroundView addSubview:headLabel];
    
    //NSLog(@"%@",[self tableView:tableView titleForHeaderInSection:section]);
    
    return sectionHeadBackgroundView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if([[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"diary"])
        {
            if (1 == [[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"num"] integerValue] )
            {
                YSummaryFields *summary = [[YSummaryFields alloc] init];
                summary.summaryId = [[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"workid"];
                summary.timeStampList = 222;
                
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                
                InformationReportDetailViewController *detail = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReportDetail"];;
                detail.summaryListField = summary;
                detail.isPush = YES;
                detail.isHome = YES;
                
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                [TOOL setKey:[[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"formtypeid"] intValue] value:1];
                
                YWLeftMenuViewController *leftVC = (YWLeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
                [leftVC selectOneItem:[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"formtypeid"] task:NO notice:NO];
            }
        }
        else if([[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"task"])
        {
            if (1 == [[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"num"] integerValue])
            {
                YWOtherNotDoneVC *task = [[YWOtherNotDoneVC alloc] init];
                task.taskID = [[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"id"];
                task.fromHomepage = YES;
                [self.navigationController pushViewController:task animated:YES];
            }else{
                [TOOL setKey:3 value:1];
                YWLeftMenuViewController *leftVC = (YWLeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
                [leftVC selectOneItem:nil task:YES notice:NO];
            }
        }
        else if ([[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"notice"])
        {
            NSLog(@"%@",_diaryArray);
            if (1 == [[[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"num"] integerValue])
            {
                YWNoticeByIdVC *notice = [[YWNoticeByIdVC alloc] init];
                notice.fromHomepage = YES;
                notice.noticeid = [[_diaryArray objectAtIndex:indexPath.row] objectForKey:@"id"];
                [self.navigationController pushViewController:notice animated:YES];
            }else{
                [TOOL setKey:2 value:1];
                YWLeftMenuViewController *leftVC = (YWLeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
                [leftVC selectOneItem:nil task:NO notice:YES];
            }
        }
    }
    
    if (indexPath.section == 1)
    {
//        备注 ：
//        type 类型的涵义
//        1 =>'您有一条新的汇报批复',  //index.php
//		2 => '您有新的通知', //notice_view.php
//		4 => '您有新的任务', //task_view.php
//		3 => '图库有更新',  //comalbum_view.php 两个地方
//		5 => '有新版本可以升级', //暂时没有，不在程序中提交。
//		6 => '新的汇报被提交' , //给收到信息汇报的人添加提醒
//		7 => '***修改了任务' ,
//		8 => '***关闭了任务',
//		9 => '***完成了任务' ,
//		10 => '***在**签到' ,
        NSInteger type = [[[_locationArray objectAtIndex:indexPath.row] objectForKey:@"type"] integerValue];
        switch (type)
        {
            case 1://信息汇报
            case 6://信息汇报
            {
                YSummaryFields *summary = [[YSummaryFields alloc] init];
                summary.summaryId = [[_locationArray objectAtIndex:indexPath.row] objectForKey:@"id"];
                summary.timeStampList = 222;
                
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                
                InformationReportDetailViewController *detail = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReportDetail"];;
                detail.summaryListField = summary;
                detail.isPush = YES;
                detail.isHome = YES;
                
                [self.navigationController pushViewController:detail animated:YES];
            }
                break;
            case 2://通知
            {
                YWNoticeByIdVC *notice = [[YWNoticeByIdVC alloc] init];
                notice.fromHomepage = YES;
                notice.noticeid = [[_locationArray objectAtIndex:indexPath.row] objectForKey:@"id"];
                [self.navigationController pushViewController:notice animated:YES];
            }
                break;
            case 3://图库
            {
                YWLibrayVC *libray = [[YWLibrayVC alloc] init];
                libray.fromHomepage = YES;
                [self.navigationController pushViewController:libray animated:YES];
            }
                break;
            case 4://任务
            case 7://任务
            case 8://任务
            case 9://任务
            {
                YWOtherNotDoneVC *task = [[YWOtherNotDoneVC alloc] init];
                task.taskID = [[_locationArray objectAtIndex:indexPath.row] objectForKey:@"id"];
                task.fromHomepage = YES;
                [self.navigationController pushViewController:task animated:YES];
            }
                break;
            case 10://签到
            {
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
                
                SignInDetailViewController *detailVC = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"signInDetail"];
                YSignInFields *sign = [[YSignInFields alloc] init];
                sign.signInID = [[_locationArray objectAtIndex:indexPath.row] objectForKey:@"id"];
                detailVC.signInFileds = sign;
                detailVC.isPush = YES;
                detailVC.isHome = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
            default:
                break;
        }
        
        
        
    }
}

#pragma mark - navigation

- (IBAction)showMenu:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - 获取首页信息

- (void)getHomeDate
{
         if (userDefaults.randCode)
         {
             if (isNetWork )
             {
                 @try
                 {
                     if (!afNetConnectArray)
                     {
                         afNetConnectArray = [[NSMutableArray alloc]init];
                     }
                     NSString *strUrl = [NSString stringWithFormat:@"%@?mod=user&fun=gethomex&user_id=%@&rand_code=%@&versions=%@&stype=1",API_headaddr,userID,randCode,VERSIONS];
                     
                     
                     NSLog(@"%@",strUrl);
                     
                     
                     if (![afNetConnectArray containsObject:strUrl])
                     {
                         [afNetConnectArray addObject:strUrl];
                         NSLog(@"%@",strUrl);
                         
                         strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         
                         [[YWNetRequest sharedInstance] requestHomePageDataWithUrl:strUrl Success:^(id respondsData) {
                             //
                             [afNetConnectArray removeObject:strUrl];
                             
                             NSLog(@"%@",respondsData);
                             
                             if ([[respondsData objectForKey:@"code"] integerValue] == 50200) {
                                 [_diaryArray removeAllObjects];
                                 [self analysisVersions:respondsData];
                                 
                                 //解析信息汇报
                                 if ([[[respondsData objectForKey:@"home_info"] objectForKey:@"is_worklog"] integerValue] > 0)
                                 {
                                     @try
                                     {
                                         NSEnumerator *enumeratorKey = [[[respondsData objectForKey:@"home_info"] objectForKey:@"diary"] keyEnumerator];
                                         
                                         for (NSString *key in enumeratorKey)
                                         {
                                             NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[[respondsData objectForKey:@"home_info"] objectForKey:@"diary"] objectForKey:key]];
                                             [dic setValue:@"diary" forKey:@"type"];
                                             
                                             [TOOL setKey:[key intValue] value:1];
                                             [_diaryArray addObject:dic];
                                             
                                             
                                         }
                                     }
                                     @catch (NSException *exception)
                                     {
                                         YWErrorDBM *ad = [[YWErrorDBM alloc]init];
                                         [ad saveAnErrorInfo:[NSString stringWithFormat:@"解析信息汇报\nClass:%@\nFun:%s\n", self.class, __FUNCTION__]];
                                     }
                                 }
                                 //解析通知
                                 if ([[[respondsData objectForKey:@"home_info"] objectForKey:@"is_message"] integerValue] > 0)
                                 {
                                     NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[respondsData objectForKey:@"home_info"] objectForKey:@"notice"]];
                                     [dic setValue:@"notice" forKey:@"type"];
                                     [dic setValue:[[respondsData objectForKey:@"home_info"] objectForKey:@"is_message"] forKey:@"num"];
                                     [_diaryArray addObject:dic];
                                 }
                                 //解析任务
                                 if ([[[respondsData objectForKey:@"home_info"] objectForKey:@"is_task"] integerValue] > 0)
                                 {
                                     
                                     @try
                                     {
                                         NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[respondsData objectForKey:@"home_info"] objectForKey:@"task"]];
                                         [dic setValue:@"task" forKey:@"type"];
                                         [dic setValue:[[respondsData objectForKey:@"home_info"] objectForKey:@"is_task"] forKey:@"num"];
                                         [_diaryArray addObject:dic];
                                     }
                                     @catch (NSException *exception)
                                     {
                                         
                                     }
                                     
                                     
                                 }
                                 //解析最新动态
                                 @try
                                 {
                                     _locationArray = [[NSMutableArray alloc]initWithArray:[[respondsData objectForKey:@"home_info"] objectForKey:@"news"]];
                                     userDefaults.homepage = _locationArray;
                                 }
                                 @catch (NSException *exception)
                                 {
                                 }
                                 
                                 if (_diaryArray.count == 0 && _locationArray.count == 0)
                                 {
                                     [self noContent:YES];
                                 }else{
                                     [self noContent:NO];
                                 }
                                 
                                 [self.tableView reloadData];
                                 [self checkWithErrorMsg];
                                 [UIApplication sharedApplication].applicationIconBadgeNumber = [[[respondsData objectForKey:@"home_info"] objectForKey:@"is_task"] integerValue]+[[[respondsData objectForKey:@"home_info"] objectForKey:@"is_message"] integerValue]+[[[respondsData objectForKey:@"home_info"] objectForKey:@"is_worklog"] integerValue];
                                 
                             }else {
                                 
                                 [self checkCodeByJson:respondsData];
                             }
                             
                         } failed:^(NSError *error) {
                             //
                             [afNetConnectArray removeObject:strUrl];
                         }];

                         
                         
                     }
                 }
                 @catch (NSException *exception)
                 {
                     YWErrorDBM* ad = [[YWErrorDBM alloc]init];
                     [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
                 }
             }
         }
    
}


-(void)checkWithErrorMsg{
    YWErrorDBM* errDB = [[YWErrorDBM alloc]init];
    
    NSString* asd = [errDB getErrorinfo];
    
    if (asd && isNetWork) {
        
        [[YWNetRequest sharedInstance] requestHomePagecheckWithErrorMsgDataWithasd:asd Success:^(id respondsData) {
            //
            [errDB cleanDatabase];
            
        } failed:^(NSError *error) {
            
        }];
        
    }
    
    
}


#pragma mark - initWithBaseBata

//-(void)checkVersion{
//    NSString *strUrl = [NSString stringWithFormat:@"%@?mod=getmessage&fun=getmessage&user_id=%@&versions=%@&stype=1",API_headaddr,userID,VERSIONS];
//    NSLog(@"%@",strUrl);
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
//
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
//                                                        NSLog(@"%@",JSON);
//                                                        if ([[JSON objectForKey:@"code"] integerValue] == 70200) {
//
//                                                            [self analysisVersions:JSON];
//
//                                                        }
//
//                                                    }
//                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"加载失败"
//                                                                                                     message:[NSString stringWithFormat:@"因数据环境不稳定，加载失败，请稍后重试"]
//                                                                                                    delegate:nil
//                                                                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//                                                        [av show];
//                                                    }];
//    [operation start];
//
//
//
//}

-(void)analysisVersions:(NSDictionary* )versionDic
{
    YUserInfomationDBM* userInfoDB = [[YUserInfomationDBM alloc]init];
    YuserInfomationFileds* userInfoFileds = [userInfoDB getUSerInfomations:userID :userDefaults.companyCode];
    //NSLog(@"%d,%d,%d,%d",userInfoFileds.formVersion,[[[versionDic objectForKey:@"home_info"] objectForKey:@"formversion"] integerValue],userInfoFileds.userVersion,[[[versionDic objectForKey:@"home_info"] objectForKey:@"userversion"] integerValue]);
    
    if (userInfoFileds.formVersion != [[[versionDic objectForKey:@"home_info"] objectForKey:@"formversion"] integerValue] && userInfoFileds.userVersion != [[[versionDic objectForKey:@"home_info"] objectForKey:@"userversion"] integerValue]){
        
        getBoth = YES;
        [SVProgressHUD showWithStatus:@"正在更新企业数据，请稍后" maskType:SVProgressHUDMaskTypeGradient];
        [JDStatusBarNotification showWithStatus:@"正在更新企业数据" styleName:JDStatusBarStyleYWheaderStyel];
    }else{
        getBoth = NO;
    }
    
        if (userInfoFileds.formVersion != [[[versionDic objectForKey:@"home_info"] objectForKey:@"formversion"] integerValue])
            [self getForm];
        if (userInfoFileds.userVersion != [[[versionDic objectForKey:@"home_info"] objectForKey:@"userversion"] integerValue] || ![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"personLastCheckTime%@%@",company_Code,userID]])
            [self getAllUserInfo];
}


-(void)getAllUserInfo{
    
  getPersonTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    //NSLog(@"%@",getPersonTime);
    
    NSString* lastCheckTime = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"personLastCheckTime%@%@",company_Code,userID]];
    if (!lastCheckTime) {
        [SVProgressHUD showWithStatus:@"正在更新企业数据，请稍后" maskType:SVProgressHUDMaskTypeGradient];
        [JDStatusBarNotification showWithStatus:@"正在更新企业数据" styleName:JDStatusBarStyleYWheaderStyel];
    }
  NSString* strUrl = !lastCheckTime?
    [NSString stringWithFormat:@"%@?mod=commemer&fun=getlist&user_id=%@&rand_code=%@&stype=1&versions=%@",API_headaddr,userID,randCode,VERSIONS]:[NSString stringWithFormat:@"%@?mod=commemer&fun=getlist&user_id=%@&rand_code=%@&limit=9999999&offset=0&stype=1&versions=%@&lastdotime=%@",API_headaddr,userID,randCode,VERSIONS,lastCheckTime];
    if (isNetWork && ![afNetConnectArray containsObject:strUrl]) {
        [afNetConnectArray addObject:strUrl];
        NSLog(@"%@",strUrl);
        
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestHomePageGetAllUserInfoDataWithUrl:strUrl Success:^(id respondsData) {
            //
            NSLog(@"%@",respondsData);
            if ( [[NSString stringWithFormat:@"%@",[respondsData objectForKey:@"code"] ] isEqualToString:@"110200"]) {
                
                [self saveUserInfo:respondsData];
            }else{
                
                [self dismisStatueWithInitDada];
                personTime = 0;
            }
            
        } failed:^(NSError *error) {
            //
            [afNetConnectArray removeObject:strUrl];
            personTime += 1;
            if (personTime < 3) {
                [self performSelector:@selector(getAllUserInfo) withObject:nil afterDelay:1];
            }else {personTime = 0;
                [self dismisStatueWithInitDada];
                getBoth?getBoth=NO:[SVProgressHUD showErrorWithStatus:@"系统数据获请求失败，请检查网络设置"];
            }
        }];
 
    }
    
}


-(void)saveUserInfo:(NSDictionary* )uisersDic{
    YManagerUserInfoDBM *managerUserInfoDB = [[YManagerUserInfoDBM alloc]init];
//    [managerUserInfoDB cleandataBase];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[[uisersDic objectForKey:@"list_info"]allValues]];
    NSSortDescriptor * frequencyDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"department"
                                ascending:YES] ;
    NSArray * descriptors =
    [NSArray arrayWithObjects:frequencyDescriptor, nil];
    NSArray * sortedArray =
    [dataArray sortedArrayUsingDescriptors:descriptors];//按key值排好顺序的数组
    //NSLog(@"%@,count%d",sortedArray,[sortedArray count]);
    [dataArray removeAllObjects];
    NSMutableArray *partmentArray = [NSMutableArray arrayWithObjects:[sortedArray objectAtIndex:0], nil];//先把第一个数据放进分组的数组中
    for (int i =0; i<([sortedArray count]-1);i++)//按key值进行分组后存入dataarray
    {
        if([[[sortedArray objectAtIndex:i+1]objectForKey:@"department"]isEqualToString:[[sortedArray objectAtIndex:i]objectForKey:@"department"]])//如果i和i+1的key相同，把i+1放进数组中
        {
            [partmentArray addObject:[sortedArray objectAtIndex:i+1]];
        }
        else//如果不相同，key的数组找完，进行下一组查找归类
        {
            [dataArray addObject:partmentArray];
            partmentArray = [NSMutableArray arrayWithObjects:[sortedArray objectAtIndex:i+1], nil];
        }
        if(i == ([sortedArray count]-2))//如果是最后一个，把key数组加到大数组中
        {
            [dataArray addObject:partmentArray];
        }
    }
    if([dataArray count]==0)
    {
         [dataArray addObject:partmentArray];
    }
    
    //NSLog(@"%@,count%i",dataArray,[dataArray count]);
    for (int i = 0; i<[dataArray count]; i++) {
        YManagerUserInfoFileds *department = [YManagerUserInfoFileds new];
        
        department.userDepartmentID=[[[dataArray objectAtIndex:i]objectAtIndex:0]objectForKey:@"partnameid"];
        department.userDepartmentName=[[[dataArray objectAtIndex:i]objectAtIndex:0]objectForKey:@"department"];
        //NSLog(@"department:::%@,%@",department.userDepartmentID,department.userDepartmentName);
        [managerUserInfoDB saveDepartment:department];
        for(int j = 0; j<([[dataArray objectAtIndex:i]count]);j++)
        {
            YManagerUserInfoFileds *userInfoFileds = [YManagerUserInfoFileds new];
            userInfoFileds.userDepartmentID=[[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"partnameid"];
            userInfoFileds.userID = [[[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"user_id"] integerValue];
            userInfoFileds.userName = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"name"];
            //插入简拼和全拼
//            userInfoFileds.nameSimplicity
//            userInfoFileds.nameFullSpelling
            
            //插入简拼
            if(userInfoFileds.userName == nil) userInfoFileds.userName = @"";
            
            if(![userInfoFileds.userName isEqualToString:@""])
            {
                NSString *pinYinResult = [NSString string];
                for(int j=0; j<userInfoFileds.userName.length; j++)
                {
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([userInfoFileds.userName characterAtIndex:j])]uppercaseString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                userInfoFileds.nameSimplicity = pinYinResult;
            }else{
                userInfoFileds.nameSimplicity = @"";
            }
            //NSLog(@"%@",userInfoFileds.nameSimplicity);
            
            //插入全拼
            NSMutableString *ms = [[NSMutableString alloc] initWithString:userInfoFileds.userName];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                NSLog(@"Pingying: %@", ms); // wǒ shì zhōng guó rén
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                NSLog(@"Pingying: %@", ms); // wo shi zhong guo ren
            }
            userInfoFileds.nameFullSpelling = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"%@",userInfoFileds.nameFullSpelling);
            
            userInfoFileds.userPhoneNumber = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"mobile"];
            userInfoFileds.userDepartmentName = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"department"];
            userInfoFileds.sex = [[[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"sex"] integerValue];
            userInfoFileds.userPhotoUrl = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"userpic"];
            userInfoFileds.position = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"isadmin"];
            userInfoFileds.userEMail = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"user"];
            userInfoFileds.positionTitle = [[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"positiontitle"];
            userInfoFileds.isCheck =  [[[[dataArray objectAtIndex:i]objectAtIndex:j]objectForKey:@"checked"] integerValue];
            [managerUserInfoDB saveUser:userInfoFileds];
            
        }
    }
    
    NSUserDefaults* userInfo = [NSUserDefaults standardUserDefaults];
    YUserInfomationDBM* userInfoDB = [[YUserInfomationDBM alloc]init];
    YuserInfomationFileds* userInfoFileds = [YuserInfomationFileds new];
    userInfoFileds.userName = userInfo.userName;
    userInfoFileds.companyCode = userInfo.companyCode;
    userInfoFileds.userVersion = [[uisersDic objectForKey:@"userversion"]integerValue];
    [userInfoDB upLoadVersions:userInfoFileds];
        
        
    [userInfo setObject:getPersonTime  forKey:[NSString stringWithFormat:@"personLastCheckTime%@%@",company_Code,userID]];
   
    [self performSelectorOnMainThread:@selector(getPersonOK) withObject:nil waitUntilDone:YES];
}

-(void)getPersonOK{
    
    
    getBoth?getBoth=NO:[SVProgressHUD dismiss];
    [self.tableView reloadData];
    [JDStatusBarNotification showWithStatus:@"人员已更新" dismissAfter:3.f styleName:JDStatusBarStyleYWheaderStyel];
    
}


-(void)getForm{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@?mod=form&fun=get&user_id=%@&rand_code=%@&versions=%@&stype=1",API_headaddr,userID,randCode,VERSIONS];
    if (isNetWork && ![afNetConnectArray containsObject:strUrl]) {
        [afNetConnectArray addObject:strUrl];
        
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestHomePagegetFormDataWithUrl:strUrl Success:^(id respondsData) {
            //
            [afNetConnectArray removeObject:strUrl];
            if ( [[NSString stringWithFormat:@"%@",[respondsData objectForKey:@"code"] ] isEqualToString:@"110200"]) {
                
                [self saveFormFiles:respondsData];
                
                
            }else{
                [self dismisStatueWithInitDada];
                formTime = 0;
            }
            
        } failed:^(NSError *error) {
            //
            [afNetConnectArray removeObject:strUrl];
            formTime += 1;
            if (formTime < 3) {
                [self performSelector:@selector(getForm) withObject:nil afterDelay:1];
                
            }else {
                formTime = 0;
                
                [self dismisStatueWithInitDada];
                getBoth?getBoth=NO:[SVProgressHUD showErrorWithStatus:@"系统数据获请求失败，请检查网络设置"];
            }
            
        }];

    }
    
}

-(void)saveFormFiles:(NSDictionary* )formDic{
    //NSLog(@"tttt%@",formDic);
    YFormDBM* formDB = [[YFormDBM alloc]init];
    [formDB cleandataBase];
   // NSLog(@"unknow:%@",[[formDic objectForKey:@"list_info" ]objectForKey:@"summary"]);
    if([[[formDic objectForKey:@"list_info" ]objectForKey:@"summary"]isKindOfClass:[NSDictionary class]])
    {
   // NSArray *allSummayKeys = [[[formDic objectForKey:@"list_info" ]objectForKey:@"summary"]allKeys];
        NSEnumerator * allSummayKeys = [[[formDic objectForKey:@"list_info" ]objectForKey:@"summary"] keyEnumerator];
    //NSLog(@"enumerator allobjects:%@",allSummayKeys);
    for (NSString* area in allSummayKeys) {
        
        YformFileds* formSection = [YformFileds new];
        
        formSection.area = @"信息汇报";
        
        //NSLog(@"%@",area);
        if (area != 0) {
            formSection.sectionID = [area integerValue];
            //NSLog(@"%d",formSection.sectionID);
            formSection.overdue = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"checked"] integerValue];
            //            formSection.imageType = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"formpicurl"] integerValue];
            @try {
                formSection.imageType = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"formpicurl"] integerValue];
            }
            @catch (NSException *exception) {
                formSection.imageType = 1;
            }
            
            formSection.sectionTitle = [[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"title"];
            formSection.gps = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"is_map"] integerValue];
            formSection.isImage = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"is_mage"] integerValue];
            formSection.isReply = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"is_reply"] integerValue];
            
            formSection.idSort = [[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"myorder"] integerValue];
            [formDB saveArea:formSection];
            
            @try {
                NSEnumerator * sec = [[[[[formDic objectForKey:@"list_info" ]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"] keyEnumerator];
                for (NSString* sect in sec) {
                    if (sect != 0) {
                        YformFileds* form = [YformFileds new];
                        form.area = @"信息汇报";
                        form.sectionID = [area integerValue];
                        form.sectionTitle = formSection.sectionTitle;
                        form.formID = [sect integerValue];
                        form.formUnit = [[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"unit"];
                        form.formName = [[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"header"];
                        form.formType = [[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"textbox"];
                        form.formReferName = [[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"formname"];
                        form.need = [[[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"is_need"] integerValue];
                        form.overdue= [[[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"checked"] integerValue];
                        form.idSort= [[[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"myorder"] integerValue];
                        form.gps = formSection.gps;
                        if ([form.formType isEqualToString:@"select"] ||[form.formType isEqualToString:@"checkbox"]) {
                            
                            NSArray* selecArr = [[[[[[formDic objectForKey:@"list_info"]objectForKey:@"summary"] objectForKey:area] objectForKey:@"form"]objectForKey:sect] objectForKey:@"formvalue"];
                            NSMutableString* selectString = [[NSMutableString alloc]init];
                            
                            for (int x = 0; x < selecArr.count; x ++) {
                                if (x == selecArr.count-1) {
                                    [selectString appendString:[NSString stringWithFormat:@"%@",[selecArr objectAtIndex:x]]];
                                }else{
                                    [selectString appendString:[NSString stringWithFormat:@"%@&&",[selecArr objectAtIndex:x]]];
                                }
                            }
                            
                            form.selectivity = selectString;
                            //
                        }
                        
                        [formDB saveArea:form];
                        
                    }
                    
                }
                
            }
            @catch (NSException *exception) {
            }
            
        }
        
        
    }
    }
    [self.tableView reloadData];
    YUserInfomationDBM* userInfoDB = [[YUserInfomationDBM alloc]init];
    YuserInfomationFileds* userInfoFileds = [YuserInfomationFileds new];
    userInfoFileds.userName = userDefaults.userName;
    userInfoFileds.companyCode = userDefaults.companyCode;
    userInfoFileds.formVersion = [[formDic objectForKey:@"formversion"]integerValue];
    [userInfoDB upLoadVersions:userInfoFileds];
    [self performSelectorOnMainThread:@selector(getFormOK) withObject:nil waitUntilDone:YES];
}

-(void)getFormOK{
    getBoth?getBoth=NO:[SVProgressHUD dismiss];
 
    [JDStatusBarNotification showWithStatus:@"表单已更新" dismissAfter:3.f styleName:JDStatusBarStyleYWheaderStyel];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadLeftReports" object:nil];

}

-(void)dismisStatueWithInitDada{
    [SVProgressHUD dismiss];
    [JDStatusBarNotification dismiss];
}


-(void)logOutRemoveNotic{
    [checkNew invalidate];
    checkNew = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"removeTimer" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"checkNetWork" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getNews" object:nil];
}

//-(void)updateNow
//{
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ye-wu-dian-dian-tong/id592930826"]];
//
//}


@end
