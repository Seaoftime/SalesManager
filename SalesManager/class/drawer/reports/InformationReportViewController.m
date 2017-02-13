//
//  InformationReportViewController.m
//  NewSaleMaster
//
//  Created by Kris on 13-12-2.
//  Copyright (c) 2013年 郑州悉知信息技术有限公司. All rights reserved.
//

#import "InformationReportViewController.h"
//#import "UITableViewController+MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import "InformationReportDetailViewController.h"
#import "InformationReportCreatViewController.h"
#import "AFNetworking.h"
#import "YSummaryFields.h"
#import "XHIndicatorView.h"
#import "YSummaryDBM.h"
#import "YformFileds.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "UINavigationBar+customBar.h"
#import "ILBarButtonItem.h"
#import "InformationReportSearchResuleViewController.h"
#import "PullingRefreshTableView.h"
#import "InformationReportDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#define bgColor  [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define lineColor  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

@interface InformationReportViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UISearchBarDelegate>
{
    YSummaryDBM *_summaryDB;
    int _dataCount;
    YManagerUserInfoDBM *userDBM;
    //    YManagerUserInfoFileds *userFiled;
    
    //用来记录未发生或发生失败的数据
    YSummaryFields *mySummaryField;
    XHIndicatorView *myIndicatorView;
    NSIndexPath *myIndexPath;
    
    BOOL _end;
    
    
    UIImageView *holdImageView;

}


@property (nonatomic) BOOL isLoadingMore;

@property (weak, nonatomic) IBOutlet UILabel *reportLb;

//@property (strong, nonatomic) IBOutlet PullingRefreshTableView *reportTableV;

@property (weak, nonatomic) IBOutlet PullingRefreshTableView *reportTableV;


@property (nonatomic, strong) NSMutableArray *searchResultArray;//搜到的结果数组
@property (nonatomic, strong) NSMutableArray *reportsDatas;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *moreLabel;


- (IBAction)goHome:(id)sender;
- (IBAction)creatReport:(id)sender;

@end

@implementation InformationReportViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.formFiled = [[YformFileds alloc] init];
        userDBM = [[YManagerUserInfoDBM alloc] init];
        //        userFiled = [[YManagerUserInfoFileds alloc] init];
        _reportsDatas = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshTable];
    
    //判断有无内容
    if (([[_reportsDatas lastObject] count] == 0) && ([[_reportsDatas objectAtIndex:0] count] == 0) && ([[_reportsDatas objectAtIndex:1] count] == 0)) {
        [self noContent:YES];
    }else {
        
        [self noContent:NO];
    }
    
    //判断是否需要刷新
    if (isNetWork){
        if ([TOOL getKey:self.formFiled.sectionID])
            [self.reportTableV launchRefreshing];
        }else {
            //[self.reportTableV launchRefreshing];
        }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.reportTableV setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 100)];


}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if(!IS_IOS7)
    {
        [self.navigationController.navigationBar customNavigationBar];
    }
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(goHome:)];
    
    ILBarButtonItem *rightBtn = [ILBarButtonItem barItemWithTitle:@"新建"
                                                       themeColor:[UIColor whiteColor]
                                                           target:self
                                                           action:@selector(creatReport:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    if (!upLoadReportArray) {
        upLoadReportArray = [[NSMutableArray alloc]init];
        
    }
//    if(IS_IOS7)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    //改变navigation bar 样式
    self.title = [NSString stringWithFormat:@"%@",self.formFiled.sectionTitle];
    self.navigationController.view.backgroundColor = bgColor;
    _summaryDB = [[YSummaryDBM alloc]init];
    self.searchResultArray = [[NSMutableArray alloc] init];
    self.reportTableV.separatorStyle = UITableViewCellSelectionStyleNone;
    self.reportTableV.backgroundColor = bgColor;
    
    
    [self createRefreshView];
    
    
}


- (void)createRefreshView
{
    
//    __weak typeof (self) wkSelf = self;
//    self.reportTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        _dataCount = 0;
//        
//        [wkSelf getSummaryList];
//        
//    }];
    
    [self.reportTableV setHeaderOnly:YES];
    [self.reportTableV setPullingDelegate:self];
    [self.reportTableV setAutoScrollToNextPage:NO];
    
    _reportTableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _reportTableV.mj_footer.hidden = NO;
    
}



- (void)loadMoreData
{
    if (self.isLoadingMore) {
        return ;
    }
    self.isLoadingMore = YES;

    _dataCount += 1;
    
    [self getSummaryList];
    
    
}



-(void)noContent:(BOOL)YN
{
    if (!holdImageView) {
        holdImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"StatueLogo@2x"]];
        holdImageView.frame = CGRectMake((_reportTableV.frame.size.width-300)/2, (KDeviceHeight-64-300)/2, 300, 300);
        holdImageView.contentMode = UIViewContentModeScaleAspectFit;
        _reportTableV.separatorStyle = UITableViewCellSelectionStyleNone;
        [_reportTableV addSubview:holdImageView];

    }
    
    holdImageView.hidden = !YN;
    _reportTableV.mj_footer.hidden = YN;

}



