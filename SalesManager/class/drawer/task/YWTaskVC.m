//
//  YWTaskVC.m
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWTaskVC.h"
#import "UIViewController+MMDrawerController.h"
#import "TaskCell.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"

#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "YWEditAddTaskVC.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "CellHeadView.h"
#import "XHIndicatorView.h"
#import "YWResendTaskAfterFailVC.h"
#import "UINavigationBar+customBar.h"

#import "MJRefresh.h"

int const taskCodeID = 3;

@interface YWTaskVC (){

    BOOL _end;
}

@property (nonatomic) BOOL isLoadingMore;

@end

@implementation YWTaskVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    if(firstAndNew == NO)
    {
        [self refresTable];
        firstAndNew = YES;
    }
    if (isNetWork)
    if ([TOOL getKey:taskCodeID])
    {
        if(self.taskTableView.hidden == NO)
            
            [self.taskTableView.mj_header beginRefreshing];
        
        else
            [self.toMeTaskTableView.mj_header beginRefreshing];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    uploadTaskArray = [[NSMutableArray alloc]init];
    firstComeToMe = YES;
   	// Do any additional setup after loading the view.
    switchView = [[UISwitch alloc] initWithFrame:CGRectMake(260.0f, 2.0f, 40.0f,18.0f)];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"showTaskLocked"]isEqualToString:@"1"])
    switchView.on = YES;
    else
    switchView.on = NO;
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    showLockLabel = [[UILabel alloc]initWithFrame:CGRectMake(180.0f, 4.0f, 80.0f,18.0f)];
    showLockLabel.text = @"显示关闭的任务";
    showLockLabel.font = [UIFont systemFontOfSize:10];
    if (IS_IOS7) {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if(!IS_IOS7)
        [self.navigationController.navigationBar customNavigationBar];
    firstAndNew = YES;
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
    self.view.backgroundColor = BGCOLOR;
    taskDB = [[YTaskDBM alloc]init];
    
    self.taskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:NUMBEROFONEPAGE isMine:0]];
    self.toMeTaskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:NUMBEROFONEPAGE isMine:1]];
    
//
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(gotoback)];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults.position isEqualToString:@"1"]) {
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
        //[rightButton setBackgroundImage:[UIImage imageNamed:@"additem@2x"] forState:UIControlStateNormal];
        [rightButton setTitle:@"新建" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        [rightButton addTarget:self action:@selector(newNotice) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = downloadItem;
    }

    /**
     我交办的
     
     - returns:
     */
    
    self.taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, (KDeviceHeight-64))];
    
    self.taskTableView.backgroundColor = [UIColor clearColor];
    self.taskTableView.dataSource = self;
    self.taskTableView.delegate = self;
    self.taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /**
     我收到的 
     */
//
    
    self.toMeTaskTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, (KDeviceHeight-64))];
    
    
    self.toMeTaskTableView.backgroundColor = [UIColor clearColor];
    self.toMeTaskTableView.dataSource = self;
    self.toMeTaskTableView.delegate = self;
    self.toMeTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.taskTableView];
    [self.view addSubview:self.toMeTaskTableView];
    
    self.taskTableView.hidden = YES;
    
    //[self refresTable];
    
    [self createRefreshView];
    
    
    
    segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(78.0f, 30.0f, 175.0f, 25.0f)];
    [segmentedControl insertSegmentWithTitle:@"我收到的" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"我交办的" atIndex:1 animated:YES];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(selectTable:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = [UIColor whiteColor];
  
    if(!IS_IOS7)
    {
        [segmentedControl setTitle:@"" forSegmentAtIndex:0];
        [segmentedControl setTitle:@"" forSegmentAtIndex:1];
        [segmentedControl setBackgroundImage:[UIImage imageNamed:@"taskseg1.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setBackgroundImage:[UIImage imageNamed:@"taskseg2.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    }
    if ([userDefaults.position isEqualToString:@"1"])
        self.navigationItem.titleView=segmentedControl;
    else
    {
        UILabel *titleText = [TOOL setTitleView:@"指派给我的任务"];
        self.navigationItem.titleView=titleText;
    }
}


- (void)createRefreshView
{
    
    self.taskTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if(self.taskTableView.hidden == NO)
            _dataCount = 0;
        else
            _toMeDataCount = 0;
        
        
        [self getTaskDataList];
        
    }];
    
    
    self.toMeTaskTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if(self.toMeTaskTableView.hidden == NO)
            _dataCount = 0;
        else
            _toMeDataCount = 0;
        
        
        [self getTaskDataList];
        
    }];
    
    
    self.taskTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(taskTVLoadMoreData)];
    
    self.toMeTaskTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(toMeTVLoadMoreData)];

    
}


