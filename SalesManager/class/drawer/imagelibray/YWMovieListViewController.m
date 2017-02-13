//
//  YWMovieListViewController.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWMovieListViewController.h"

#import "NavigationView.h"
#import "YWMoviesListTableViewCell.h"


//2
#import "YWVideoListTableViewCell.h"
#import "MoviePlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ILBarButtonItem.h"
#import "YWMovieDownloadViewController.h"
#import "UINavigationBar+customBar.h"
//3
#import "YWMoviePlayerTableViewCell.h"
#import "SDImageCache.h"

#define USER_D [NSUserDefaults standardUserDefaults]
#define NOTI_CENTER [NSNotificationCenter defaultCenter]
#define FILE_M [NSFileManager defaultManager]
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\

#define SHIPIN_One @"http://baobab.cdn.wandoujia.com/14468618701471.mp4"

#define SHIPIN_Two @"http://data.idocv.com/idocv-manual.docx"

@interface YWMovieListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_movieListTableView;
    
    UITableView *_downloadTableView;
    //
    NavigationView *_naviView;
}

//@property (nonatomic, strong) UIScrollView *bgscrollView;
@property (nonatomic,strong)UISegmentedControl * segmentedControl;


//
@property (nonatomic , strong) NSArray *movieList;

//@property (nonatomic, strong) MPMoviePlayerController *player;
//3
// 标记是否全选
@property (nonatomic ,assign) BOOL isAllSelected;
@property (nonatomic ,strong) UIButton *deleteButton;
@property (nonatomic ,strong) UIButton *selectAllButton;
@property (nonatomic ,strong) UIAlertView *alertV;

@end

@implementation YWMovieListViewController

+ (YWMovieListViewController *)sharedMovieListViewController
{
    static YWMovieListViewController *movieListVC = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        movieListVC = [[self alloc] init];
    });
    
    return movieListVC;
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recover) name:@"reloaddd" object:nil];
    
    
    //通知问题
    //[NOTI_CENTER addObserver:self selector:@selector(fileDownloadFinishhh:) name:@"downloadFinishh" object:nil];
    

}

- (void)recover
{
    //[_movieListTableView reloadData];

}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[NOTI_CENTER postNotificationName:@"stopRequesting" object:self];
    
        
}



- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    _naviView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    _naviView.titleLabel.text = @"";
    _naviView.titleLabel.userInteractionEnabled = YES;
    
    [_naviView.titleLabel setCenter:CGPointMake(kDeviceWidth/2, _naviView.titleLabel.frame.origin.y + _naviView.titleLabel.frame.size.height/2 + 2)];
    
    [_naviView.leftButton setFrame:CGRectMake(10, 20, 50, 44)];
    [_naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    _naviView.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [_naviView.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_naviView.leftButton  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_naviView];
    
    self.view.backgroundColor = BGCOLOR;
//
    
    
    //2
//    [naviView.rightBtton setFrame:CGRectMake(kDeviceWidth - 120, 10, 120, 64)];
//    
//    [naviView.rightBtton  setTitle:@"本地视频"  forState:UIControlStateNormal];
//    naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [naviView.rightBtton  addTarget:self action:@selector(findLocationVideos) forControlEvents:UIControlEventTouchUpInside];

    
    //self.navigationItem.titleView = self.segmentedControl;
    
    [_naviView.titleLabel addSubview:self.segmentedControl];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    
    
    _movieListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kDeviceWidth,KDeviceHeight - 64)];
    _movieListTableView.backgroundColor = [UIColor clearColor];
    _movieListTableView.dataSource = self;
    _movieListTableView.delegate = self;
    _movieListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _movieListTableView.tag = 1000;
    [self.view addSubview:_movieListTableView];
    
    
    
    
    _downloadTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kDeviceWidth,KDeviceHeight - 64)];
    _downloadTableView.backgroundColor = [UIColor clearColor];
    _downloadTableView.dataSource = self;
    _downloadTableView.delegate = self;
    _downloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _downloadTableView.tag = 2000;
    [self.view addSubview:_downloadTableView];

    _downloadTableView.hidden = YES;
    
    
    
    
    [_naviView.rightBtton setFrame:CGRectMake(kDeviceWidth - 120, 10, 120, 64)];
    
    [_naviView.rightBtton  setTitle:@"编辑"  forState:UIControlStateNormal];
    _naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_naviView.rightBtton  addTarget:self action:@selector(edittt) forControlEvents:UIControlEventTouchUpInside];
    
    _naviView.rightBtton.hidden = YES;
    //*允许编辑
    _downloadTableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    

    //底部删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = deleteButton;
    [self.view addSubview:deleteButton];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.7f]];
    [deleteButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton addTarget:self action:@selector(deleteMoreArray) forControlEvents:UIControlEventTouchUpInside];

    
