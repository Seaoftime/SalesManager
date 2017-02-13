//
//  SetReportsVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SetReportsVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
#import "YWAddReportsVC.h"
@interface SetReportsVC ()

@end

@implementation SetReportsVC
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
    [self getReportData];
    [self.defineReportsTb reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // self.defineReportsData = [[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor = BGCOLOR;
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    [rightButton setTitle:@"新建" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(newReport) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    
    UILabel *titleText = [TOOL setTitleView:@"自定义快捷回复"];
    self.navigationItem.titleView=titleText;
    
    [self getReportData];
    self.defineReportsTb = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kDeviceWidth, (KDeviceHeight-10))];
    self.defineReportsTb.backgroundColor = [UIColor clearColor];
    self.defineReportsTb.dataSource = self;
    self.defineReportsTb.delegate = self;
    [self.view addSubview:self.defineReportsTb];
    
    addBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    if(!IS_IOS7)
        addBgView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    addBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    addBgView.userInteractionEnabled =YES;
    addTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300, 100)];
    //addTextView.layer.borderColor = [NAVIGATIONCOLOR CGColor];
    addTextView.layer.borderWidth = 0.5;
    addTextView.layer.cornerRadius = 5.0;
    addTextView.font = [UIFont systemFontOfSize:14.0];
    addTextView.layer.borderColor = [BORDERCOLOR CGColor];
    holderLabel = [[UILabel alloc]initWithFrame:CGRectMake(4,8, 280, 15)];
    holderLabel.backgroundColor = [UIColor clearColor];
    holderLabel.font = [UIFont systemFontOfSize:14.0];
    holderLabel.textColor = LINECOLOR;
    holderLabel.text = @"输入新的回复语";
    [addTextView addSubview:holderLabel];
    addTextView.delegate = self;
    [addBgView addSubview:addTextView];
    [self.view addSubview:addBgView];
    addBgView.hidden = YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        holderLabel.text = @"输入新的回复语";
    }else{
        holderLabel.text = @"";
    }
    
    
    
    
   

}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (addTextView == textView)
    {
        if ([aString length] > 20) {
            textView.text = [aString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"超过最大字数不能输入了"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        
    }
    return YES;
}

-(void)getReportData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString*filePath = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [TOOL createFileWithName:@"tYWdefinedReport.plist"];
    }
    //self.defineReportsData =[NSMutableArray arrayWithContentsOfFile:filePath];
    self.defineReportsData = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
    //NSLog(@"%@",self.defineReportsData);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [addTextView resignFirstResponder];
}
-(void)gotoback
{
    if(addBgView.hidden == NO)
    {
        addBgView.hidden = YES;
        [addTextView resignFirstResponder];
        [rightButton setFrame:CGRectMake(240, 20, 20, 19)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"additem.png"] forState:UIControlStateNormal];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)newReport
{
#if 0
    if(addBgView.hidden == YES)
    {
        addBgView.hidden = NO;
        addTextView.text = @"";
        holderLabel.text = @"输入新的回复语";
        [rightButton setFrame:CGRectMake(240, 20, 20, 14)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"creatReport_done.png"] forState:UIControlStateNormal];
    }
    else
    {
        addBgView.hidden = YES;
        [addTextView resignFirstResponder];
        [rightButton setFrame:CGRectMake(240, 20, 20, 19)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"additem.png"] forState:UIControlStateNormal];
        if(![addTextView.text isEqualToString:@""])
        {
            [self.defineReportsData insertObject:[NSString stringWithFormat:@"%@", addTextView.text]atIndex:0];
            NSString *file = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
            [self.defineReportsData writeToFile:file atomically:YES];
            NSLog(@"define:%@",self.defineReportsData);
            [self.defineReportsTb reloadData];
        }
    }
#endif
    YWAddReportsVC *vc = [[YWAddReportsVC alloc]init];
    vc.prepareAdd = YES;

    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.defineReportsData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = @"DefineReportCellID";
    DefineReportCell *cell= [self.defineReportsTb dequeueReusableCellWithIdentifier:CellIdentifier];
    [self.defineReportsTb setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DefineReportCell" owner:self options:nil] lastObject];
    }
    //
    //cell.contentView.userInteractionEnabled = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.defineLab.text =[self.defineReportsData objectAtIndex:indexPath.row];
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteReport:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  51.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWAddReportsVC *vc = [[YWAddReportsVC alloc]init];
    vc.prepareAdd = NO;
    vc.atIndex = (int)indexPath.row;
    vc.prepareEditString = [self.defineReportsData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteReport:(UIButton*)sender
{
    UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"确定要删除自定义回复"
                                                  message:Nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
    [avv show];
    willDelecteRow = (int)sender.tag;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    if(buttonIndex == 1)
    {
        [self.defineReportsData removeObjectAtIndex:willDelecteRow];
        NSString *file = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
        [self.defineReportsData writeToFile:file atomically:YES];
        [self.defineReportsTb reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
