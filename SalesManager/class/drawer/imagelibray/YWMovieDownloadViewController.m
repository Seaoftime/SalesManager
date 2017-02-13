//
//  YWMovieDownloadViewController.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWMovieDownloadViewController.h"


#import "NavigationView.h"
#import <MediaPlayer/MediaPlayer.h>

#import "YWMoviePlayerTableViewCell.h"
//2
#import "FileDownloader.h"
#import "SDImageCache.h"


#define FILE_M [NSFileManager defaultManager]
#define NOTI_CENTER [NSNotificationCenter defaultCenter]
#define USER_D [NSUserDefaults standardUserDefaults]
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\

@interface YWMovieDownloadViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
{
    
    
    
}

@property (strong, nonatomic) UITableView *downloadTableView;


@property (nonatomic, retain) UIDocumentInteractionController *docController;

@end

@implementation YWMovieDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    NavigationView *naviView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    naviView.titleLabel.text = @"本地视频";
    
    [naviView.titleLabel setCenter:CGPointMake(kDeviceWidth/2, naviView.titleLabel.frame.origin.y + naviView.titleLabel.frame.size.height/2 + 2)];
    
    [naviView.leftButton setFrame:CGRectMake(10, 20, 50, 44)];
    [naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    naviView.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [naviView.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [naviView.leftButton  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviView];
    self.view.backgroundColor = BGCOLOR;
    
    //2
    [naviView.rightBtton setFrame:CGRectMake(kDeviceWidth - 120, 10, 120, 64)];
    
    [naviView.rightBtton  setTitle:@"全部删除"  forState:UIControlStateNormal];
    naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.rightBtton  addTarget:self action:@selector(clearAllLocalVedios) forControlEvents:UIControlEventTouchUpInside];

    
    
    self.downloadTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kDeviceWidth,KDeviceHeight - 64)];
    self.downloadTableView.backgroundColor = [UIColor clearColor];
    self.downloadTableView.dataSource = self;
    self.downloadTableView.delegate = self;
    self.downloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.downloadTableView];

    
    
    //2
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

    
    [self.downloadTableView reloadData];
    
    //[NOTI_CENTER addObserver:self selector:@selector(fileDownloadFinish:) name:@"downloadFinish" object:nil];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //
//    self.dataSource = [[MusicDownloadDataSource alloc ] init];
//    
//    //
//    //YWMoviePlayerViewController *player = [[YWMoviePlayerViewController alloc] init];
//    
//    __weak typeof(self) weakSelf = self;
//    self.dataSource.downloadStatusChangeBlock = ^(TaskDownloadState mpDownloadState,NSString *downLoadUrlString){
//        //
//        [weakSelf mpDownLoadCompleteTask];
//        
//        
//        [weakSelf.downloadTableView reloadData];
//        
//        //[weakSelf.navigationController pushViewController:player animated:YES];
//                
//    };
//    
//    
//    [self loadNewTask];
//    
//    
//    //
//    //
//    self.downLoadCompleteDataSource = [[DownLoadCompleteDataSource alloc ] init];
//    [self mpDownLoadCompleteTask];

    
    
}



#pragma mark -监听下载完成-

- (void)fileDownloadFinish:(NSNotification *)noti
{
    FileDownloader *fileD = noti.object;
    [self.localVideos addObject:fileD.file];
    NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.localVideos];
    
    [USER_D setObject:Savedata forKey:@"VideoList"];
    [USER_D synchronize];
    
    //SHOW_ALERT(@"一个视频已下载成功！");
    
    NSLog(@"本地数组==%@",self.localVideos);
    [self.downloadTableView reloadData];
    
}