- (void)refreshTable
{
    //获取本地数据
    _reportsDatas = [NSMutableArray arrayWithArray:[_summaryDB findWithsummaryID:nil BySummaryDate:0 inSectionID:_formFiled.sectionID limit:(_dataCount+1)*NUMBEROFONEPAGE byUserID:0]];
    
    [self.reportTableV reloadData];
    
    _isLoadingMore = NO;
    
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    
    return 3;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithObjects:
                                     @"本月",@"上月",@"更早",nil];
    for (int i = 0; i < sectionTitles.count ; i++)
    {
        if ([[_reportsDatas objectAtIndex:i] count] == 0)
        {
            [sectionTitles setObject:@"" atIndexedSubscript:i];
        }
    }
    return  [sectionTitles objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return self.searchResultArray.count;
    }
    
    return [[_reportsDatas objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"PersonListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        YManagerUserInfoFileds *userFiled = [self.searchResultArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = userFiled.userName;
        
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"InformationReportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //获取数据
    YSummaryFields *summaryInRow = [[_reportsDatas objectAtIndex:indexPath.section] objectAtIndex: indexPath.row];
    
    //头像
    YManagerUserInfoFileds *user;
    if (summaryInRow.isMine) {
        user = [userDBM getPersonInfoByUserID:[userDefaults.ID intValue] withPhotoUrl:YES withDepartment:NO withContacts:NO];
    }else{
        user = [userDBM getPersonInfoByUserID:[summaryInRow.senderUserID integerValue] withPhotoUrl:YES withDepartment:NO withContacts:NO];
    }
    UIImageView *photoImageView = (UIImageView *)[cell.contentView viewWithTag:100];
    photoImageView.layer.cornerRadius = 5;
    photoImageView.layer.masksToBounds = YES;
    
    
    [photoImageView setImageWithURL:[NSURL URLWithString:user.userPhotoUrl] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
    
    
    //姓名
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
    nameLabel.text = summaryInRow.senderName;
    
    
    UILabel *lb = [cell.contentView viewWithTag:20001];
    lb.textColor = [UIColor colorWithRed:133/255. green:133/255. blue:133/255. alpha:1];
  
    if (kDeviceWidth > 700.000000) {
        [lb setFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y, kDeviceWidth -200, lb.frame.size.height)];
    }
    
    
    if (!summaryInRow.summaryPreview || [summaryInRow.summaryPreview isEqualToString:@""]) {
        //
        lb.text = @"暂无浏览数据";
    }else {
        
        lb.text = [NSString stringWithFormat:@"%@",summaryInRow.summaryPreview];
        
    }

    //时间
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:103];
    timeLabel.text = [TOOL ttimeUptoNowFrom:summaryInRow.postTime];
    
    //回复次数
    UILabel *replyCountLabel = (UILabel *)[cell.contentView viewWithTag:104];
    replyCountLabel.text = [NSString stringWithFormat:@"回复:%ld",summaryInRow.replyNum];
    
    UIView *bottomLine = (UIView *)[cell.contentView viewWithTag:12323];
    [bottomLine setFrame:CGRectMake(0, 71.5, kDeviceWidth, 0.5)];
    bottomLine.backgroundColor = lineColor;
    
    if (summaryInRow.isread) {
        replyCountLabel.text = [NSString stringWithFormat:@"回复:%ld",summaryInRow.replyNum];
        replyCountLabel.textColor = [UIColor colorWithWhite:0.522 alpha:1.000];
        
    }else{
        
        if (summaryInRow.isMine != 1)
        {
            replyCountLabel.text = @"未读";
            replyCountLabel.textColor = [UIColor colorWithRed:0.976 green:0.141 blue:0.141 alpha:1.000];
        } else {
            replyCountLabel.textColor = [UIColor colorWithWhite:0.522 alpha:1.000];
        }
        
    }
    
    XHIndicatorView *view = (XHIndicatorView *)[cell.contentView viewWithTag:106];
    
    //[view setFrame:CGRectMake(kDeviceWidth - 100, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    
    
    switch (summaryInRow.upload)
    {
        case 0://未发送
        {
            [timeLabel setHidden:YES];
            [replyCountLabel setHidden:YES];
            
            if (![upLoadReportArray containsObject:[NSNumber numberWithInteger:summaryInRow.postTime]]) {
                [self uploadReport:summaryInRow indicatorView:view indexPath:indexPath];
            }
        }
            break;
        case 3://正在发送
        {
            [view setType:XHIndicatorViewTypeSending];
            
            [timeLabel setHidden:YES];
            [replyCountLabel setHidden:YES];
            if (![upLoadReportArray containsObject:[NSNumber numberWithInteger:summaryInRow.postTime]]) {
                [self uploadReport:summaryInRow indicatorView:view indexPath:indexPath];
            }
        }
            break;
        case 2://发送失败
        {
            [timeLabel setHidden:YES];
            [replyCountLabel setHidden:YES];
            [view setType:XHIndicatorViewTypeFailure];
        }
            break;
        case 1://发送成功
        {
            [timeLabel setHidden:NO];
            [replyCountLabel setHidden:NO];
            [view setType:XHIndicatorViewTypeSuccess];
            
        }
            break;
            
        case 4://草稿箱
        {
            [timeLabel setHidden:YES];
            [replyCountLabel setHidden:YES];
            [view setType:XHIndicatorViewTypeSuccess];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 50;
    
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || [[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return 0;
    }
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView )
    {
        [self.searchDisplayController setActive:NO animated:YES];
        YManagerUserInfoFileds *userFiled = [self.searchResultArray objectAtIndex:indexPath.row];
        //        [self.searchDisplayController.searchBar setText:userFiled.userName];
        //        [self.searchDisplayController.searchBar setShowsCancelButton:YES];
        //
        //搜索人员信息汇报（需要数据库）
        [self performSegueWithIdentifier:@"toReportResult" sender:userFiled];
        
        
    }
    else
    {
        YSummaryFields* send = [[_reportsDatas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        switch (send.upload)
        {
            case 1://成功
            {
                //InformationReportDetailViewController *details = [[InformationReportDetailViewController alloc] init];
            
                
                [self performSegueWithIdentifier:@"toReportDetail" sender:send];
                break;
            }
            case 2://失败
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                mySummaryField = send;
                myIndexPath = indexPath;
                myIndicatorView =  (XHIndicatorView *)[cell.contentView viewWithTag:106];
                
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"重新发送",@"重新编辑",nil];
                sheet.tag = 1986;
                [sheet showInView:self.view];
                break;
            }
            case 4://草稿箱
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                mySummaryField = send;
                myIndexPath = indexPath;
                myIndicatorView =  (XHIndicatorView *)[cell.contentView viewWithTag:106];
                
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"重新编辑",nil];
                sheet.tag = 1987;
                [sheet showInView:self.view];
                
                break;
            }
            default:
                break;
        }
    }
    
    
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
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 310, 13)];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.font = [UIFont systemFontOfSize:13];
    headLabel.textColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
    headLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionHeadBackgroundView addSubview:headLabel];
    
    //NSLog(@"%@",[self tableView:tableView titleForHeaderInSection:section]);
    
    return sectionHeadBackgroundView;
}




