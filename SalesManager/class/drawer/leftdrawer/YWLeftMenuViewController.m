//
//  YWLeftMenuViewController.m
//  TJtest
//
//  Created by tianjing on 13-11-26.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWLeftMenuViewController.h"
#import "HomePageViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "YWNoticeViewController.h"
#import "ImageSizeCell.h"
#import "HeaderView.h"
#import "YFormDBM.h"
#import "YformFileds.h"
#import "YWViewController.h"
#import "NSUserDefaults+Additions.h"
#import "YUserInfomationDBM.h"
#import "YWPersonalVC.h"

#import "UIImageView+WebCache.h"
@interface YWLeftMenuViewController (){
    YformFileds *formFiled;
    NSIndexPath *selectIndexPath;
}

@property (nonatomic, strong) NSMutableArray *informationReportTypeArray;//存储信息信息汇报类型
@property (nonatomic, strong) NSMutableArray *informationReportDataArray;//信息汇报类型数组

@end

@implementation YWLeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"HomePageStoryboard" bundle:nil];
        slideSwitchVC = [homeStoryboard instantiateViewControllerWithIdentifier:@"home"];
        self.navSlideSwitchVC = [[UINavigationController alloc] initWithRootViewController:slideSwitchVC];//homepage作为左侧菜单加载的首个vc
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int x=1; x < 5; x++){
        [TOOL setKey:x value:1];
    }
    
    
    //添加一条通知  重置左侧菜单
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reLoadLeftReports) name:@"reloadLeftReports" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTaleView) name:@"refreshMyPicture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"logOutt" object:nil];
    YFormDBM *formDBM = [[YFormDBM alloc] init];
    formFiled = [[YformFileds alloc] init];
    
    self.informationReportDataArray = [[NSMutableArray alloc] initWithArray:[formDBM getForm:@"信息汇报"]];
    NSLog(@"%@",self.informationReportDataArray);
    
    navigationTb= [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kDeviceWidth, (KDeviceHeight-20)) style:UITableViewStyleGrouped];
    if(!IS_IOS7)
        navigationTb.frame = CGRectMake(0,0, kDeviceWidth, (KDeviceHeight-20));
    //[navigationTb setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    NSLog(@"%f",KDeviceHeight);
    [navigationTb setBackgroundView:nil];
    navigationTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    navigationTb.dataSource = self;
    navigationTb.delegate = self;
    [navigationTb setShowsVerticalScrollIndicator:NO];
    CGSize logoSize = CGSizeMake(32, 32);
    UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(navigationTb.bounds)-logoSize.width/2.0,
                                                                       -logoSize.height-logoSize.height/4.0,
                                                                       logoSize.width,
                                                                       logoSize.height)];
    logo.image = [UIImage imageNamed:@"IOS7icon.png"];
    [logo setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [navigationTb addSubview:logo];
    [navigationTb setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    bgImageView.image = [UIImage imageNamed:@"menubackground@2x"];
    [self.view addSubview:bgImageView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationTb];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (_isShowSelect) {
        [navigationTb selectRowAtIndexPath:selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        [navigationTb deselectRowAtIndexPath:selectIndexPath animated:NO];
    }
    
}

- (void)selectOneItem:(NSString *)formId task:(BOOL)isTask notice:(BOOL)isNotice
{
    if (isTask)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        [self tableView:navigationTb didSelectRowAtIndexPath:indexPath];
        return;
    }
    else if (isNotice)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        [self tableView:navigationTb didSelectRowAtIndexPath:indexPath];
        return;
    }
    else
    {
        NSLog(@"%@",formId);
        int i = 0;
        for (YformFileds *object in _informationReportDataArray)
        {
            if (object.sectionID == [formId integerValue])
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                [self tableView:navigationTb didSelectRowAtIndexPath:indexPath];
                return;
            }
            i++;
        }
    }
}


