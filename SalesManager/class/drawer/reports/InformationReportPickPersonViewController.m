//
//  InformationReportPickPersonViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "InformationReportPickPersonViewController.h"
//#import "RTLabel.h"
#import "UIImageView+AddSelect.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "InformationReportCreatViewController.h"
#import "ILBarButtonItem.h"

#define BUTTON_ENABLED_COLOR [UIColor colorWithRed:0.000 green:0.569 blue:1.000 alpha:1.000]
#define BUTTON_DISABLED_COLOR [UIColor colorWithRed:0.494 green:0.498 blue:0.498 alpha:1.000]

@interface InformationReportPickPersonViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate>
{
    YManagerUserInfoDBM *userDBM;
    YManagerUserInfoFileds *userFiled;
}

@property(nonatomic, strong) NSMutableArray *allPersonArray;       //显示
@property(nonatomic, strong) NSMutableArray *allPersonInOneArray;  //比对
@property(nonatomic, strong) NSMutableArray *searchResultArray;  //搜索结果


@property(strong, nonatomic) IBOutlet UITableView *peopleTableView;
@property(strong, nonatomic) IBOutlet UITableView *selectTableView;

@property(strong, nonatomic) IBOutlet UIButton *selectButton;

- (IBAction)backToTop:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation InformationReportPickPersonViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _selectPersonArray = [[NSMutableArray alloc] init];
        _allPersonArray = [[NSMutableArray alloc] init];
        _searchResultArray = [[NSMutableArray alloc] init];
        userDBM = [[YManagerUserInfoDBM alloc] init];
        userFiled = [[YManagerUserInfoFileds alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  
  
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
    self.allPersonArray = [[NSMutableArray alloc] initWithArray:[userDBM findWithDepartmentID:nil
                                                                                  SortbyGroup:YES
                                                                                     withInfo:NO
                                                                                       Status:NO
                                                                                       withMe:NO]];
    NSLog(@"%@", self.allPersonArray);
    
    NSMutableArray *tempArray = [self.allPersonArray copy];
    for (NSArray *object in tempArray) {
        if (object.count == 0) {
            [self.allPersonArray removeObject:object];
        }
    }
    
    NSLog(@"%@", self.allPersonArray);
    
    //针对数据折叠做的处理
    
    for (int i = 0; i<[self.allPersonArray count]; i++)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:[self.allPersonArray objectAtIndex:i] forKey:@"allMembers"];//人员信息
        [dic setValue: @"0" forKey:@"isStretch"];//是否展开
        [self.allPersonArray replaceObjectAtIndex:i withObject:dic];
    }
    
    NSLog(@"%@",self.allPersonArray);
    
    
    self.allPersonInOneArray = [[NSMutableArray alloc] initWithArray:[userDBM findWithDepartmentID:nil
                                                                                       SortbyGroup:NO
                                                                                          withInfo:NO
                                                                                            Status:NO
                                                                                            withMe:NO]];
    //NSLog(@"%@", self.allPersonInOneArray);
    
    if (_selectPersonArray.count > 0)
    {
        [self.selectButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)_selectPersonArray.count] forState:UIControlStateNormal];
        self.selectButton.enabled = YES;
        self.selectButton.backgroundColor = BUTTON_ENABLED_COLOR;
    }else{
        [self.selectButton setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
        self.selectButton.enabled = NO;
        self.selectButton.backgroundColor = BUTTON_DISABLED_COLOR;
    }
    
    //去掉多余的cell
    self.peopleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.peopleTableView.backgroundColor = BGCOLOR;
    
    //tableview逆时针旋转90度。
    self.selectTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    //self.selectTableView.center = CGPointMake(SCREENW/2 - 100, 25);
    
    
    self.selectTableView.center = CGPointMake(130, 25);
    
    if (kDeviceWidth > 700.000000) {
        [self.selectTableView setFrame:CGRectMake(self.selectTableView.frame.origin.x, self.selectTableView.frame.origin.y, kDeviceWidth - 200, self.selectTableView.frame.size.height)];
        
    }else if (kDeviceWidth > 320.000000 && kDeviceWidth < 500.000000 ){
    
        [self.selectTableView setFrame:CGRectMake(self.selectTableView.frame.origin.x, self.selectTableView.frame.origin.y, kDeviceWidth - 100, self.selectTableView.frame.size.height)];
    
    }
    
    
    //self.searchDisplayController.searchBar.backgroundColor = [UIColor lightGrayColor];
    
    
    //选择加边框
    self.selectButton.layer.cornerRadius = 5;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView == self.searchDisplayController.searchResultsTableView) || (tableView == self.peopleTableView))
    {
        UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[selectCell.contentView viewWithTag:101];
        imageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            userFiled = (YManagerUserInfoFileds *)[self.searchResultArray objectAtIndex:indexPath.row];
            
            if (![_selectPersonArray containsObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]]) {
                [_selectPersonArray addObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]];
            }
            
            NSLog(@"%@", _selectPersonArray);
        }else{
            userFiled = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"] objectAtIndex:indexPath.row];
            if (![_selectPersonArray containsObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]])
            {
                [_selectPersonArray addObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]];
            }
            NSLog(@"%@", _selectPersonArray);
        }
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            [self.searchDisplayController setActive:NO animated:YES];
        }
        
        UIImageView *imageView1 = (UIImageView *)[selectCell.contentView viewWithTag:102];
        imageView1.backgroundColor = [UIColor colorWithWhite:0.890 alpha:1.000];
        
        [self refreshSelectTableView];
        
        [self performSelector:@selector(cancleBackgroundColor:) withObject:imageView1 afterDelay:0.25];
    }else{
        [self.selectPersonArray removeObjectAtIndex:indexPath.row];
        [self.selectTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.peopleTableView reloadData];
        
        if (_selectPersonArray.count > 0) {
            [self.selectButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)_selectPersonArray.count] forState:UIControlStateNormal];
            self.selectButton.enabled = YES;
            self.selectButton.backgroundColor = BUTTON_ENABLED_COLOR;
        }else{
            [self.selectButton setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
            self.selectButton.enabled = NO;
            self.selectButton.backgroundColor = BUTTON_DISABLED_COLOR;
        }
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 46;
    }else if(tableView == self.peopleTableView){
        return 46;
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }else if(tableView == self.peopleTableView){
        return self.allPersonArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return self.searchResultArray.count;
    }else if(tableView == self.peopleTableView){
        if([[[self.allPersonArray objectAtIndex:section] objectForKey:@"isStretch"] isEqualToString:@"0"])
        {
            return 0;
        }else{
            return [[[self.allPersonArray objectAtIndex:section] objectForKey:@"allMembers"] count];
        }
    }else{
        return self.selectPersonArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"SearchPersonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 20, 20)];
            
            imageView.tag = 101;
            
            [cell.contentView addSubview:imageView];
            
            
            /**
             选择发送人
             
             - returns:
             */

            UILabel *labell = [[UILabel alloc] initWithFrame:CGRectMake(46, 13, 254, 16)];
            labell.tag = 1100;
            [cell.contentView addSubview:labell];
            
            
        }
        
        userFiled = (YManagerUserInfoFileds *)[self.searchResultArray objectAtIndex:indexPath.row];
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
        if ([_selectPersonArray containsObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]]) {
            imageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
        } else {
            imageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];
        }
        
        UILabel *lb = [cell.contentView viewWithTag:1100];
        
        if (lb == nil) {
            lb = (UILabel *)[cell viewWithTag:1100];
        }
        if (userFiled.positionTitle) {
            
            lb.text = [NSString stringWithFormat:@"%@ (%@)",userFiled.userName,userFiled.positionTitle];
//            UILabel *lbl = [[UILabel alloc] init];
//            lbl.text = lb.text;
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:lb.text];
            
            //NSRange clorRange = NSMakeRange(2, lb.text.length - 2);
            NSRange clorRange = NSMakeRange([[noteStr string] rangeOfString:@"("].location, [[noteStr string] rangeOfString:[NSString stringWithFormat:@"%@",userFiled.positionTitle]].length + 2);
            
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] range:clorRange];
            
            [lb setAttributedText:noteStr];
            [lb sizeToFit];
            
        } else {
            
            lb.text = [NSString stringWithFormat:@"%@",userFiled.userName];
            
        }
        
        return cell;
        
        
    }else if(tableView == self.peopleTableView){
        
        
        static NSString *CellIdentifier = @"PickPersonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
        // Configure the cell...
        
        
        userFiled = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"] objectAtIndex:indexPath.row];
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
        
        //[imageView setFrame:CGRectMake(imageView.frame.origin.x + 15, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
        
        
        
        if ([_selectPersonArray containsObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]])
        {
            imageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            
            imageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];
        }
        
        
        UILabel *lb = [cell.contentView viewWithTag:10001];
        UILabel *lb2 = [cell.contentView viewWithTag:10002];
        UILabel *lb3 = [cell.contentView viewWithTag:20004];
        
        /**
         *  选择发送人
         */
        UILabel *lb4 = [cell.contentView viewWithTag:1100];
        
        
        if (lb == nil && lb2 == nil && lb3 == nil && lb4 == nil) {
            
            lb = [cell.contentView viewWithTag:10001];
            
            lb2 = [cell.contentView viewWithTag:10002];
            
            lb3 = [cell.contentView viewWithTag:20004];
            
            lb4 = [cell.contentView viewWithTag:1100];
            
            
            
        }
        
        if (userFiled.positionTitle == nil || [userFiled.positionTitle isEqualToString:@"(null)"])
        {
//
            lb.text = [NSString stringWithFormat:@"%@",userFiled.userName];
            
            lb3.text = [NSString stringWithFormat:@"%@",userFiled.userName];
            
            lb4.text = [NSString stringWithFormat:@"%@",userFiled.userName];
            

            
        }else{
            
            lb.text = [NSString stringWithFormat:@"%@",userFiled.userName];
            
            lb2.text = [NSString stringWithFormat:@"%@",userFiled.positionTitle];

            lb3.text = [NSString stringWithFormat:@"%@",userFiled.userName];
            
            lb4.text = [NSString stringWithFormat:@"%@",userFiled.userName];
        }
        
        if (indexPath.row == [[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"]count]-1)
        {
            
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5f, kDeviceWidth, 0.5)];
            
            [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
            //[cell.contentView addSubview:line1];
        }
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"SelectPersonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // cell顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
        if (label == nil) {
            label = (UILabel *)[cell viewWithTag:100];
        }
        
        YManagerUserInfoFileds *tempUserFiled = [userDBM getPersonInfoByUserID:[[_selectPersonArray objectAtIndex:indexPath.row] integerValue] withPhotoUrl:NO withDepartment:NO withContacts:NO];
        label.text = tempUserFiled.userName;
        
        
        label.layer.cornerRadius = 5;
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        [label sizeToFit];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        CGRect frame = label.frame;
        frame.size.height = 26;
        if (frame.size.width < 50)
        {
            frame.size.width = 50;
        }
        label.frame = frame;
        
        [cell setFrame:CGRectMake(0, 0, 50, label.frame.size.width + 6)];
        
        return cell;
        
    }
}


