//
//  YWOtherNotDoneVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-6.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWOtherNotDoneVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"

#import "SVProgressHUD.h"
#import "YWEditAddTaskVC.h"
#import "YWSaveTaskContent.h"
#import "YWPrepareDoneVC.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "TaskReplyCell.h"


@interface YWOtherNotDoneVC ()<UIGestureRecognizerDelegate>
{
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;


}

@property (weak, nonatomic) IBOutlet UIImageView *doneIcon;

@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (nonatomic ,strong) UIPanGestureRecognizer *panGesture;

@end

@implementation YWOtherNotDoneVC
@synthesize delegate;
extern NSString* userid;
extern NSString* randcode;
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
    if(!firstview)
    {
    taskFilesd = [[taskDB findautoIncremenID:self.autoIncremenID limit:0 isMine:9] objectAtIndex:0];
    [self createTaskView];
    }
}

- (void)viewDidLoad
{
    firstview = YES;
    [super viewDidLoad];
    taskDB = [[YTaskDBM alloc]init];
    TaskReplyDBM = [[YSummaryReplyDBM alloc]init];
    self.replyListArray = [[NSMutableArray alloc]initWithArray:[TaskReplyDBM findSummaryReplyBySummaryID:[NSString stringWithFormat:@"TASK%@",self.taskID]]];
    self.totalBgView.frame = CGRectMake(0, 10, kDeviceWidth, KDeviceHeight-75.0-50.0);
    backgroundScrollViewFrame = self.totalBgView.frame;
    self.totalBgView.pagingEnabled = NO;
    self.totalBgView.showsVerticalScrollIndicator = YES;
    
    //[self.doneIcon setCenter:CGPointMake(kDeviceWidth/2 - self.doneIcon.frame.size.width/2 - 30, self.doneIcon.frame.origin.y + 11)];
    [self.doneLabel setCenter:CGPointMake(kDeviceWidth/2, self.doneLabel.frame.origin.y + 10)];
    
    
    self.contentTxet.editable = NO;
    [self.contentTxet setFrame:CGRectMake(0, self.contentTxet.frame.origin.y, kDeviceWidth, 70)];
    
    
    self.noteTextView.layer.cornerRadius = 5;
    [self.noteTextView setClipsToBounds:YES];
    
    self.toMeButton.layer.cornerRadius = 5.0;
    self.lineView.layer.borderColor = [BORDERCOLOR CGColor];
    self.lineView.layer.borderWidth = 0.3;
    self.view.backgroundColor = BGCOLOR;
    
    self.replyTb.hidden = YES;
    self.replyTb.delegate = self;
    self.replyTb.dataSource = self;
    
//
    if(self.fromPush)
         self.replyBgView.frame = CGRectMake(0,(KDeviceHeight-64) , 320, 45);
    else
    self.replyBgView.frame = CGRectMake(0,(KDeviceHeight-46-64) , 320, 46);
    //self.replyBgView.backgroundColor = [UIColor redColor];
    
     replyViewFrame = self.replyBgView.frame;
    self.replyField.layer.cornerRadius = 5;
    self.replyField.layer.borderColor = [UIColor colorWithWhite:0.600 alpha:1.000].CGColor;
    self.replyField.layer.borderWidth = 0.5;
    self.replyField.returnKeyType = UIReturnKeySend;
    
    [self.lineImgV setFrame:CGRectMake(0, self.lineImgV.frame.origin.y, kDeviceWidth, 0.5)];
    self.lineImgV.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    self.replyBtn.enabled = NO;
    self.replyField.delegate = self;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 68, 44)];
    [rightButton setTitle:@"修改" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    rightButtonItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(modifyTask) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.hasdelayBgView.hidden =YES;
    self.toMeButton .hidden =YES;
    self.tootherBgView.hidden =YES;
    self.hasdoneBgView.hidden =YES;
    
    UILabel *titleText = [TOOL setTitleView:@"任务详情"];
    self.navigationItem.titleView=titleText;
    self.navigationController.navigationBar.backgroundColor = NAVIGATIONCOLOR;
    
    modifySheet =[[UIActionSheet alloc]
                                               initWithTitle:Nil
                                               delegate:self
                                               cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:Nil
                                               otherButtonTitles:@"关闭任务",nil];
    if(self.fromPush == YES||self.fromHomepage == YES)
    {
        taskFilesd = [YTaskFieleds new];
        taskFilesd.taskID = self.taskID;
    }
    else
    {
    taskFilesd = [[taskDB findautoIncremenID:self.autoIncremenID limit:0 isMine:9] objectAtIndex:0];
    }
    NSLog(@"%@",self.taskID);
     NSLog(@"%@",taskFilesd.taskContent);
    if (taskFilesd.taskContent && (taskFilesd.taskLocked || taskFilesd.taskWhetherFinished)&&(taskFilesd.timeStampList == taskFilesd.timeStampContent))
    {
      [self createTaskView];
    }
    else
    {
        [self createTaskView];
        [self getDoneTaskData];
    }
    
    self.bgImggView.backgroundColor = [UIColor whiteColor];
    
    [self.contentTxet setFrame:CGRectMake(9, self.contentTxet.frame.origin.y, kDeviceWidth -20, 65)];
    self.contentTxet.font = [UIFont systemFontOfSize:15];
    self.noteTextView.font = [UIFont systemFontOfSize:15];
    
//
    
    [self.sendTimeLabel sizeToFit];
    
    
    
    [self addTapGesture];
    
}


