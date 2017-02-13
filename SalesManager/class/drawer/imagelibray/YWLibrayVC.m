//
//  YWLibrayVC.m
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWLibrayVC.h"
#import "UIViewController+MMDrawerController.h"
#import "NavigationView.h"
#import "AlbumCell.h"
//#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "TOOL.h"
#import "YWPicInAlbumVC.h"
#import "NavigationView.h"
#import "SDImageCache.h"
#import "JDStatusBarNotification.h"
#import "MJRefresh.h"
#import "YWImgLibMyLibTableViewCell.h"
#import "YWMyLibDocumentViewController.h"

@interface YWLibrayVC (){


    BOOL _end;
    BOOL _save;
}




@end

@implementation YWLibrayVC

int const pictureCodeID = 4;

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
    pictureDB = [[YPicturesDBM    alloc]init];
    
    self.view.backgroundColor = BGCOLOR;
    //    self.allPhotoURLs = [[NSMutableArray alloc]initWithCapacity:0];
    finishedPicNum = 0;
    failedPicNum  = 0;
    self.navigationController.navigationBarHidden = YES;
    
    naviView = [[NavigationView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    
    naviView.titleLabel.text = @"企业图库";
    naviView.titleLabel.frame = CGRectMake(kDeviceWidth/2 - 50, 15, 100, 64 - 10);
    
    [naviView.leftButton  addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView.leftButton setFrame:CGRectMake(10, 20, 50, 44)];
    [naviView.leftButton setTitle:@"首页" forState:UIControlStateNormal];
    naviView.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [naviView.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [naviView.rightBtton setFrame:CGRectMake(kDeviceWidth - 120, 10, 120, 64)];
    
    [naviView.rightBtton  setTitle:@"同步下载"  forState:UIControlStateNormal];
    naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.rightBtton  addTarget:self action:@selector(downloadPicUrls) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:naviView];
    
    downloadView = [[DownLoadProgressView alloc]initWithFrame:CGRectMake(kDeviceWidth - 70, 35, 60, 20)];
    //downloadView.backgroundColor = [UIColor redColor];
    [self.view addSubview:downloadView];
    downloadView.hidden = YES;
    
    //
    _albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65,kDeviceWidth,KDeviceHeight - 65)];
    _albumTableView.backgroundColor = [UIColor clearColor];
    _albumTableView.dataSource = self;
    _albumTableView.delegate = self;
    _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_albumTableView];
    
    _save = NO;
    
    [self createRefreshView];
    
    
    
    if (![_albumList count]||self.fromPush||self.fromHomepage) {
        [self getalbumData:NO];
    }
    
}

- (void)createRefreshView
{
    
    _albumTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        _dataCount = 0;
        if (_save == NO) {
            [self getalbumData:NO];
        }else {
        
            [self refreshtable];
        
        }
        
    }];
    
    
//    albumTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        _dataCount ++;
//        [self getalbumData:NO];
//        
//        [self refreshtable];
//        
//        [albumTableView.footer endRefreshing];
//        [albumTableView.footer endRefreshingWithNoMoreData];
//    }];
    
    
    _albumTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    _albumTableView.mj_footer.hidden = NO;
    
    
}

- (void)loadMoreData
{
    _dataCount ++;
    
    if (_save == NO) {
        [self getalbumData:NO];
    }else {
        
        [self refreshtable];
        
    }
    
    //[self getalbumData:NO];
    
    //[self refreshTable];
    
}




-(void)viewWillAppear:(BOOL)animated{
    if (isNetWork)
        if ([TOOL getKey:pictureCodeID])
            [_albumTableView.mj_header beginRefreshing];
    
    
}



