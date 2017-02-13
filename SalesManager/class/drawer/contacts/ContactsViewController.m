//
//  ContactsViewController.m
//  SalesManager
//
//  Created by Kris on 14-2-7.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "ContactsViewController.h"
#import "UINavigationBar+customBar.h"
#import "ILBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "ContactsDetailViewController.h"
#import "ChineseString.h"
#import "pinyin.h"

#import "UIImageView+WebCache.h"

@interface ContactsViewController ()
{
    YManagerUserInfoDBM *userDBM;
//    NSMutableArray* searchResultArray;
}

@property (nonatomic, strong) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *allPersonArray;
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys;
@property (nonatomic, strong) YManagerUserInfoFileds *selectedUser;
@property (nonatomic, strong) NSMutableArray *searchResultArray;

- (IBAction)makeaCall:(UIButton *)sender;

@end

@implementation ContactsViewController

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
	// Do any additional setup after loading the view.
    
    //初始化加载数据
    userDBM = [[YManagerUserInfoDBM alloc] init];
    self.searchResultArray = [[NSMutableArray alloc] init];
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }else{
        [self.navigationController.navigationBar customNavigationBar];
    }
    
    if ([self.contactsTableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)])
    {
        self.contactsTableView.sectionIndexBackgroundColor = [UIColor colorWithWhite:1 alpha:0.300];
    }
    
    
//    /* Left bar button item */
//    ILBarButtonItem *leftBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"backHome"]
//                                                   selectedImage:nil
//                                                          target:self
//                                                          action:@selector(backToHome:)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(backToHome:)];
//
//    [self.segmentedControl addTarget:self action:@selector(changeSort:) forControlEvents:UIControlEventValueChanged];
//    self.segmentedControl.selectedSegmentIndex = 0;
    
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(90.0f, 30.0f, 175.0f, 25.0f) ];
    [self.segmentedControl insertSegmentWithTitle:@"字母排序" atIndex:0 animated:YES];
    [self.segmentedControl insertSegmentWithTitle:@"组织架构" atIndex:1 animated:YES];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.multipleTouchEnabled=NO;
    [self.segmentedControl addTarget:self action:@selector(changeSort:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    if(!IS_IOS7)
    {
        [self.segmentedControl setTitle:@"" forSegmentAtIndex:0];
        [self.segmentedControl setTitle:@"" forSegmentAtIndex:1];
        [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"contacts_segment1@2x"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"contacts_segment2@2x"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    }
    self.navigationItem.titleView = self.segmentedControl;
    
    
    
    [self changeSort:self.segmentedControl];
    
    
    
    //去掉多余的cell
    self.contactsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.contactsTableView deselectRowAtIndexPath:[self.contactsTableView indexPathForSelectedRow] animated:YES];
}

- (void)changeSort:(UISegmentedControl *)sender
{
    //NSLog(@"%d",sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex)
    {
        case 0://字母
        {
            self.allPersonArray = [[NSMutableArray alloc] initWithArray:[userDBM findWithDepartmentID:nil
                                                                                          SortbyGroup:NO
                                                                                             withInfo:YES
                                                                                               Status:NO
                                                                                               withMe:NO]];
            self.sectionHeadsKeys = [[NSMutableArray alloc] init];
            [self sortByPinYin:self.allPersonArray];
            break;
        }
        case 1://组织
        {
            self.allPersonArray = [[NSMutableArray alloc] initWithArray:[userDBM findWithDepartmentID:nil
                                                                                          SortbyGroup:YES
                                                                                             withInfo:YES
                                                                                               Status:NO
                                                                                               withMe:NO]];
            self.sectionHeadsKeys = [[NSMutableArray alloc] init];
            [self sortByOrganization:self.allPersonArray];
            break;
        }
        default:
            break;
    }
}


//按组织架构排序
- (void)sortByOrganization:(NSMutableArray *)aArray
{
    NSLog(@"%@",aArray);
    for (NSArray *userArray in self.allPersonArray)
    {
        if (userArray.count) {
            YManagerUserInfoFileds *user = [userArray objectAtIndex:0];
            [_sectionHeadsKeys addObject:user.userDepartmentName];
        }
    }
    
    //针对数据折叠做的处理
    for (int i = 0; i<[self.allPersonArray count]; i++)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:[self.allPersonArray objectAtIndex:i] forKey:@"allMembers"];//人员信息
        [dic setValue: @"0" forKey:@"isStretch"];//是否展开
        [self.allPersonArray replaceObjectAtIndex:i withObject:dic];
    }
    NSLog(@"%@",self.allPersonArray);
    
    [self.contactsTableView reloadData];
}

