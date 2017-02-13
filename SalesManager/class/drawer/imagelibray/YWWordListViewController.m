//
//  YWWordListViewController.m
//  SalesManager
//
//  Created by TonySheng on 16/5/18.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWWordListViewController.h"

#import "NavigationView.h"
#import "YWWordListTableViewCell.h"
#import "Word.h"
//#import "FileDownloader.h"
#import "WordFileDownloader.h"
#import "YWMoviePlayerTableViewCell.h"
#import "SDImageCache.h"


#define USER_D [NSUserDefaults standardUserDefaults]
#define NOTI_CENTER [NSNotificationCenter defaultCenter]
#define FILE_M [NSFileManager defaultManager]

#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\

#define SHIPIN_One @"http://yunpic.feesun.com/myfiles/2016-05-13/1463107161253.gif"
#define SHIPIN_Twoo @"http://yunpic.feesun.com/myfiles/2016-05-13/1463109191134.xls"

@interface YWWordListViewController ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UITableView *_wordListTableView;
    UITableView *_wordDownloadTableView;
    NavigationView *_naviView;
    
}


@property (nonatomic, retain) UIDocumentInteractionController *docController;
@property (nonatomic, strong) UISegmentedControl * segmentedControl;
//
@property (nonatomic ,assign) BOOL isAllSelected;
@property (nonatomic ,strong) UIButton *deleteButton;
@property (nonatomic ,strong) UIButton *selectAllButton;
@property (nonatomic ,strong) UIAlertView *alertV;

@end

@implementation YWWordListViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];


}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[NOTI_CENTER postNotificationName:@"stopWordRequesting" object:self];
    
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
    
    
    [_naviView.titleLabel addSubview:self.segmentedControl];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //

    //
    _wordListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kDeviceWidth,KDeviceHeight - 64)];
    _wordListTableView.backgroundColor = [UIColor clearColor];
    _wordListTableView.tag = 10001;
    _wordListTableView.dataSource = self;
    _wordListTableView.delegate = self;
    _wordListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_wordListTableView];
    
    //本地文档
    _wordDownloadTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kDeviceWidth,KDeviceHeight - 64)];
    _wordDownloadTableView.backgroundColor = [UIColor clearColor];
    _wordDownloadTableView.tag = 10002;
    _wordDownloadTableView.dataSource = self;
    _wordDownloadTableView.delegate = self;
    _wordDownloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_wordDownloadTableView];
    _wordDownloadTableView.hidden = YES;
    
    
    [_naviView.rightBtton setFrame:CGRectMake(kDeviceWidth - 120, 10, 120, 64)];
    
    [_naviView.rightBtton  setTitle:@"编辑"  forState:UIControlStateNormal];
    _naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_naviView.rightBtton  addTarget:self action:@selector(editt) forControlEvents:UIControlEventTouchUpInside];
    
    _naviView.rightBtton.hidden = YES;
    //*允许编辑
    _wordDownloadTableView.allowsMultipleSelectionDuringEditing = YES;
    
    //底部删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = deleteButton;
    [self.view addSubview:deleteButton];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.7f]];
    [deleteButton setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton addTarget:self action:@selector(alertVShow) forControlEvents:UIControlEventTouchUpInside];
    

    
    //
    //2
    self.wordDownloaderManager = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.remoteWords = [[NSMutableArray alloc] initWithCapacity:0];
    //第二次进来 如果文件存在 读取已经选中的行 反之 初始化选中数组
    
    NSData *savedEncodedData = [USER_D objectForKey:@"WordList"];
    if(!savedEncodedData)
    {
        self.locationWords = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        self.locationWords = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
    

    
    //
    Word * word1 = [[Word alloc] init];
    word1.wordName = @"xls";
    word1.wordUrl = SHIPIN_One;
    [self.remoteWords  addObject:word1];
    
    Word * word2 = [[Word alloc] init];
    word2.wordName = @"word2";
    word2.wordUrl = SHIPIN_Twoo;
    [self.remoteWords  addObject:word2];
    
    
    
    //
    [NOTI_CENTER addObserver:self selector:@selector(wordFileDownloadFinishhh:) name:@"worddownloadFinishh" object:nil];
    
    self.alertV = [[UIAlertView alloc] initWithTitle:@"确定全部删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    
}


#pragma mark - UI -

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"我的文档" ,@"本地文档"]];
        _segmentedControl.frame = CGRectMake(0, 7.0f, 175.0f, 25.0f);
        _segmentedControl.selectedSegmentIndex = 0;
        
        [_segmentedControl addTarget:self action:@selector(tableViewChange:)forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}



//segmentedControl
-(void)tableViewChange:(UISegmentedControl*)sender
{
    
    if (_wordDownloadTableView.hidden) {
        
        _wordListTableView.hidden = YES;
        _wordDownloadTableView.hidden = NO;
        _naviView.rightBtton.hidden = NO;
        
        
    }else if (_wordListTableView.hidden) {
        
        _wordDownloadTableView.hidden = YES;
        _naviView.rightBtton.hidden = YES;
        
        _wordListTableView.hidden = NO;
        
    }else {
        
    }
    
}


