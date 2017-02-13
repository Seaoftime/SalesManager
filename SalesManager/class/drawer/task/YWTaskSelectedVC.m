//
//  YWTaskSelectedVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-12.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWTaskSelectedVC.h"
#import "SelectCell.h"
#import "CellHeadView.h"
#import "ClickHeadCell.h"
@interface YWTaskSelectedVC ()

@end

@implementation YWTaskSelectedVC
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
	// Do any additional setup after loading the view.

    
    selectedIndex = -1;
    selectedIndexSection = -1;
    userDBM = [[YManagerUserInfoDBM alloc]init];
    
    self.searchResultArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.managerData = [[NSMutableArray alloc] initWithArray:[userDBM findWithDepartmentID:nil SortbyGroup:YES withInfo:YES Status:NO withMe:NO]];
    
   NSLog(@"dbdata%@",self.managerData);
    
    int xx =0; int yy =0;int zz =0;int managerNull = -1;
    for (int i = 0; i<[self.managerData count]; i++) {
        
        for(int j = 0;j<[[self.managerData objectAtIndex:i]count];j++)
        {
            YManagerUserInfoFileds* userInfo = [[self.managerData objectAtIndex:i]objectAtIndex:j];
            
           if([[NSString stringWithFormat:@"%li", (long)userInfo.userID] isEqualToString:userID])
           {
               zz = 1;
                xx =i; yy =j;
               NSLog(@"%i,%i",xx,yy);
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
            zz =0;
        }
        if([[self.managerData objectAtIndex:i]count]==0)
            managerNull = i;
    }
    
    if(managerNull >=0)
        [self.managerData removeObjectAtIndex:managerNull];
    for (int i = 0; i<[self.managerData count]; i++) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:[self.managerData objectAtIndex:i] forKey:@"allMembers"];
        [dic setValue: @"0" forKey:@"isStretch"];
        [self.managerData replaceObjectAtIndex:i withObject:dic];
    }
   // NSLog(@"replace:%@",self.managerData);
//    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(10, 20, 50, 44)];
//    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal ];
//    UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    self.navigationItem.titleView=[TOOL setTitleView:@"选择发送人"];
    
    self.view.backgroundColor = BGCOLOR;
    
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
    /**
     tableView
     */
    peopleTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-65) style:UITableViewStylePlain];
    
    //peopleTB.backgroundColor = [UIColor redColor];
    peopleTB.backgroundColor = [UIColor colorWithRed:240/255.f  green:245/255.f  blue:246/255.f alpha:1];
    
    peopleTB.tableHeaderView = mySearchBar;
    
      if(IS_IOS7)
    peopleTB.separatorInset = UIEdgeInsetsZero;
    peopleTB.dataSource = self;
    peopleTB.delegate = self;
    peopleTB.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:peopleTB];

}
#pragma mark -searchdelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                     // called when keyboard search button pressed
{
    [mySearchBar resignFirstResponder];
}
//cancel button clicked...
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
//        [self.searchResultArray removeAllObjects];
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
            NSLog(@"searchResultArray:%@",self.searchResultArray);
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

-(void)gotoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        return 1;
    }
        return [self.managerData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        return self.searchResultArray.count;
    }
    if([[[self.managerData objectAtIndex:section] objectForKey:@"isStretch"]isEqualToString:@"0"])
        return 0;
    else
            return [[[self.managerData objectAtIndex:section]objectForKey:@"allMembers"]count];
   
}
#if 1
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        return Nil;
    }
    return [[[[self.managerData objectAtIndex:section]objectForKey:@"allMembers"]objectAtIndex:0]objectForKey:@"part_name"];
   
}
#endif
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        return Nil;
    }
    ClickHeadCell *headView = [[ClickHeadCell alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    //headView.backgroundColor = [UIColor redColor];
    
    
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
    if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        return 0;
    }
            //return 46;
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        static  NSString *CellIdentifier = @"SelectCellID";
        
        SelectCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
        }
        if((selectedIndex == indexPath.row) &&(selectedIndexSection == indexPath.section))
        {
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
        }
        else
        {
            cell.simageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];
        }
        
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = LINECOLOR;
        cell.selectedBackgroundView = aView;
        if([[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"position"] == nil || [[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"position"]isEqualToString:@"(null)"])
        {
//
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"name"]];
            
        }else{
//
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"name"], [[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"position"]];
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.nameLabel.text];
            
            NSRange clorRange = NSMakeRange([[noteStr string] rangeOfString:@"("].location, [[noteStr string] rangeOfString:[NSString stringWithFormat:@"%@",[[self.searchResultArray objectAtIndex:indexPath.row] objectForKey:@"position"]]].length + 2);
            
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] range:clorRange];
            
            [cell.nameLabel setAttributedText:noteStr];
            //[cell.nameLabel sizeToFit];
            
        }
 
        return cell;

    }

        static  NSString *CellIdentifier = @"SelectCellID";
        SelectCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
        }
      if((selectedIndex == indexPath.row) &&(selectedIndexSection == indexPath.section))
      {
          cell.simageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
      }
    else
     {
         cell.simageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];
     }
        
    UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    
    aView.backgroundColor = LINECOLOR;
    //aView.backgroundColor = [UIColor redColor];
    
    
    cell.selectedBackgroundView = aView;
    if([[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"] == nil || [[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"]isEqualToString:@"(null)"])
    {
                
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"name"]];
        
        
        
    }else{
        
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"name"], [[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"]];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.nameLabel.text];
        
        NSRange clorRange = NSMakeRange([[noteStr string] rangeOfString:@"("].location, [[noteStr string] rangeOfString:[NSString stringWithFormat:@"%@",[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"position"]]].length + 2);
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0] range:clorRange];
        
        [cell.nameLabel setAttributedText:noteStr];
        //[cell.nameLabel sizeToFit];

    }

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     selectedIndex = (int)indexPath.row;
    selectedIndexSection = (int)indexPath.section;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if  (tableView == mySearchDisplayController.searchResultsTableView)
    {
        [dic setValue:[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"id"] forKey:@"id"];
        [dic setValue:[[self.searchResultArray objectAtIndex:indexPath.row]objectForKey:@"name"] forKey:@"name"];
        [mySearchDisplayController.searchResultsTableView reloadData];
    }
    else
    {
        [dic setValue:[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"id"] forKey:@"id"];
        [dic setValue:[[[[self.managerData objectAtIndex:indexPath.section]objectForKey:@"allMembers"]objectAtIndex:indexPath.row]objectForKey:@"name"] forKey:@"name"];
        [peopleTB reloadData];
    }
    if (delegate && [delegate respondsToSelector:@selector(selectTaskSendData:)]) {
        [delegate performSelector:@selector(selectTaskSendData:)withObject:dic];
    }
   [self.navigationController popViewControllerAnimated:YES];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 35.0;
    
    return 40;
}

@end