#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"%@",searchString);
    if (searchString.length > 0)
    {
        self.searchResultArray = [NSMutableArray arrayWithArray:[userDBM checkUserInfoByString:searchString]];
        if (self.searchResultArray.count == 0) {
            self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        }
    }
        
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UISearchBarDelegate


#pragma mark - IB Action

- (IBAction)goHome:(id)sender
{
    self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController:self.homeNavi withCloseAnimation:YES completion:nil];
}

- (IBAction)creatReport:(id)sender
{
    [self performSegueWithIdentifier:@"toCreatReport" sender:self.formFiled];
}

#pragma mark - UIStoryboardSegue Action

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toReportDetail"])
    {
        InformationReportDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.summaryListField = (YSummaryFields* )sender;
        detailViewController.summaryFormFiled = _formFiled;
    }
    
    if ([segue.identifier isEqualToString:@"toCreatReport"])
    {
        InformationReportCreatViewController *creatViewController = [segue destinationViewController];
        creatViewController.formFiled = (YformFileds *)sender;
    }
    
    if ([segue.identifier isEqualToString:@"toReportResult"])
    {
        InformationReportSearchResuleViewController *resultViewController = [segue destinationViewController];
        resultViewController.formFiled = self.formFiled;
        resultViewController.userFiled = (YManagerUserInfoFileds *)sender;
    }
    
    if ([segue.identifier isEqualToString:@"toEditReport"])
    {
        InformationReportCreatViewController *creatViewController = [segue destinationViewController];
        creatViewController.formFiled = self.formFiled;
        if ([mySummaryField.reciverID isEqualToString:@""] || mySummaryField.reciverID == nil) {
            creatViewController.selectPersonArray = [NSMutableArray array];
        }else{
            creatViewController.selectPersonArray =  [NSMutableArray arrayWithArray:[mySummaryField.reciverID componentsSeparatedByString:@","]];
        }
        
        NSLog(@"%@",mySummaryField.reciverID);
        creatViewController.creatDic = [NSMutableDictionary dictionaryWithDictionary:[_summaryDB findWithsummaryPostTime:mySummaryField.postTime]];
        NSLog(@"%@",[creatViewController.creatDic description]);
        creatViewController.isEdit = YES;
        creatViewController.editPosttime = (int)mySummaryField.postTime;
        //        if (self.formFiled.isImage) {
        //            creatViewController.selectPictureArray = [NSMutableArray arrayWithArray:[_summaryDB findPhotoUrlWithPostTime:mySummaryField.postTime]];
        //        }
    }
    
}