- (void)addTapGesture
{
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTaped)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;

    [self.totalBgView addGestureRecognizer:tableViewGesture];
    
    //
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTaped)];
    self.panGesture.delegate = self;
   
    
}

- (void)tableViewTaped
{
    
    [self.replyField resignFirstResponder];
    [self.totalBgView removeGestureRecognizer:self.panGesture];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{
    
    contentOffsetY = scrollView.contentOffset.y;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    newContentOffsetY = scrollView.contentOffset.y;
    
    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {
        
        
        NSLog(@"up");
        
    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) {
        
        
        
        NSLog(@"down");
        
        //[self.backgroundScrollView addGestureRecognizer:self.panGesture];
        
    } else {
        
        
        NSLog(@"dragging");
        
    }
    
    
    if (scrollView.dragging) {
        //
        if ((scrollView.contentOffset.y - contentOffsetY) > 20.0f) {  // 向上拖拽
            
            //[self.footTextField becomeFirstResponder];
            
            
            
        } else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f) {   // 向下拖拽
            
            
            [self.totalBgView addGestureRecognizer:self.panGesture];
            
        } else {
            
            
            
        }
        
        
    }
    
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    oldContentOffsetY = scrollView.contentOffset.y;
    
}



#pragma mark -reply
- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    if ([self.replyField isFirstResponder])
    {
        // move the toolbar frame up as keyboard animates into view
        NSDictionary *userInfo = [notification userInfo];
        
        // Get animation info from userInfo
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
         getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
         getValue:&animationDuration];
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
         getValue:&keyboardFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.replyBgView setFrame:CGRectMake(replyViewFrame.origin.x, replyViewFrame.origin.y - keyboardFrame.size.height, kDeviceWidth, replyViewFrame.size.height)];
        
        
       [self.totalBgView setFrame:CGRectMake(backgroundScrollViewFrame.origin.x, backgroundScrollViewFrame.origin.y, backgroundScrollViewFrame.size.width, backgroundScrollViewFrame.size.height - keyboardFrame.size.height)];
        
        [UIView commitAnimations];
        
        if (kDeviceWidth > 700.000000) {
            
            if (self.replyListArray.count > 10) {
                //滚动到底部
                CGPoint bottomOffset = CGPointMake(0, self.totalBgView.contentSize.height-self.totalBgView.bounds.size.height - 5);
                [self.totalBgView setContentOffset:bottomOffset animated:YES];
            }
        }
        
        //if (self.replyListArray.count > 5) {
        
        if (self.totalBgView.contentSize.height > (KDeviceHeight- keyboardFrame.size.height - 100)) {
            
            //滚动到底部
            CGPoint bottomOffset = CGPointMake(0, self.totalBgView.contentSize.height-self.totalBgView.bounds.size.height - 5);
            [self.totalBgView setContentOffset:bottomOffset animated:YES];
            
            
        }
        
