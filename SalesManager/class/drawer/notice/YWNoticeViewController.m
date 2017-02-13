//
//  YWNoticeViewController.m
//  TJtest
//
//  Created by tianjing on 13-11-26.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWNoticeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "TOOL.h"
#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "NoticeCell.h"
#import "YWNoticeByIdVC.h"
#import "YWNewNoticeViewController.h"
#import "CellHeadView.h"
#import "XHIndicatorView.h"
#import "UINavigationBar+customBar.h"
#import "YWEditAfterSendFailVC.h"

#import "MJRefresh.h"

int const noticCodeID = 2;

@interface YWNoticeViewController ()

@property (nonatomic) BOOL isLoadingMore;

@end

@implementation YWNoticeViewController{
    
    BOOL _end;
    BOOL _save;
    
    
}

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
    
    //_save = NO;
    
    firstAndAdd = YES;
    resendafterfail = NO;
    noticDB = [[YNoticDBM alloc]init];
    upLoadNoticArray = [[NSMutableArray alloc]init];
    
    self.noticeList = [NSMutableArray arrayWithArray:[noticDB findWithNoticID:0 limit:NUMBEROFONEPAGE]];
    
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    if(!IS_IOS7)
        [self.navigationController.navigationBar customNavigationBar];

    
    modifySheet =[[UIActionSheet alloc]
                  initWithTitle:Nil
                  delegate:self
                  cancelButtonTitle:@"取消"
                  destructiveButtonTitle:Nil
                  otherButtonTitles:@"发送",@"编辑",@"删除",nil];
    draftSheet =[[UIActionSheet alloc]
                 initWithTitle:Nil
                 delegate:self
                 cancelButtonTitle:@"取消"
                 destructiveButtonTitle:Nil
                 otherButtonTitles:@"编辑",@"删除",nil];

//      UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(gotoback)];
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults.position isEqualToString:@"1"]) {
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"additem@2x"] forState:UIControlStateNormal ];
    [rightButton setTitle:@"新建" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(newNotice) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    }
    
    UILabel *titleText = [TOOL setTitleView:@"通知公告"];
    self.navigationItem.titleView=titleText;
    
    self.noticeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight - 64)];
    self.view.backgroundColor = BGCOLOR;
    self.noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.noticeTableView.backgroundColor = [UIColor clearColor];
    self.noticeTableView.dataSource = self;
    self.noticeTableView.delegate = self;
    [self.view addSubview:self.noticeTableView];
    
    [self createRefreshView];
    
   
}


- (void)viewDidAppear:(BOOL)animated {
    if (isNetWork)
    if ([TOOL getKey:noticCodeID])//在首次进入左侧菜单 和从主页进入列表时  noticecodeid才为1，即才自动刷新列表，其他手动刷新列表
        
    //[_noticeTable launchRefreshing];//(NOTICE 2;TASK 3; IMAGELIBRARY 4;)
        
        [self.noticeTableView.mj_header beginRefreshing];
    
    if(firstAndAdd == NO)//如果从详情返回列表 则刷新（已读，未读）
    {
        [self refreshTableView];
        firstAndAdd = YES;
    }
    
}



- (void)createRefreshView
{
    
    __weak typeof (self)weakSelf = self;
    
    self.noticeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        if (_save) {
//            
//            _dataCount = 0;
//            [self refreshTableView];
//            [self.noticeTableView.mj_header endRefreshing];
//            
//        }else {
//        
//            _dataCount = 0;
//            
//            [weakSelf getNoticListLimit:NUMBEROFONEPAGE offsetNum:_dataCount];
//        
//        }
        _dataCount = 0;
        
        [weakSelf getNoticListLimit:NUMBEROFONEPAGE offsetNum:_dataCount];
        
    }];
    
    
    self.noticeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}



- (void)loadMoreData
{

    if (self.isLoadingMore) {
        return ;
    }
    self.isLoadingMore = YES;
    
//    if (_save) {
//        
//        _dataCount += 1;
//        [self refreshTableView];
//        [self.noticeTableView.mj_footer endRefreshing];
//        
//    }else {
//    
//        _dataCount += 1;
//        
//        [self getNoticListLimit:NUMBEROFONEPAGE offsetNum:_dataCount*NUMBEROFONEPAGE];
//    
//    }
    
    _dataCount += 1;
    
    [self getNoticListLimit:NUMBEROFONEPAGE offsetNum:_dataCount*NUMBEROFONEPAGE];
    
    
}