- (void)taskTVLoadMoreData
{
    if (self.isLoadingMore) {
        return ;
    }
    self.isLoadingMore = YES;
    
    if(self.taskTableView.hidden == NO)
        _dataCount += 1;
    else
        _toMeDataCount += 1;

    [self getTaskDataList];


}


- (void)toMeTVLoadMoreData
{
    if (self.isLoadingMore) {
        return ;
    }
    self.isLoadingMore = YES;
    
    if(self.toMeTaskTableView.hidden == NO)
        _dataCount += 1;
    else
        _toMeDataCount+=1;

    [self getTaskDataList];

    
}






-(void)selectTable:(UISegmentedControl*)sender
{
     NSInteger Index = sender.selectedSegmentIndex;
    if(Index == 0)
    {
        self.taskTableView.hidden = YES;
        self.toMeTaskTableView.hidden = NO;
    }
    else
    {
        self.taskTableView.hidden = NO;
        self.toMeTaskTableView.hidden = YES;
        if(firstComeToMe)
        {
            [self.taskTableView.mj_header beginRefreshing];
            
            firstComeToMe = NO;
        }
    }
}



-(void)gotoback
{
    
    self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController: self.homeNavi
                                   withCloseAnimation:YES completion:nil];
    
}


-(void)deleteTaskDateInSection:(NSString*)section inRow:(NSString* )row;
{
    [self.taskList removeObjectAtIndex:[row integerValue]];
    
    [self.taskTableView reloadData];
    
}


