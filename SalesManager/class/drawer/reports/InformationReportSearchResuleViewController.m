//
//  InformationReportSearchResuleViewController.m
//  SalesManager
//
//  Created by Kris on 14-1-7.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "InformationReportSearchResuleViewController.h"
#import "UINavigationBar+customBar.h"
#import "ILBarButtonItem.h"
#import "YSummaryDBM.h"
#import "YSummaryFields.h"
#import "YformFileds.h"
#import "YManagerUserInfoFileds.h"
#import "YManagerUserInfoDBM.h"
#import "InformationReportDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

/**
 *  搜索结果页面
 */
@interface InformationReportSearchResuleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    YSummaryDBM *summaryDB;
    YSummaryFields *summaryFields;
    int dataCount;
    YManagerUserInfoDBM *userDBM;
}

//@property (strong, nonatomic) IBOutlet PullingRefreshTableView *tableView;

//@property (weak, nonatomic) IBOutlet UITableView *SearchTableView;

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@property (strong, nonatomic) NSMutableArray *reportsDatas;


@end

@implementation InformationReportSearchResuleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        summaryDB = [[YSummaryDBM alloc] init];
        userDBM = [[YManagerUserInfoDBM alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(!IS_IOS7)
    {
        [self.navigationController.navigationBar customNavigationBar];
    }
    
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
    [self.searchResultTableView setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64)];
    
    self.searchResultTableView.backgroundColor = [UIColor clearColor];
    
    [self createRefreshView];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isNetWork) {
        //[self.searchResultTableView.mj_header beginRefreshing];
        [self updateData];
    }
    

}

- (void)createRefreshView
{
    
    _searchResultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        dataCount = 0;
        
        [self updateData];
        
        
    }];
    
    _searchResultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _searchResultTableView.mj_footer.hidden = NO;
    
//    _searchResultTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [self updateData];
//        
//        [self.searchResultTableView.mj_footer endRefreshing];
//        [self.searchResultTableView.mj_footer endRefreshingWithNoMoreData];
//    }];
    
}


- (void)loadMoreData
{
    
    dataCount += 1;
    
    [self updateData];
    
    
}

- (void)updateData
{
    //dataCount += 1;
    
    //获取本地数据
    
        
    _reportsDatas = [NSMutableArray arrayWithArray:[summaryDB findWithsummaryID:nil BySummaryDate:0 inSectionID:_formFiled.sectionID limit:(dataCount+1)*NUMBEROFONEPAGE byUserID:_userFiled.userID]];

    if (dataCount == 0) {
        [self.searchResultTableView.mj_header endRefreshing];
        if ([[_reportsDatas objectAtIndex:0] count] < 8) {
            //[self.searchResultTableView.mj_footer endRefreshing];
            [self.searchResultTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else if (dataCount > 0){
    
        
        [self.searchResultTableView.mj_footer endRefreshing];
        [self.searchResultTableView.mj_footer endRefreshingWithNoMoreData];
        
    }

    [self.searchResultTableView reloadData];
    
    
    //判断是否有数据，没有数据现在图标
    if ([[_reportsDatas objectAtIndex:0] count] == 0 && [[_reportsDatas objectAtIndex:1] count] == 0 && [[_reportsDatas objectAtIndex:2]count] == 0)
    {
        [self noContent:YES];
    }else{
        [self noContent:NO];
    }

    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
-(void)noContent:(BOOL)YN
{
//
    UIImageView* hold = (UIImageView* )[_searchResultTableView viewWithTag:2077];
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
                    y = 41;
                }else{
                    y = 21;
                }
                
                hold.center = CGPointMake(_searchResultTableView.center.x, _searchResultTableView.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                [_searchResultTableView.mj_footer removeFromSuperview];

                
                [_searchResultTableView addSubview:hold];
            }
        }
    }

}

#pragma mark - navigaition

- (void)backToTop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toReportDetail2"])
    {
        InformationReportDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.summaryListField = (YSummaryFields* )sender;
        detailViewController.summaryFormFiled = _formFiled;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[_reportsDatas objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    return 22;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_reportsDatas objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InformationReportCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //获取数据
    YSummaryFields *summaryInRow = [[_reportsDatas objectAtIndex:indexPath.section] objectAtIndex: indexPath.row];
    
    //头像
    YManagerUserInfoFileds *user;
    if (summaryInRow.isMine) {
        user = [userDBM getPersonInfoByUserID:[[NSUserDefaults standardUserDefaults].ID intValue] withPhotoUrl:YES withDepartment:NO withContacts:NO];
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
    
    //汇报内容摘要
    UILabel *abstractLabel = (UILabel *)[cell.contentView viewWithTag:102];
    if (!summaryInRow.summaryPreview) {
        abstractLabel.text = @"暂无浏览数据";
    }else{
        abstractLabel.text = summaryInRow.summaryPreview;
    }
    
    if (indexPath.section == 0 && [[_reportsDatas objectAtIndex:0] count] && ([[_reportsDatas objectAtIndex:1] count] || [[_reportsDatas objectAtIndex:2] count] )) {
        if ([[_reportsDatas objectAtIndex:0] count]-1 == indexPath.row) {
            UIImageView* aS = (UIImageView* )[cell viewWithTag:105];
            [aS removeFromSuperview];
        }
        
    }
    if (indexPath.section == 1 && [[_reportsDatas objectAtIndex:1] count] && [[_reportsDatas objectAtIndex:2] count]) {
        if ([[_reportsDatas objectAtIndex:1] count]-1 == indexPath.row) {
            UIImageView* aS = (UIImageView* )[cell viewWithTag:105];
            [aS removeFromSuperview];
        }
    }
    
    //时间
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:103];
    timeLabel.text = [TOOL ttimeUptoNowFrom:(int)summaryInRow.postTime];
    
    //回复次数
    UILabel *replyCountLabel = (UILabel *)[cell.contentView viewWithTag:104];
    replyCountLabel.text = [NSString stringWithFormat:@"回复:%ld",(long)summaryInRow.replyNum];
    
    if (summaryInRow.isread) {
        replyCountLabel.text = [NSString stringWithFormat:@"回复:%ld",(long)summaryInRow.replyNum];
        replyCountLabel.textColor = [UIColor colorWithWhite:0.522 alpha:1.000];
    }else{
        if (summaryInRow.isMine != 1)
        {
            replyCountLabel.text = @"未读";
            replyCountLabel.textColor = [UIColor colorWithRed:0.976 green:0.141 blue:0.141 alpha:1.000];
        }
    }
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 72, kDeviceWidth, 0.5)];
    lineV.backgroundColor = [UIColor colorWithRed:200/255. green:199/255. blue:204/255. alpha:1];
    [cell addSubview:lineV];
    
    
    return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSummaryFields* send = [[_reportsDatas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toReportDetail2" sender:send];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //背景
    UIView *sectionHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 22)];
    
    sectionHeadBackgroundView.backgroundColor = [UIColor colorWithRed:0.941 green:0.957 blue:0.969 alpha:0.9];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [sectionHeadBackgroundView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 21.5, kDeviceWidth, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [sectionHeadBackgroundView addSubview:line2];
    
    //文字
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5.5, 310, 11)];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.font = [UIFont systemFontOfSize:13];
    headLabel.textColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
    headLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionHeadBackgroundView addSubview:headLabel];
    
    //NSLog(@"%@",[self tableView:tableView titleForHeaderInSection:section]);
    
    return sectionHeadBackgroundView;
}



@end