//按首字母排序
- (void)sortByPinYin:(NSMutableArray *)aArray
{
    YManagerUserInfoFileds *user;
    
    //Step1输出
    NSLog(@"尚未排序的NSString数组:");
    for(int i=0; i<[aArray count]; i++){
        
        user = (YManagerUserInfoFileds *)[aArray objectAtIndex:i];
        
        NSLog(@"%@",user.userName);
    }

    
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    for(int i=0; i<[aArray count]; i++){
        
        user = (YManagerUserInfoFileds *)[aArray objectAtIndex:i];
        
        if(user.userName == nil){
            user.userName = @"";
        }
        
        if(![user.userName isEqualToString:@""]){
            NSString *pinYinResult = [NSString string];
            for(int j=0; j<user.userName.length; j++){
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([user.userName characterAtIndex:j])]uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            user.pinYin = pinYinResult;
        }else{
            user.pinYin = @"";
        }
    }
    
    //Step2输出
    NSLog(@"\n\n\n转换为拼音首字母后的NSString数组");
    for(int i=0; i<[aArray count]; i++){
        user = (YManagerUserInfoFileds *)[aArray objectAtIndex:i];
        NSLog(@"原String:%@----拼音首字母String:%@",user.userName, user.pinYin);
    }
    
    
    
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [aArray sortUsingDescriptors:sortDescriptors];

    //Step3输出
    NSLog(@"\n\n\n按照拼音首字母后的NSString数组");
    for(int i=0; i<[aArray count]; i++){
        user = (YManagerUserInfoFileds *)[aArray objectAtIndex:i];
        NSLog(@"原String:%@----拼音首字母String:%@",user.userName, user.pinYin);
    }
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [aArray count]; index++)
    {
        user = (YManagerUserInfoFileds *)[aArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:user.pinYin];
        NSString *sr = [strchar substringToIndex:1];
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[aArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    
    self.allPersonArray = arrayForArrays;
    
    NSLog(@"%@",self.allPersonArray);
    
    //针对数据折叠做的处理
    for (int i = 0; i<[self.allPersonArray count]; i++)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:[self.allPersonArray objectAtIndex:i] forKey:@"allMembers"];//人员信息
        [dic setValue: @"1" forKey:@"isStretch"];//是否展开
        [self.allPersonArray replaceObjectAtIndex:i withObject:dic];
    }
    NSLog(@"%@",self.allPersonArray);
    
    [self.contactsTableView reloadData];
}

- (void)backToHome:(id)sender
{
    [self.mm_drawerController setCenterViewController: self.homeNavi withCloseAnimation:YES completion:nil];
}