#pragma mark - Actions
-(void)getTaskDataList{
    
    if (isNetWork) {
        
        NSString *stype = @"1";
        NSString *ismine = @"0";
        int aaa = 0;
        int tempDataCount;
        if(self.taskTableView.hidden == NO)
        {
            tempDataCount = _dataCount;
            ismine = @"2";
        }
        else
        {
            tempDataCount = _toMeDataCount;
            ismine = @"1";
        }
        
         __weak typeof (self)weakSelf = self;
        
        [[YWNetRequest sharedInstance] requestgetTaskDataListWithDataCount:tempDataCount Withaaa:aaa WithStype:stype WithIsmine:ismine WithSuccess:^(id respondsData) {
            //
            //NSLog(@"%@",respondsData);
            
            [self saveTaskList:(NSDictionary* )respondsData];
            
            if(self.taskTableView.hidden == NO)
                _dataCount = 0;
            else
                _toMeDataCount = 0;
            
            
            if (_dataCount == 0) {
                
                [weakSelf.taskTableView.mj_header endRefreshing];
                [weakSelf.taskTableView.mj_footer endRefreshing];
                if (_end) {
                    [weakSelf.taskTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    
                    [weakSelf.taskTableView.mj_footer endRefreshing];
                    
                }
                
            }else if(_dataCount > 0) {
                
                if (_end) {
                    [weakSelf.taskTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    
                    [weakSelf.taskTableView.mj_footer endRefreshing];
                    
                }
            }
            
            
            if (_toMeDataCount == 0) {
                
                [weakSelf.toMeTaskTableView.mj_header endRefreshing];
                [weakSelf.toMeTaskTableView.mj_footer endRefreshing];
                if (_end) {
                    [weakSelf.toMeTaskTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    
                    [weakSelf.toMeTaskTableView.mj_footer endRefreshing];
                    
                }
                
            }else if(_toMeDataCount > 0) {
                
                if (_end) {
                    [weakSelf.toMeTaskTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    
                    [weakSelf.toMeTaskTableView.mj_footer endRefreshing];
                    
                }
            }
            
            
        } failed:^(NSError *error) {
            //
            if(self.taskTableView.hidden == NO){
                [self.taskTableView.mj_header endRefreshing];
                [self.taskTableView.mj_footer endRefreshing];
                [SVProgressHUD showSuccessWithStatus:@"数据请求错误"];
                
            } else {
                [self.toMeTaskTableView.mj_header endRefreshing];
                [self.toMeTaskTableView.mj_footer endRefreshing];
                [SVProgressHUD showSuccessWithStatus:@"数据请求错误"];
                
            }
            
        }];

        
    }else{
        if(self.taskTableView.hidden == NO){
            
            [self.taskTableView.mj_header endRefreshing];
            [self.taskTableView.mj_footer endRefreshing];
            [self.taskTableView.mj_footer endRefreshingWithNoMoreData];
            [SVProgressHUD showErrorWithStatus:@"无网络"];
            
            
            if ([[_taskList objectAtIndex:0] count] == 0 && [[_taskList objectAtIndex:1] count] == 0 )
            {
                [self noContent:YES];
            }else{
                [self noContent:NO];
            }
                
            
        } else {

            [self.toMeTaskTableView.mj_header endRefreshing];
            [self.toMeTaskTableView.mj_footer endRefreshing];
            [self.toMeTaskTableView.mj_footer endRefreshingWithNoMoreData];
            [SVProgressHUD showErrorWithStatus:@"无网络"];
            
            
            if ([[_toMeTaskList objectAtIndex:0] count] == 0 && [[_toMeTaskList objectAtIndex:1] count] == 0 )
            {
                [self noContent:YES];
            }else{
                [self noContent:NO];
            }
            
        }
    }
}

-(void)saveTaskList:(NSDictionary* )taskDic{
//    BOOL end;
    
    if ([[taskDic objectForKey:@"code"] integerValue] == 80200) {
        
        
        NSEnumerator *enumeratorKey = [[taskDic objectForKey:@"list_info" ] keyEnumerator]; //得到所有键值、
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        int i = 0;//用来记录条数
        
        for (NSObject* taskID in enumeratorKey)
        {
            i += 1;
            
            YTaskFieleds* taskFiles = [YTaskFieleds new];
            
            taskFiles.taskID = [NSString stringWithFormat:@"%@",taskID];
            taskFiles.taskEndTime = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"endtime"]integerValue];
            //NSLog(@"endt:%i",taskFiles.taskEndTime);
            taskFiles.taskWhetherFinished = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"is_end"]integerValue];
            taskFiles.taskFromPersonName = [[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"frommuername"];
            taskFiles.taskFromPersonID = [[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"frommuserid"];
            taskFiles.taskLocked = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"is_lock"]integerValue];
            taskFiles.isRead = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"is_read"]integerValue];
            taskFiles.isMine = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"ismine"]integerValue];
            taskFiles.taskTo = [[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"taskto"];
            taskFiles.taskTitle = [[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"title"];
            taskFiles.taskTime = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"posttime"]integerValue];
            taskFiles.timeStampList = [[[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"lastdotime"]integerValue];
            taskFiles.toPersonName = [[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"tomusername"];
            taskFiles.toPersonID = [[[taskDic objectForKey:@"list_info"] objectForKey:taskID] objectForKey:@"tomuserid"];
            taskFiles.upLoad = 1;
            
            
            [taskDB saveTask:taskFiles];
        }
        _end = i < NUMBEROFONEPAGE?YES:NO;
        
    }else if ([[taskDic objectForKey:@"code"] integerValue] == 80201){
        _end = YES;
       
        
    }else{
        [self checkCodeByJson:taskDic];
    }
    
    [self refresTable];
    
    [TOOL setKey:taskCodeID value:0];
    
//    if(self.taskTableView.hidden == NO)
//    {
//        
//        [self.taskTableView.header endRefreshing];
//    }
//    else
//    {
//        [self.toMeTaskTableView.header endRefreshing];
//    }
    
}