#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
        case 1:
            return _informationReportDataArray.count;
        case 2:
        {
            NSUserDefaults *user = [[NSUserDefaults alloc] init];
            if ([user.companyCode isEqualToString:LIMING1])
            {
                return 2;
            }else{
                return 3;
            }
        }
        case 3:
            return 2;
        case 4:
            return 2;
        default:
            return 0;
    }
    
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return nil;
        case 1:
            return @"信息汇报";
        case 2:
            return @"公司相关";
        case 3:
            return @"个人相关";
        case 4:
            return @"系统设置";
        default:
            return nil;
    }
}

- (void)signIn
{
    if ([userDefaults.companyCode isEqualToString:LIMING1] || [userDefaults.companyCode isEqualToString:LIMING2]){
        UIAlertView* asd = [[UIAlertView alloc   ]initWithTitle:nil message:@"请选择左侧信息汇报下的签到类型进行签到" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil , nil];
        [asd show];
        
    }else{
        NSLog(@"%s",__FUNCTION__);
        
        //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fastSignIn"];
        
        UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
        
        self.quickSignInVC = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"SignInList"];;
        self.quickSignInVC.homeNavi = self.navSlideSwitchVC;
        self.quickSignInVC.isFast = YES;
        
        self.NVquickSignInVC = [[UINavigationController alloc] initWithRootViewController:self.quickSignInVC];
        self.NVquickSignInVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        if (IS_IOS7) {
            self.NVquickSignInVC.navigationBar.barTintColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
            self.NVquickSignInVC.navigationBar.tintColor = [UIColor whiteColor];
            self.NVquickSignInVC.navigationBar.translucent = NO;
        }
        
        //    [self.quickSignInVC pressAddSignButton];
        [self.mm_drawerController setCenterViewController:self.NVquickSignInVC withCloseAnimation:YES completion:nil];
    }
    
}

-(void)pushToPersonalSetting:(UIGestureRecognizer *)gesture
{
    if (!self.NVpersonalVC) {//personal
        self.personalVC = [[YWPersonalVC alloc]init];
        self.NVpersonalVC = [[UINavigationController alloc] initWithRootViewController:self.personalVC];
    }
    self.personalVC.homeNavi = self.navSlideSwitchVC;
    self.NVpersonalVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController:  self.NVpersonalVC
                                   withCloseAnimation:YES completion:nil];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil)
    {
        HeaderView* headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, 220.0, 116.f)];
        [headerView.signinButton addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
        
        YUserInfomationDBM* userDB = [[YUserInfomationDBM alloc]init];
        YuserInfomationFileds* myInfo = [userDB getUSerInfomations:userID :userDefaults.companyCode];
        headerView.nameLabel.text = myInfo.name;
        headerView.departmentLabel.text = [myInfo.department stringByAppendingFormat:@"  %@",myInfo.positionName];
        headerView.departmentLabel.numberOfLines = 0;
        headerView.departmentLabel.lineBreakMode = UILineBreakModeWordWrap;
        [headerView.portraitView setImageWithURL:[NSURL URLWithString:[myInfo.userPicUrl stringByAppendingString:@"_small220190"]] placeholderImage:[UIImage imageNamed:@"personPhoto.png"]];
        
        NSLog(@"%@",myInfo.userPicUrl);
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPersonalSetting:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [singleFingerOne setDelegate:self];
        [headerView.portraitView addGestureRecognizer:singleFingerOne];     //imageView 增加触摸事件
        
        
        
        return headerView;
    }
    else
    {
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake(16, 0, kDeviceWidth-16, 30);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = sectionTitle;
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithRed:1.f  green:1.f  blue:1.f alpha:0.6];
        
        UIImageView * bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 31, kDeviceWidth, 1.5)];
        bottomView.image = [self defaultImage];
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 33.f)];
        headerView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        [headerView addSubview:bottomView];
        return headerView;
    }
}