//            //滚动到底部
//            CGPoint bottomOffset = CGPointMake(0, self.totalBgView.contentSize.height-self.totalBgView.bounds.size.height);
//            [self.totalBgView setContentOffset:bottomOffset animated:YES];
       // }
//        //滚动到底部
//        CGPoint bottomOffset = CGPointMake(0, self.totalBgView.contentSize.height-self.totalBgView.bounds.size.height);
//        [self.totalBgView setContentOffset:bottomOffset animated:YES];
    }
    
    [self.totalBgView addGestureRecognizer:self.panGesture];
    
}



- (void)keyboardWillHide:(NSNotification *)notification {
    if ([self.replyField isFirstResponder])
    {
        // move the toolbar frame up as keyboard animates into view
        NSDictionary *userInfo = [notification userInfo];
        
        // Get animation info from userInfo
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
         getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
         getValue:&animationDuration];
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
         getValue:&keyboardFrame];
        
        // move the toolbar frame down as keyboard animates into view
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        //self.totalBgView.frame = backgroundScrollViewFrame;
        [self.totalBgView setFrame:CGRectMake(backgroundScrollViewFrame.origin.x, backgroundScrollViewFrame.origin.y, backgroundScrollViewFrame.size.width, backgroundScrollViewFrame.size.height + 5)];
        
        //self.replyBgView.frame = replyViewFrame;
        self.replyBgView.frame = CGRectMake(replyViewFrame.origin.x, replyViewFrame.origin.y, kDeviceWidth, replyViewFrame.size.height);
        
        
       [UIView commitAnimations];
    }
    
    [self.totalBgView removeGestureRecognizer:self.panGesture];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        [self.replyField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate methods

// Override to dynamically enable/disable the send button based on user typing
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSUInteger length =
    self.replyField.text.length - range.length + string.length;
    if (length > 0) {
        self.replyBtn.enabled = YES;
    } else {
        self.replyBtn.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.replyField.text.length == 0)
    {
       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请输入回复内容"
                                                    delegate:self
                                           cancelButtonTitle:@"知道了"
                                           otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
    }
    else
    {
        [self reply:self.replyBtn];
         return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// Delegate method called when the message text field is resigned.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Check if there is any message to send
    if (self.replyField.text.length) {
        // Resign the keyboard
        [textField resignFirstResponder];
        
        // Clear the textField and disable the send button
        self.replyBtn.enabled = YES;
    }else{
        self.replyBtn.enabled = NO;
    }
}


-(IBAction)fastReply:(id)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
    if (![fileManager fileExistsAtPath:filePath]) {
        [TOOL createFileWithName:@"tYWdefinedReport.plist"];
    }
    // self.defineReportsData =[NSMutableArray arrayWithContentsOfFile:filePath];
    NSMutableArray *titles = [NSMutableArray
                              arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
    
    UIAlertView *alertView;
    if (titles.count > 0) {
        alertView = [[UIAlertView alloc] initWithTitle:@"快速回复"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:nil];
        for (NSString *title in titles) {
            [alertView addButtonWithTitle:title];
        }
    } else {
        alertView =
        [[UIAlertView alloc] initWithTitle:@"快速回复"
                                   message:@"暂无数据，请在‘个人设置’中进行设定"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:nil];
    }
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == backalertView)
    {
        [self gotoback];
    }
    else
    {
    
    if (buttonIndex) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
        if (![fileManager fileExistsAtPath:filePath]) {
            [TOOL createFileWithName:@"tYWdefinedReport.plist"];
        }
        NSMutableArray *titles = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
        
        self.replyField.text = [titles objectAtIndex:buttonIndex - 1];
         self.replyBtn.enabled = YES;
    }
    }
}