-(void)refresTable{
    
    if(self.taskTableView.hidden == NO)
    {
        self.taskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:(_dataCount+1)*NUMBEROFONEPAGE isMine:0]];
        [self.taskTableView reloadData];
        
        _isLoadingMore = NO;
        
        if ([[_taskList objectAtIndex:0] count] == 0 && [[_taskList objectAtIndex:1] count] == 0 )
        {
            [self noContent:YES];
        }else{
            [self noContent:NO];
        }
    }
    else
    {
        self.toMeTaskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:(_toMeDataCount+1)*NUMBEROFONEPAGE isMine:1]];
        [self.taskTableView reloadData];
        
        _isLoadingMore = NO;
        
        
        if ([[_toMeTaskList objectAtIndex:0] count] == 0 && [[_toMeTaskList objectAtIndex:1] count] == 0 )
        {
            [self noContent:YES];
        }else{
            [self noContent:NO];
        }
    }
}




-(void)newNotice
{
    YWEditAddTaskVC *vc = [[YWEditAddTaskVC alloc]initWithNibName:@"YWEditAddTaskVC" bundle:Nil];
    vc.isAdd = @"1";
    vc.delegate = self;
    firstAndNew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)editTaskDatebyID:(NSString*)editTaskID
{
    
}
-(void)addTaskDatebyID:(NSString*)addTaskID
{
    
}