-(UIImage *)defaultImage
{
	static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kDeviceWidth, 3.f), NO, 0.0f);
		[[UIColor colorWithRed:29/255.f green:33/255.f blue:37/255.f alpha:0.4] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kDeviceWidth, 3)] fill];
        defaultImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	});
    return defaultImage;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 116.0;
    else
        return 40.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    int section = (int)indexPath.section;
    
    
    NSString *LeftSideCellId = @"LeftSideCellId";
    ImageSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    //    ImageSizeCell* cell;
    UILabel* aa = (UILabel* )[cell.contentView viewWithTag:9];
    if (cell == nil) {
        cell = [[ImageSizeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LeftSideCellId];
    }
    if(section == 0)
    {
        
        if (aa) [aa removeFromSuperview];
    }
    else  if (section == 1)
    {
        
        formFiled = [self.informationReportDataArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = formFiled.sectionTitle;
        
        NSLog(@"%@",formFiled.sectionTitle);
        
        //        NSLog(@"%d",formFiled.imageType);
        //        int  xx;
        NSString * imN;
        ////        if (!formFiled.imageType) {
        //           xx =arc4random()%12;
        //            if (!xx)  xx++;
        
        
        if ([userDefaults.companyCode isEqualToString:LIMING1]) {
            //
            if (!formFiled.imageType) {
                imN = @"L1.png";
            }else{
                imN = [NSString stringWithFormat:@"L%ld.png",(long)formFiled.imageType];
                
                NSLog(@"%@",imN);
            }
            
            UILabel* aa = (UILabel* )[cell.contentView viewWithTag:9];
            if (aa) [aa removeFromSuperview];
            
            
            if ([cell.textLabel.text isEqualToString:@"工作日志"]) {
                
                cell.imageView.image = [UIImage imageNamed:@"L3"];
            }else if ([cell.textLabel.text isEqualToString:@"客户资源"]) {
                
                cell.imageView.image = [UIImage imageNamed:@"L6"];
            }else if ([cell.textLabel.text isEqualToString:@"返郑申请"]) {
                cell.imageView.image = [UIImage imageNamed:@"L7"];
                
            }else {
                
                cell.imageView.image = [UIImage imageNamed:imN];
                
                if (aa) [aa removeFromSuperview];

            }
            
            
            
        }else {
        
            if (!formFiled.imageType) {
                imN = @"L1.png";
            }else{
                imN = [NSString stringWithFormat:@"L%ld.png",(long)formFiled.imageType];
                
                NSLog(@"%@",imN);
            }
            
            UILabel* aa = (UILabel* )[cell.contentView viewWithTag:9];
            if (aa) [aa removeFromSuperview];
            
            
            cell.imageView.image = [UIImage imageNamed:imN];
            
            if (aa) [aa removeFromSuperview];

        
        
        }
//
    }
    else  if (section == 2)
    {
        NSUserDefaults *user = [[NSUserDefaults alloc] init];
        if ([user.companyCode isEqualToString:LIMING1])
        {
            if (row == 0) {
                cell.textLabel.text = @"企业图库";
                //cell.imageView.image = [UIImage imageNamed:@"piclibray_icon@2x"];
                
                cell.imageView.image = [UIImage imageNamed:@"企业图库@2x"];
                
            } else if (row == 1) {
                cell.textLabel.text = @"通知公告";
                //cell.imageView.image = [UIImage imageNamed:@"notic_icon@2x"];
                cell.imageView.image = [UIImage imageNamed:@"通知公告@2x"];
            }
        }else{
            if (row == 0) {
                cell.textLabel.text = @"企业图库";
                cell.imageView.image = [UIImage imageNamed:@"企业图库@2x"];
                
            } else if (row == 1) {
                cell.textLabel.text = @"通知公告";
                
                cell.imageView.image = [UIImage imageNamed:@"通知公告@2x"];
                
            } else if (row == 2) {
                cell.textLabel.text = @"通讯录";
                //cell.imageView.image = [UIImage imageNamed:@"Contacts_icon@2x"];
                cell.imageView.image = [UIImage imageNamed:@"通讯录@2x"];
            }
        }
        if (aa) [aa removeFromSuperview];
    }
    else  if (section == 3)
    {
        if (row == 0) {
            cell.textLabel.text = @"我的任务";
            cell.imageView.image = [UIImage imageNamed:@"我的任务@2x"];
        } else if (row == 1) {
            cell.textLabel.text = @"定位签到";
            cell.imageView.image = [UIImage imageNamed:@"定位签到@2x"];
        }
        if (aa) [aa removeFromSuperview];
    }
    else  if (section == 4)
    {
        if (row == 0) {
            cell.textLabel.text = @"个人资料";
            cell.imageView.image = [UIImage imageNamed:@"个人资料@2x"];
            if (aa) [aa removeFromSuperview];
            
        } else if (row == 1) {
            cell.textLabel.text = @"系统设置";
            cell.imageView.image = [UIImage imageNamed:@"设置@2x"];
            
            NSLog(@"%@\n%@",VERSIONS,[userDefaults objectForKey:@"newVersion"]);
            
            
//            if (![[userDefaults objectForKey:@"newVersion"] isEqualToString:VERSIONS]) {
//                aa = [[UILabel alloc]initWithFrame:CGRectMake(105, 8, 25, 12)];
//                aa.font = [UIFont systemFontOfSize:8];
//                aa.text = @"NEW";
//                aa.tag = 9;
//                aa.textColor = [UIColor whiteColor];
//                aa.textAlignment = NSTextAlignmentCenter;
//                aa.layer.masksToBounds = YES;
//                aa.layer.cornerRadius = 6;
//                [aa setBackgroundColor:[UIColor redColor]];
//                [cell.contentView addSubview:aa];
//            }else { if (aa) [aa removeFromSuperview];}
            
            
            
        }
        
    }
    //    tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndexPath = indexPath;
    _isShowSelect = YES;
    
    int section = indexPath.section;
    int row = indexPath.row;
#if 0
    if (!self.navCommonComponentVC) {
        YWNoticeViewController *noticeDemoVC = [[YWNoticeViewController alloc] init];
        self.navCommonComponentVC = [[UINavigationController alloc] initWithRootViewController:noticeDemoVC];
    }
#endif
    if (section == 1)
    {
        if (!self.informationReportTypeArray)
        {
            self.informationReportTypeArray = [[NSMutableArray alloc] init];
            
            for (int x = 0; x < _informationReportDataArray.count;  x++)
            {
                UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"InformationReport" bundle:nil];
                
                self.NVreportsVC = (UINavigationController *)[informationReportStoryboard instantiateViewControllerWithIdentifier:@"InformationReport"];
                self.NVreportsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                
                self.reportsVC = (InformationReportViewController *)self.NVreportsVC.topViewController;
                self.reportsVC.homeNavi = self.navSlideSwitchVC;
                self.reportsVC.formFiled = (YformFileds *)[self.informationReportDataArray objectAtIndex:x];
                
                [TOOL setKey:self.reportsVC.formFiled.sectionID value:1];
                
                
                
                
                [self.informationReportTypeArray addObject:self.NVreportsVC];
                
                NSLog(@"%@",[(YformFileds *)[self.informationReportDataArray objectAtIndex:x] sectionTitle]);
                
            }
        }
        
        [self.mm_drawerController setCenterViewController:[self.informationReportTypeArray objectAtIndex:row] withCloseAnimation:YES completion:nil];
    }
    else if (section == 2)
    {
        if(row == 0)
        {
            if (!self.NVlibrayVC) {//libray
                self.librayVC = [[YWLibrayVC alloc]init];
                self.NVlibrayVC = [[UINavigationController alloc] initWithRootViewController:self.librayVC];
            }
            self.librayVC.fromPush = NO;
            self.librayVC.homeNavi = self.navSlideSwitchVC;//将首页的navi赋值给类，以便能直接返回首页
            self.NVlibrayVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController:  self.NVlibrayVC
                                           withCloseAnimation:YES completion:nil];
        }
        else if(row == 1)
        {
            if (!self.NVnoticeVC) {//notice
                self.noticeVC = [[YWNoticeViewController alloc]init];
                self.NVnoticeVC = [[UINavigationController alloc] initWithRootViewController:self.noticeVC];
            }
            self.noticeVC.homeNavi = self.navSlideSwitchVC;
            self.NVnoticeVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController:  self.NVnoticeVC
                                           withCloseAnimation:YES completion:nil];
        }
        else if(row == 2)
        {
            UIStoryboard *contactsStoryboard = [UIStoryboard storyboardWithName:@"Contacts" bundle:nil];
            self.contactsVC = [contactsStoryboard instantiateViewControllerWithIdentifier:@"ContactsList"];;
            self.contactsVC.homeNavi = self.navSlideSwitchVC;
            
            if (!self.NVcontactsVC)
            {
                self.NVcontactsVC = [[UINavigationController alloc] initWithRootViewController:self.contactsVC];
            }
            self.NVsignInVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController:self.NVcontactsVC withCloseAnimation:YES completion:nil];
        }
    }
    else if (section == 3)
    {
        if(row == 0)
        {
            if (!self.NVtaskVC) {//task
                self.taskVC = [[YWTaskVC alloc]init];
                self.NVtaskVC = [[UINavigationController alloc] initWithRootViewController:self.taskVC];
            }
            self.taskVC.homeNavi = self.navSlideSwitchVC;
            self.NVtaskVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController:  self.NVtaskVC
                                           withCloseAnimation:YES completion:nil];
        }
        else if (row == 1)//签到
        {
            [userDefaults setBool:NO forKey:@"fastSignIn"];
            
            UIStoryboard *informationReportStoryboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
            
            self.signInVC = [informationReportStoryboard instantiateViewControllerWithIdentifier:@"SignInList"];;
            self.signInVC.homeNavi = self.navSlideSwitchVC;
            
            if (!self.NVsignInVC)
            {
                self.NVsignInVC = [[UINavigationController alloc] initWithRootViewController:self.signInVC];
            }
            self.NVsignInVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController:self.NVsignInVC withCloseAnimation:YES completion:nil];
        }
    }
    else if (section == 4)
    {
        
        if(row == 0)
        {
            if (!self.NVpersonalVC) {//personal
                self.personalVC = [[YWPersonalVC alloc]init];
                self.NVpersonalVC = [[UINavigationController alloc] initWithRootViewController:self.personalVC];
            }
            self.personalVC.homeNavi = self.navSlideSwitchVC;
            self.NVpersonalVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController:  self.NVpersonalVC
                                           withCloseAnimation:YES completion:nil];
        }
        
        else if(row == 1)
        {
            if (!self.NVsettingVC) {//libray
                UIStoryboard* sb = [UIStoryboard storyboardWithName:@"settingStoryBoard" bundle:nil];
                
                self.settingVC = [sb instantiateViewControllerWithIdentifier:@"settingVC"];
                self.NVsettingVC = [[UINavigationController alloc] initWithRootViewController:self.settingVC];
            }
            self.settingVC.fromPush = NO;
            self.settingVC.homeNavi = self.navSlideSwitchVC;
            self.NVsettingVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.mm_drawerController setCenterViewController: self.NVsettingVC
                                           withCloseAnimation:YES completion:nil];
        }
        
    }
    
    //    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0)
    {
        return 0;
    }
    else
        return 45.0;
}
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//
//        [self logOut];
//
//
//    }
//
//}

-(void)logOut{
    userDefaults.randCode = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeTimer" object:nil];
    UIViewController* logVC = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadLeftReports" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshMyPicture" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"logOut" object:nil];
    
    [self presentViewController:logVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadTaleView{
    [navigationTb reloadData];
}


-(void)reLoadLeftReports{
        YFormDBM* asd = [[YFormDBM alloc]init];
        self.informationReportDataArray = [[NSMutableArray alloc] initWithArray:[asd getForm:@"信息汇报"]];
        [navigationTb performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}


@end
