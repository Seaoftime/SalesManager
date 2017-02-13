//
//  SignInViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SignInViewController.h"
#import "UITableViewController+MMDrawerController.h"
#import "SignInDetailViewController.h"
#import "YSignInFields.h"
#import "XHIndicatorView.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "UINavigationBar+customBar.h"
#import "ILBarButtonItem.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

int const signInCodeID = 1;


extern BOOL refreshSignIn;

@interface SignInViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    YSignInFields *signInField;
    YManagerUserInfoDBM *userDBM;
    
    //用来记录未发生或发生失败的数据
    YSignInFields *mySignInField;
    XHIndicatorView *myIndicatorView;
    NSIndexPath *myIndexPath;
    
    BOOL _end;
    BOOL _firstRefresh;
   
}

@property (nonatomic) BOOL isLoadingMore;

- (IBAction)backToHome:(id)sender;

@end

@implementation SignInViewController

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
        userDBM = [[YManagerUserInfoDBM alloc] init];
        _signInDB = [[YSignInDBM alloc]init];
        upLoadSignInArrary = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(backToHome:)];
    
    /* Right bar button item */
    ILBarButtonItem *rightBtn = [ILBarButtonItem barItemWithTitle:@"新建"
                                                       themeColor:[UIColor whiteColor]
                                                           target:self
                                                           action:@selector(pressAddSignButton)];
    self.navigationItem.rightBarButtonItem = rightBtn;

    self.tableView.backgroundColor = BGCOLOR;
    
     //NSLog(@"%@",NSStringFromCGRect(_signInTableView.frame));
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //去掉多余的cell
    _signInTableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self createRefreshView];
    
    //
    _firstRefresh = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    
    if (_firstRefresh) {
        [_signInTableV.mj_header beginRefreshing];
    }
//    _dataCont = 0;
//    [self getListlimitNum:NUMBEROFONEPAGE offsetNum:_dataCont];

    if (isNetWork)
    if ([TOOL getKey:signInCodeID])
    
        [_signInTableV.mj_header beginRefreshing];
    
    [_signInTableV deselectRowAtIndexPath:[_signInTableV indexPathForSelectedRow] animated:YES];
    
}


- (void)createRefreshView
{
    
    __weak typeof (self) wkSelf = self;
    
    _signInTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _dataCont = 0;
        
        [wkSelf getListlimitNum:NUMBEROFONEPAGE offsetNum:_dataCont];
        
        
    }];
    
    
    _signInTableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    
    
    
}

- (void)loadMoreData
{
    
    if (self.isLoadingMore) {
        return ;
    }
    self.isLoadingMore = YES;
    
    _dataCont += 1;
    
    [self getListlimitNum:NUMBEROFONEPAGE offsetNum:_dataCont * NUMBEROFONEPAGE];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFast) {
        [self pressAddSignButton];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _firstRefresh = NO;
}