#pragma mark - 全选

- (UIButton *)selectAllButton
{
    if (!_selectAllButton) {
        _selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
        _selectAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
    }
    
    return _selectAllButton;
    
}


- (void)editt
{
    self.isAllSelected = NO;
    
    NSString *string = !_wordDownloadTableView.editing?@"取消":@"编辑";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    [_naviView.rightBtton setTitle:string forState:UIControlStateNormal];
    
    if ([string isEqualToString:@"取消"]) {
        
        _naviView.leftButton.hidden = YES;
        [_naviView addSubview:self.selectAllButton];
        
    }
    
    if ([string isEqualToString:@"编辑"]) {
        
        _naviView.leftButton.hidden = NO;
        [self.selectAllButton removeFromSuperview];
        //self.selectAllButton.hidden = YES;
        
    }
    
    if (self.locationWords.count) {
        
        NSString *string2 = !_wordDownloadTableView.editing?@"全选":@"返回";
        [_naviView.leftButton setTitle:string2 forState:UIControlStateNormal];
        
        
        CGFloat height = !_wordDownloadTableView.editing?40:0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, 40);
            
        }];
        
        
    }else{
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
            
        }];
    }
    
    _wordDownloadTableView.editing = !_wordDownloadTableView.editing;
    
}

#pragma mark - 全选
-(void)selectAll
{
    
    self.isAllSelected = !self.isAllSelected;
    
    for (int i = 0; i<self.locationWords.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        if (self.isAllSelected) {
            
            [_wordDownloadTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }else{//反选
            
            [_wordDownloadTableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
    }
}

#pragma mark - 删除本地所有
- (void)deleteArr
{
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    for (NSIndexPath *indexPath in _wordDownloadTableView.indexPathsForSelectedRows) {
        
        [deleteArrarys addObject:self.locationWords[indexPath.row]];
    }
    
    
    
    [UIView animateWithDuration:0 animations:^{
        [self.locationWords removeObjectsInArray:deleteArrarys];
        
        [_wordDownloadTableView reloadData];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if (!self.locationWords.count) {
                
                [self.selectAllButton removeFromSuperview];
                _naviView.leftButton.hidden = NO;
                [_naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
                
                //[_naviView.rightBtton setTitle:@"编辑" forState:UIControlStateNormal];
                _naviView.rightBtton.hidden = YES;
                
                self.deleteButton.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40);
                
                
            }
            
        } completion:^(BOOL finished) {
            // 考虑到全选之后 ，反选几个 再删除  需要将全选置为NO
            self.isAllSelected = NO;
            
        }];
    }];
    
    //
    [self clearAllLocalWords];
}



#pragma mark -alertView
- (void)alertVShow
{
    [self.alertV show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self deleteArr];
        
    }else {
        
        
    }
    
}


//清除缓存
-(void)clearAllLocalWords
{
    
    NSDirectoryEnumerator *enumerator = [FILE_M enumeratorAtPath:[Tools wordDownloadPath]];
    unsigned long long size = 0;
    
    //
    while ([enumerator nextObject]) {
        size += [[enumerator fileAttributes] fileSize];
    }
    NSString * str = [NSString stringWithFormat:@"已成功清除%.2fM内存",size/1000.0/1000.0];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [FILE_M removeItemAtPath:[Tools wordDownloadPath] error:nil];
    
    [self.locationWords removeAllObjects];
    
    [USER_D removeObjectForKey:@"WordList"];
    SHOW_ALERT(str);
    
    [_wordDownloadTableView reloadData];
    [_wordListTableView reloadData];
    
}




#pragma mark -监听下载完成-

- (void)wordFileDownloadFinishhh:(NSNotification *)noti
{
    WordFileDownloader *wordFileD = noti.object;
    [self.locationWords addObject:wordFileD.wordFile];
    
    NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.locationWords];
    
    [USER_D setObject:Savedata forKey:@"WordList"];
    
    [USER_D synchronize];
    
    SHOW_ALERT(@"一个文档已下载成功！");
    
    NSLog(@"本地数组==%@",self.locationWords);
    
    [_wordListTableView reloadData];
    [_wordDownloadTableView reloadData];
    
}