-(IBAction)reply:(id)sender
{
     [self.replyField resignFirstResponder];
    if (isNetWork) {
        self.replyBtn.enabled = NO;
        [SVProgressHUD showWithStatus:@"正在发送..."];
        
        
        [[YWNetRequest sharedInstance] requestTaskReplyWithText:self.replyField.text WithTaskId:self.taskID WithSuccess:^(id respondsData) {
            //
            [SVProgressHUD dismiss];
            if ([[respondsData objectForKey:@"code"] integerValue] == 80200) {

                YSummaryReplyFileds *aSumaryReply = [[YSummaryReplyFileds alloc] init];
                aSumaryReply.replyContent = self.replyField.text;
                aSumaryReply.summaryID = [NSString stringWithFormat:@"TASK%@",self.taskID];
                aSumaryReply.replyDate = [[respondsData objectForKey:@"lastdotime"] integerValue];
                taskFilesd.timeStampContent = [[respondsData objectForKey:@"lastdotime"]integerValue];
                taskFilesd.timeStampList =[[respondsData objectForKey:@"lastdotime"]integerValue];
                [taskDB uploadTaskContent:taskFilesd];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                aSumaryReply.replyPerson = userDefaults.name;
                [TaskReplyDBM saveSummaryReply:aSumaryReply];


                if (self.replyListArray) {
                    [_replyListArray addObject:aSumaryReply];
                }else
                self.replyListArray = [[NSMutableArray alloc ]initWithObjects:aSumaryReply, nil];

                [self createTaskView];
                self.replyField.text = @"";
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:[respondsData objectForKey:@"msg"]];
                self.replyBtn.enabled = YES;
            }
            
        } failed:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            self.replyBtn.enabled = YES;
            
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
    }
    
    //
    if (self.replyListArray.count > 3) {
    //滚动到底部
        
        CGPoint bottomOffset = CGPointMake(0, self.totalBgView.contentSize.height-self.totalBgView.bounds.size.height + 50);
        [self.totalBgView setContentOffset:bottomOffset animated:YES];
        
    }
    

}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.replyListArray count];
}


//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [NSString stringWithFormat:@"    回复(3)"];
//}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    
    [view setBackgroundColor:[UIColor clearColor]];
    view.text = [NSString stringWithFormat:@"   回复"];
    view.font = [UIFont systemFontOfSize:17.0];
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(40,0, 200, 30)];
    [number setBackgroundColor:[UIColor clearColor]];
    number.text = [NSString stringWithFormat:@" （%lu）",(unsigned long)[self.replyListArray count]];
    number.textColor = [UIColor colorWithRed:235/255.0 green:106/255.0 blue:66/225.0 alpha:1];
    number.font = [UIFont systemFontOfSize:17.0];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, kDeviceWidth, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [view addSubview:number];
    [view addSubview:line1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      return 30.0;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = @"ReplyTaskCell";
    TaskReplyCell *cell= [self.replyTb dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskReplyCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    YSummaryReplyFileds *tempReplyFiled = [self.replyListArray objectAtIndex:indexPath.row];
    
    
    //cell.replyFields = [self.replyListArray objectAtIndex:indexPath.row];
    [cell setFileds:tempReplyFiled];
    
    return cell;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //return cell.frame.size.height;
    
    YSummaryReplyFileds *replyFields = [self.replyListArray objectAtIndex:indexPath.row];
    
    return [TOOL getText:replyFields.replyContent MinHeightWithBoundsWidth:kDeviceWidth - 24 fontSize:17] + 30;
    
}


#pragma mark -data and view
-(void)getDoneTaskData
{
    [SVProgressHUD showWithStatus:@"加载中。。。"];
    
    [[YWNetRequest sharedInstance] requestTaskDetailsWithTaskId:self.taskID WithSuccess:^(id respondsData) {
        //
        [SVProgressHUD dismiss];
        if ([[(NSDictionary* )respondsData objectForKey:@"code"] integerValue] == 80200) {
            
            [self saveTaskDateToDB:(NSDictionary* )[respondsData objectForKey:@"list_info"]];
            [self createTaskView];
        }
        else
        {
            //UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
            //                                             message:[respondsData objectForKey:@"msg"]
            //                                            delegate:nil
            //                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[av show];
        }
        
    } failed:^(NSError *error) {
        //
        if (isNetWork) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }else{
            [SVProgressHUD dismiss];
        }
        
    }];
    
    
}