- (IBAction)makeaCall:(UIButton *)sender
{
    UITableViewCell *cell;
    
    if ([sender.superview.superview.superview class] != [UITableViewCell class])
    {
        cell = (UITableViewCell *)sender.superview.superview.superview.superview;
    }
    else
    {
        cell = (UITableViewCell *)sender.superview.superview.superview;
    }
    
    NSIndexPath* indexPath= [self.contactsTableView indexPathForCell:cell];
    
    //NSLog(@"%@",sender.superview.superview.superview.superview);
    //NSLog(@"%d,%d",indexPath.section,indexPath.row);
    
    YManagerUserInfoFileds *user = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"] objectAtIndex:indexPath.row];
    self.selectedUser = user;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.selectedUser.userPhoneNumber]]];
    
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }else{
        return self.sectionHeadsKeys.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return self.searchResultArray.count;
    }else{
        if([[[self.allPersonArray objectAtIndex:section] objectForKey:@"isStretch"] isEqualToString:@"0"])
        {
            return 0;
        }else{
            return [[[self.allPersonArray objectAtIndex:section] objectForKey:@"allMembers"] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier1 = @"seacherCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            cell.separatorInset = UIEdgeInsetsZero;
            
            UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 12, 48, 48)];
            photoImageView.layer.cornerRadius = 5;
            photoImageView.clipsToBounds = YES;
            photoImageView.tag = 99;
            [cell.contentView addSubview:photoImageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 17, 196, 14)];
            nameLabel.font = [UIFont systemFontOfSize:17];
            nameLabel.tag = 100;
            [cell.contentView addSubview:nameLabel];
            
            
            UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 42, 189, 15)];
            departmentLabel.font = [UIFont systemFontOfSize:14];
            departmentLabel.textColor = [UIColor colorWithWhite:0.522 alpha:1.000];
            departmentLabel.tag = 101;
            [cell.contentView addSubview:departmentLabel];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(kDeviceWidth - 60, 12, 50, 50)];
            [button setImage:[UIImage imageNamed:@"contacts_iphone"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(makeaCall:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
        }
        
        YManagerUserInfoFileds *user = (YManagerUserInfoFileds *)[self.searchResultArray objectAtIndex:indexPath.row];
        
        UIImageView *photoImageView = (UIImageView *)[cell.contentView viewWithTag:99];
        photoImageView.layer.cornerRadius = 5;
        photoImageView.clipsToBounds = YES;
     [photoImageView setImageWithURL:[NSURL URLWithString:[user.userPhotoUrl stringByAppendingString:@"_small220190"]] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
        nameLabel.text = [NSString stringWithFormat:@"%@（%@）", user.userName, user.positionTitle];
        
        UILabel *departmentLabel = (UILabel *)[cell.contentView viewWithTag:101];
        departmentLabel.text = [user.userDepartmentName substringFromIndex:5];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"contactsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        YManagerUserInfoFileds *user = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"] objectAtIndex:indexPath.row];
        
        UIImageView *photoImageView = (UIImageView *)[cell.contentView viewWithTag:99];
        photoImageView.layer.cornerRadius = 5;
        photoImageView.clipsToBounds = YES;
        [photoImageView setImageWithURL:[NSURL URLWithString:[user.userPhotoUrl stringByAppendingString:@"_small220190"]] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];

        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
        nameLabel.text = [NSString stringWithFormat:@"%@（%@）", user.userName, user.positionTitle];
        
        UILabel *departmentLabel = (UILabel *)[cell.contentView viewWithTag:101];
        NSLog(@"%@",departmentLabel.text);
        departmentLabel.text = user.userDepartmentName;
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [_sectionHeadsKeys objectAtIndex:section];
}

//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.contactsTableView)
    {
        if (self.segmentedControl.selectedSegmentIndex == 0)//字母
        {
            return _sectionHeadsKeys;
            
        }else{
            
            return nil;
            
        }
        
    }else{
        return nil;
    }
}