#pragma mark - 获取日志列表

-(void)getSummaryList
{
    //_formFiled从YWLeftMenuViewController传入
    
    if (isNetWork) {
        
        [[YWNetRequest sharedInstance] requestReportDataWithDataCount:_dataCount WithSectionId:_formFiled.sectionID WithSuccess:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 30200) {
                
                [self importDataBaseWithSummaryListDic:respondsData];
                
                if (_dataCount == 0) {
                    
                    //[_reportTableV tableViewDidFinishedLoading];
                    //_reportTableV.reachedTheEnd  = _end;
                    [_reportTableV.mj_footer endRefreshing];
                    if (_end) {
                        [_reportTableV tableViewDidFinishedLoading];
                        [_reportTableV.mj_footer endRefreshingWithNoMoreData];
                        //_reportTableV.reachedTheEnd  = _end;
                    }else {
                        
                        [_reportTableV tableViewDidFinishedLoading];
                        [_reportTableV.mj_footer endRefreshing];
                    }
                    
                    //判断有无内容
                    if (([[_reportsDatas lastObject] count] == 0) && ([[_reportsDatas objectAtIndex:0] count] == 0) && ([[_reportsDatas objectAtIndex:1] count] == 0)) {
                        [self noContent:YES];
                    }else {
                        
                        [self noContent:NO];
                    }


                    
                }else if(_dataCount > 0) {
                    
                    if (_end) {
                        [_reportTableV tableViewDidFinishedLoading];
                        [_reportTableV.mj_footer endRefreshingWithNoMoreData];
                        //_reportTableV.reachedTheEnd  = _end;
                    }else {
                        
                        [_reportTableV tableViewDidFinishedLoading];
                        [_reportTableV.mj_footer endRefreshing];
//                        
                    }
                }
                
            }else if ([[respondsData objectForKey:@"code"] integerValue] == 30201){
                
                [_reportTableV tableViewDidFinishedLoading];
                [_reportTableV.mj_footer endRefreshing];
                [_reportTableV.mj_footer endRefreshingWithNoMoreData];
                
                
                //[self noContent:YES];
                
                
            }else{
                [self checkCodeByJson:respondsData];
                [_reportTableV tableViewDidFinishedLoading];
                [_reportTableV.mj_footer endRefreshing];
                [_reportTableV.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            [TOOL setKey:(int)self.formFiled.sectionID value:0];
            
        } failed:^(NSError *error) {
            //
            [_reportTableV tableViewDidFinishedLoading];
            [_reportTableV.mj_footer endRefreshing];
            [_reportTableV.mj_footer endRefreshingWithNoMoreData];
            [SVProgressHUD showErrorWithStatus:@"数据请求失败"];
            
        }];
        
    }else {
        
        [_reportTableV tableViewDidFinishedLoading];
        [_reportTableV.mj_footer endRefreshing];
        [_reportTableV.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD showErrorWithStatus:@"无网络"];
        [self refreshTable];
        
//        if (([[_reportsDatas lastObject] count] == 0) && ([[_reportsDatas objectAtIndex:0] count] == 0) && ([[_reportsDatas objectAtIndex:1] count] == 0)) {
//            [self noContent:YES];
//        }else {
//        
//            [self noContent:NO];
//        }
        
    }
    
}