-(void)saveTaskDateToDB:(NSDictionary* )JSON
{
    NSLog(@"%@",JSON);
    taskFilesd.toPersonID = [JSON objectForKey:@"tomuserid"];
    taskFilesd.taskFromPersonID = [JSON objectForKey:@"frommuserid"];
    taskFilesd.taskTitle = [JSON objectForKey:@"title"];
    taskFilesd.taskFromPersonName = [JSON objectForKey:@"frommusername"];
    taskFilesd.taskTime  =  [[JSON objectForKey:@"posttime"]integerValue];
    taskFilesd.taskEndTime =  [[JSON objectForKey:@"endtime"]integerValue];
    taskFilesd.taskContent =  [JSON objectForKey:@"content"];
    taskFilesd.taskFinishedContent =  [JSON objectForKey:@"endcontent"];
    taskFilesd.taskWhetherFinished =  [[JSON objectForKey:@"is_end"]integerValue];
    taskFilesd.isMine =  [[JSON objectForKey:@"ismine"]integerValue];
    taskFilesd.taskLocked =  [[JSON objectForKey:@"is_lock"]integerValue];
    taskFilesd.toPersonName = [JSON objectForKey:@"tomusername"];
    taskFilesd.upLoad = 1;
    taskFilesd.taskID = [JSON objectForKey:@"taskid"];
    taskFilesd.timeStampContent = [[JSON objectForKey:@"lastdotime"]integerValue];
    taskFilesd.timeStampList =[[JSON objectForKey:@"lastdotime"]integerValue];
    if(taskFilesd.isMine){
        taskFilesd.taskTo = [NSString stringWithFormat:@"%@指派给我",taskFilesd.taskFromPersonName];
        if(taskFilesd.isRead == 1)
            ;
        else
        {
            [TOOL minusIconBadgeNumber];
        }
    }
    else
        taskFilesd.taskTo = [NSString stringWithFormat:@"我指派给%@",taskFilesd.toPersonName];
    taskFilesd.isRead = 1;
    if(self.fromPush == YES||self.fromHomepage == YES)
    {
        [taskDB deleteTaskWithId:taskFilesd.taskID];
        [taskDB saveTask:taskFilesd];
        taskFilesd.autoIncremenID = [taskDB findfieldAutoIDwithtaskId:taskFilesd.taskID];
        self.autoIncremenID = taskFilesd.autoIncremenID;
    }
    else
    {
    [taskDB uploadTaskContent:taskFilesd];
    }
    NSLog(@"%@,%@,%@",taskFilesd.taskFromPersonID,taskFilesd.toPersonID,userID);
    if((![taskFilesd.taskFromPersonID isEqualToString:userID ])&& (![taskFilesd.toPersonID isEqualToString: userID]))
    {
        [taskDB deleteTaskWithId:taskFilesd.taskID];
        backalertView = [[UIAlertView alloc] initWithTitle:@"" message:@"此任务已改变接收人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [backalertView show];
    }
   else
  {
    [TaskReplyDBM cleanReply:[NSString stringWithFormat:@"TASK%@",self.taskID]];
      [self.replyListArray removeAllObjects];
    for (int i = 0;i<[[JSON objectForKey:@"replycontent"]count]; i++) {
        YSummaryReplyFileds *aSumaryReply = [[YSummaryReplyFileds alloc] init];
        aSumaryReply.replyContent = [[[JSON objectForKey:@"replycontent"]objectAtIndex:i]objectForKey:@"reply"];
        aSumaryReply.summaryID = [NSString stringWithFormat:@"TASK%@",self.taskID];
        aSumaryReply.replyDate = [[[[JSON objectForKey:@"replycontent"]objectAtIndex:i]objectForKey:@"newstime"]integerValue];
        aSumaryReply.replyPerson = [[[JSON objectForKey:@"replycontent"]objectAtIndex:i]objectForKey:@"replyer"];
        [TaskReplyDBM saveSummaryReply:aSumaryReply];
        [self.replyListArray insertObject:aSumaryReply atIndex:0];
     }
    }

}

-(void)createTaskView{
    

    self.sendPeople.textColor = [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1];
    self.receivePeople.textColor = [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1];

    self.sendTimeLabel.textColor = [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1];
    self.deadTime.textColor = [UIColor colorWithRed:63/255. green:63/255. blue:63/255. alpha:1];
    self.deadLineLabel.textColor = [UIColor colorWithRed:63/255. green:63/255. blue:63/255. alpha:1];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    self.titleLabel.text = taskFilesd.taskTitle;
    self.sendLabel.text = taskFilesd.taskFromPersonName;
    NSLog(@"%@",taskFilesd.taskFromPersonName);
    self.receiveLabel.text = [self setStyleForTaskWithNameString:taskFilesd.toPersonName];//taskFilesd.toPersonName;

    self.sendTimeLabel.text = [TOOL convertUnixTime:taskFilesd.taskTime timeType:1];
    if(taskFilesd.taskEndTime == 0)
    self.deadLineLabel.text = @"不限定任务日期";
    else
    self.deadLineLabel.text = [TOOL convertUnixTime:taskFilesd.taskEndTime timeType:1];
    self.noteTextView.text = taskFilesd.taskFinishedContent;
    self.contentTxet.text = taskFilesd.taskContent;
    
    //CGFloat contentHeight = [TOOL getText:self.contentTxet.text MinHeightWithBoundsWidth:kDeviceWidth - 24 fontSize:14];
    
    
    CGRect ssframe = self.contentTxet.frame;
   
    
    ssframe.size.width = kDeviceWidth - 20;

    
    
    //self.contentTxet.frame = CGRectMake(12, ssframe.origin.y, ssframe.size.width, contentHeight);
    self.contentTxet.frame = ssframe;

    CGRect sssframe = self.contentTxet.frame;
    
    sssframe.size.width = kDeviceWidth;
    
    sssframe.size.height = 20+sssframe.size.height;
    
//    [self.tootherBgView setFrame:CGRectMake(self.tootherBgView.frame.origin.x, self.tootherBgView.frame.origin.y, self.tootherBgView.frame.size.width, self.tootherBgView.frame.size.height + contentHeight)];
//    
//    [self.totalBgView setFrame:CGRectMake(self.totalBgView.frame.origin.x, self.totalBgView.frame.origin.y, self.totalBgView.frame.size.width, self.totalBgView.frame.size.height + contentHeight)];

    //self.contentTxet.frame = sssframe;
    self.contentTxet.scrollEnabled = NO;
    [self.contentTxet setEditable:NO];
    self.contentTxet.font = [UIFont systemFontOfSize:14];
    
    CGSize newSize;
    if([self.replyListArray count])
    {
    self.replyTb.hidden = NO;
    [self.replyTb reloadData];
    [self.replyTb sizeToFit];
    [self.replyTb layoutIfNeeded];
    CGSize size = self.replyTb.contentSize;
    self.replyTb.frame = CGRectMake(self.replyTb.frame.origin.x,self.hasdoneBgView.frame.size.height + self.hasdoneBgView.frame.origin.y + 11, self.replyTb.frame.size.width, size.height);
    newSize = CGSizeMake(kDeviceWidth,self.replyTb.frame.size.height + self.replyTb.frame.origin.y);
    }
    else
    {
       newSize = CGSizeMake(kDeviceWidth,self.hasdoneBgView.frame.size.height + self.hasdoneBgView.frame.origin.y+20);
    }
    [self.totalBgView setContentSize:newSize];
    
    //NSLog(@"totalBgViewheight:%f",self.totalBgView.contentSize.height);
    self.hasDone = taskFilesd.taskWhetherFinished;
    self.toMe = taskFilesd.isMine;
    self.islocked = taskFilesd.taskLocked;
    //NSLog(@"%i",taskFilesd.isMine);
    
    
    [self showWhichView];
    [SVProgressHUD dismiss];
    
    
}


-(void)showWhichView
{
    if(self.hasDone ==1)
    {
        self.hasdoneBgView.hidden = NO;
        self.hasdelayBgView.hidden = YES;
        self.toMeButton.hidden = YES;
        self.tootherBgView.hidden = YES;
        self.navigationItem.rightBarButtonItem = Nil;
    }
    else if (self.islocked == 1)
    {
        self.hasdoneBgView.hidden = YES;
        self.hasdelayBgView.hidden = NO;
        self.toMeButton.hidden = YES;
        self.tootherBgView.hidden = YES;
        self.navigationItem.rightBarButtonItem = Nil;
    }
    else if (self.toMe ==1)
    {
        self.hasdoneBgView.hidden = YES;
        self.hasdelayBgView.hidden = YES;
       // self.toMeButton.hidden = NO;
        self.tootherBgView.hidden = NO;
        [(UIButton*)rightButtonItem.customView setTitle:@"完成" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    else
    {
        self.hasdoneBgView.hidden = YES;
        self.hasdelayBgView.hidden = YES;
        self.toMeButton.hidden = YES;
        self.tootherBgView.hidden = NO;
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    
}


-(NSString*)setStyleForTaskWithNameString:(NSString*)name
{
    //NSString* sss = [NSString stringWithFormat:@"<font face='%@' size=11 color='#000000'>%@</font><font face='%@' size=11 color='#939393'>%@</font>",[UIFont systemFontOfSize:11].fontName, @"接受者： ", [UIFont systemFontOfSize:11].fontName, name];
    
    NSString* sss = [NSString stringWithFormat:@"%@",name];
   //
    
    return sss;
}

-(void)done
{
    YWPrepareDoneVC *vc = [[YWPrepareDoneVC alloc]init];
    vc.taskID = self.taskID;
    vc.autoIncremenID = self.autoIncremenID;
    firstview = NO;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- acitonsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0) {
//        NSLog(@"edit");
//        [self editTaskByID];
//          }else
              if (buttonIndex == 0) {
        NSLog(@"close");
              [self deleteTaskByID];
              
          }
        else if (buttonIndex == 2) {
                  NSLog(@"cancel");
    }
}


-(void)editTaskByID
{
    YWEditAddTaskVC *vc = [[YWEditAddTaskVC alloc]initWithNibName:@"YWEditAddTaskVC" bundle:nil];
//    vc.selectedPPaField.text = self.receiveLabel.text;
//    vc.titleField.text = self.titleLabel.text;
//    vc.deadLineLabel.text = self.deadLineLabel.text;
//    vc.contentTxet.text = self.contentTxet.text;
    vc.titleString = self.titleLabel.text;
    //NSLog(@"%@,%@",self.titleLabel.text,vc.titleString);
    vc.selectedppString = self.receiveLabel.text;
    vc.deadlineString = self.deadLineLabel.text;
    vc.contentString = self.contentTxet.text;
    vc.sendUnixTime = [self.taskData objectForKey:@"endtime"];
    vc.selectedPID = [self.taskData objectForKey:@"tomuserid"];
    vc.isAdd = 0;
    vc.taskID = self.taskID;
    vc.autoIncremenID = self.autoIncremenID;
    firstview = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteTaskByID
{
    
    [[YWNetRequest sharedInstance] requestDeleteTaskDetailsWithTaskId:self.taskID WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"] integerValue]==80200)
        {
            [SVProgressHUD showSuccessWithStatus:@"此任务已关闭"];
            taskFilesd.taskLocked  = 1;
            taskFilesd.timeStampContent = [[respondsData objectForKey:@"lastdotime"]integerValue];
            taskFilesd.timeStampList =[[respondsData objectForKey:@"lastdotime"]integerValue];
            [taskDB uploadTaskContent:taskFilesd];
            [self.navigationController popViewControllerAnimated:YES];
#if 0
            if (delegate && [delegate respondsToSelector:@selector(deleteTaskDateInSection:inRow:)]) {
                [delegate performSelector:@selector(deleteTaskDateInSection:inRow:)withObject:self.inSection withObject:self.inRow];
            }
#endif
            
        }
        else
        {
            [self checkCodeByJson:respondsData];
            
        }

    } failed:^(NSError *error) {
        //
        if (isNetWork) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
    
    
}


-(void)modifyTask
{
    if(self.toMe ==1)
    {
//       if([self hasBeenSavedToCanlender])
//          [SVProgressHUD showSuccessWithStatus:@"已添加过"];
//        else
//        [self saveToCalendar];
        [self done];
    }
    else
    [modifySheet showInView:self.view];
}



-(BOOL)hasBeenSavedToCanlender
{
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSDate* ssdate = [NSDate dateWithTimeIntervalSince1970:taskFilesd.taskTime];//事件段，开始时间
    NSDate* ssend = [NSDate dateWithTimeIntervalSinceNow:(taskFilesd.taskEndTime+100)];//结束时间，取中间
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:ssdate
                                                                 endDate:ssend
                                                               calendars:nil];
    NSArray* events = [eventStore eventsMatchingPredicate:predicate];//数组里面就是时间段中的EKEvent事件数组
    NSLog(@"eeee%@",events);
    if([events count])
    {
        for (int i = 0; i<[events count]; i++) {
            EKEvent *aevent =[events objectAtIndex:i];
            //NSLog(@"event:%f  endtime:%i",[aevent.endDate timeIntervalSince1970],taskFilesd.taskEndTime);
            if(([aevent.endDate timeIntervalSince1970]==taskFilesd.taskEndTime)&&[aevent.title isEqualToString:taskFilesd.taskTitle]&&[aevent.notes isEqualToString:taskFilesd.taskContent])
                return YES;
        }
    }
    return NO;
}

-(void)saveToCalendar
{
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
         [SVProgressHUD showWithStatus:@"添加日历中" maskType:SVProgressHUDMaskTypeBlack];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    // display error message here
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                }
                else
                {
                   
                    
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    
                    
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = taskFilesd.taskTitle;
                    event.notes = taskFilesd.taskContent;
                    event.startDate = [NSDate dateWithTimeIntervalSince1970:taskFilesd.taskTime];
                    event.endDate   = [NSDate dateWithTimeIntervalSince1970:taskFilesd.taskEndTime];
                    NSLog(@"createndtime:%f",[event.endDate timeIntervalSince1970]);
                    event.allDay = NO;
                    
                    //添加提醒
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:-10]];
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:-20]];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];//defaultCalendarForNewEvents
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                  //  NSLog(@"%@,%ld,%@,",err.userInfo,(long)err.code,err.domain);
                    if(!err)
                      [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    else
                      [SVProgressHUD showErrorWithStatus:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
                }
            });
        }];
    }
    else
    {
        // this code runs in iOS 4 or iOS 5
        // ***** do the important stuff here *****
        
        //4.0和5.0通过下述方式添加
//         [SVProgressHUD showWithStatus:@"添加日历中" maskType:SVProgressHUDMaskTypeBlack];
        //保存日历
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        event.title     = taskFilesd.taskTitle;
        event.notes = taskFilesd.taskContent;
        
        //                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
        //                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        
        event.startDate = [[NSDate alloc]init];
        event.endDate   = [NSDate dateWithTimeIntervalSince1970:taskFilesd.taskEndTime];
        event.allDay = NO;
        
        //添加提醒
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-10]];
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-20]];
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];//defaultCalendarForNewEvents
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"已添加至日历"
//                              message:@"完成"
//                              delegate:nil
//                              cancelButtonTitle:@"完成"
//                              otherButtonTitles:nil];
//        [alert show];
//        NSLog(@"保存成功");
        if(!err)
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        else
            [SVProgressHUD showErrorWithStatus:err.description];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
    }
}