-(void)getNoticListLimit:(int )limit offsetNum:(int )offset
{
    __weak typeof (self)weakSelf = self;

    if (isNetWork) {
        
        
        [[YWNetRequest sharedInstance] requestNoticeDataWithLimit:limit WithOffset:offset WithSuccess:^(id respondsData) {
            
            
            //NSLog(@"%@",respondsData);
            
            [weakSelf saveNoticList:(NSDictionary* )respondsData];//把数据保存到数据库中
            
            if (_dataCount == 0) {
                
                [weakSelf.noticeTableView.mj_header endRefreshing];
                
                if (_end) {
                    [weakSelf.noticeTableView.mj_footer endRefreshingWithNoMoreData];
                    //_save = YES;
                    
                }else {
                    
                    [weakSelf.noticeTableView.mj_footer endRefreshing];
                }
                
            }else if(_dataCount > 0) {
            
                if (_end) {
                    [weakSelf.noticeTableView.mj_footer endRefreshingWithNoMoreData];
                    
                    //_save = YES;
                    //NSLog(@"%d",_dataCount);
                    
                }else {
                
                    [weakSelf.noticeTableView.mj_footer endRefreshing];
                }
            }

            
        } failed:^(NSError *error) {
            [weakSelf.noticeTableView.mj_header endRefreshing];
            [weakSelf.noticeTableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"数据请求失败"];
        }];
        
       
    }else{
        [self.noticeTableView.mj_header endRefreshing];
        [self.noticeTableView.mj_footer endRefreshing];
        
        [SVProgressHUD showErrorWithStatus:@"无网络"];
        [self refreshTableView];
    }
}



-(void)saveNoticList:(NSDictionary* )noticDic{
    
    //BOOL end;
    
    if([[noticDic objectForKey:@"code"] integerValue] == 60200)
    {
        NSEnumerator *enumeratorKey = [[noticDic objectForKey:@"list_info" ] keyEnumerator]; //得到所有键值
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        int i = 0;//用来记录条数
        
        for (NSObject* noticID in enumeratorKey)
        {
            i += 1;
            
            YNoticFileds* noticFiles = [YNoticFileds new];
            
            noticFiles.noticID = [NSString stringWithFormat:@"%@",noticID];
            noticFiles.noticTitle = [[[noticDic objectForKey:@"list_info"]objectForKey:noticID] objectForKey:@"title"];
            noticFiles.noticDate = [[[[noticDic objectForKey:@"list_info"]objectForKey:noticID] objectForKey:@"posttime"] integerValue];
            noticFiles.noticIsread = [[[[noticDic objectForKey:@"list_info"]objectForKey:noticID] objectForKey:@"is_read"] integerValue];
            //NSLog(@"%@,%@",[[noticDic objectForKey:@"list_info"]objectForKey:noticID],noticID);
            noticFiles.fromUserID = [[[noticDic objectForKey:@"list_info"]objectForKey:noticID] objectForKey:@"fromuserid"];
            noticFiles.isMine = [[[[noticDic objectForKey:@"list_info"]objectForKey:noticID] objectForKey:@"ismine"] integerValue];
            noticFiles.fromUserName = [[[noticDic objectForKey:@"list_info"]objectForKey:noticID] objectForKey:@"frommusername"];
            noticFiles.upLoad = 1;
            
            [noticDB saveNotic:noticFiles success:YES];
        }
        
        _end = i<NUMBEROFONEPAGE?YES:NO;
        
//        if (_end) {
//            [_noticeTableView.mj_footer endRefreshingWithNoMoreData];
//
//        }else{
//            [_noticeTableView.mj_footer endRefreshing];
//        }
        
    }else if ([[noticDic objectForKey:@"code"] integerValue] == 60201){
        _end = YES;
    }else{
        [self checkCodeByJson:noticDic];
    }
     
    [TOOL setKey:noticCodeID value:0];
    
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:YES];
    
}


