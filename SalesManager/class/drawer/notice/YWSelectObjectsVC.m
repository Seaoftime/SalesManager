//
//  YWSelectObjectsVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWSelectObjectsVC.h"

//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
#import "SelectCell.h"
#import "YWNewNoticeViewController.h"
#import "CellHeadView.h"
#import "YWErrorDBM.h"
#import "ClickHeadCell.h"


extern NSString* userid;
extern NSString* randcode;
@interface YWSelectObjectsVC ()

@end

@implementation YWSelectObjectsVC
@synthesize delegate;
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
    fromup = YES;
       selectedPartNum = 0;//选中cell时、切换部门人员时改变。选中id等到确定时计算
    selectedPeopleNum = 0;//
    isAllSelected = NO;
    userDBM = [[YManagerUserInfoDBM alloc]init];
    self.managerData = [[NSMutableArray alloc] initWithArray:[userDBM findWithDepartmentID:nil SortbyGroup:YES withInfo:YES Status:NO withMe:YES]];
    NSLog(@"%@",self.managerData);
    
    int xx =0; int yy =0;int zz =0;int managerNull =-1;
    for (int i = 0; i<[self.managerData count]; i++) {
        for(int j = 0;j<[[self.managerData objectAtIndex:i]count];j++)
        {
            YManagerUserInfoFileds* userInfo = [[self.managerData objectAtIndex:i]objectAtIndex:j];
            if([[NSString stringWithFormat:@"%li", (long)userInfo.userID] isEqualToString:userID])
            {
                zz = 1;
                xx =i; yy =j;
            }
            else
            {
                NSMutableDictionary* dic = [NSMutableDictionary dictionary];
                [dic setValue:userInfo.userDepartmentID forKey:@"partnameid"];
                [dic setValue: userInfo.userDepartmentName forKey:@"part_name"];
                [dic setValue:[NSString stringWithFormat:@"%li", (long)userInfo.userID] forKey:@"id"];
                [dic setValue: userInfo.userName forKey:@"name"];
                [dic setValue:userInfo.positionTitle forKey:@"position"];
                [dic setValue: userInfo.nameFullSpelling forKey:@"nameFullSpelling"];
                [dic setValue:userInfo.nameSimplicity forKey:@"nameSimplicity"];
                [[self.managerData objectAtIndex:i]replaceObjectAtIndex:j withObject:dic];
            }
        }
        if(zz ==1)
        {
            [[self.managerData objectAtIndex:xx] removeObjectAtIndex:yy];
            zz = 0;
        }
        if([[self.managerData objectAtIndex:i]count]==0)
            managerNull = i;
    }
    if(managerNull >=0)
        [self.managerData removeObjectAtIndex:managerNull];   //NSLog(@"replace:%@",self.managerData);
    
    self.departmentArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.searchResultArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.bottomDepartmentArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.bottomPeopleArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.sendData = [NSMutableDictionary dictionary];
    
    NSLog(@"$$$$$%@",self.managerData);
        for(int i = 0;i<[self.managerData count];i++)
        {
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setValue:[[[self.managerData objectAtIndex:i]objectAtIndex:0]objectForKey:@"partnameid"] forKey:@"id"];
            [dic setValue:[[[self.managerData objectAtIndex:i]objectAtIndex:0]objectForKey:@"part_name"] forKey:@"name"];
              NSLog(@"%@,dandu%@",[dic objectForKey:@"id"],[self.hasBeenSelectedData objectForKey:@"partid"]);
            if([[self.hasBeenSelectedData objectForKey:@"all"]isEqualToString:@"1"])
            [dic setValue:@"1" forKey:@"selected"];
            else
            {
                if([[self.hasBeenSelectedData objectForKey:@"partid"]containsObject:[dic objectForKey:@"id"]])
                  [dic setValue:@"1" forKey:@"selected"];
                  else
                  [dic setValue:@"0" forKey:@"selected"];
            }
            [dic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[[self.managerData objectAtIndex:i]count]] forKey:@"number"];
            [self.departmentArray addObject:dic];
            for(int j = 0;j<[[self.managerData objectAtIndex:i]count];j++)
            {
                NSMutableDictionary* dica = [[self.managerData objectAtIndex:i]objectAtIndex:j];
                if([[dic objectForKey:@"selected"]isEqualToString:@"1"])
                     [dica setValue:@"1" forKey:@"selected"];
                else
                {
                    if([[self.hasBeenSelectedData objectForKey:@"peopleid"] containsObject: [[[self.managerData objectAtIndex:i]objectAtIndex:j]objectForKey:@"id"]])
                   [dica setValue:@"1" forKey:@"selected"];
                    else
                        [dica setValue:@"0" forKey:@"selected"];
                }
            }
        }
    
    for (int i = 0; i<[self.managerData count]; i++) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:[[[self.managerData objectAtIndex:i]objectAtIndex:0]objectForKey:@"partnameid"]forKey:@"partnameid"];
        [dic setValue:[self.managerData objectAtIndex:i] forKey:@"allMembers"];
        [dic setValue: @"0" forKey:@"isStretch"];
        [self.managerData replaceObjectAtIndex:i withObject:dic];
    }