-(void)refreshtable{
    
    self.albumList = [NSMutableArray arrayWithArray:[pictureDB findWithautoIncremenID:nil limit:NUMBEROFONEPAGE]];
    [_albumTableView reloadData];
    [_albumTableView.mj_header endRefreshing];
    NSLog(@"%@",self.albumList);
    if (self.albumList.count == 0) {
        [self noContent:YES];
    }else {
        
        [self noContent:NO];
    }

    
}

#pragma mark -left&rightbutton
-(void)downloadPicUrls
{
        if([TOOL IsEnableWIFI])
            [self getalbumData:YES];
        else
        {
            UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"当前不是wifi环境,下载可能会消耗大量流量,确定要下载?"
                                                          message:Nil
                                                         delegate:self
                                                cancelButtonTitle:@"暂不下载" otherButtonTitles:@"下载",nil];
            [avv show];
        }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    if(buttonIndex == 1)
    {
        [self getalbumData:YES];
    }
}

-(void)beginDownloadPicUrls:(BOOL)downLoad
{
    if(downLoad)
    {
        naviView.rightBtton.hidden = YES;
        downloadView.hidden = NO;
    }
    else
    {
        naviView.rightBtton.hidden = NO;
        downloadView.hidden = YES;
    }
    
    [[YWNetRequest sharedInstance] requestDownloadPicsWithSuccess:^(id respondsData) {
        //
        [self getAllPhotos:(NSDictionary* )respondsData :downLoad];

        
    } failed:^(NSError *error) {
        //
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"图库数据更新失败"
                                                    message:[NSString stringWithFormat:@"%@",error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [av show];
        
    }];

}


-(void)getAllPhotos:(NSDictionary* )photosDic :(BOOL)download{
    
    if([[photosDic  objectForKey:@"code"]integerValue] == 70200){
        
        NSEnumerator * enumeratorKey = [[photosDic objectForKey:@"photo_info"]keyEnumerator];
        
        for (NSObject* photoID in enumeratorKey) {
            //                        [array addObject:albumID];
            
            YPcituresFileds* pictures = [YPcituresFileds new];
            
            
            
            pictures.photoTitle = [[[photosDic objectForKey:@"photo_info"]objectForKey:photoID] objectForKey:@"title"];
            pictures.photoContent = [[[photosDic objectForKey:@"photo_info"]objectForKey:photoID]objectForKey:@"content"];
            pictures.photoUrl = [[[[photosDic objectForKey:@"photo_info"]objectForKey:photoID]objectForKey:@"photourl"]stringByAppendingString:@"_small220190"];
            pictures.phtotBigPhotoUrl = [[[[photosDic objectForKey:@"photo_info"]objectForKey:photoID]objectForKey:@"photourl"]stringByAppendingString:@"_bigimage"];
            pictures.photoID = [[NSString stringWithFormat:@"%@",photoID] integerValue];
            
            pictures.albumID = [[[[photosDic objectForKey:@"photo_info"]objectForKey:photoID]objectForKey:@"albumid"] integerValue];
            
            [pictureDB saveAlbumOrPhotos:pictures isPicture:YES];
            
            
        }
        
        // [self startDonwLoadingSmallPhotos];
        if (download)
        {
            [self performSelectorOnMainThread:@selector(startDonwLoadingPhotos) withObject:nil waitUntilDone:YES];
            //           [self startDonwLoadingSmallPhotos];
            [self performSelectorOnMainThread:@selector(startDonwLoadingSmallPhotos) withObject:nil waitUntilDone:YES];
        }
        else{
            [self refreshtable];
            //[albumTable tableViewDidFinishedLoading];
            //albumTable.reachedTheEnd = YES;
        }
        
    }else if([[photosDic  objectForKey:@"code"]integerValue] == 70201){
        [SVProgressHUD showSuccessWithStatus:@"操作完成"];
        
    }else{
        [self checkCodeByJson:photosDic];
        
    }
}

-(void)startDonwLoadingSmallPhotos
{
    
    
    NSArray* photosArray = [pictureDB findWithAllPhotos:Nil limit:2000];
    
    for(int i = 0; i < photosArray.count;i++)
    {
        YPcituresFileds* picInfo = [photosArray objectAtIndex:i];
        NSString *ccmd5Path = [TOOL convertCCMD5Path:picInfo.photoUrl];
        NSLog(@"pic savepath:%@",ccmd5Path);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:ccmd5Path]) { //检查对应url的图片是否已经存在，如果不存在，下载
            NSURL *URL = [NSURL URLWithString:picInfo.photoUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.outputStream = [NSOutputStream outputStreamToFileAtPath:ccmd5Path append:NO];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [[NSOperationQueue mainQueue] setMaxConcurrentOperationCount:1];
            [[NSOperationQueue mainQueue] addOperation:op];
        }
        else
        {
        }
    }
}