-(void)getOtherNotDoneTaskData
{
    [SVProgressHUD showWithStatus:@"加载中。。。"];
    
    [[YWNetRequest sharedInstance] requestgetNotDoneTaskDetailsDataWithTaskId:self.taskID WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"]integerValue]==80200)
        {
            self.taskData = [NSMutableDictionary dictionaryWithDictionary:[respondsData objectForKey:@"list_info"]];
            self.titleLabel.text = [self.taskData objectForKey:@"title"];
            self.sendLabel.text = [self.taskData objectForKey:@"frommusername"];
            self.receiveLabel.text = [self setStyleForTaskWithNameString:[self.taskData objectForKey:@"tomusername"]];//[self.taskData objectForKey:@"tomusername"];
            self.sendTimeLabel.text = [TOOL convertUnixTime:[[self.taskData objectForKey:@"newstime"]integerValue] timeType:3];
            self.deadLineLabel.text = [TOOL convertUnixTime:[[self.taskData objectForKey:@"endtime"]integerValue] timeType:3];
            self.contentTxet.text = [self.taskData objectForKey:@"content"];
        }
        else
        {
            [self checkCodeByJson:respondsData];
        }
        [SVProgressHUD dismiss];
        
    } failed:^(NSError *error) {
        //
        [SVProgressHUD dismiss];
        if (isNetWork) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            
        } else
            [SVProgressHUD dismiss];
    }];
    

}

-(void)gotoback
{
    if(self.fromPush)
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    else
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