-(void)refreshTableView{
    
    //NSInteger isEnd = 0;
    //NSLog(@"%d",_dataCount);
    NSLog(@"%ld",self.noticeList.count);
    self.noticeList = [NSMutableArray arrayWithArray:[noticDB findWithNoticID:nil limit:(_dataCount+1)*NUMBEROFONEPAGE]];//数据库里按时间排序的数据
    
    if ([[_noticeList objectAtIndex:0] count] == 0 && [[_noticeList objectAtIndex:1] count] == 0 && [[_noticeList objectAtIndex:2] count] == 0)
    {
        [self noContent:YES];
    }else{
        [self noContent:NO];
    }
    
    [self.noticeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    //[self.noticeTableView reloadData];

    self.isLoadingMore = NO;
    
}


-(void)newNotice
{
    
    YWNewNoticeViewController *vc = [[YWNewNoticeViewController alloc]initWithNibName:@"YWNewNoticeViewController" bundle:Nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addNoticeDatebyID:(NSString*)addTaskID
{
    
}

-(void)gotoback
{
    firstAndAdd = YES;
    self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController: self.homeNavi
                                       withCloseAnimation:YES completion:nil];
   // [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.noticeList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithObjects:
                                     @"本月",@"上月",@"更早",nil];
    for (int i = 0; i < sectionTitles.count ; i++)
    {
        if ([[self.noticeList objectAtIndex:i] count] == 0)
        {
            [sectionTitles setObject:@"" atIndexedSubscript:i];
        }
    }
    return  [sectionTitles objectAtIndex:section];
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithObjects:
                                     @"本月",@"上月",@"更早",nil];
    
    for (int i = 0; i < sectionTitles.count ; i++)
    {
        if ([[self.noticeList objectAtIndex:i] count] == 0)
        {
            [sectionTitles setObject:@"" atIndexedSubscript:i];
        }
    }
    if ([[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return Nil;
    }
    else
    {
        CellHeadView *view = [[CellHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30.5)];
        
        //view.backgroundColor = [UIColor clearColor];
        
        view.backgroundColor = [UIColor colorWithRed:240/255.f  green:245/255.f  blue:246/255.f alpha:1];
        
        view.headTitle.text = [sectionTitles objectAtIndex:section];
        
        return view;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return 0;
    }
    else
    {
        return 30.5;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    //则通过添加footer来去除多出来的空cell
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    footer.backgroundColor = [UIColor clearColor];
//    return footer;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.noticeList objectAtIndex:section] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = @"NoticeCellID";
    NoticeCell *cell= [self.noticeTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCell" owner:self options:nil] lastObject];
        
        XHIndicatorView *view = [[XHIndicatorView alloc] initWithFrame:CGRectMake(kDeviceWidth - 70, 12, 47, 10)];
        view.tag = 103;
        if(IS_IOS7)
        [cell.contentView addSubview:view];
        else
        [cell addSubview:view];
    }
    
    YNoticFileds* noticFileds = [[self.noticeList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ];
    
    cell.noticeID = noticFileds.noticID;
    
    cell.bigTitle.text = noticFileds.noticTitle;
    
    
    //分割线


    //cell.lineImage.frame = CGRectMake(0, 45.5f, kDeviceWidth, .5f);
    
    
    if (indexPath.section == 0 && [[_noticeList objectAtIndex:0] count] && ([[_noticeList objectAtIndex:1] count] || [[_noticeList objectAtIndex:2] count] )) {
        if ([[_noticeList objectAtIndex:0] count]-1 == indexPath.row) {
            
            [cell.lineImage removeFromSuperview];
        }
        
    }else if (indexPath.section == 1 && [[_noticeList objectAtIndex:1] count] &&   [[_noticeList objectAtIndex:2] count]) {
        if ([[_noticeList objectAtIndex:1] count]-1 == indexPath.row) {
            
            [cell.lineImage removeFromSuperview];
        }
    }
    if(noticFileds.upLoad == 1)//如果是发送成功的状态，就显示日期
    {
   if(noticFileds.isMine)
   {
       cell.smallTitle.text = [TOOL ttimeUptoNowFrom:noticFileds.noticDate];
       cell.smallTitle.textColor =  SMALLTITLECOLOR;
   }
    else
    {
    if(noticFileds.noticIsread == 1)
    {
          cell.smallTitle.text = [TOOL ttimeUptoNowFrom:noticFileds.noticDate];
          cell.smallTitle.textColor =  SMALLTITLECOLOR;
    }
    else
    {
       cell.smallTitle.text = @"未读";
        cell.smallTitle.textColor = [UIColor redColor];
    }
    }
    }
    else
    {
        cell.smallTitle.text=@"";
    }
     cell.bigTitle.textColor = BIGTITLECOLOR;;
    XHIndicatorView *view;
    if(IS_IOS7)
     view = (XHIndicatorView *)[cell.contentView viewWithTag:103];
    else
      view = (XHIndicatorView *)[cell viewWithTag:103];
    switch (noticFileds.upLoad)
    {
        case 0://未发送
        {
            if (![upLoadNoticArray containsObject:[NSNumber numberWithInteger:noticFileds.noticDate]]) {//如果有这个时间的发送数据，那就不再发送
                [upLoadNoticArray addObject:[NSNumber numberWithInteger:noticFileds.noticDate]];
                
                [self uploadNotice:noticFileds indicatorView:view indexPath:indexPath];
            }
            
        }
            break;
        case 3://正在发送
        {
            [view setType:XHIndicatorViewTypeSending];
        }
            break;
        case 2://发送失败
        {
            [view setType:XHIndicatorViewTypeFailure];
        }
            break;
        case 5://存为草稿
        {
            if (cell.bigTitle.text.length == 0 || !cell.bigTitle.text){
                cell.bigTitle.text = [NSString stringWithFormat:@"%@%@", @"[草稿]", @"还没有写标题"];
            }else{
                cell.bigTitle.text =[NSString stringWithFormat:@"%@%@", @"[草稿]", noticFileds.noticTitle];
            }
          [view setType:XHIndicatorViewTypeSuccess];
        }
            break;
        case 1://发送成功
        {
            [view setType:XHIndicatorViewTypeSuccess];
        }
            break;
            
        default:
            break;
    }
//    [view setType:XHIndicatorViewTypeSending];
    if(IS_IOS7)
      [cell.contentView addSubview:view];
    else
       [cell addSubview:view];

    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return  35.0;
    return 46;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    //firstAndAdd = NO;
    
    YWNoticeByIdVC *vc = [[YWNoticeByIdVC alloc]initWithNibName:@"YWNoticeByIdVC" bundle:Nil];
//    NoticeCell *cell = (NoticeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    YNoticFileds* asd = [[self.noticeList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NoticeCell *cell = (NoticeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    vc.fromPush = NO;
    vc.noticeid = asd.noticID;
    vc.noticPostTime = asd.noticDate;
    willSendNoticeData = [[self.noticeList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(willSendNoticeData.upLoad == 2)//发送失败的数据
    {
        willsendindexPath = indexPath;
        willsendIndicatorView = (XHIndicatorView *)[cell.contentView viewWithTag:103];
        [modifySheet showInView:self.view];
    }
    else if(willSendNoticeData.upLoad == 5)//存草稿的数据
    {
        willsendindexPath = indexPath;
        [draftSheet showInView:self.view];
    }
    else
    {
      firstAndAdd = NO;//查看详情后，返回更新数据
      [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    
}


//消除选中效果
- (void)deselect
{
    [self.noticeTableView deselectRowAtIndexPath:[self.noticeTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark- acitonsheet delegate 点击发送失败的通知：1重新发送、2编辑、3删除
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == modifySheet)
    {
    if (buttonIndex == 0) {
        [self sendNotice];
    }else if (buttonIndex == 1) {
        [self editNotice];
    }
    else if (buttonIndex == 2) {
        [self deleteNotice];
    }
    else if (buttonIndex == 3) {
        
        NSLog(@"cancel");
    }
    }
    else
    {
       if (buttonIndex == 0) {
            [self editNotice];
        }
        else if (buttonIndex == 1) {
            [self deleteNotice];
        }
        else if (buttonIndex == 2) {
            NSLog(@"cancel");
        }
    }
}

-(void)sendNotice
{
    [self  uploadNotice:willSendNoticeData indicatorView:willsendIndicatorView indexPath:willsendindexPath];
}

-(void)editNotice
{
    YWEditAfterSendFailVC *vc = [[YWEditAfterSendFailVC alloc]init];
    vc.noticeDate = willSendNoticeData.noticDate;
    [self.navigationController pushViewController:vc animated:YES];
    resendafterfail = YES;
}
-(void)deleteNotice
{
    [noticDB deleteNoticeWithTime:willSendNoticeData.noticDate];
    [[self.noticeList objectAtIndex:willsendindexPath.section]removeObjectAtIndex:willsendindexPath.row];
    //NSLog(@"section %d,row %d",willsendindexPath.section,willsendindexPath.row);
  //  [self.noticeTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:willsendindexPath ] withRowAnimation:UITableViewRowAnimationLeft];
    [self.noticeTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 上传通知

- (void)addCell:(YNoticFileds *)aField
{
    if(resendafterfail == YES)//发送失败后重新发送
    {
        [self refreshTableView];
        resendafterfail = NO;
    }
    else
    {
        [self refreshTableView];
    }
    
    [self noContent:NO];
}

- (void)uploadNotice:(YNoticFileds *)aField indicatorView:(XHIndicatorView*)indicatorView indexPath:(NSIndexPath *)indexPath
{
    [indicatorView setType:XHIndicatorViewTypeSending];
    
    aField.upLoad = 3;
    [noticDB upload:aField];
    
    self.noticeList = [NSMutableArray arrayWithArray:[noticDB findWithNoticID:nil limit:(_dataCount+1)*NUMBEROFONEPAGE]];
    [self.noticeTableView reloadData];
    
    
    if (!aField.toDepartmentID) {
        aField.toDepartmentID = @"";
    }
    if (!aField.toPersonID) {
        aField.toPersonID = @"";
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
     NSString *startTime =  [NSString stringWithFormat:@"%li",(long)aField.noticDate];
    NSString *urls =API_addNotice(API_headaddr, user.ID, user.randCode, aField.noticTitle,startTime, aField.noticContent, aField.toPersonID, aField.toDepartmentID, VERSIONS, @"1");
    //NSLog(@"%@",urls);
    
    [[YWNetRequest sharedInstance] requestNoticeuploadNoticeWithUrl:urls WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"]integerValue]==60200)
        {
            [indicatorView setType:XHIndicatorViewTypeSuccess];
            
            // YNoticFileds *field = [[YNoticFileds alloc] init];
            aField.noticID = [respondsData objectForKey:@"noticeid"];
            aField.upLoad = 1;
            [noticDB upload:aField];
            
            self.noticeList = [NSMutableArray arrayWithArray:[noticDB findWithNoticID:nil limit:(_dataCount+1)*NUMBEROFONEPAGE]];
            [self.noticeTableView reloadData];
        }
        else
        {
            [self checkCodeByJson:respondsData];
            [indicatorView setType:XHIndicatorViewTypeFailure];
            
            aField.upLoad = 2;
            [noticDB upload:aField];
            self.noticeList = [NSMutableArray arrayWithArray:[noticDB findWithNoticID:nil limit:(_dataCount+1)*NUMBEROFONEPAGE]];
            [self.noticeTableView reloadData];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                         message:[respondsData objectForKey:@"msg"]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            
        }
        
        
    } failed:^(NSError *error) {
        //
        [SVProgressHUD dismiss];
        aField.upLoad = 2;
        [noticDB upload:aField];                                                                                                                                                                      self.noticeList = [NSMutableArray arrayWithArray:[noticDB findWithNoticID:nil limit:(_dataCount+1) * NUMBEROFONEPAGE]];
        [self.noticeTableView reloadData];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        
    }];

    //
    
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)noContent:(BOOL)YN
{
    UIImageView* hold = (UIImageView* )[_noticeTableView viewWithTag:2077];
    if (hold)//有图片在tableview上
    {
        if (!YN)//有内容，列表不为空
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
                    y = 53;
                }else{
                    y = 23;
                }
                
                hold.center = CGPointMake(_noticeTableView.center.x, _noticeTableView.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                [_noticeTableView addSubview:hold];
            }
        }
    }

    
}



@end