-(void)startDonwLoadingPhotos{
    
    SDImageCache* ds = [SDImageCache sharedImageCache];
    [ds cleanDisk];
    [ds clearMemory];
    [ds clearDisk ];

    
    //  [SVProgressHUD showSuccessWithStatus:@"图库数据更新完成，请求图片信息!"];
    NSArray* photosArray = [pictureDB findWithAllPhotos:Nil limit:2000];
    for(int i = 0; i < photosArray.count;i++)
    {
        YPcituresFileds* picInfo = [photosArray objectAtIndex:i];
        NSString *ccmd5Path = [TOOL convertCCMD5Path:picInfo.phtotBigPhotoUrl];
        NSLog(@"pic savepath:%@",ccmd5Path);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:ccmd5Path]) { //检查对应url的图片是否已经存在，如果不存在，下载
            
            NSURL *URL = [NSURL URLWithString:picInfo.phtotBigPhotoUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.outputStream = [NSOutputStream outputStreamToFileAtPath:ccmd5Path append:NO];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                finishedPicNum++;
                NSLog(@"%i--SUCESS PICURL:%@",i,picInfo.phtotBigPhotoUrl);
                if((i+1) == [photosArray count])
                {
                    [self performSelector:@selector(downLoadAllPhotoFinished) withObject:self afterDelay:.5f];
                }
                downloadView.progressView.progress = ((float)finishedPicNum)/([photosArray count]);
                downloadView.progressLabel.text = [NSString stringWithFormat:@"%i/%lu",finishedPicNum,(unsigned long)photosArray.count];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failedPicNum++;
                NSFileManager * defaultManager = [NSFileManager defaultManager];
                [defaultManager removeItemAtPath:ccmd5Path error:nil];
                
                NSLog(@"%i--FAIL PICURL:%@",i,picInfo.phtotBigPhotoUrl);
                if((i+1) == [photosArray count])
                    [self performSelector:@selector(downLoadAllPhotoFinished) withObject:self afterDelay:.5f];
                else
                    ;
                // [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"第%i张下载失败，图片下载失败%i张",i,failedPicNum]];
            }];
            [[NSOperationQueue mainQueue] addOperation:op];
            
            
            
        }
        else
        {
            finishedPicNum ++;
            if((i+1) == [photosArray count])
            {
                [self performSelector:@selector(downLoadAllPhotoFinished) withObject:self afterDelay:.5f];
            }else
                ;
        }
        downloadView.progressView.progress = ((float)finishedPicNum)/([photosArray count]);
        downloadView.progressLabel.text = [NSString stringWithFormat:@"%i/%lu",finishedPicNum,(unsigned long)[photosArray count]];
    }
}