//
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Discover" ofType:@".plist"];
    self.movieList = [NSArray arrayWithContentsOfFile:path];

    //[_movieListTableView reloadData];

    //
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push) name:@"push" object:nil];
    
    //2
    self.downloaderManager = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.remoteVideos = [[NSMutableArray alloc] initWithCapacity:0];
    //第二次进来 如果文件存在 读取已经选中的行 反之 初始化选中数组
    
    NSData *savedEncodedData = [USER_D objectForKey:@"VideoList"];
    if(!savedEncodedData)
    {
        self.localVideos = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        self.localVideos = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
    
    NSLog(@"_selectedRows====%@", self.localVideos);
    
    //self.remoteVideos = [NSArray arrayWithContentsOfFile:path];
    Video * video1 = [[Video alloc] init];
    video1.videoName =@"魔兽崛起";
    video1.videoURL = SHIPIN_One;
    [self.remoteVideos  addObject:video1];
    
    Video * video2 = [[Video alloc] init];
    video2.videoName =@"02";
    video2.videoURL = SHIPIN_One;
    [self.remoteVideos  addObject:video2];
    
    Video * video3 = [[Video alloc] init];
    video3.videoName =@"video";
    video3.videoURL = SHIPIN_One;
    [self.remoteVideos  addObject:video3];
    
    Video * video4 = [[Video alloc] init];
    video4.videoName =@"04";
    video4.videoURL = SHIPIN_One;
    [self.remoteVideos  addObject:video4];
    
    [self.remoteVideos  addObject:video1];
    [self.remoteVideos  addObject:video2];
    
    [NOTI_CENTER addObserver:self selector:@selector(fileDownloadFinishhh:) name:@"downloadFinishh" object:nil];

    
//    if (_downloadTableView.hidden) {
//        naviView.rightBtton.hidden = YES;
//        
//    }else {
//    
//        naviView.rightBtton.hidden = NO;
//    }
    
   
    
    
    
}




#pragma mark - UI -

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"我的视频" ,@"本地视频"]];
        _segmentedControl.frame = CGRectMake(0, 7.0f, 175.0f, 25.0f);
        _segmentedControl.selectedSegmentIndex = 0;
        
        [_segmentedControl addTarget:self action:@selector(changeee:)forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}



//segmentedControl
-(void)changeee:(UISegmentedControl*)sender
{
    
    //[self.bgscrollView setContentOffset:CGPointMake(kDeviceWidth *sender.selectedSegmentIndex, 0) animated:YES];
    if (_downloadTableView.hidden) {
        
        _movieListTableView.hidden = YES;
        _downloadTableView.hidden = NO;
        _naviView.rightBtton.hidden = NO;
        //
//        _naviView.leftButton.hidden = YES;
//        [_naviView addSubview:self.selectAllButton];
        
        
    }else if (_movieListTableView.hidden) {
    
        _downloadTableView.hidden = YES;
        _naviView.rightBtton.hidden = YES;
        
        _movieListTableView.hidden = NO;
        //
//        [self.selectAllButton removeFromSuperview];
//        _naviView.leftButton.hidden = NO;
    
    }else {
    
    }
    
}