-(void)importDataBaseWithSummaryListDic:(NSDictionary* )sumDic
{
    
    NSEnumerator *enumeratorKey = [[sumDic objectForKey:@"list_info" ] keyEnumerator]; //得到所有键值
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    int i = 0;//用来记录条数
    
    for (NSObject* sumID in enumeratorKey)
    {
        i += 1;
        
        @try {
            YSummaryFields* summaryFiles = [[YSummaryFields alloc]init];
            
            summaryFiles.summaryId = [NSString stringWithFormat:@"%@",sumID];
            summaryFiles.postTime = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"posttime"] integerValue];
            //            summaryFiles.summaryDate = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"date"] integerValue];
            summaryFiles.summaryTitle = [[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"title"];
            summaryFiles.timeStampList = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"lastdotime"] integerValue];
            summaryFiles.isread = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"is_read"] integerValue];
            summaryFiles.isreply = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"is_reply"] integerValue];
            summaryFiles.isMine = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"ismine"] integerValue];
            summaryFiles.myLocation = [[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"address"];
            summaryFiles.replyNum = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"replynum"] integerValue];
            summaryFiles.sectionID = [[[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"formtype"] integerValue];
            summaryFiles.senderName = [[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"frommusername"];
            summaryFiles.senderUserID = [[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"fromuserid"];
            summaryFiles.summaryPreview = [[[sumDic objectForKey:@"list_info"]objectForKey:sumID] objectForKey:@"content"];
            
            summaryFiles.upload = 1;
            
            [_summaryDB saveSummaryList:summaryFiles];
        }
        @catch (NSException *exception) {
            YWErrorDBM *ad = [[YWErrorDBM alloc]init];
            [ad saveAnErrorInfo:[NSString stringWithFormat:@"解析信息汇报列表\nClass:%@\nFun:%s\n", self.class, __FUNCTION__]];
        }
    }
    NSLog(@"%i",i);
    
    /**
     *  判断数据是否加载完成
     */
//    BOOL end;
    
    if (i < NUMBEROFONEPAGE)
    {
        _end = YES;
    }else{
        _end = NO;
    }
    
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
    
    
}

//PullingRefreshTableView
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    _dataCount = 0;
    [self getSummaryList];
    
}



// 开始加载数据
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
//{
//    _dataCount += 1;
//    
//    [self getSummaryList];
//}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.reportTableV tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.reportTableV tableViewDidEndDragging:scrollView];
}

//


#pragma mark - 上传信息汇报

- (void)addCell:(YSummaryFields *)aField
{
    
    [[_reportsDatas objectAtIndex:0] insertObject:aField atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.reportTableV insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self noContent:NO];
    
}