-(void)downLoadAllPhotoFinished{
    NSArray* photosArray = [pictureDB findWithAllPhotos:Nil limit:2000];
    if(failedPicNum==0)
        [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"图片下载完成(%i/%lu)",finishedPicNum,(unsigned long)[photosArray count]] dismissAfter:3.f styleName:JDStatusBarStyleYWheaderStyel];
    else
        [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"图片下载完成(%i/%lu),失败%i",finishedPicNum,(unsigned long)[photosArray count],failedPicNum] dismissAfter:3.f styleName:JDStatusBarStyleYWheaderStyel];
    
    downloadView.hidden = YES;
    naviView.rightBtton.hidden = NO;
    [naviView.rightBtton setTitle: [NSString stringWithFormat:@"已同步%i/%lu",finishedPicNum,(unsigned long)[photosArray count]] forState:UIControlStateNormal];
    //
    //naviView.rightBtton.enabled = NO;
    
    
    naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    NSLog(@"s:%i,f:%i,t:%lu",finishedPicNum,failedPicNum,(unsigned long)[photosArray count]);
    finishedPicNum = 0;
    failedPicNum = 0;
}

-(void)gotoback
{
    if(self.fromPush)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.fromHomepage)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.mm_drawerController setCenterViewController: self.homeNavi
                                       withCloseAnimation:NO completion:nil];
        //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        
        return 1;
    }else {
    
        return [self.albumList count];
    }
    //return [self.albumList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        
        static  NSString *CellIdentifier = @"myLib";
        YWImgLibMyLibTableViewCell *cell= [_albumTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [_albumTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWImgLibMyLibTableViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        
        return cell;
        
        

    }else {
        
        static  NSString *CellIdentifier = @"AlbumCellID";
        AlbumCell *cell= [_albumTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [_albumTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:self options:nil] lastObject];
            
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        YPcituresFileds* pictureFile = [self.albumList objectAtIndex:indexPath.row];
        
        // cell.albumImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.albumImage setImageWithURL:[NSURL URLWithString:pictureFile.albumCoverUrl] placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
        
        cell.albumName.text = [NSString stringWithFormat:@"%@ (%ld)",pictureFile.albumTitle,(long)pictureFile.albumPhotoNumbers];
        
        cell.albumID = pictureFile.albumID;
        
        return cell;
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //
        YWMyLibDocumentViewController *mylibDocVC = [[YWMyLibDocumentViewController alloc] init];
        
        [self performSelector:@selector(deselect) withObject:nil afterDelay:.3f];
        
        [self.navigationController pushViewController:mylibDocVC animated:YES];
        
    }else {
    
        YWPicInAlbumVC *vc = [[YWPicInAlbumVC alloc]init];
        
        AlbumCell *cell = (AlbumCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        vc.albumID = cell.albumID;
        
        YPcituresFileds* pictureFile = [self.albumList objectAtIndex:indexPath.row];
        
        vc.photoCount = pictureFile.albumPhotoNumbers;
        vc.albumTitle = pictureFile.albumTitle;
        
        [self performSelector:@selector(deselect) withObject:nil afterDelay:.3f];
        
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        //[self presentViewController:vc  animated:YES completion:Nil];
//        [self.navigationController setNavigationBarHidden:YES];
//        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
       // [self.navigationController setNavigationBarHidden:NO];
        //self.hidesBottomBarWhenPushed = YES;
        
    }
    
//    YWPicInAlbumVC *vc = [[YWPicInAlbumVC alloc]init];
//    
//    AlbumCell *cell = (AlbumCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    vc.albumID = cell.albumID;
//    
//    YPcituresFileds* pictureFile = [self.albumList objectAtIndex:indexPath.row];
//    
//    vc.photoCount = pictureFile.albumPhotoNumbers;
//    vc.albumTitle = pictureFile.albumTitle;
//    
//    [self performSelector:@selector(deselect) withObject:nil afterDelay:.3f];
//    
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    
//    //[self presentViewController:vc  animated:YES completion:Nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
/**
 *  消除cell的选中状态
 */
-(void)deselect{
    [_albumTableView deselectRowAtIndexPath:[_albumTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)noContent:(BOOL)YN
{
    UIImageView* hold = (UIImageView* )[_albumTableView viewWithTag:2077];
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
                    y = 119;
                }else{
                    y = 89;
                }
                
                hold.center = CGPointMake(_albumTableView.center.x, _albumTableView.center.y-y);
                hold.contentMode = UIViewContentModeScaleAspectFit;
                _albumTableView.separatorStyle = UITableViewCellSelectionStyleNone;
                [_albumTableView.mj_footer removeFromSuperview];
                [_albumTableView addSubview:hold];
            }
        }
    }

    
}