- (void)refreshSelectTableView
{
    [self.selectTableView reloadData];
    if (_selectPersonArray.count > 0)
    {
        [self.selectButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)_selectPersonArray.count] forState:UIControlStateNormal];
        self.selectButton.enabled = YES;
        self.selectButton.backgroundColor = BUTTON_ENABLED_COLOR;
    }else{
        [self.selectButton setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
        self.selectButton.enabled = NO;
        self.selectButton.backgroundColor = BUTTON_DISABLED_COLOR;
    }
    
    if (_selectPersonArray.count > 3) {
        
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:_selectPersonArray.count-1 inSection:0];
        [self.selectTableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];

    }
//    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:_selectPersonArray.count-1 inSection:0];
//    [self.selectTableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
}

- (void)cancleBackgroundColor:(UIImageView *)imageView
{
    imageView.backgroundColor = [UIColor clearColor];
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //背景
    UIView *sectionHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 46)];
    sectionHeadBackgroundView.backgroundColor = [UIColor colorWithRed:0.941 green:0.957 blue:0.969 alpha:0.9];
    sectionHeadBackgroundView.layer.borderColor = [UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1].CGColor;
    
    //    //分割线上
    //    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    //    [line1 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    //    [sectionHeadBackgroundView addSubview:line1];
    
    //分割线下
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, kDeviceWidth, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]];
    [sectionHeadBackgroundView addSubview:line2];
    
    //图片
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 11, 11)];
    if([[[self.allPersonArray objectAtIndex:section] objectForKey:@"isStretch"]isEqualToString:@"0"])
    {
        [image setImage:[UIImage imageNamed:@"closeArrow"]];
    }else{
        [image setImage:[UIImage imageNamed:@"openArrow"]];
    }
    [image setContentMode:UIViewContentModeCenter];
    [sectionHeadBackgroundView addSubview:image];
    
    //文字
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 18, 287, 12)];
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



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView == self.searchDisplayController.searchResultsTableView) || (tableView == self.peopleTableView))
    {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        //
        UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[selectCell.contentView viewWithTag:101];
        imageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            userFiled = (YManagerUserInfoFileds *)[self.searchResultArray objectAtIndex:indexPath.row];
            [_selectPersonArray removeObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]];
            NSLog(@"%@", _selectPersonArray);
        } else {
            
            
            userFiled = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:indexPath.section] objectForKey:@"allMembers"] objectAtIndex:indexPath.row];
            [_selectPersonArray removeObject:[NSString stringWithFormat:@"%ld", (long)userFiled.userID]];