#pragma mark -tableview delegte
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //return self.remoteWords.count;
    
    if (tableView.tag == 10001) {
        
        return self.remoteWords.count;
        
    }else{
        
        return self.locationWords.count;
       
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (tableView.tag == 10001) {
        //
        static  NSString *cellIdentifier = @"word";
        YWWordListTableViewCell *cell= [_wordListTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [_wordListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWWordListTableViewCell" owner:self options:nil] lastObject];
        }
        //cell 点击
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //    cell.index = indexPath;
        //
        //    cell.delegate = self;
        //[cell showData:[self.movieList objectAtIndex:indexPath.row]];
        
        //2
        
        Word * word = self.remoteWords[indexPath.row];
        
        cell.wordNameLb.text = word.wordName;
        
        
        //
        //  下载按钮
        cell.downloadBtn.layer.masksToBounds = YES;
        cell.downloadBtn.layer.cornerRadius = 5;
        cell.downloadBtn.layer.borderColor= [UIColor blackColor].CGColor;
        cell.downloadBtn.layer.borderWidth = 0.5;
        
        //
        cell.downloadBtn.wordFile = word;
        //给button关联自己的下载器
        cell.downloadBtn.fileDownloader = [self.wordDownloaderManager objectForKey:word.wordName];
        //[cell.downloadBtn setBackgroundImageWithURL:url];
        cell.downloadBtn.tag = indexPath.row;
        [cell.downloadBtn addTarget:self action:@selector(wordDownloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置button状态
        if ([Tools wordIsDownloadFinish:word])
        {
            //在下载文件夹下存在，说明已经下载完毕
            cell.downloadBtn.downloadState = ButtonComplete;
        }
        else if ([Tools wordIsFileDownloading:word])
        {
            //在临时文件夹下存在，说明下了一部分
            WordFileDownloader *fileD = [self.wordDownloaderManager objectForKey:word.wordName];
            
            if ([fileD isDownloadingWord])
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
        YWMoviePlayerTableViewCell *cell= [_wordDownloadTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [_wordDownloadTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWMoviePlayerTableViewCell" owner:self options:nil] lastObject];
        }
        
        Word * word = self.locationWords[indexPath.row];
        
        cell.movieNameLb.text = word.wordName;
        [cell.playerButton setTitle:@"查看" forState:UIControlStateNormal];
        cell.playerButton.tag = indexPath.row;
        
        //[cell.movieDeleteButton addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 10001) {
        
        return 100;
    }else {
        
        return 80;
    }

    
}


- (void)wordDownloadButtonClick:(WordDownloadBtn *)sender
{
    
    //先去下载管理器中寻找这个文件的下载器，如果有，说明之前在下过，直接用，如果没有，说明没有下载过，那么就为这个文件创建一个下载器，然后放入下载管理器字典。
    Word *wordFile = [self.remoteWords objectAtIndex:sender.tag];
    
    WordFileDownloader *fileD = [self.wordDownloaderManager objectForKey:wordFile.wordName];
    
    if (!fileD) {
        fileD = [[WordFileDownloader alloc] initWithWordFile:wordFile];
        
        [self.wordDownloaderManager setObject:fileD forKey:wordFile.wordName];
    }
    
    //创建下载器时，需要给button设置关联的下载器
    sender.fileDownloader = fileD;
    
    switch (sender.downloadState) {
        case ButtonNormal:
        {
            //普通状态，开始下载
            sender.downloadState = ButtonDownloading;
            [fileD startDownloadWord];
            
        }
            break;
        case ButtonDownloading:
        {
            //正在下载状态，暂定下载
            sender.downloadState = ButtonPause;
            [fileD cancelDownloadWord];
        }
            break;
        case ButtonPause:
        {
            //暂停状态，继续下载
            sender.downloadState = ButtonDownloading;
            [fileD startDownloadWord];
        }
            break;
        case ButtonComplete:
        {
            //完成状态，查看文件
            
            NSString *audioPath = [NSString stringWithFormat:@"%@/%@.word",[Tools wordDownloadPath],wordFile.wordName];
            
            NSLog(@"%@",audioPath);
            
            //
            //NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
            NSURL *audioUrl = [[NSURL alloc] initFileURLWithPath:audioPath];

            NSString *path = [[NSBundle mainBundle] pathForResource:@"word1.word" ofType:nil];
            
            //NSString *path = [[NSBundle mainBundle] pathForResource:@"我们都能幸福着 官方版--音悦Tai.mp4" ofType:nil];
            
            NSURL *file_URL = [NSURL fileURLWithPath:path];
            
            //NSLog(@"%@",audioUrl);
            
            
            if (_docController == nil) {
                
                _docController = [[UIDocumentInteractionController alloc] init];
                
                _docController = [UIDocumentInteractionController interactionControllerWithURL:audioUrl];
                _docController.delegate = self;
                
            }else {
                
                _docController.URL = audioUrl;
            }
            
            //直接显示预览
            [_docController presentPreviewAnimated:YES];

            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}


//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView.tag == 10002) {
//        return UITableViewCellEditingStyleDelete;
//    }
//    else
//    {
//        return UITableViewCellEditingStyleNone;
//    }
//    
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView.tag ==10002)
//    {
//        
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            //
//            Word *file = [self.locationWords objectAtIndex:indexPath.row];
//            NSString *path = [NSString stringWithFormat:@"%@/%@",[Tools wordDownloadPath],file.wordName];
//            
//            //从本地文件夹中删除
//            [FILE_M removeItemAtPath:path error:nil];
//            
//            //从tableView中删除
//            [self.locationWords removeObjectAtIndex:indexPath.row];
//            NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.locationWords];
//            
//            [USER_D setObject:Savedata forKey:@"WordList"];
//            [USER_D synchronize];
//            [_wordDownloadTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//            
//        }
//        
//    }
//    
//}






#pragma mark - documentController



- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return  self.view.frame;
}


- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