- (UIButton *)selectAllButton
{
    if (!_selectAllButton) {
        _selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(selectAllFiles) forControlEvents:UIControlEventTouchUpInside];
        _selectAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    
    return _selectAllButton;

}


- (void)edittt
{
    /** 每次点击 rightBarButtonItem 都要取消全选 */
    self.isAllSelected = NO;
    
    NSString *string = !_downloadTableView.editing?@"取消":@"编辑";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    [_naviView.rightBtton setTitle:string forState:UIControlStateNormal];
    
    
//    self.selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
//    [self.selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
//    [self.selectAllButton addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([string isEqualToString:@"取消"]) {
        
        _naviView.leftButton.hidden = YES;
        [_naviView addSubview:self.selectAllButton];
        
    }
 //       else {
//    
//        _naviView.leftButton.hidden = NO;
//    
//    }
    
    if ([string isEqualToString:@"编辑"]) {
        
        _naviView.leftButton.hidden = NO;
        [self.selectAllButton removeFromSuperview];
        //self.selectAllButton.hidden = YES;
        
    }
    
    
    if (self.localVideos.count) {
//        self.navigationItem.leftBarButtonItem = !_downloadTableView.editing? [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)]:nil;
        
        NSString *string2 = !_downloadTableView.editing?@"全选":@"返回";
        [_naviView.leftButton setTitle:string2 forState:UIControlStateNormal];
        
        
        
//        if ([string2 isEqualToString:@"全选"]) {
//            
//            [_naviView.leftButton setImage:nil forState:UIControlStateNormal];
//            
//            [_naviView.leftButton  addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
//        }else {
//        
//            [_naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
//            [_naviView.leftButton  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//        
//        }
        
        
        
//        if (_downloadTableView.editing) {
//            [_naviView.leftButton setTitle:@"全选" forState:UIControlStateNormal];
//            [_naviView.leftButton setImage:nil forState:UIControlStateNormal];
//        }
        
        
        CGFloat height = !_downloadTableView.editing?40:0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, 40);
            
        }];
        
        
    }else{
        
        //self.navigationItem.leftBarButtonItem = nil;
        //self.navigationItem.rightBarButtonItem = nil;
        //_naviView.rightBtton.hidden = YES;
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
            
        }];
    }
    
    _downloadTableView.editing = !_downloadTableView.editing;
    
}

#pragma mark - 全选
-(void)selectAllFiles
{
    
    self.isAllSelected = !self.isAllSelected;
    
    for (int i = 0; i<self.localVideos.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        
        if (self.isAllSelected) {
            
            [_downloadTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }else{//反选
            
            [_downloadTableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
    }
}

#pragma mark - 多选


- (CGFloat)folderSizeAtPath:(NSString *)path
{
    //初始化一个文件管理类对象
    NSFileManager * fileManager = [NSFileManager defaultManager];
    CGFloat folderSize = 0.0;
    //如果文件夹存在
    if ([fileManager fileExistsAtPath:path]) {
        //NSArray * childerFiles = [fileManager subpathsAtPath:path];
        
        NSMutableArray *deleteArrarys = [NSMutableArray array];
        for (NSIndexPath *indexPath in _downloadTableView.indexPathsForSelectedRows) {
            [deleteArrarys addObject:self.localVideos[indexPath.row]];
        }
        
        for (NSString * fileName in deleteArrarys)
        {
            NSString * absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self filePathSize:absolutePath];
        }
        [self showCacheFileSizeToDelete:folderSize];
        
        return folderSize;
        
    }
    return 0;
    
}





//计算文件大小
- (CGFloat)filePathSize:(NSString *)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return  size / 1024.0 / 1024.0;
    }
    return 0;
}