NSLog(@"%@$$$$$%@^^^^^%@",self.managerData,self.departmentArray,self.hasBeenSelectedData);
    
    for (int i = 0; i<[self.departmentArray count]; i++) {
        if([[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]isEqualToString:@"1"])
            [self.bottomDepartmentArray addObject:[self.departmentArray objectAtIndex:i]];
    }

//        UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(10, 20, 50, 44)];
//    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal ];
//    UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    
    segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(90.0f, 30.0f, 140.0f, 25.0f) ];
    [segmentedControl insertSegmentWithTitle:@"部门" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"员工" atIndex:1 animated:YES];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = [UIColor whiteColor];
    if(!IS_IOS7)
    {
        [segmentedControl setTitle:@"" forSegmentAtIndex:0];
        [segmentedControl setTitle:@"" forSegmentAtIndex:1];
       [segmentedControl setBackgroundImage:[UIImage imageNamed:@"111.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setBackgroundImage:[UIImage imageNamed:@"222.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    }
    self.navigationItem.titleView=segmentedControl;
       self.view.backgroundColor = BGCOLOR;
    departmentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, (KDeviceHeight-65-50))];
     departmentBgView.backgroundColor = [UIColor clearColor];
    
    UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 7, kDeviceWidth+2, 40)];
    allBgView.backgroundColor = [UIColor whiteColor];
    allBgView.layer.borderColor = [SMALLTITLECOLOR CGColor];
    allBgView.layer.borderWidth = 0.5;
    allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectButton.frame = CGRectMake(0, 0, kDeviceWidth, 46);
    [allSelectButton addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    allimageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 20, 20)];
    [allimageview setImage:[UIImage imageNamed:@"pickPerson_unselected.png"]];
    if([[self.hasBeenSelectedData objectForKey:@"all"]isEqualToString:@"1"])
    {
      [allimageview setImage:[UIImage imageNamed:@"pickPerson_selected.png"]];
        isAllSelected = YES;
    }
    UILabel*allLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 11, 200, 18)];
    allLabel.text = @"全公司";
    allLabel.font = [UIFont systemFontOfSize:17.0];
    
    [allBgView addSubview:allimageview];
    [allBgView addSubview:allLabel];
    [allBgView addSubview:allSelectButton];
    [departmentBgView addSubview:allBgView];
    
    departmentTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 52, kDeviceWidth, KDeviceHeight-65-52-50) style:UITableViewStylePlain];
    departmentTB.backgroundColor = [UIColor clearColor];
    departmentTB.dataSource = self;
    departmentTB.delegate = self;
     departmentTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if(IS_IOS7)
    departmentTB.separatorInset = UIEdgeInsetsZero;
    [departmentBgView addSubview:departmentTB];
    //[departmentTB setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:departmentBgView];
    
    peopleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, (KDeviceHeight-64-50))];
    peopleBgView.backgroundColor = [UIColor clearColor];
    
    mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.frame = CGRectMake(0, 0, 320, 44);
    [mySearchBar setBackgroundColor:[UIColor clearColor]];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入搜索人员";
    mySearchBar.translucent = YES;
    mySearchBar.barStyle = UIBarStyleDefault;
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    
    [mySearchDisplayController setDelegate:self];
    [mySearchDisplayController setSearchResultsDataSource:self];
    [mySearchDisplayController setSearchResultsDelegate:self];
    
    peopleTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-65-50) style:UITableViewStylePlain];
    peopleTB.backgroundColor = [UIColor clearColor];
    peopleTB.tableHeaderView = mySearchBar;
    peopleTB.dataSource = self;
    peopleTB.delegate = self;
      if(IS_IOS7)
    peopleTB.separatorInset = UIEdgeInsetsZero;
     peopleTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [peopleBgView addSubview:peopleTB];
    
    [self.view addSubview:peopleBgView];
    peopleBgView.hidden = YES;
    
    /**
     底部视图
     */
    UIView *bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight-64-50, kDeviceWidth, 50)];
    bottomBgView.backgroundColor = [UIColor colorWithRed:196/255.0 green:200/255.0 blue:202/255.0 alpha:1];
    //bottomBgView.backgroundColor = [UIColor redColor];
    
    bottomTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 50, kDeviceWidth - 73)];
    bottomTB.backgroundColor =[UIColor clearColor];
    bottomTB.dataSource = self;
    bottomTB.delegate = self;
    bottomTB.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    bottomTB.showsVerticalScrollIndicator = NO;
    bottomTB.center = CGPointMake(kDeviceWidth/2 - 40, 25);
    
    
    
    bottomTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    bottomTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //选择加边框
    bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(kDeviceWidth - 73, 10, 63, 30);
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
   
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [bottomBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [bottomBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [bottomBtn setBackgroundColor:NAVIGATIONCOLOR];
    [bottomBtn addTarget:self action:@selector(beSure) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 5;

    [self.view addSubview:bottomBgView];
    [bottomBgView addSubview:bottomBtn];
    [bottomBgView addSubview:bottomTB];
   // [self getAllMember];
     [self setBottomBtnStyle];
}
-(void)setBottomBtnStyle
{
    if(([self.bottomDepartmentArray count]+[self.bottomPeopleArray count])==0)
    {
        bottomBtn.enabled = NO;
        [bottomBtn setBackgroundColor:[UIColor colorWithRed:126/255.0 green:127/255.0 blue:127/255.0 alpha:1]];
        
    }
    else
    {
         bottomBtn.enabled = YES;
         [bottomBtn setBackgroundColor:NAVIGATIONCOLOR];
        if(departmentBgView.hidden == NO)
        {
            for (int i=0;i<[self.departmentArray count];i++) {
                if([[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]isEqualToString:@"1"])
                {
                    for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
                    {
                        [[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]setValue:@"1" forKey:@"selected"];
                    }
                }
            }
            int peopleNum = 0;
            for (int i=0;i<[self.departmentArray count];i++) {
                for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
                {
                    peopleNum= peopleNum + [[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j] objectForKey:@"selected"]integerValue];
                }
            }
            selectedPeopleNum = peopleNum;
        }
        [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPeopleNum] forState:UIControlStateNormal];
    }
}
-(void)getAllMember
{
    [[YWNetRequest sharedInstance] requestgetAllMemberWithSuccess:^(id respondsData) {
        //
        self.managerData = [NSMutableArray arrayWithArray:[[NSMutableDictionary dictionaryWithDictionary:[respondsData objectForKey:@"data"]]allValues]];
        self.managerData = [NSMutableArray arrayWithArray: [TOOL sortArray:self.managerData byKey:@"part_name"]];
        NSLog(@"%@",self.managerData);
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);                                                         NSString *path=[paths objectAtIndex:0];
        NSLog(@"path = %@",path);
        NSString *filename=[path stringByAppendingPathComponent:@"managerMemberTest.plist"];
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        [self.managerData writeToFile:filename atomically:YES];
        
    } failed:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    
}
#pragma mark -search delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
    for(id cc in [searchBar subviews])
      {
             if([cc isKindOfClass:[UIButton class]])
                {
                     UIButton *sbtn = (UIButton *)cc;
                     [sbtn setTitle:@"取消" forState:UIControlStateNormal];
                     [sbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    }
            }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                     // called when keyboard search button pressed
{
       [mySearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
    [mySearchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    
    if (self.searchResultArray.count == 0) {
        self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }

    
    
//    if ( (searchString == nil) || (searchString.length == 0) )
//    {
//          [self.searchResultArray removeAllObjects];
//    }
//    else
    {
        [self.searchResultArray removeAllObjects];
        for(int i=0;i<[self.managerData count];i++)
        {
            for (int j=0; j<[[[self.managerData objectAtIndex:i] objectForKey:@"allMembers"]count]; j++) {
                NSRange nameRange = [[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]objectForKey:@"name"] rangeOfString:searchString options:NSCaseInsensitiveSearch];
                NSRange simpleRange = [[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]objectForKey:@"nameSimplicity"] rangeOfString:searchString options:NSCaseInsensitiveSearch];
                NSRange fullRange = [[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]objectForKey:@"nameFullSpelling"] rangeOfString:searchString options:NSCaseInsensitiveSearch];
                if((fullRange.location != NSNotFound)||(simpleRange.location != NSNotFound)||(nameRange.location != NSNotFound))
                {
                    NSMutableDictionary *object = [[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j];
                    [object setValue:[NSString stringWithFormat:@"%i",j] forKey:@"row"];
                    [object setValue:[NSString stringWithFormat:@"%i",i] forKey:@"section"];
                    if (![self.searchResultArray containsObject:object])
                    {
                        [self.searchResultArray addObject:object];
                    }
                }
            }
            //NSLog(@"searchResultArray:%@",self.searchResultArray);
    }
    }
      return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mySearchBar resignFirstResponder];
}

