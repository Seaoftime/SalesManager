//
//  YWPicInAlbumVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-2.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWPicInAlbumVC.h"
#import "PhotoCell.h"
//#import "AFJSONRequestOperation.h"

#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "YWSeePictureVC.h"
#import "NavigationView.h"

#import "MJRefresh.h"

@interface YWPicInAlbumVC ()
{

    BOOL _end;

}
@end

@implementation YWPicInAlbumVC

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
    self.navigationController.navigationBarHidden = YES;
    pictureDB = [[YPicturesDBM alloc]init];
    
    NavigationView *naviView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    naviView.titleLabel.text = self.albumTitle;
    
    
    [naviView.titleLabel setCenter:CGPointMake(kDeviceWidth/2, naviView.titleLabel.frame.origin.y + naviView.titleLabel.frame.size.height/2 + 2)];
    
        [naviView.leftButton setFrame:CGRectMake(10, 20, 50, 44)];
    [naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    naviView.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [naviView.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [naviView.leftButton  addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviView];
    self.view.backgroundColor = BGCOLOR;
    
    self.photoListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, KDeviceHeight - 64)];
    self.photoListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.photoListTable.backgroundColor = [UIColor clearColor];
    self.photoListTable.dataSource = self;
    self.photoListTable.delegate = self;
    [self.view addSubview:self.photoListTable];
    
   [self createRefreshView];

    //[self refreshView];
    
    if (isNetWork && [_photoList count] != _photoCount)
    //[photoListTable launchRefreshing];
        [self.photoListTable.mj_header beginRefreshing];
    
}


- (void)createRefreshView
{
    
    self.photoListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _dataCount = 0;
        
        [self getphotoData];
        
        
    }];
    
    self.photoListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _dataCount ++;
        
        [self getphotoData];
        
    }];
    
}









-(void)refreshView{
    _photoList = [NSMutableArray arrayWithArray:[pictureDB findWithAlbumID:self.albumID limit:1000]];
    [self.photoListTable reloadData];
    
    if (![_photoList count]) {
        [self noContent:YES];
    }else{
        [self noContent:NO];
    }
}


-(void)gotoback
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getphotoData
{

    if (isNetWork) {
        
        [[YWNetRequest sharedInstance] requestPicInAlbumWithAlbumId:(int)self.albumID WithSuccess:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 70200) {

                [self savePhotoList:(NSDictionary* )respondsData];
                
                if (_dataCount == 0) {
                    
                    [self.photoListTable.mj_header endRefreshing];
                    
                    if (_end) {
                        [self.photoListTable.mj_footer endRefreshing];
                        [self.photoListTable.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        
                        [self.photoListTable.mj_footer endRefreshing];
                    }
                    
                    
                }else if(_dataCount > 0) {
                    
                    if (_end) {
                        [self.photoListTable.mj_footer endRefreshing];
                        [self.photoListTable.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        
                        [self.photoListTable.mj_footer endRefreshing];
                    }
                    
                }

                

            }else if([[respondsData objectForKey:@"code"] integerValue] == 70201){
                
                [self.photoListTable.mj_header endRefreshing];
                [self.photoListTable.mj_footer endRefreshing];
                
                
            }else{
                [self checkCodeByJson:respondsData];
            }
            
        } failed:^(NSError *error) {
            //
            [self.photoListTable.mj_header endRefreshing];
            [self.photoListTable.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"数据请求失败"];
        }];
        
    }else{
        
        //[photoListTable tableViewDidFinishedLoading];
        [self.photoListTable.mj_footer endRefreshing];
        [self.photoListTable.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD showErrorWithStatus:@"无网络"];
        
    }
   }