//显示删除提示
- (void)showCacheFileSizeToDelete:(CGFloat)fileSize
{
    if (fileSize > 0.001)
    {
        NSString * string = [NSString stringWithFormat:@"缓存大小为:%.2fM,是否删除",fileSize];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:string
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"删除", nil];
        [alertView show ];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"当前没有缓存"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        //延时1s消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}


//alertView的代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self clearCache:[self getPath]];
    }
}

//点击删除按钮时调用
- (void)clearCache:(NSString *)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString * fileName in childerFiles)
        {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
        
    }
}

- (NSString *)getPath
{
//    //获取沙河文件夹下的library下caches文件夹路径   caches文件夹主要存放缓存文件
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//    //    NSLog(@"%@", path);
//    return path;
    
    return [Tools downloadPath];
    
}







- (void)deleteMoreArray
{
    
    
    [self folderSizeAtPath:[self getPath]];
    
    
    
//    NSMutableArray *deleteArrarys = [NSMutableArray array];
//    for (NSIndexPath *indexPath in _downloadTableView.indexPathsForSelectedRows) {
//        [deleteArrarys addObject:self.localVideos[indexPath.row]];
//    }
//    
//    
  
    
//    NSDirectoryEnumerator *enumerator = [FILE_M enumeratorAtPath:[Tools downloadPath]];
//    unsigned long long size = 0;
//    
    
//    for (NSInteger i = 0; i< deleteArrarys.count; i++) {
//        //
//        size += [[enumerator fileAttributes] fileSize];
//
//    }
//    
//    NSString * str = [NSString stringWithFormat:@"缓存大小为%.2fM，是否删除？",size/1024.0/1024.0];
//    
//    NSLog(@"%@",str);
//    
//     self.alertV = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    [self.alertV show];
//    
//    
//    
//    
//    [[SDImageCache sharedImageCache] clearDisk];
//    
//    [FILE_M removeItemAtPath:[Tools downloadPath] error:nil];
//    [self.localVideos removeObjectsInArray:deleteArrarys];
//    
//    [USER_D removeObjectForKey:@"VideoList"];
    
//    [UIView animateWithDuration:0 animations:^{
//        
//        
//        
//        [self.localVideos removeObjectsInArray:deleteArrarys];
//        [_movieListTableView reloadData];
//        [_downloadTableView reloadData];
//        
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            if (!self.localVideos.count) {
//                //self.navigationItem.leftBarButtonItem = nil;
//                //self.navigationItem.rightBarButtonItem = nil;
//                
//                [self.selectAllButton removeFromSuperview];
//                _naviView.leftButton.hidden = NO;
//                [_naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
//                
//                //[_naviView.rightBtton setTitle:@"编辑" forState:UIControlStateNormal];
//                _naviView.rightBtton.hidden = YES;
//                
//                self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
//                
//                
//            }
//            
//        } completion:^(BOOL finished) {
//            // 考虑到全选之后 ，反选几个 再删除  需要将全选置为NO
//            self.isAllSelected = NO;
//            
//        }];
//    }];
//    
//    
    //
    //[self clearAllLocalVedios];
    
}


- (void)clearMoreCatchFiles
{



}


#pragma mark - 清除缓存
-(void)clearAllLocalVedios
{
//    if (_downloadTableView.hidden) {
//        _downloadTableView.hidden = NO;
//    }
    
    NSDirectoryEnumerator *enumerator = [FILE_M enumeratorAtPath:[Tools downloadPath]];
    unsigned long long size = 0;
    
    //通过while循环遍历文件夹中的所有文件，(和FMDB的结果集遍历类似)
    while ([enumerator nextObject]) {
        size += [[enumerator fileAttributes] fileSize];
    }
    NSString * str = [NSString stringWithFormat:@"已成功清除%.2fM内存",size/1024.0/1024.0];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [FILE_M removeItemAtPath:[Tools downloadPath] error:nil];
    [self.localVideos removeAllObjects];
    
    [USER_D removeObjectForKey:@"VideoList"];
    SHOW_ALERT(str);
    
    [_movieListTableView reloadData];
    
    [_downloadTableView reloadData];
    
}


#pragma mark -监听下载完成-

- (void)fileDownloadFinishhh:(NSNotification *)noti
{
    FileDownloader *fileD = noti.object;
    [self.localVideos addObject:fileD.file];
    
    NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.localVideos];
    
    [USER_D setObject:Savedata forKey:@"VideoList"];
    [USER_D synchronize];
    
    //SHOW_ALERT(@"一个视频已下载成功！");
    
    NSLog(@"本地数组==%@",self.localVideos);
    
    [_movieListTableView reloadData];
    [_downloadTableView reloadData];
    
}