#pragma mark - tableview delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toDetail"])
    {
        ContactsDetailViewController* viewController = segue.destinationViewController;
        viewController.user =  (YManagerUserInfoFileds *)sender;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    YManagerUserInfoFileds *user;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        user = (YManagerUserInfoFileds *)[self.searchResultArray objectAtIndex:indexPath.row];
    }else{
        user = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"] objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"toDetail" sender:user];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 50;
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 0;
    }else{
        if (self.segmentedControl.selectedSegmentIndex == 0)//字母
        {
            return 22;
        }else{ //组织架构
            return 46;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || [[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""])
    {
        return nil;
    }else{
        
        if (self.segmentedControl.selectedSegmentIndex == 0)//字母
        {
            //背景
            UIView *sectionHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
            sectionHeadBackgroundView.backgroundColor = [UIColor colorWithRed:0.941 green:0.957 blue:0.969 alpha:0.9];
            sectionHeadBackgroundView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
            
            //分割线
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
            [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
            [sectionHeadBackgroundView addSubview:line1];
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 21.5, kDeviceWidth, 0.5)];
            [line2 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
            [sectionHeadBackgroundView addSubview:line2];
            
            //文字
            UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5.5, 310, 12)];
            headLabel.backgroundColor = [UIColor clearColor];
            headLabel.font = [UIFont systemFontOfSize:17];
            headLabel.textColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
            headLabel.text = [self tableView:tableView titleForHeaderInSection:section];
            [sectionHeadBackgroundView addSubview:headLabel];
            
            return sectionHeadBackgroundView;
            
            
            
            
        }else{ //组织架构
            //背景
            UIView *sectionHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
            sectionHeadBackgroundView.backgroundColor = [UIColor colorWithRed:0.941 green:0.957 blue:0.969 alpha:0.9];
            sectionHeadBackgroundView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
            
            //分割线上
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
            [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
            [sectionHeadBackgroundView addSubview:line1];
            
            //分割线下
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, kDeviceWidth, 0.5)];
            [line2 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
            //[sectionHeadBackgroundView addSubview:line2];
            
            //图片
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 11, 11)];
            if([[[self.allPersonArray objectAtIndex:section] objectForKey:@"isStretch"]isEqualToString:@"0"])
            {
                [image setImage:[UIImage imageNamed:@"closeArrow"]];
            }else{
                [image setImage:[UIImage imageNamed:@"openArrow"]];
            }
            [image setContentMode:UIViewContentModeCenter];
            [sectionHeadBackgroundView addSubview:image];
            
            //文字
            UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 16, 287, 12)];
            headLabel.backgroundColor = [UIColor clearColor];
            headLabel.font = [UIFont systemFontOfSize:17];
            headLabel.textColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
            headLabel.text = [self tableView:tableView titleForHeaderInSection:section];
            [sectionHeadBackgroundView addSubview:headLabel];
            
            //触发方法
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(0, 0, kDeviceWidth, 46);
            
            button.tag = section;
            [button addTarget:self action:@selector(stretchList:) forControlEvents:UIControlEventTouchUpInside];
            [sectionHeadBackgroundView addSubview:button];
            
            return sectionHeadBackgroundView;
        }
    }
}

-(void)stretchList:(UIButton*)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 1)//组织架构
    {
        //NSLog(@"%d",sender.tag);
        if([[[self.allPersonArray objectAtIndex:sender.tag] objectForKey:@"isStretch"]isEqualToString:@"0"])
            [[self.allPersonArray objectAtIndex:sender.tag] setValue:@"1" forKey:@"isStretch"];
        else
            [[self.allPersonArray objectAtIndex:sender.tag] setValue:@"0" forKey:@"isStretch"];
        [self.contactsTableView reloadData];
    }
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //NSLog(@"%@",searchString);
    if (searchString.length > 0)
    {
        self.searchResultArray = [NSMutableArray arrayWithArray:[userDBM checkUserInfoByString:searchString]];
    }
    
    
    
//    if ( (searchString == nil) || (searchString.length == 0) )
//    {
//        [self.searchResultArray removeAllObjects];
//    }else{
//        NSArray *array = [userDBM findWithDepartmentID:nil SortbyGroup:NO withInfo:YES Status:NO withMe:NO];
//        
//        for (YManagerUserInfoFileds *userFiled in array)
//        {
//            NSRange nameRange = [userFiled.userName rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            if(nameRange.location != NSNotFound)
//            {
//                [self.searchResultArray addObject:userFiled];
//            }
//        }
//        NSLog(@"%@",self.searchResultArray);
//    }
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    //去掉多余的cell
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


@end