-(void)savePhotoList:(NSDictionary* )photoDic{
    
     [pictureDB cleanAlbum:_albumID];
    
//     BOOL end;
    
    YPcituresFileds* picture = [[YPcituresFileds alloc]init];
    picture.albumTitle = [[photoDic objectForKey:@"list_info"] objectForKey:@"title"];
    picture.albumPhotoNumbers = [[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list"]count];
    picture.albumCoverUrl =[NSString stringWithFormat:@"%@%@", @"http://yunpic.feesun.com",[[photoDic objectForKey:@"list_info"]objectForKey:@"cover"]];
    picture.albumContetn = [[photoDic objectForKey:@"list_info"] objectForKey:@"content"];
    picture.localAlbumID = self.albumID;
    [pictureDB saveAlbumOrPhotos:picture isPicture:NO];
    NSEnumerator * enumeratorKey = [[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list"] keyEnumerator];
    int i = 0;
    for (NSObject* photoID in enumeratorKey) {
        i++;
            YPcituresFileds* pictures = [YPcituresFileds new];
//            pictures.photoTitle = [[[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list" ] objectForKey:photoID]objectForKey:@"title"];
            pictures.photoUrl =  [[[[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list" ] objectForKey:photoID]objectForKey:@"photourl"]stringByAppendingString:@"_small220190"];
            pictures.phtotBigPhotoUrl = [[[[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list" ] objectForKey:photoID]objectForKey:@"photourl"]stringByAppendingString:@"_bigimage"];

            pictures.photoID= [[[[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list" ] objectForKey:photoID]objectForKey:@"photoid"] integerValue];
            pictures.photoContent = [[[[photoDic objectForKey:@"list_info"]objectForKey:@"photo_list" ] objectForKey:photoID]objectForKey:@"content"];
            pictures.albumID = self.albumID;
            
            [pictureDB saveAlbumOrPhotos:pictures isPicture:YES];
            
        
        
    }
    _end = i<1000?YES:NO;

    //[photoListTable tableViewDidFinishedLoading];
    //photoListTable.reachedTheEnd = end;
    
    [self refreshView];
}



#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.photoList count]+2)/3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *CellIdentifier = @"PhotoCellID";
    PhotoCell *cell= [self.photoListTable dequeueReusableCellWithIdentifier:CellIdentifier];
    [self.photoListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil] lastObject];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0 ) {
        
        [cell.contentView addSubview:cell.photoImage1];
        [cell.contentView addSubview:cell.photoImage2];
        [cell.contentView addSubview:cell.photoImage3];
    }
//    if(IS_IOS7)
//    {
//     [cell.contentView addSubview:cell.photoImage1];
//     [cell.contentView addSubview:cell.photoImage2];
//     [cell.contentView addSubview:cell.photoImage3];
//    }

    YPcituresFileds* picInfo = [self.photoList objectAtIndex:indexPath.row*3];
    [cell.photoImage1 setImageWithURL:[NSURL URLWithString:picInfo.photoUrl]placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
    cell.photoImage1.tag =indexPath.row*3;
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPic:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [cell.photoImage1 addGestureRecognizer:singleFingerOne];
    
    if (([self.photoList count]+2)/3 == (indexPath.row+1))//最后一行
    {
        NSLog(@"%lu",(unsigned long)[self.photoList count]);
        if((indexPath.row*3+2)>[self.photoList count])//最后一行只有1个图片 4
        {
        }
        else if ((indexPath.row*3+3)>[self.photoList count])//最后一行只有2个图片
        {
            picInfo = [self.photoList objectAtIndex:indexPath.row*3+1];
            [cell.photoImage2 setImageWithURL:[NSURL URLWithString:picInfo.photoUrl]placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
            cell.photoImage2.tag =indexPath.row*3+1;
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPic:)];
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            [cell.photoImage2 addGestureRecognizer:singleFingerOne];
        }
        else//最后一行只有3个图片
        {
            picInfo = [self.photoList objectAtIndex:indexPath.row*3+1];
            [cell.photoImage2 setImageWithURL:[NSURL URLWithString:picInfo.photoUrl]placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
            cell.photoImage2.tag =indexPath.row*3+1;
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPic:)];
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            [cell.photoImage2 addGestureRecognizer:singleFingerOne];
            picInfo = [self.photoList objectAtIndex:indexPath.row*3+2];
            [cell.photoImage3 setImageWithURL:[NSURL URLWithString:picInfo.photoUrl]placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
            cell.photoImage3.tag =indexPath.row*3+2;
            UITapGestureRecognizer *singleFingerOne1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPic:)];
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            [cell.photoImage3 addGestureRecognizer:singleFingerOne1];        }
    }
    else
    {
        picInfo = [self.photoList objectAtIndex:indexPath.row*3+1];
        [cell.photoImage2 setImageWithURL:[NSURL URLWithString:picInfo.photoUrl]placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
        cell.photoImage2.tag =indexPath.row*3+1;
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPic:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [cell.photoImage2 addGestureRecognizer:singleFingerOne];
        
        picInfo = [self.photoList objectAtIndex:indexPath.row*3+2];
        [cell.photoImage3 setImageWithURL:[NSURL URLWithString:picInfo.photoUrl] placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
        cell.photoImage3.tag =indexPath.row*3+2;
        UITapGestureRecognizer *singleFingerOne1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPic:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [cell.photoImage3 addGestureRecognizer:singleFingerOne1];
    }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kDeviceWidth > 700.000000) {
        //
        return 154;
    }
    
    return 104.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
}

-(void)seeBigPic:(UIPanGestureRecognizer* )recognizer
{
    NSLog(@"tag:%ld",(long)recognizer.view.tag);
    YWSeePictureVC *vc = [[YWSeePictureVC alloc] init];
   vc.currentPic = (int)recognizer.view.tag + 1;
    vc.photosInfo = self.photoList;
    vc.albumTitle = self.albumTitle;
     vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentViewController:vc animated:YES completion:nil];
    
    if ((([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)) && (([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0))) {
        [self presentViewController:vc animated:YES completion:nil];
    }else {
    
        [self.navigationController setNavigationBarHidden:YES];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        //[self.navigationController setNavigationBarHidden:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
//    [self.navigationController setNavigationBarHidden:YES];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    //[self.navigationController setNavigationBarHidden:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)noContent:(BOOL)YN
{
    UIImageView* hold = (UIImageView* )[self.photoListTable viewWithTag:2077];
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
                    y = 85;
                }else{
                    y = 55;
                }
                
                hold.center = CGPointMake(self.view.center.x, self.view.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                [self.photoListTable addSubview:hold];
            }
        }
    }

    
}



@end


