#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //return self.movieList.count;
    //2
    //return self.remoteVideos.count;
    
    
    if (tableView.tag == 1000) {
        
        return self.remoteVideos.count;
        
    }else{
        
        return self.localVideos.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1000) {
        //
        static  NSString *cellIdentifier = @"movie";
        YWVideoListTableViewCell *cell= [_movieListTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [_movieListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWVideoListTableViewCell" owner:self options:nil] lastObject];
        }
        //cell 点击
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //    cell.index = indexPath;
        //
        //    cell.delegate = self;
        //[cell showData:[self.movieList objectAtIndex:indexPath.row]];
        
        //2
        
        Video * vide = self.remoteVideos[indexPath.row];
        
        cell.videoNameLb.text = vide.videoName;
        
        // 点击播放
        [cell.onlineWatchBtn setTitle:@"在线播放" forState:UIControlStateNormal];
        cell.onlineWatchBtn.layer.masksToBounds = YES;
        cell.onlineWatchBtn.layer.cornerRadius = 5;
        cell.onlineWatchBtn.layer.borderColor= [UIColor blackColor].CGColor;
        cell.onlineWatchBtn.layer.borderWidth = 0.5;
        cell.onlineWatchBtn.tag = indexPath.row;
        [cell.onlineWatchBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:141/255.0 blue:247/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
        [cell.onlineWatchBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchUpInside];
        
         ///////////////////////////////////////////
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /**
         *  <#Description#>
         */
        
//        //  下载按钮
//        
//        //
        cell.downloadBtn.layer.masksToBounds = YES;
        cell.downloadBtn.layer.cornerRadius = 5;
        cell.downloadBtn.layer.borderColor= [UIColor blackColor].CGColor;
        cell.downloadBtn.layer.borderWidth = 0.5;
        [cell.downloadBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:141/255.0 blue:247/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        //
        cell.downloadBtn.file = vide;
        //给button关联自己的下载器
        cell.downloadBtn.fileDownloader = [self.downloaderManager objectForKey:vide.videoName];
        //[cell.downloadBtn setBackgroundImageWithURL:url];
        cell.downloadBtn.tag = indexPath.row;
        [cell.downloadBtn addTarget:self action:@selector(downloadButtonClickk:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置button状态
        if ([Tools isDownloadFinish:vide])
        {
            //在下载文件夹下存在，说明已经下载完毕
            cell.downloadBtn.downloadState = ButtonComplete;
        }
        else if ([Tools isFileDownloading:vide])
        {
            //在临时文件夹下存在，说明下了一部分
            FileDownloader *fileD = [self.downloaderManager objectForKey:vide.videoName];
            if ([fileD isDownloading])
            {
                //正在下载
                cell.downloadBtn.downloadState = ButtonDownloading;
            }
            else
            {
                //暂停
                cell.downloadBtn.downloadState = ButtonPause;
            }
        }
        else
        {
            cell.downloadBtn.downloadState = ButtonNormal;
        }
        
        
        return cell;

    }else {
    
        static  NSString *cellIdentifier = @"download";
        YWMoviePlayerTableViewCell *cell= [_downloadTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [_downloadTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWMoviePlayerTableViewCell" owner:self options:nil] lastObject];
        }
        
        Video * vide = self.localVideos[indexPath.row];
        
        cell.movieNameLb.text = vide.videoName;
        //
        cell.playerButton.tag = indexPath.row;
        
        //[cell.movieDeleteButton addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //return 74;
    //2
    //return 100;
    //3
    if (tableView.tag == 1000) {
        
        return 100;
    }else {
    
        return 80;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YWDocuInterctionViewController *docuInterVC = [[YWDocuInterctionViewController alloc] init];
//    docuInterVC.path = self.docuArray[indexPath.row];
//    
    
//    
//    //[self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController pushViewController:docuInterVC animated:YES];
    
//    [self performSelector:@selector(deselect) withObject:nil afterDelay:.3f];
//    
 //   YWMovieDownloadViewController *download = [[YWMovieDownloadViewController alloc] init];
//    [self.navigationController pushViewController:download animated:YES];
    
    
    
    
    
    
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (tableView.tag == 1000) {
//        
//        
//    }else {
//        NSString *audioPath = [NSString stringWithFormat:@"%@/%@.mp4",[Tools downloadPath],[self.localVideos[indexPath.row] videoName]];
//        NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
//        NSLog(@"下载文件路径-----%@",audioPath);
//        MoviePlayerController * movieVC = [[MoviePlayerController alloc]initWithURLStr:audioUrl];
//        [self presentViewController:movieVC animated:YES completion:^{
//            
//            
//        }];
//        
//    }

    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2000) {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==2000)
    {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //
            Video *file = [self.localVideos objectAtIndex:indexPath.row];
            NSString *path = [NSString stringWithFormat:@"%@/%@",[Tools downloadPath],file.videoName];
            
            //从本地文件夹中删除
            [FILE_M removeItemAtPath:path error:nil];
            
            //从tableView中删除
            [self.localVideos removeObjectAtIndex:indexPath.row];
            NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.localVideos];
            
            [USER_D setObject:Savedata forKey:@"VideoList"];
            [USER_D synchronize];
            [_downloadTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            

        }
        
    }
    
}






//- (void)push
//{
////    YWMovieDownloadViewController *download = [[YWMovieDownloadViewController alloc] init];
////    [self.navigationController pushViewController:download animated:YES];
////
//
//}




-(void)deselect
{
    [_movieListTableView deselectRowAtIndexPath:[_movieListTableView indexPathForSelectedRow] animated:YES];
}



//-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath{
//    
//    NSDictionary *entity = [self.movieList objectAtIndex:indexPath.row];
//    NSString *downLoadUrl = [entity objectForKey:@"downLoadUrl"];
//    
//    MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance ] getTaskState:downLoadUrl];
//    
//    switch (taskState) {
//        case MPTaskCompleted: {
//            NSLog(@"已经下载完成");
//            [self showTip:@"已经下载完成"];
//            
////            YWMoviePlayerViewController *player = [[YWMoviePlayerViewController alloc] init];
////            [self.navigationController pushViewController:player animated:YES];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"reback" object:self];
//
//        }
//            break;
//            
//        case MPTaskExistTask:
//            NSLog(@"已经在下载列表");
//            [self showTip:@"已经在下载列表"];
//            break;
//            
//        case MPTaskNoExistTask:
//        {
//            MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
//            downLoadEntity.downLoadUrlString = downLoadUrl;
//            downLoadEntity.extra = entity;
//            [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
//            [self showTip:@"添加成功，正在下载"];
//            //
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"rename" object:self];
//            
//        }
//            break;
//        default:
//            break;
//    }
//}
//

-(void)showTip:(NSString *)tip
{
    [[[UIAlertView alloc ] initWithTitle:@""
                                 message:tip
                                delegate:nil
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil, nil]  show];
}


#pragma mark - event -
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
    
}





/**
 *  第2种
 */


-(void)playBtn:(UIButton*)sender
{
    
    //NSString *urlStr = [[self.movieList objectAtIndex:sender.tag] objectForKey:@"downLoadUrl"];
    //MoviePlayerController * movieVC = [[MoviePlayerController alloc] initWithURLStr: [NSURL URLWithString:urlStr]];
    
    
    MoviePlayerController * movieVC = [[MoviePlayerController alloc] initWithURLStr: [NSURL URLWithString:[self.remoteVideos[sender.tag] videoURL]]];

    
    [self presentViewController:movieVC animated:YES completion:^{
        
    }];

    
    
//    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
//
//    [movie.moviePlayer prepareToPlay];
//    
//    [self presentMoviePlayerViewControllerAnimated:movie];
//    
//    [movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
//
//    [movie.view setBackgroundColor:[UIColor clearColor]];
//
//    [movie.view setFrame:self.view.bounds];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:movie.moviePlayer];
    
    
}


-(void)movieFinishedCallback:(NSNotification*)notify{
    
    
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];

    [[NSNotificationCenter defaultCenter] removeObserver:self  name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];

    
    [self dismissMoviePlayerViewControllerAnimated];
    
}


- (void)downloadButtonClickk:(DownLoadBtn *)sender{
    //先去下载管理器中寻找这个文件的下载器，如果有，说明之前在下过，直接用，如果没有，说明没有下载过，那么就为这个文件创建一个下载器，然后放入下载管理器字典。
    
    //[NOTI_CENTER postNotificationName:@"newProgresss" object:self];
    
    //
    
    Video *file = [self.remoteVideos objectAtIndex:sender.tag];
    FileDownloader *fileD = [self.downloaderManager objectForKey:file.videoName];
    if (!fileD) {
        fileD = [[FileDownloader alloc] initWithFile:file];
        [self.downloaderManager setObject:fileD forKey:file.videoName];
    }
    
    //创建下载器时，需要给button设置关联的下载器
    sender.fileDownloader = fileD;
    
    switch (sender.downloadState) {
        case ButtonNormal:
        {
            //普通状态，开始下载
            sender.downloadState = ButtonDownloading;
            [fileD startDownload];
            
        }
            break;
        case ButtonDownloading:
        {
            //正在下载状态，暂定下载
            sender.downloadState = ButtonPause;
            [fileD cancelDownload];
        }
            break;
        case ButtonPause:
        {
            //暂停状态，继续下载
            sender.downloadState = ButtonDownloading;
            [fileD startDownload];
        }
            break;
        case ButtonComplete:
        {
            //完成状态，查看文件
            
            NSString *audioPath = [NSString stringWithFormat:@"%@/%@.mp4",[Tools downloadPath],file.videoName];
            //NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
            NSURL *audioUrl = [[NSURL alloc] initFileURLWithPath:audioPath];
            //NSURL *audioUrl = [NSURL URLWithString:audioPath];
            
            
            NSLog(@"%@",audioUrl);
            
            
            MoviePlayerController * movieVC = [[MoviePlayerController alloc] initWithURLStr:audioUrl];
            
            [self presentViewController:movieVC animated:YES completion:^{
                
            }];
            
            
            
            //
            //NSURL*videoPathURL=[NSURL URLWithString:urlStr];//urlStr是视频播放地址
            
            //如果是播放本地视频的话。这样初始化：
            
            //NSURL*videoPathURL=[[NSURL alloc] initFileURLWithPath:urlStr];
            
//            NSURL *URL = [[NSURL alloc] initFileURLWithPath:audioPath];
//            NSURL *url = [NSURL fileURLWithPath:audioPath];
//            
//            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//            //
//            [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
//            //控制模式(触摸)
//            moviePlayer.moviePlayer.scalingMode =MPMovieScalingModeAspectFill;
//            
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer.moviePlayer];
//        
//            //[self.view addSubview:moviePlayer.view];
//            
//            moviePlayer.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
//            moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
//            
//            //
//            MPMoviePlayerController *player = [moviePlayer moviePlayer];
//            [player play];
//            
//            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
            
            
            
        }
            break;
            
        default:
            break;
    }
}


////横屏
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//
//    return YES;
//}



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