//            NSLog(@"%@", _selectPersonArray);
            
            
        }
        
        UIImageView *imageView1 = (UIImageView *)[selectCell.contentView viewWithTag:102];
        imageView1.backgroundColor = [UIColor colorWithWhite:0.890 alpha:1.000];
        
        [self refreshSelectTableView];
        
        [self performSelector:@selector(cancleBackgroundColor:) withObject:imageView1 afterDelay:0.25];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    userFiled = (YManagerUserInfoFileds *)[[[self.allPersonArray objectAtIndex:section] objectForKey:@"allMembers"] objectAtIndex:0];
    return userFiled.userDepartmentName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 0;
    }else if(tableView == self.peopleTableView){
        return 46;
    }else{
        return 0;
    }
}


-(void)stretchList:(UIButton*)sender
{
    //NSLog(@"%d",sender.tag);
    if([[[self.allPersonArray objectAtIndex:sender.tag] objectForKey:@"isStretch"]isEqualToString:@"0"])
        [[self.allPersonArray objectAtIndex:sender.tag] setValue:@"1" forKey:@"isStretch"];
    else
        [[self.allPersonArray objectAtIndex:sender.tag] setValue:@"0" forKey:@"isStretch"];
    [self.peopleTableView reloadData];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.allowsMultipleSelection = YES;
    if (IS_IOS7) tableView.separatorInset = UIEdgeInsetsZero;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //NSLog(@"%@",searchString);
    if (searchString.length > 0)
    {
        self.searchResultArray = [NSMutableArray arrayWithArray:[userDBM checkUserInfoByString:searchString]];
        
//        if (self.searchResultArray.count == 0) {
//            self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        }
        
        
        
    }
    
//    if ((searchString == nil) || (searchString.length == 0)) {
//        [self.searchResultArray removeAllObjects];
//    } else {
//        for (YManagerUserInfoFileds *object in self.allPersonInOneArray)
//        {
//            NSLog(@"%@", object.userName);
//            NSRange nameRange = [object.userName rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            if (nameRange.location != NSNotFound) {
//                if (![self.searchResultArray containsObject:object]) {
//                    [self.searchResultArray addObject:object];
//                }
//            }
//        }
//    }
//    
    NSLog(@"%@", self.searchResultArray);
    
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_peopleTableView reloadData];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)backToTop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender
{
    NSLog(@"%@", self.navigationController.viewControllers);
    
    InformationReportCreatViewController *createVC = [self.navigationController.viewControllers objectAtIndex:1];
    createVC.selectPersonArray = _selectPersonArray;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