- (void)uploadReport:(YSummaryFields *)aFields indicatorView:(XHIndicatorView *)indicatorView indexPath:(NSIndexPath *)indexPath
{
    
    if (isNetWork) {
        [indicatorView setType:XHIndicatorViewTypeSending];
        
        YSummaryFields *field = [[YSummaryFields alloc] init];
        field.postTime = aFields.postTime;
        field.upload = 3;
        [_summaryDB upload:field];
        
        field = [[_summaryDB findWithsummaryID:nil BySummaryDate:aFields.postTime inSectionID:self.formFiled.sectionID limit:1 byUserID:0] objectAtIndex:0];
        
        [[_reportsDatas objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
        
        [self.reportTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        NSString *picString = [[_summaryDB findPhotoUrlWithPostTime:aFields.postTime] componentsJoinedByString:@"|"];
        NSLog(@"%@",picString);
        
        //拼接url
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@?mod=diary&fun=postto&versions=%@&user_id=%@&rand_code=%@&diary_value[toid]=%@&diary_value['picurl']=%@&stype=1&diary_value[title]=aaa&diary_value[date]=%ld&diary_value[formtype]=%ld&diary_value[content]=%@", API_headaddr, VERSIONS, userDefaults.ID, userDefaults.randCode,aFields.reciverID,picString,(long)aFields.postTime,(long)_formFiled.sectionID,aFields.summaryPreview];
        if (aFields.longitude) {
            [urlString appendFormat:@"&diary_value[longitude]=%@",aFields.longitude];
        }
        if (aFields.latitude) {
            [urlString appendFormat:@"&diary_value[latitude]=%@",aFields.latitude];
        }
        if (aFields.myLocation) {
            [urlString appendFormat:@"&diary_value[address]=%@",aFields.myLocation];
            
        }
        
        NSDictionary *contentDic = [_summaryDB findWithsummaryPostTime:aFields.postTime];
        
        
        for (NSString *key in [contentDic allKeys]) {
            NSLog(@"%@",urlString);
            [urlString appendString:[NSString stringWithFormat:@"&diary_value[tag][%@]=%@",key,[contentDic objectForKey:key]]];
        }
        NSLog(@"%@",urlString);
        urlString = (NSMutableString *)[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[YWNetRequest sharedInstance] requestReportDataWithUrl:urlString WithSuccess:^(id respondsData) {
            //
            if([[respondsData objectForKey:@"code"]integerValue]==30200)
            {
                [indicatorView setType:XHIndicatorViewTypeSuccess];
                
                YSummaryFields *field = [[YSummaryFields alloc] init];
                field.postTime = aFields.postTime;
                field.summaryId = [respondsData objectForKey:@"id"];
                field.timeStampContent = [[respondsData objectForKey:@"lastdotime"] intValue];
                field.timeStampList = [[respondsData objectForKey:@"lastdotime"] intValue];
                field.upload = 1;
                [_summaryDB upload:field];
                
                field = [[_summaryDB findWithsummaryID:nil BySummaryDate:aFields.postTime inSectionID:self.formFiled.sectionID limit:1 byUserID:0] objectAtIndex:0];
                [[_reportsDatas objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
                
                [self.reportTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _dataCount = 0;
                    [self getSummaryList];
                });
                
                
            }
            else
            {
                [self checkCodeByJson:respondsData];
                [indicatorView setType:XHIndicatorViewTypeFailure];
                
                YSummaryFields *field = [[YSummaryFields alloc] init];
                field.postTime = aFields.postTime;
                field.upload = 2;
                [_summaryDB upload:field];
                
                field = [[_summaryDB findWithsummaryID:nil BySummaryDate:aFields.postTime inSectionID:self.formFiled.sectionID limit:1 byUserID:0] objectAtIndex:0];
                [[_reportsDatas objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
                [self.reportTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [upLoadReportArray removeObject:[NSNumber numberWithInteger:aFields.postTime]];
            
        } failed:^(NSError *error) {
            //
            [indicatorView setType:XHIndicatorViewTypeFailure];
            
            YSummaryFields *field = [[YSummaryFields alloc] init];
            field.postTime = aFields.postTime;
            field.upload = 2;
            [_summaryDB upload:field];
            
            field = [[_summaryDB findWithsummaryID:nil BySummaryDate:aFields.postTime inSectionID:self.formFiled.sectionID limit:1 byUserID:0] objectAtIndex:0];
            [[_reportsDatas objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:field];
            [self.reportTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            [upLoadReportArray removeObject:[NSNumber numberWithInteger:aFields.postTime]];
        }];

        [upLoadReportArray addObject:[NSNumber numberWithInteger:aFields.postTime]];
    }


}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1986) {
        //NSLog(@"%d",buttonIndex);
        switch (buttonIndex)
        {
            case 0:
                [_summaryDB deleteSummaryWithpostTime:mySummaryField.postTime];
                [[_reportsDatas objectAtIndex:myIndexPath.section] removeObjectAtIndex:myIndexPath.row];
                [self.reportTableV deleteRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case 1:
                if (![upLoadReportArray containsObject:[NSNumber numberWithInteger:mySummaryField.postTime]]) {
                    [self uploadReport:mySummaryField indicatorView:myIndicatorView indexPath:myIndexPath];
                }
                break;
            case 2:
                [self performSegueWithIdentifier:@"toEditReport" sender:nil];
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == 1987){
        //NSLog(@"%d",buttonIndex);
        switch (buttonIndex)
        {
            case 0:
                [_summaryDB deleteSummaryWithpostTime:mySummaryField.postTime];
                [[_reportsDatas objectAtIndex:myIndexPath.section] removeObjectAtIndex:myIndexPath.row];
                [self.reportTableV deleteRowsAtIndexPaths:@[myIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case 1:
                [self performSegueWithIdentifier:@"toEditReport" sender:nil];
                break;
            default:
                break;
        }
    }
    
    
}

@end