#pragma mark -tableview delegte

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if(tableView == self.taskTableView)
    return [[self.taskList objectAtIndex:section] count];
    else
        return [[self.toMeTaskList objectAtIndex:section] count];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithObjects:
                                     @"未完成",@"已完成",nil];
    if(tableView == self.taskTableView)
    {
    for (int i = 0; i < sectionTitles.count ; i++)
    {
        if ([[self.taskList objectAtIndex:i] count] == 0)
        {
            [sectionTitles setObject:@"" atIndexedSubscript:i];
        }
    }
    }
    else
    {
        for (int i = 0; i < sectionTitles.count ; i++)
        {
            if ([[self.toMeTaskList objectAtIndex:i] count] == 0)
            {
                [sectionTitles setObject:@"" atIndexedSubscript:i];
            }
        }
    }
    return  [sectionTitles objectAtIndex:section];
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] initWithObjects:
                                     @"未完成",@"已完成",nil];
    if ([[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return Nil;
    }
    else
    {
        CellHeadView *view = [[CellHeadView alloc]initWithFrame:CGRectMake(-1, 0, 321, 28)];
         view.headTitle.text = [sectionTitles objectAtIndex:section];
        view.headTitle.font = [UIFont systemFontOfSize:13];
        
        if(section == 0)
        {
            view.headTitle.textColor = [UIColor redColor];
            //view.headTitle.backgroundColor = [UIColor blackColor];
            
            
#if 0
            [view addSubview:showLockLabel];
            [view addSubview:switchView];
#endif
        }
        return view;
    }
}

-(void)switchAction:(id)sender{
    UISwitch* control = (UISwitch*)sender;
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(control.on)
      [ud setObject:@"1" forKey:@"showTaskLocked"];
    else
      [ud setObject:@"0" forKey:@"showTaskLocked"];
     [self refresTable];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return 0;
    }
    return 28;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
     if(tableView == self.taskTableView)
    return [self.taskList count];
    else
        return [self.toMeTaskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.taskTableView)
    {
        static  NSString *CellIdentifier = @"NoticeCellID";
        TaskCell *cell= [self.taskTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil] lastObject];
            
            XHIndicatorView *view = [[XHIndicatorView alloc] initWithFrame:CGRectMake(265, 20, 47, 10)];
            //view.backgroundColor = [UIColor blackColor];
            
            
            view.tag = 103;
            if(IS_IOS7)
                [cell.contentView addSubview:view];
            else
                [cell addSubview:view];
        }
        
        YTaskFieleds* taskFile = [[self.taskList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.contentLable.textColor = SMALLTITLECOLOR;
        cell.taskIDD = taskFile.taskID;
        cell.titleLable.text = [NSString stringWithFormat:@"%@",taskFile.taskTo];
        cell.contentLable.text = taskFile.taskTitle;
        
        
        if(taskFile.upLoad == 5)
        {
            cell.timeLabel.text = @"";
        }
        else
        {
            if(taskFile.taskEndTime==0)
            {
                cell.timeLabel.text = @"无截止日期";
            }
            else
            {
                if (indexPath.section) {
                    cell.timeLabel.text = [TOOL convertUnixTime:taskFile.taskEndTime timeType:3];
                }else{
                    cell.timeLabel.text = [TOOL getEndDateString:taskFile.taskEndTime];
                }
            }
        }
        
        YManagerUserInfoDBM *userinfo = [[YManagerUserInfoDBM alloc]init];
        YManagerUserInfoFileds *aaa;
        if(taskFile.isMine)
            aaa= [userinfo getPersonInfoByUserID:[taskFile.taskFromPersonID integerValue] withPhotoUrl:YES withDepartment:0 withContacts:0];
        else
            aaa= [userinfo getPersonInfoByUserID:[taskFile.toPersonID integerValue] withPhotoUrl:YES withDepartment:0 withContacts:0];
        NSLog(@"%@,%@",taskFile.taskFromPersonID,aaa.userPhotoUrl);
        [cell.portraitView  setImageWithURL:[NSURL URLWithString:aaa.userPhotoUrl] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
        cell.hasDone = taskFile.taskWhetherFinished;
        cell.toMe = taskFile.isMine;
        cell.islocked = taskFile.taskLocked;
        
        
        //cell.line.frame = CGRectMake(0, 71.5f, 320, .5f);
        if (indexPath.section == 0) {
            if ([[[self taskList] objectAtIndex:1] count]) {
                if ([[[self taskList] objectAtIndex:0] count ] == (indexPath.row+1)) {
                    
                    [cell.line removeFromSuperview];
                    
                }
            }
        }
        
        
        if(!taskFile.taskID|| [taskFile.taskID isEqualToString:@"nil"]||[taskFile.taskID isEqualToString:@""])
        {
            XHIndicatorView *view;
            if(IS_IOS7)
                view = (XHIndicatorView *)[cell.contentView viewWithTag:103];
            else
                view = (XHIndicatorView *)[cell viewWithTag:103];
            switch (taskFile.upLoad)
            {
                case 0://未发送
                {
                    
                    if(![uploadTaskArray containsObject:[NSNumber numberWithInteger:taskFile.taskTime]]){
                        [uploadTaskArray addObject:[NSNumber numberWithInteger:taskFile.taskTime]];
                        [self uploadTask:taskFile indicatorView:view indexPath:indexPath];
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
                    if(taskFile.taskTitle.length == 0)
                    {
                        cell.contentLable.text = [NSString stringWithFormat:@"%@%@", @"[草稿]", @"还没有写标题"];//@"[草稿]还没有写标题";
                    }
                    else
                    {
                        cell.contentLable.text =[NSString stringWithFormat:@"%@%@", @"[草稿]", taskFile.taskTitle];
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
        }
        return cell;
    }
    else
    {
        static  NSString *CellIdentifier = @"NoticeCellID";
        TaskCell *cell= [self.toMeTaskTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil] lastObject];
        }
        
        YTaskFieleds* taskFile = [[self.toMeTaskList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.contentLable.textColor = SMALLTITLECOLOR;
        cell.taskIDD = taskFile.taskID;
        cell.titleLable.text = [NSString stringWithFormat:@"%@",taskFile.taskTo];
        cell.contentLable.text = taskFile.taskTitle;
        //NSLog(@"endtime:%i",taskFile.taskEndTime);
        if(taskFile.taskEndTime==0)
        {
            cell.timeLabel.text = @"无截止日期";
        }
        else
        {
            if (indexPath.section) {
                cell.timeLabel.text = [TOOL convertUnixTime:taskFile.taskEndTime timeType:3];
            }else{
                cell.timeLabel.text = [TOOL getEndDateString:taskFile.taskEndTime];
            }
        }
        YManagerUserInfoDBM *userinfo = [[YManagerUserInfoDBM alloc]init];
        YManagerUserInfoFileds *aaa;
        if(taskFile.isMine)
            aaa= [userinfo getPersonInfoByUserID:[taskFile.taskFromPersonID integerValue] withPhotoUrl:YES withDepartment:0 withContacts:0];
        else
            aaa= [userinfo getPersonInfoByUserID:[taskFile.toPersonID integerValue] withPhotoUrl:YES withDepartment:0 withContacts:0];
        NSLog(@"%@,%@",taskFile.taskFromPersonID,aaa.userPhotoUrl);
        [cell.portraitView  setImageWithURL:[NSURL URLWithString:aaa.userPhotoUrl] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
        cell.hasDone = taskFile.taskWhetherFinished;
        cell.toMe = taskFile.isMine;
        cell.islocked = taskFile.taskLocked;
        return cell;
    }


}








- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return  51.0;
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    YWOtherNotDoneVC *vc = [[YWOtherNotDoneVC alloc] initWithNibName:@"YWOtherNotDoneVC" bundle:Nil];
    TaskCell *cell = (TaskCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;

    
    vc.delegate = self;
    vc.fromPush = NO;
    vc.taskID= cell.taskIDD;
    if(tableView == self.taskTableView)
        
    vc.autoIncremenID = [[[self.taskList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] autoIncremenID];
    else
      vc.autoIncremenID = [[[self.toMeTaskList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] autoIncremenID];
    vc.hasDone = cell.hasDone;
    vc.islocked = cell.islocked;
    vc.toMe = cell.toMe;
    vc.inSection = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    vc.inRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //NSLog(@"id%@,end%i,mine%i,lock%i",vc.taskID,vc.hasDone,vc.toMe,vc.islocked);
    
    
    if(tableView == self.taskTableView)
    {
    willSendTaskData = [[self.taskList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(willSendTaskData.upLoad == 2)
    {
        willsendindexPath = indexPath;
        willsendIndicatorView = (XHIndicatorView *)[cell.contentView viewWithTag:103];
        [modifySheet showInView:self.view];
    }
    else if(willSendTaskData.upLoad == 5)//存草稿的数据
    {
        willsendindexPath = indexPath;
        willsendIndicatorView = (XHIndicatorView *)[cell.contentView viewWithTag:103];
        [draftSheet showInView:self.view];
    }
    else
    {
        firstAndNew = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    }
    else
    {
        firstAndNew = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    
    
}


//消除选中效果
- (void)deselect
{
    [self.taskTableView deselectRowAtIndexPath:[self.taskTableView indexPathForSelectedRow] animated:YES];
    [self.toMeTaskTableView deselectRowAtIndexPath:[self.toMeTaskTableView indexPathForSelectedRow] animated:YES];
}



#pragma mark- acitonsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == modifySheet)
    {
    if (buttonIndex == 0) {
        [self sendTask];
    }else if (buttonIndex == 1) {
        [self editTask];
    }
    else if (buttonIndex == 2) {
        [self deleteTask];
    }
    else if (buttonIndex == 3) {
        NSLog(@"cancel");
    }
    }
    else
    {
        if (buttonIndex == 0) {
            [self editTask];
        }
        else if (buttonIndex == 1) {
            [self deleteTask];
        }
        else if (buttonIndex == 2) {
            NSLog(@"cancel");
        }
    }
}


-(void)sendTask
{
    [self uploadTask:willSendTaskData indicatorView:willsendIndicatorView indexPath:willsendindexPath];
}


-(void)editTask
{
    YWResendTaskAfterFailVC *vc = [[YWResendTaskAfterFailVC alloc]init];
    vc.autoIncremenID = willSendTaskData.autoIncremenID;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)deleteTask
{
    [taskDB deleteTaskWithTime:willSendTaskData.taskTime];
    [[self.taskList objectAtIndex:willsendindexPath.section]removeObjectAtIndex:willsendindexPath.row];
    //NSLog(@"section %d,row %d",willsendindexPath.section,willsendindexPath.row);
    [self.taskTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:willsendindexPath ] withRowAnimation:UITableViewRowAnimationLeft];
    [self.taskTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//去除多余的空cell
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return 0.1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    //则通过添加footer来去除多出来的空cell
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    footer.backgroundColor = [UIColor clearColor];
//    return footer;
//}

#pragma mark - 上传任务

- (void)addCell:(YTaskFieleds *)aField
{
//
    segmentedControl.selectedSegmentIndex = 1;
    [self selectTable:segmentedControl];
    [self refresTable];
}

- (void)uploadTask:(YTaskFieleds *)aField indicatorView:(XHIndicatorView *)indicatorView indexPath:(NSIndexPath *)indexPath
{

    [indicatorView setType:XHIndicatorViewTypeSending];
    aField.upLoad = 3;
    [taskDB uploadTaskID:aField];
    
//    [[_taskList objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:aField];
//    [self.taskTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.taskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:(_dataCount+1)*NUMBEROFONEPAGE isMine:0]];
    [self.taskTableView reloadData];
    
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    //#define  API_addTask(headaddr,userid,randcode,title,endtime,content,toid,versions,stype)
    NSString *urls =API_addTask(API_headaddr,userDefaults.ID,userDefaults.randCode,aField.taskTitle, (int)aField.taskEndTime,aField.taskContent,aField.toPersonID,VERSIONS,@"1");
    NSLog(@"%@",urls);
    [[YWNetRequest sharedInstance] requestUploadTaskWithUrl:urls WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"]integerValue]==80200)
        {
            [indicatorView setType:XHIndicatorViewTypeSuccess];
            
            @try {
                aField.timeStampContent = [[respondsData objectForKey:@"lastdotime"]integerValue];
                aField.timeStampList = aField.timeStampContent;
                aField.taskID = [respondsData objectForKey:@"id"];
                aField.upLoad = 1;
                [taskDB uploadTaskID:aField];
            }
            @catch (NSException *exception) {
                YWErrorDBM* ad = [[YWErrorDBM alloc]init];
                [ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n",self.class,__FUNCTION__]];
            }
            
            
            
            self.taskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:(_dataCount+1)*NUMBEROFONEPAGE isMine:0]];
            [self.taskTableView reloadData];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"失败"
                                                         message:[respondsData objectForKey:@"msg"]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            
            [indicatorView setType:XHIndicatorViewTypeFailure];
            aField.upLoad = 2;
            [taskDB uploadTaskID:aField];
            
            
            self.taskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:(_dataCount+1)*NUMBEROFONEPAGE isMine:0]];
            [self.taskTableView reloadData];
            
        }
        [uploadTaskArray removeObject:[NSNumber numberWithInteger:aField.taskTime]];
        
    } failed:^(NSError *error) {
        //
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请求失败"
                                                     message:Nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        
        [indicatorView setType:XHIndicatorViewTypeFailure];
        aField.upLoad = 2;
        [taskDB uploadTaskID:aField];
        
        self.taskList = [NSMutableArray arrayWithArray:[taskDB findautoIncremenID:0 limit:(_dataCount+1)*NUMBEROFONEPAGE isMine:0]];
        [self.taskTableView reloadData];
        [uploadTaskArray removeObject:[NSNumber numberWithInteger:aField.taskTime]];
        
    }];
    

    
    
}


-(void)noContent:(BOOL)YN
{
   
    UIImageView* hold ;
    if(self.taskTableView.hidden == NO)
        hold= (UIImageView* )[_taskTableView viewWithTag:2077];
    else
        //hold= (UIImageView* )[_toMeTaskTabel viewWithTag:2077];
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
                    y = 52;
                }else{
                    y = 22;
                }
                
                hold.center = CGPointMake(_taskTableView.center.x, _taskTableView.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                if(self.taskTableView.hidden == NO) {
                    [_taskTableView.mj_footer removeFromSuperview];
                    [_taskTableView addSubview:hold];
                }
                else{
                    [_toMeTaskTableView.mj_footer removeFromSuperview];
                    [_toMeTaskTableView addSubview:hold];
                }
            }
        }
    }

}





@end