-(void)saveAlbum:(NSDictionary* )albumDic :(BOOL)downLoad{
    
    
    _save = YES;
    
    [pictureDB cleandataBase];
//    BOOL end;
    
    
    NSEnumerator * enumeratorKey = [[albumDic objectForKey:@"list_info" ] keyEnumerator];
    
    int i = 0;
    
    for (NSObject* albumID in enumeratorKey) {
        
        i ++;
        
        YPcituresFileds* pictures = [YPcituresFileds new];
        pictures.albumID = [[NSString stringWithFormat:@"%@",albumID] integerValue];
        pictures.localAlbumID = [[NSString stringWithFormat:@"%@",albumID] integerValue];
        pictures.albumTitle = [[[albumDic objectForKey:@"list_info"]objectForKey:albumID]objectForKey:@"title"];
        pictures.albumPhotoNumbers = [[[[albumDic objectForKey:@"list_info"]objectForKey:albumID]objectForKey:@"photnum"] integerValue];
        
        pictures.albumCoverUrl = [[[[albumDic objectForKey:@"list_info"]objectForKey:albumID]objectForKey:@"cover"] stringByAppendingString:@"_small220190"];
        pictures.albumPhotoNumbers = [[[[albumDic objectForKey:@"list_info"]objectForKey:albumID]objectForKey:@"photnum"] integerValue];
        
        [pictureDB saveAlbumOrPhotos:pictures isPicture:NO];
        
    }
    
    _end = i<NUMBEROFONEPAGE?YES:NO;
    
//    if (_end) {
//        [_albumTableView.mj_footer endRefreshingWithNoMoreData];
//        
//    }else{
//        [_albumTableView.mj_footer endRefreshing];
//    }

    [self beginDownloadPicUrls:downLoad];
    
    
}


- (void)getalbumData:(BOOL)downLoad
{
    
    if (isNetWork) {
        
        [[YWNetRequest sharedInstance] requestLibraryDataWithDataCount:_dataCount WithSuccess:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 70200) {
                
                [self saveAlbum:(NSDictionary* )respondsData :downLoad];
                
                if (_dataCount == 0) {
                    
                    [_albumTableView.mj_header endRefreshing];
                    [_albumTableView.mj_footer endRefreshing];
                    if (_end) {
                        [_albumTableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        
                        [_albumTableView.mj_footer endRefreshing];
                        
                    }
                    
                }else if(_dataCount > 0) {
                    
                    if (_end) {
                        [_albumTableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        
                        [_albumTableView.mj_footer endRefreshing];
                        
                    }
                }

            }else if([[respondsData objectForKey:@"code"] integerValue] == 70201){
                
                naviView.rightBtton.hidden = YES;
                [_albumTableView.mj_header endRefreshing];
                [_albumTableView.mj_footer endRefreshing];
                [_albumTableView.mj_footer endRefreshingWithNoMoreData];
                [self noContent:YES];
                
                
            }else{
                
            }
            
            [TOOL setKey:pictureCodeID value:0];
            
        } failed:^(NSError *error) {
            //
            [_albumTableView.mj_header endRefreshing];
            [_albumTableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"数据请求失败"];
        }];

        
        
    }else{
        
        [_albumTableView.mj_header endRefreshing];
        [_albumTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"无网络"];
        if (self.albumList.count == 0) {
            [self noContent:YES];
        }else {
        
            [self noContent:NO];
        }
        
        
    }
    
}





@end
