//
//  ReportCheckBoxViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-16.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ReportCheckBoxViewController.h"
#import "YformFileds.h"

//#import "RTLabel.h"
#import "ReportCheckBoxCell.h"
#import "InformationReportCreatViewController.h"
#import "ILBarButtonItem.h"

@interface ReportCheckBoxViewController ()
{
    NSArray *array;//所有选项
    NSMutableArray *selectArray;//选择到的选项
}

- (IBAction)backToTop:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation ReportCheckBoxViewController

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
        array = [[NSArray alloc] init];
        selectArray = [[NSMutableArray alloc] init];
    }
    return self;
}


/**
 *  新建需求建议 页面
 */




- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
//    /* Left bar button item */
//    ILBarButtonItem *leftBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"backHome"]
//                                                   selectedImage:nil
//                                                          target:self
//                                                          action:@selector(backToTop:)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    //self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(backToTop:)];
    
    /* Right bar button item */
    ILBarButtonItem *rightBtn =
    [ILBarButtonItem barItemWithTitle:@"确定"
                           themeColor:[UIColor whiteColor]
                               target:self
                               action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
 
    NSString *str = _formFiled.formName;
    
    //self.title = [NSString stringWithFormat:@"%@",_formFiled.formName];
    self.title = [str substringToIndex:4];
    
    if (_formFiled.selectivity)
    {
        array = [_formFiled.selectivity componentsSeparatedByString:@"&&"];
        [self.tableView reloadData];
    }
    
    if (_reportCheckBoxCell.selectTextField.text.length != 0)
    {
        selectArray = [NSMutableArray arrayWithArray:[_reportCheckBoxCell.selectTextField.text componentsSeparatedByString:@","]];
    }
    
    if (selectArray.count > 0)
    {
//        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确定（%d）",selectArray.count];
        
        ILBarButtonItem *rightBtn =
        [ILBarButtonItem barItemWithTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)selectArray.count]
                               themeColor:[UIColor whiteColor]
                                   target:self
                                   action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigationbar item action

- (IBAction)backToTop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender
{
    NSString *selectLabelString = [selectArray componentsJoinedByString:@","];

    _reportCheckBoxCell.selectTextField.text = selectLabelString;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:selectLabelString, self.formFiled.formReferName, nil];

    [_informationReportCreatVC reportCheckBoxCell:_reportCheckBoxCell didEndEditingWithDictionary:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return array.count;
//    return self.allPersonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckBoxCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    UIImageView *imageView  = (UIImageView *)[cell.contentView viewWithTag:101];
    if ([selectArray containsObject:[array objectAtIndex:indexPath.row]])
    {
        imageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        imageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];
    }
    
    
    
    //RTLabel *label = (RTLabel *)[cell.contentView viewWithTag:100];
    //label.text = [NSString stringWithFormat:@"<font face='%@' size=14 color='#000000'>%@</font>",[UIFont systemFontOfSize:14].fontName, [array objectAtIndex:indexPath.row]];
    
    UILabel *lb = [cell.contentView viewWithTag:20004];
    lb.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:indexPath.row]];
    
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView  = (UIImageView *)[selectCell.contentView viewWithTag:101];
    imageView.image = [UIImage imageNamed:@"pickPerson_selected@2x"];
    
    if(![selectArray containsObject:[array objectAtIndex:indexPath.row]])
    {
        [selectArray addObject:[array objectAtIndex:indexPath.row]];
    }
    
    
    NSLog(@"%@",selectArray);

    if (selectArray.count == 0) {
        ILBarButtonItem *rightBtn =
        [ILBarButtonItem barItemWithTitle:@"确定"
                               themeColor:[UIColor whiteColor]
                                   target:self
                                   action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }else{
        ILBarButtonItem *rightBtn =
        [ILBarButtonItem barItemWithTitle:[NSString stringWithFormat:@"确定(%d)",selectArray.count]
                               themeColor:[UIColor whiteColor]
                                   target:self
                                   action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView  = (UIImageView *)[selectCell.contentView viewWithTag:101];
    imageView.image = [UIImage imageNamed:@"pickPerson_unselected@2x"];

    [selectArray removeObject:[array objectAtIndex:indexPath.row]];
    NSLog(@"%@",selectArray);
    
    if (selectArray.count == 0) {
        ILBarButtonItem *rightBtn =
        [ILBarButtonItem barItemWithTitle:@"确定"
                               themeColor:[UIColor whiteColor]
                                   target:self
                                   action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }else{
        ILBarButtonItem *rightBtn =
        [ILBarButtonItem barItemWithTitle:[NSString stringWithFormat:@"确定(%d)",selectArray.count]
                               themeColor:[UIColor whiteColor]
                                   target:self
                                   action:@selector(done:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
}



@end