//删除所有
- (void)clearAllLocalVedios
{
    NSDirectoryEnumerator *enumerator = [FILE_M enumeratorAtPath:[Tools downloadPath]];
    unsigned long long size = 0;
    
    //通过while循环遍历文件夹中的所有文件，(和FMDB的结果集遍历类似)
    while ([enumerator nextObject]) {
        size += [[enumerator fileAttributes] fileSize];
    }
    NSString * str = [NSString stringWithFormat:@"已成功清除%.2fM内存",size/1000.0/1000.0];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [FILE_M removeItemAtPath:[Tools downloadPath] error:nil];
    [self.localVideos removeAllObjects];
    //    NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.localVideos];
    //
    //    [USER_D setObject:Savedata forKey:@"VideoList"];
    //    [USER_D synchronize];
    [USER_D removeObjectForKey:@"VideoList"];
    SHOW_ALERT(str);
    
    [self.downloadTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloaddd" object:nil];

}

//-(void)loadNewTask{
//    
//    [self.dataSource  loadUnFinishedTasks];
//    [self.downloadTableView reloadData];
//    [self.dataSource startDownLoadUnFinishedTasks];
//}
//
//
//-(void)mpDownLoadCompleteTask
//{
//    [self.downLoadCompleteDataSource loadFinishedTasks];
//    [self.downloadTableView reloadData];
//}



#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    //return 2;
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSArray *titleArray = @[@"已下载",@"下载中"];
//    return [titleArray objectAtIndex:section];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return [self.downLoadCompleteDataSource.finishedTasks count];
//    }
//    return [self.dataSource.unFinishedTasks count];
  
    //2
    return self.localVideos.count;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0 && self.downLoadCompleteDataSource.finishedTasks.count == 0) {
//        return 0;
//    }
//    if (section == 1 && self.dataSource.unFinishedTasks.count == 0) {
//        return 0;
//        
//    }
//    return 44;
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //if (indexPath.section == 0) {
        //
//        static  NSString *cellIdentifier = @"play";
//        YWMoviePlayerTableViewCell *cell= [self.downloadTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        [self.downloadTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        if(!cell){
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWMoviePlayerTableViewCell" owner:self options:nil] lastObject];
//        }
//        
//        YWTaskEntity *taskEntity = [self.downLoadCompleteDataSource.finishedTasks objectAtIndex:indexPath.row];
//        cell.movieNameLb.text = taskEntity.name;
//        
//        return cell;
    
   // }else {
//    
//        static  NSString *cellIdentifier = @"download";
//        YWMoviewDownloadTableViewCell *cell= [self.downloadTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        [self.downloadTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        if(!cell){
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWMoviewDownloadTableViewCell" owner:self options:nil] lastObject];
//        }
//        
//        YWTaskEntity *taskEntity = [self.dataSource.unFinishedTasks objectAtIndex:indexPath.row];
//        [cell showData:taskEntity];
//        
//        return cell;
//    
//    
//    
//    }
    
    
    
    static  NSString *cellIdentifier = @"download";
    YWMoviePlayerTableViewCell *cell= [self.downloadTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self.downloadTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YWMoviePlayerTableViewCell" owner:self options:nil] lastObject];
    }
    
    Video * vide = self.localVideos[indexPath.row];
    
    cell.movieNameLb.text = vide.videoName;
    //
    cell.playerButton.tag = indexPath.row;
    
    [cell.playerButton addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
    
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
    //    [self performSelector:@selector(deselect) withObject:nil afterDelay:.3f];
    //
    //    //[self.navigationController setNavigationBarHidden:YES];
    //    [self.navigationController pushViewController:docuInterVC animated:YES];
    
//    if (indexPath.section == 0) {
//        //
//        YWTaskEntity *taskEntity = [self.downLoadCompleteDataSource.finishedTasks objectAtIndex:indexPath.row];
//        //MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:taskEntity.mpDownLoadPath]];
//        
//        
//        
//        //[self presentViewController:moviePlayer animated:YES completion:nil];
//        
//        
//        
//        
//        NSURL *file_URL = [NSURL fileURLWithPath:taskEntity.mpDownLoadPath];
//        
//        
//        if (_docController == nil) {
//            
//            _docController = [[UIDocumentInteractionController alloc] init];
//            
//            _docController = [UIDocumentInteractionController interactionControllerWithURL:file_URL];
//            _docController.delegate = self;
//            
//            
//        }else {
//            
//            _docController.URL = file_URL;
//        }
//        
//        
//        
//        //直接显示预览
//        [_docController presentPreviewAnimated:YES];
//        
//
//        
//    }else {
//    
////        YWTaskEntity *taskEntity = [self.dataSource.unFinishedTasks objectAtIndex:indexPath.row];
////        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:taskEntity.mpDownLoadPath]];
////        [self presentViewController:moviePlayer animated:YES completion:nil];
//
//        
//    
//    }
//    
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:.5f];
    
}

-(void)deselect
{
    [self.downloadTableView deselectRowAtIndexPath:[self.downloadTableView indexPathForSelectedRow] animated:YES];
}





#pragma mark - event -
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


//#pragma mark - document
//
//- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
//{
//    return self;
//}
//
//- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
//{
//    return self.view;
//}
//
//- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
//{
//    return  self.view.frame;
//}
//
//
//- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    //[_docController dismissMenuAnimated:YES];
//    
//}



//2
- (void)deleteVideo:(UIButton *)btn
{
    
    
    
    
//    Video *file = [self.localVideos objectAtIndex:btn.tag];
//    
//    NSString *path = [NSString stringWithFormat:@"%@/%@",[Tools downloadPath],file.videoName];
//    
//    //从本地文件夹中删除
//    [FILE_M removeItemAtPath:path error:nil];
//    
//    //从tableView中删除
//    [self.localVideos removeObjectAtIndex:btn.tag];
//    
//    
//    [USER_D removeObjectForKey:@"VideoList"];
//    
////    NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.localVideos];
////    
////    [USER_D setObject:Savedata forKey:@"VideoList"];
////    [USER_D synchronize];
//    
//    
////    [self.downloadTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    //[self.downloadTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    [self.downloadTableView reloadData];
//    




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