#pragma mark - 获取签到列表
-(void)getListlimitNum:(int)limit offsetNum:(int)offset{
    
    if (isNetWork) {
        
        __weak typeof(self) wSlf = self;
        
        [[YWNetRequest sharedInstance] requestgetSignInListWithDataCount:_dataCont WithSuccess:^(id respondsData) {
            
            __strong typeof(self) sSlf = wSlf;
            
            if (!sSlf) {
                return;
            }
            if ([[respondsData objectForKey:@"code"] integerValue] == 40201) {
                
                [wSlf noContent:YES];
                
                
            }else if([[respondsData objectForKey:@"code"] integerValue] ==40200) {
                
                [wSlf importDataBaseWithsignInListDic:(NSDictionary* )respondsData];
                
                if (_dataCont == 0) {
                    
                    [_signInTableV.mj_header endRefreshing];
                    [_signInTableV.mj_footer endRefreshing];
                    
                    if (_end) {
                        
                        [_signInTableV.mj_footer endRefreshingWithNoMoreData];
                        
                    }else {
                        
                        [_signInTableV.mj_footer endRefreshing];
                        
                    }
                    
                }else if(_dataCont > 0) {
                    
                    if (_end) {
                        
                        [_signInTableV.mj_footer endRefreshingWithNoMoreData];
                        
                    }else {
                        
                        [_signInTableV.mj_footer endRefreshing];
                        
                    }
                }
                
            }else{
                
                [wSlf checkCodeByJson:respondsData];
                
            }
            
        } failed:^(NSError *error) {
            //
            [_signInTableV.mj_header endRefreshing];
            [_signInTableV.mj_footer endRefreshing];
            //[_signInTableV.mj_footer endRefreshingWithNoMoreData];
            [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        }];
        
        
        //
        [TOOL setKey:signInCodeID value:0];
        
    }else{
        
        [_signInTableV.mj_header endRefreshing];
        [_signInTableV.mj_footer endRefreshing];
        [_signInTableV.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD showErrorWithStatus:@"无网络"];
        if (_signInData.count == 0) {
            [self noContent:YES];
        }else
            [self noContent:NO];
    }
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_signInData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"signInCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
    signInField = [[_signInData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    YManagerUserInfoFileds *user = [userDBM getPersonInfoByUserID:[signInField.signInPersonID intValue] withPhotoUrl:YES withDepartment:NO withContacts:NO];
    
    UIImageView *photoImageView = (UIImageView *)[cell.contentView viewWithTag:99];
    photoImageView.layer.cornerRadius = 5;
    photoImageView.clipsToBounds = YES;
    
    
    [photoImageView setImageWithURL:[NSURL URLWithString:user.userPhotoUrl] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
    nameLabel.text = user.userName;
    
    UILabel *loacationLabel = (UILabel *)[cell.contentView viewWithTag:101];
    NSLog(@"%@",signInField.myLocation);
    if ([signInField.myLocation isEqualToString:@""] || [signInField.myLocation isEqualToString:@"无法获取城市信息"]) {
        loacationLabel.text = @"暂无位置信息";
    }else{
        loacationLabel.text = signInField.myLocation;
    }
    
    
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:102];
    timeLabel.text = [TOOL ttimeUptoNowFrom:signInField.signInTime];
    NSLog(@"%@",timeLabel.text);
   
//     UIImageView* aS = (UIImageView* )[cell viewWithTag:103];
//    aS.frame = CGRectMake(0, 49.5f, 320, .5f);
//    if (indexPath.section == 0 && [[_signInData objectAtIndex:0] count] && ([[_signInData objectAtIndex:1] count] || [[_signInData objectAtIndex:2] count] )) {
//        if ([[_signInData objectAtIndex:0] count]-1 == indexPath.row) {
//        
//            [aS removeFromSuperview];
//        }
//        
//    }else if (indexPath.section == 1 && [[_signInData objectAtIndex:1] count] &&   [[_signInData objectAtIndex:2] count]) {
//        if ([[_signInData objectAtIndex:1] count]-1 == indexPath.row) {
//           
//            [aS removeFromSuperview];
//        }
//    }
    

//    if (indexPath.row = ) {
//        
//    }
    
    
    XHIndicatorView *view = (XHIndicatorView *)[cell.contentView viewWithTag:104];
    switch (signInField.upload)
    {
        case 0://未发送
        {
            [timeLabel setHidden:YES];
            
            if (![upLoadSignInArrary containsObject:[NSNumber numberWithInteger:signInField.signInTime]]) {

                [self upLoadSignIn:signInField with:view with:indexPath];
            }
        }
            break;
        case 3://正在发送
        {
            [timeLabel setHidden:YES];
            [view setType:XHIndicatorViewTypeSending];
            if (![upLoadSignInArrary containsObject:[NSNumber numberWithInteger:signInField.signInTime]]) {

                [self upLoadSignIn:signInField with:view with:indexPath];
            }
        }
            break;
        case 2://发送失败
        {
            [timeLabel setHidden:YES];
            [view setType:XHIndicatorViewTypeFailure];
        }
            break;
        case 1://发送成功
        {
            [timeLabel setHidden:NO];
            [view setType:XHIndicatorViewTypeSuccess];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithObjects:
                                     @"本月",@"上月",@"更早",nil];
    for (int i = 0; i < sectionTitles.count ; i++)
    {
        if ([[_signInData objectAtIndex:i] count] == 0)
        {
            [sectionTitles setObject:@"" atIndexedSubscript:i];
        }
    }
    return  [sectionTitles objectAtIndex:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    YSignInFields* send = [[_signInData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    switch (send.upload)
    {
        case 1: //成功
        {
            [self performSegueWithIdentifier:@"toSignInDetail"
                                      sender:send];
            break;
        }
        case 2: //失败
        {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            mySignInField = send;
            myIndexPath = indexPath;
            myIndicatorView = (XHIndicatorView*)[cell.contentView viewWithTag:104];
            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:@"删除"
                                                      otherButtonTitles:@"重新发送", nil];
            [sheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return 72;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[_signInData objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || [[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return nil;
    }
    //背景
    UIView *sectionHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    sectionHeadBackgroundView.backgroundColor = [UIColor colorWithRed:0.941 green:0.957 blue:0.969 alpha:0.9];
    sectionHeadBackgroundView.layer.borderWidth = 0.5;
    sectionHeadBackgroundView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
    
    //文字
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 310, 12)];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.font = [UIFont systemFontOfSize:13];
    headLabel.textColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
    headLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionHeadBackgroundView addSubview:headLabel];
    
    NSLog(@"%@",[self tableView:tableView titleForHeaderInSection:section]);
    
    return sectionHeadBackgroundView;
}



#pragma mark - Navigation

- (IBAction)pressAddSignButton
{
    [self performSegueWithIdentifier:@"newSignIn" sender:nil];
    _isFast = NO;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSignInDetail"]) {
        SignInDetailViewController* viewController = segue.destinationViewController;
        viewController.signInFileds =  (YSignInFields* )sender;
    }
    
}

- (IBAction)backToHome:(id)sender
{
    [self.mm_drawerController setCenterViewController: self.homeNavi withCloseAnimation:YES completion:nil];
}

-(void)importDataBaseWithsignInListDic:(NSDictionary* )signinDic{
    
      @try {
        NSEnumerator * enumeratorKey = [[signinDic objectForKey:@"list_info" ]  keyEnumerator];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        int i = 0;
        for (NSObject* signInID in enumeratorKey) {
            i += 1;
            @try {
                YSignInFields* signInfiles = [YSignInFields new];
                
                signInfiles.signInID = [NSString stringWithFormat:@"%@",signInID] ;
                signInfiles.signInTime = [[[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"time"] integerValue];
                signInfiles.signInTitle = [[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"title"];
                if (![[[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"longitude"] isEqualToString:@"(null)"]) {
                    signInfiles.longitude = [[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"longitude"];
                    signInfiles.latitude = [[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"latitude"];
                }
                signInfiles.signInPersonID = [[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"user_id"];
                
                signInfiles.myLocation = [[[signinDic objectForKey:@"list_info"]objectForKey:signInID] objectForKey:@"address"];
                if ([signInfiles.myLocation isEqualToString:@"(null)"]) {
                    signInfiles.myLocation = nil;
                }
                signInfiles.upload = 1;
                
                [_signInDB saveSignIn:signInfiles];
            }
            @catch (NSException *exception) {
                YWErrorDBM* ad = [[YWErrorDBM alloc]init];
                [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
            }

           
        }
        NSLog(@"%i",i);
        
        /**
         *  判断数据是否加载完成
         */
        _end = i<NUMBEROFONEPAGE?YES:NO;
        
          
          
        [self refreshTableView];

    }
    @catch (NSException *exception) {
        YWErrorDBM* ad = [[YWErrorDBM alloc]init];
        [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
        }
    
    
}





-(void)refreshTableView{
    
    @try {
        _signInData = [NSMutableArray arrayWithArray:[_signInDB findWithSignInTime:0 limit:(_dataCont+1)*NUMBEROFONEPAGE]];
        [_signInTableV reloadData];
        
        _isLoadingMore = NO;
        
    }
    @catch (NSException *exception) {
        
        YWErrorDBM* ad = [[YWErrorDBM alloc]init];
        [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
        
    }

   
    if  (![[_signInData objectAtIndex:0] count] && ![[_signInData objectAtIndex:1] count]&& ![[_signInData objectAtIndex:2]count]) {
        
        [self noContent:YES];
    }else{
        [self noContent:NO];
    }
    
}

#pragma mark - 上传签到

- (void)addCell:(YSignInFields *)aField
{
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"fastSignIn"]) {
//        [self viewDidLoad];
//    }else{
        @try {
            [[_signInData objectAtIndex:0] insertObject:aField atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self noContent:NO];
        }
        @catch (NSException *exception) {
            YWErrorDBM* ad = [[YWErrorDBM alloc]init];
            [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
        }
//    }
}

- (NSString *)getNowDateFromatAnDate:(NSTimeInterval)unixTime
{
    NSDate *anyDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
//    //设置源日期时区
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
//    //设置转换后的目标日期时区
//    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
//    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
//    //得到时间偏移量的差值
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    //转为现在时间
//    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    NSDateFormatter* YMD = [[NSDateFormatter alloc]init];
    [YMD setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [YMD stringFromDate:anyDate];
}


- (NSString *)getTime
{
    NSDate *  senddate=[NSDate date];
    
    NSLog(@"%@",senddate);
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}


- (void)upLoadSignIn:(YSignInFields *)tempField with:(XHIndicatorView *)indicatorView with:(NSIndexPath *)indexPath
{
    if (![upLoadSignInArrary containsObject:[NSNumber numberWithInteger:tempField.signInTime]]) {
        [upLoadSignInArrary addObject:[NSNumber numberWithInteger:tempField.signInTime]];
    }
    
    

    [indicatorView setType:XHIndicatorViewTypeSending];
    
    YSignInFields *field = [[YSignInFields alloc] init];
    field.signInTime = tempField.signInTime;
    field.upload = 3;
    [_signInDB upload:field];
    
    field = [[_signInDB findWithSignInTime:field limit:11] objectAtIndex:0];
    
    [[_signInData objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
    [[YWNetRequest sharedInstance] requestUploadSignInDataWithSignInTime:[self getNowDateFromatAnDate:field.signInTime] WithTime:field.signInTime WithLatitude:field.latitude WithLongtitude:field.longitude WithLocation:field.myLocation WithContent:field.signInContent WithSuccess:^(id respondsData) {
        //
        
        if([[respondsData objectForKey:@"code"] integerValue] ==40200)
        {
            [indicatorView setType:XHIndicatorViewTypeSuccess];
            
            YSignInFields *field = [[YSignInFields alloc] init];
            field.signInID = [respondsData objectForKey:@"id"];
            field.signInTime = tempField.signInTime;
            field.upload = 1;
            [_signInDB upload:field];
            
            field = [[_signInDB findWithSignInTime:field limit:0] objectAtIndex:0];
            [[_signInData objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self checkCodeByJson:respondsData];
            [indicatorView setType:XHIndicatorViewTypeFailure];
            
            YSignInFields *field = [[YSignInFields alloc] init];
            field.upload = 2;
            field.signInTime = tempField.signInTime;
            [_signInDB upload:field];
            
            field = [[_signInDB findWithSignInTime:field limit:0] objectAtIndex:0];
            [[_signInData objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [upLoadSignInArrary removeObject:[NSNumber numberWithInteger:tempField.signInTime]];
        
    } failed:^(NSError *error) {
        //
        [indicatorView setType:XHIndicatorViewTypeFailure];
        
        YSignInFields *field = [[YSignInFields alloc] init];
        field.upload = 2;
        field.signInTime = tempField.signInTime;
        [_signInDB upload:field];
        
        field = [[_signInDB findWithSignInTime:field limit:0] objectAtIndex:0];
        [[_signInData objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [upLoadSignInArrary removeObject:[NSNumber numberWithInteger:tempField.signInTime]];
        
    }];
    
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [_signInDB deleteSignInWithpostTime:mySignInField.signInTime];
            [[_signInData objectAtIndex:myIndexPath.section] removeObjectAtIndex:myIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 1:
        {
            if (![upLoadSignInArrary containsObject:[NSNumber numberWithInteger:signInField.signInTime]])
            {
                [self upLoadSignIn:mySignInField with:myIndicatorView with:myIndexPath];
            }
            break;
        }
        default:
            break;
    }
}

-(void)noContent:(BOOL)YN
{
    UIImageView* hold = (UIImageView* )[_signInTableV viewWithTag:2077];
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
                    y = 75;
                }
                
                hold.center = CGPointMake(_signInTableV.center.x,_signInTableV.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                _signInTableV.separatorStyle = UITableViewCellSelectionStyleNone;
                [_signInTableV.mj_footer removeFromSuperview];
                [_signInTableV addSubview:hold];
            }
        }
    }

    
}




@end
