//
//  YWMyLibDocumentViewController.m
//  SalesManager
//
//  Created by TonySheng on 16/5/10.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWMyLibDocumentViewController.h"
#import "NavigationView.h"
#import "YWImgLibMyLibTableViewCell.h"
#import "YWDocuInterctionViewController.h"
//
#import "YWMovieListViewController.h"
#import "YWWordListViewController.h"
//
//test


@interface YWMyLibDocumentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_docuTableView;


}
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *docuArray;


@end

@implementation YWMyLibDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    NavigationView *naviView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    naviView.titleLabel.text = @"我的资料库";
    
    [naviView.titleLabel setCenter:CGPointMake(kDeviceWidth/2, naviView.titleLabel.frame.origin.y + naviView.titleLabel.frame.size.height/2 + 2)];
    
    [naviView.leftButton setFrame:CGRectMake(10, 20, 50, 44)];
    [naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    naviView.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [naviView.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [naviView.leftButton  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviView];
    self.view.backgroundColor = BGCOLOR;
    
    _docuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65,kDeviceWidth,KDeviceHeight - 65)];
    _docuTableView.backgroundColor = [UIColor clearColor];
    _docuTableView.dataSource = self;
    _docuTableView.delegate = self;
    _docuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_docuTableView];
    
    self.titleArray = @[@"文档库",@"视频库"];
    
    self.docuArray = @[@"aa.docx",@"我们都能幸福着 官方版--音悦Tai.mp4"];
    
}


#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *CellIdentifier = @"docu";
    YWImgLibMyLibTableViewCell *cell= [_docuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [_docuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YWImgLibMyLibTableViewCell" owner:self options:nil] lastObject];
    }
    cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        
    return cell;
        
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YWDocuInterctionViewController *docuInterVC = [[YWDocuInterctionViewController alloc] init];
//    docuInterVC.path = self.docuArray[indexPath.row];
//
//    
//    //[self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController pushViewController:docuInterVC animated:YES];
    
    
    
    if (indexPath.row == 1) {
        
        YWMovieListViewController *movieList = [YWMovieListViewController sharedMovieListViewController];
        
        
        [self.navigationController pushViewController:movieList animated:YES];
        
        
    }else {
    
        YWWordListViewController *wordList = [[YWWordListViewController alloc] init];
        [self.navigationController pushViewController:wordList animated:YES];
    
    
    }
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:.3f];
}

-(void)deselect{
    [_docuTableView deselectRowAtIndexPath:[_docuTableView indexPathForSelectedRow] animated:YES];
}



#pragma mark - event -
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