-(void)selectAll
{
    if(isAllSelected)
    {
        for(int i=0;i<[self.departmentArray count];i++)
        {
            [[self.departmentArray objectAtIndex:i]setValue:@"0" forKey:@"selected"];
        }
        for (int i=0;i<[self.departmentArray count];i++) {
          for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
                {
                    [[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]setValue:@"0" forKey:@"selected"];
                }
        }
        isAllSelected = NO;
        [allimageview setImage:[UIImage imageNamed:@ "pickPerson_unselected.png"]];
        [departmentTB reloadData];
        selectedPartNum = 0;
        [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPartNum] forState:UIControlStateNormal];
        
    }
    else
    {
        for(int i=0;i<[self.departmentArray count];i++)
        {
            [[self.departmentArray objectAtIndex:i]setValue:@"1" forKey:@"selected"];
        }
        isAllSelected = YES;
        [allimageview setImage:[UIImage imageNamed:@ "pickPerson_selected.png"]];
        [departmentTB reloadData];
        selectedPartNum = [self.departmentArray count];
        [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPartNum] forState:UIControlStateNormal];
        
    }
    [self.bottomDepartmentArray removeAllObjects];
    for (int i = 0; i<[self.departmentArray count]; i++) {
        if([[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]isEqualToString:@"1"])
            [self.bottomDepartmentArray addObject:[self.departmentArray objectAtIndex:i]];
    }
   // [bottomTB reloadData];
    [self refreshBottomTB];
    [self setBottomBtnStyle];
}
-(void)refreshBottomTB
{
    NSIndexPath *myIndexPath;
    [bottomTB reloadData];
     if(departmentBgView.hidden == NO)
     {
         if(self.bottomDepartmentArray.count>0)
         {
           myIndexPath = [NSIndexPath indexPathForRow:self.bottomDepartmentArray.count-1 inSection:0];
           [bottomTB selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
         }
     }
    else
    {
        if(self.bottomPeopleArray.count>0)
        {
         myIndexPath = [NSIndexPath indexPathForRow:self.bottomPeopleArray.count-1 inSection:0];
        [bottomTB selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
    }
}
-(void)selectButton:(UISegmentedControl*)sender
{
    NSInteger Index;
    if(departmentBgView.hidden == YES)
        Index = 0;
    else
        Index =1;
    //NSInteger Index = sender.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    switch (Index) {
        case 0://选择部门时，如果这个部门的人全部选中，部门selected为1.
            for (int i=0;i<[self.departmentArray count];i++) {
                [[self.departmentArray objectAtIndex:i]setValue:@"1" forKey:@"selected"];
                for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
                    {
                       if( [[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]objectForKey:@"selected"]isEqualToString:@"0"])
                       {
                           [[self.departmentArray objectAtIndex:i]setValue:@"0" forKey:@"selected"];
                           break; //如果i部门中有一个selected为0 ，部门selected为0
                       }
                    }
            }
            int departnum = 0;
            for (int i=0;i<[self.departmentArray count];i++)
            {
                departnum = departnum + [[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]integerValue];
            }
            selectedPartNum = departnum;
            if(selectedPartNum == [self.departmentArray count])
            {
                isAllSelected = YES;
                [allimageview setImage:[UIImage imageNamed:@"pickPerson_selected.png"]];
            }
            else
            {
                isAllSelected = NO;
                [allimageview setImage:[UIImage imageNamed:@"pickPerson_unselected.png"]];
            }
            [self.bottomDepartmentArray removeAllObjects];
            for (int i = 0; i<[self.departmentArray count]; i++) {
                if([[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]isEqualToString:@"1"])
                    [self.bottomDepartmentArray addObject:[self.departmentArray objectAtIndex:i]];
            }
            [departmentTB reloadData];
            peopleBgView.hidden = YES;
            departmentBgView.hidden = NO;
            [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPartNum] forState:UIControlStateNormal];
            
            NSLog(@"department");
           // [bottomTB reloadData];
             [self refreshBottomTB];
            break;
            
        case 1:  //如果选择人员列表时 部门selected为1时，部门全人员selected为1
            for (int i=0;i<[self.departmentArray count];i++) {
               if([[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]isEqualToString:@"1"])
               {
                   for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
                   {
                       [[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]setValue:@"1" forKey:@"selected"];
                   }
               }
            }
            int peopleNum = 0;
            for (int i=0;i<[self.departmentArray count];i++) {
                    for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
                    {
                        peopleNum= peopleNum + [[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j] objectForKey:@"selected"]integerValue];
                    }
            }
            [self.bottomPeopleArray removeAllObjects];
            for (int i = 0; i<[self.managerData count]; i++) {
                for (int j = 0; j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count]; j++) {
                    if([[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j] objectForKey:@"selected"]isEqualToString:@"1"])
                        [self.bottomPeopleArray addObject:[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]];
                }
            }

            selectedPeopleNum = peopleNum;
         [peopleTB reloadData];
          peopleBgView.hidden = NO;
          departmentBgView.hidden = YES;
        [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPeopleNum] forState:UIControlStateNormal];
           
          NSLog(@"people");
           // [bottomTB reloadData];
             [self refreshBottomTB];
            break;
        
        default:
            break;
    }
    [self setBottomBtnStyle];

}
-(void)beSure
{
    [self selectButton:segmentedControl];
    NSMutableArray *departIdsArray =[[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *departNamesArray =[[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *peopleIdsArray =[[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *peopleNamesArray =[[NSMutableArray alloc]initWithCapacity:0];
    for(int i = 0;i< [self.departmentArray count];i++)
    {
        if([[[self.departmentArray objectAtIndex:i]objectForKey:@"selected"]isEqualToString:@"1"])
        {
            [departIdsArray addObject:[[self.departmentArray objectAtIndex:i]objectForKey:@"id"]];
            [departNamesArray addObject:[[self.departmentArray objectAtIndex:i]objectForKey:@"name"]];
        }
        else
        {
            for(int j=0;j<[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]count];j++)
            {
                if([[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j]objectForKey:@"selected"]isEqualToString:@"1"])
                {
                [peopleIdsArray addObject:[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j] objectForKey:@"id"]];
                [peopleNamesArray addObject:[[[[self.managerData objectAtIndex:i]objectForKey:@"allMembers"]objectAtIndex:j] objectForKey:@"name"]];
                }
            }
        }
    }
    [self.sendData setValue:departIdsArray forKey:@"partid"];
    [self.sendData setValue:departNamesArray forKey:@"partname"];
    [self.sendData setValue:peopleIdsArray forKey:@"peopleid"];
    [self.sendData setValue:peopleNamesArray forKey:@"peoplename"];
    [self.sendData setValue:[NSString stringWithFormat:@"%i",isAllSelected] forKey:@"all"];
    NSLog(@"senddata:%@",self.sendData);
    if (delegate && [delegate respondsToSelector:@selector(selectSendData:)]) {
        [delegate performSelector:@selector(selectSendData:)withObject:self.sendData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == departmentTB)
    return 1;
    else if  (tableView == mySearchDisplayController.searchResultsTableView)
        return 1;
    else if(tableView == peopleTB)
        return [self.managerData count];
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == departmentTB)
        return [self.departmentArray count];
    else if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        return self.searchResultArray.count;
    }
    else if(tableView == peopleTB)
    {
        if([[[self.managerData objectAtIndex:section] objectForKey:@"isStretch"]isEqualToString:@"0"])
            return 0;
        else
            return [[[self.managerData objectAtIndex:section]objectForKey:@"allMembers"]count];
    }
    else
    {
        if(departmentBgView.hidden == NO)
        {
            return [self.bottomDepartmentArray count];
        }
        else
        {
            return [self.bottomPeopleArray count];
        }
    }
        
}
#if 1
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(!(tableView == peopleTB))
      return Nil;
    else
    {
        return [[[[self.managerData objectAtIndex:section]objectForKey:@"allMembers"]objectAtIndex:0]objectForKey:@"part_name"];
        }
}
#endif
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if(!(tableView == peopleTB))
         return nil;
    else
    {
        ClickHeadCell *headView = [[ClickHeadCell alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
        
        //headView.backgroundColor = [UIColor redColor];
        
        
        /**
         分割线
         
         - returns:
         */
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5f, kDeviceWidth, 0.5)];
        
        [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
        [headView  addSubview:line1];
        if([[[self.managerData objectAtIndex:section] objectForKey:@"allMembers"]count])
            headView.departmentLabel.text = [[[[self.managerData objectAtIndex:section] objectForKey:@"allMembers"]objectAtIndex:0]objectForKey:@"part_name"];
        if([[[self.managerData objectAtIndex:section] objectForKey:@"isStretch"]isEqualToString:@"0"])
            [headView.stretchBtn setImage:[UIImage imageNamed:@"closeArrow"] forState:UIControlStateNormal];
        else
            [headView.stretchBtn setImage:[UIImage imageNamed:@"openArrow"] forState:UIControlStateNormal];
        
        [headView.stretchBtn addTarget:self action:@selector(stretchList:) forControlEvents:UIControlEventTouchUpInside];
        headView.stretchBtn.tag = section;
        headView.allSelectedBtn.hidden = YES;
        return headView;
    }
 }

-(void)stretchList:(UIButton*)sender
{
    if([sender imageForState:UIControlStateNormal]==[UIImage imageNamed:@"closeArrow"])
        [sender setImage:[UIImage imageNamed:@"openArrow"] forState:UIControlStateNormal];
    else
        [sender setImage:[UIImage imageNamed:@"closeArrow"] forState:UIControlStateNormal];
    if([[[self.managerData objectAtIndex:sender.tag] objectForKey:@"isStretch"]isEqualToString:@"0"])
        [[self.managerData objectAtIndex:sender.tag] setValue:@"1" forKey:@"isStretch"];
    else
        [[self.managerData objectAtIndex:sender.tag] setValue:@"0" forKey:@"isStretch"];
    [peopleTB reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!(tableView == peopleTB))
    {
        return 0;
    }
    else
    //return 46;
        return 40;
   }



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  部门
     */
    if(tableView == departmentTB)
    {
        static  NSString *CellIdentifier = @"SelectCellID";
        SelectCell *cell= [departmentTB dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([[[self.departmentArray objectAtIndex:indexPath.row]objectForKey:@"selected"]isEqualToString:@"0"])
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_unselected.png"];
        else
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_selected.png"];
      
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = LINECOLOR;
        cell.selectedBackgroundView = aView;
        
        //
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[[self.departmentArray objectAtIndex:indexPath.row] objectForKey:@"name"],[[self.departmentArray objectAtIndex:indexPath.row]objectForKey:@"number"]];

        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.nameLabel.text];
        
        NSRange clorRange = NSMakeRange([[noteStr string] rangeOfString:@"("].location, [[noteStr string] rangeOfString:[NSString stringWithFormat:@"%@",[[self.departmentArray objectAtIndex:indexPath.row] objectForKey:@"number"]]].length + 2);
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] range:clorRange];
        
        [cell.nameLabel setAttributedText:noteStr];
        //[cell.nameLabel sizeToFit];
        
        
        
        
    return cell;
        
        
    }
    else if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        static  NSString *CellIdentifier = @"SelectCellID";
        SelectCell *cell= [mySearchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if([[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"selected"]isEqualToString:@"0"])
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_unselected.png"];
        else
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_selected.png"];
        
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = LINECOLOR;
        cell.selectedBackgroundView = aView;
        if([[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"position"] == nil || [[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"position"]isEqualToString:@"(null)"])
        {
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"name"]];
            
        }else{
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"name"], [[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"position"]];
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.nameLabel.text];
            
            NSRange clorRange = NSMakeRange([[noteStr string] rangeOfString:@"("].location, [[noteStr string] rangeOfString:[NSString stringWithFormat:@"%@",[[self.searchResultArray objectAtIndex:indexPath.row] objectForKey:@"position"]]].length + 2);
            
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] range:clorRange];
            
            [cell.nameLabel setAttributedText:noteStr];
            //[cell.nameLabel sizeToFit];

            
        }

        return cell;

    }
    else if(tableView == peopleTB)//员工
    {
        static  NSString *CellIdentifier = @"SelectCellID";
        SelectCell *cell= [departmentTB dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
        }
        if([[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"selected"]isEqualToString:@"0"])
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_unselected.png"];
        else
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_selected.png"];
        
        if([[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"] == nil || [[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"]isEqualToString:@"(null)"])
        {
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"name"]];
            
        }else{
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"name"], [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"]];
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.nameLabel.text];
            
            NSRange clorRange = NSMakeRange([[noteStr string] rangeOfString:@"("].location, [[noteStr string] rangeOfString:[NSString stringWithFormat:@"%@",[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"]]].length + 2);
            
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] range:clorRange];
            
            [cell.nameLabel setAttributedText:noteStr];
            //[cell.nameLabel sizeToFit];

        }
        
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = LINECOLOR;
        cell.selectedBackgroundView = aView;
        return cell;
}
    else
    {
        static NSString *CellIdentifier = @"SelectPersonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 12, 42, 26)];
            label.tag = 100;
            label.backgroundColor = [UIColor whiteColor];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:0.000 green:0.569 blue:1.000 alpha:1.000];
            [cell.contentView addSubview:label];
        }
        // cell顺时针旋转90度
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        cell.backgroundColor = [UIColor clearColor];
        //cell.textLabel.text = @"name";
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
        if (label == nil) {
            label = (UILabel *)[cell viewWithTag:100];
        }
        if(departmentBgView.hidden == NO)
        {
          label.text = [[self.bottomDepartmentArray objectAtIndex:indexPath.row]objectForKey:@"name"];
        }
        else
        {
            label.text = [[self.bottomPeopleArray objectAtIndex:indexPath.row]objectForKey:@"name"];
        }
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        [label sizeToFit];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        CGRect frame = label.frame;
        frame.size.height = 26;
        if (frame.size.width < 50)
        {
            frame.size.width = 50;
        }
        else
        {
            frame.size.width = frame.size.width+ 12;
        }
        
        label.frame = frame;
        
        [cell setFrame:CGRectMake(0, 0, 50, label.frame.size.width + 6)];
        
        return cell;

    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == peopleTB)
    {
       //SelectCell *cell = (SelectCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if([[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"selected"]isEqualToString:@"0"])
        {
            [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row] setValue:@"1" forKey:@"selected"];
                selectedPeopleNum++;
            [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPeopleNum] forState:UIControlStateNormal];
            
            [self.bottomPeopleArray addObject:[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]];
            [self refreshBottomTB];

        }
        else
        {
            [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row] setValue:@"0" forKey:@"selected"];
            selectedPeopleNum--;
            [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPeopleNum] forState:UIControlStateNormal];
      if(fromup)
      {
            [self.bottomPeopleArray removeObject:[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]];
            [self refreshBottomTB];
      }
            fromup = YES;
        }
        [peopleTB reloadData];
       // [bottomTB reloadData];
            }
    else if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        int srow =(int)[[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"row"]integerValue];
        int ssection = (int)[[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"section"]integerValue];
        if([[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"selected"]isEqualToString:@"0"])
        {
            [[self.searchResultArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"selected"];
             [[[[self.managerData objectAtIndex:ssection]objectForKey:@"allMembers"]objectAtIndex:srow] setValue:@"1" forKey:@"selected"];
            selectedPeopleNum++;
            [self.bottomPeopleArray addObject:[[[self.managerData objectAtIndex:ssection]objectForKey:@"allMembers"]objectAtIndex:srow]];
            [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPeopleNum] forState:UIControlStateNormal];
      
        }
        else
        {
            [[self.searchResultArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"selected"];
            [[[[self.managerData objectAtIndex:ssection]objectForKey:@"allMembers"]objectAtIndex:srow] setValue:@"0" forKey:@"selected"];
            selectedPeopleNum--;
            [self.bottomPeopleArray removeObject:[[[self.managerData objectAtIndex:ssection]objectForKey:@"allMembers"]objectAtIndex:srow]];
            [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPeopleNum] forState:UIControlStateNormal];
          
        }
        [peopleTB reloadData];
        [mySearchDisplayController.searchResultsTableView reloadData];
         [self refreshBottomTB];
        [mySearchBar resignFirstResponder];
        [self.searchDisplayController setActive:NO animated:YES];
    }
    else if(tableView == departmentTB)
    {
        //SelectCell *cell = (SelectCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if([[[self.departmentArray objectAtIndex:indexPath.row]objectForKey:@"selected"]isEqualToString:@"0"])
        {
            [[self.departmentArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"selected"];
            selectedPartNum++;
            [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPartNum] forState:UIControlStateNormal];
            [self.bottomDepartmentArray addObject:[self.departmentArray objectAtIndex:indexPath.row]];
             [self refreshBottomTB];
                  }
        else// 如果当前部门selected为0，当点击时，部门全人员selected为0
        {
                [[self.departmentArray objectAtIndex:indexPath.row] setValue:@"0" forKey:@"selected"];
              selectedPartNum--;
             [bottomBtn setTitle:[NSString stringWithFormat:@"确定(%i)",selectedPartNum] forState:UIControlStateNormal];
         
              for(int j=0;j<[[[self.managerData objectAtIndex:indexPath.row]objectForKey:@"allMembers"]count];j++)
              {
                [[[[self.managerData objectAtIndex:indexPath.row]objectForKey:@"allMembers"]objectAtIndex:j]setValue:@"0" forKey:@"selected"];
               }
            if(fromup)
            {
            [self.bottomDepartmentArray removeObject:[self.departmentArray objectAtIndex:indexPath.row]];
             [self refreshBottomTB];
            }
            fromup = YES;
        }
        if(selectedPartNum == [self.departmentArray count])
        {
            isAllSelected = YES;
            [allimageview setImage:[UIImage imageNamed:@"pickPerson_selected.png"]];
        }
        else
        {
            isAllSelected = NO;
            [allimageview setImage:[UIImage imageNamed:@"pickPerson_unselected.png"]];
        }

        [departmentTB reloadData];
       // [bottomTB reloadData];
        
    }
    else
    {
        if(departmentBgView.hidden == NO)
        {
            fromup = NO;
            NSInteger willdisappear = [self.departmentArray indexOfObject:[self.bottomDepartmentArray objectAtIndex:indexPath.row]];
            //NSLog(@"depart%@   bottom %@   %i",self.departmentArray,[self.bottomDepartmentArray objectAtIndex:indexPath.row],willdisappear);
           NSIndexPath *index = [NSIndexPath indexPathForRow:willdisappear inSection:0];
            [self tableView:departmentTB didSelectRowAtIndexPath:index];
            [self.bottomDepartmentArray removeObjectAtIndex:indexPath.row];
            [bottomTB deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else
        {
         fromup = NO;
        if([self.managerData count]>0)
        {
            NSInteger willdisappearsection = 0;
            for(int i = 0; i<[self.managerData count]; i++) {
                if([[[self.managerData objectAtIndex:i]objectForKey:@"partnameid"]isEqualToString:[[self.bottomPeopleArray objectAtIndex:indexPath.row]objectForKey:@"partnameid"]])
                {
                    willdisappearsection = i;
                   break;
                }
            }            
            NSInteger willdisappearrow = [[[self.managerData objectAtIndex:willdisappearsection]objectForKey:@"allMembers"] indexOfObject:[self.bottomPeopleArray objectAtIndex:indexPath.row]];
            NSIndexPath *index = [NSIndexPath indexPathForRow:willdisappearrow inSection:willdisappearsection];
            [self tableView:peopleTB didSelectRowAtIndexPath:index];
            [self.bottomPeopleArray removeObjectAtIndex:indexPath.row];
            [bottomTB deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        }
    }
    [self setBottomBtnStyle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
       // return 35.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
