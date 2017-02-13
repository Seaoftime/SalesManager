//
//  YWNoticeByIdVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-5.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWNoticeByIdVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "UINavigationBar+customBar.h"

//
#import "WordDownloadBtn.h"
#import "Tools.h"
#import "Word.h"



#define USER_D [NSUserDefaults standardUserDefaults]
#define NOTI_CENTER [NSNotificationCenter defaultCenter]
#define FILE_M [NSFileManager defaultManager]


@interface YWNoticeByIdVC ()<UIDocumentInteractionControllerDelegate>
{
    Word *_word;
    

}
//

@property (strong, nonatomic) UIImageView *addImgV;
@property (strong, nonatomic) UIImageView *fujianImgV;
@property (strong, nonatomic) UIImageView *wordpptImgV;


@property (strong, nonatomic) WordDownloadBtn *downloadBtn;
@property (strong, nonatomic) UIButton *lookBtn;
@property (strong, nonatomic) UILabel *wordpptUrlLb;
@property (nonatomic, retain) UIDocumentInteractionController *docController;


@end

@implementation YWNoticeByIdVC
extern NSString* userid;
extern NSString* randcode;
//@synthesize noticeid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalBgView.frame= CGRectMake(0, 10, kDeviceWidth, KDeviceHeight-75.0);
    self.totalBgView.pagingEnabled = NO;
    self.totalBgView.showsVerticalScrollIndicator = NO;
    self.totalBgView.showsHorizontalScrollIndicator = YES;
   
    self.view.backgroundColor = BGCOLOR;
   
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UILabel *titleText = [TOOL setTitleView:@"通知详情"];
    self.navigationItem.titleView = titleText;
    self.navigationController.navigationBar.backgroundColor = NAVIGATIONCOLOR;
    
    for (int i = 1; i<=4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 35*i, kDeviceWidth, 0.5)];
        [view setBackgroundColor:[UIColor colorWithRed:210/255. green:210/255. blue:210/255. alpha:1]];
        [self.bgView addSubview:view];
    }

    noticDB = [[YNoticDBM alloc]init];
    
    if(self.fromPush||self.fromHomepage)
    {
        noticFileds = [YNoticFileds new];
        noticFileds.noticID = [NSString stringWithFormat:@"%@",self.noticeid];
    }
    else
    {
     noticFileds = [[noticDB findWithNoticID:_noticeid limit:0] objectAtIndex:0];
    }
    
    [self setNoticContent];
    
    [self getNoticeByID];

  
    if (!noticFileds.noticContent) {
        [self getNoticeByID];
    }

    //
    //2
    self.wordDownloadManager = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.remoteWordsArray = [[NSMutableArray alloc] initWithCapacity:0];
    //
    NSData *savedEncodedData = [USER_D objectForKey:@"NoticeWordList"];
    if(!savedEncodedData)
    {
        self.locationWordsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        self.locationWordsArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
    
    //
    
    _word = [[Word alloc] init];
    _word.wordName = @"notice";
    //_word.wordUrl = noticFileds.wordpptUrl;
    [self.remoteWordsArray  addObject:_word];
    

    
    //
    [NOTI_CENTER addObserver:self selector:@selector(wordFileDownloadFinishhh:) name:@"worddownloadFinishh" object:nil];
    

}

- (UIImageView *)fujianImgV
{
    if (_fujianImgV == nil) {
        _fujianImgV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 40, 15, 15)];
        //_fujianImgV.image = [UIImage imageNamed:@"附件"];
        UIImage *image = [[UIImage imageNamed:@"附件"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _fujianImgV.image = image;
        _fujianImgV.tintColor = [UIColor colorWithRed:13/255.0 green:112/255.0 blue:188/255.0 alpha:1.0];
        
        
    }

    return _fujianImgV;
}


- (UIImageView *)wordpptImgV
{
    if (_wordpptImgV == nil) {
        _wordpptImgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 30, 30)];
        //_fujianImgV.image = [UIImage imageNamed:@"附件"];
        UIImage *image = [[UIImage imageNamed:@"word@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _wordpptImgV.image = image;
        //_wordpptImgV.tintColor = [UIColor colorWithRed:13/255.0 green:112/255.0 blue:188/255.0 alpha:1.0];
        
        
    }
    
    return _wordpptImgV;
}



- (UILabel *)wordpptUrlLb
{
    if (!_wordpptUrlLb) {
        _wordpptUrlLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 18, kDeviceWidth - 40, 50)];
        _wordpptUrlLb.font = [UIFont systemFontOfSize:15];
        _wordpptUrlLb.backgroundColor = [UIColor whiteColor];
        _wordpptUrlLb.text = noticFileds.wordpptUrl;
        _wordpptUrlLb.numberOfLines = 0;
        
    }
    return _wordpptUrlLb;
}


- (WordDownloadBtn *)downloadBtn
{
    if (_downloadBtn == nil) {
        _downloadBtn = [[WordDownloadBtn alloc] initWithFrame:CGRectMake(kDeviceWidth/2 + 60, self.addImgV.frame.size.height - 50, 120, 30)];
        _downloadBtn.backgroundColor = [UIColor whiteColor];
        
        _downloadBtn.layer.masksToBounds = YES;
        _downloadBtn.layer.cornerRadius = 5;
        _downloadBtn.layer.borderColor= [UIColor blackColor].CGColor;
        _downloadBtn.layer.borderWidth = 0.5;
        
        
        //
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:141/255.0 blue:247/255.0 alpha:1.0] forState:UIControlStateNormal];
        _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        
//        
        Word *word = self.remoteWordsArray[0];
        
        
        _downloadBtn.wordFile = word;
        //给button关联自己的下载器
        _downloadBtn.fileDownloader = [self.wordDownloadManager objectForKey:word.wordUrl];
        
        
        // //设置button状态
        if ([Tools wordIsDownloadFinish:word])
        {
            //在下载文件夹下存在，说明已经下载完毕
            _downloadBtn.downloadState = ButtonComplete;
        }
        else if ([Tools wordIsFileDownloading:word])
        {
            //在临时文件夹下存在，说明下了一部分
            WordFileDownloader *fileD = [self.wordDownloadManager objectForKey:word.wordUrl];
            
            if ([fileD isDownloadingWord])
            {
                //正在下载
                _downloadBtn.downloadState = ButtonDownloading;
            }
            else
            {
                //暂停
                _downloadBtn.downloadState = ButtonPause;
            }
        }
        else
        {
            _downloadBtn.downloadState = ButtonNormal;
        }
//
//        
        
        
        
        //
        
        [_downloadBtn addTarget:self action:@selector(downloaddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _downloadBtn;
}


- (void)downloaddButtonClicked:(WordDownloadBtn *)btn
{
    
    Word *wordFile = [self.remoteWordsArray objectAtIndex:0];
    
    NSLog(@"%@",wordFile);
    
    WordFileDownloader *fileD = [self.wordDownloadManager objectForKey:wordFile.wordUrl];
    
    if (!fileD) {
        fileD = [[WordFileDownloader alloc] initWithWordFile:wordFile];
        
        [self.wordDownloadManager setObject:fileD forKey:wordFile.wordUrl];
    }
    
    //
    btn.fileDownloader = fileD;
    
    
    switch (btn.downloadState) {
        case ButtonNormal:
        {
            //普通状态，开始下载
            btn.downloadState = ButtonDownloading;
            [fileD startDownloadWord];
            
        }
            break;
        case ButtonDownloading:
        {
            //正在下载状态，暂定下载
            btn.downloadState = ButtonPause;
            [fileD cancelDownloadWord];
        }
            break;
        case ButtonPause:
        {
            //暂停状态，继续下载
            btn.downloadState = ButtonDownloading;
            [fileD startDownloadWord];
        }
            break;
        case ButtonComplete:
        {
            //完成状态，查看文件
            
            NSString *audioPath = [NSString stringWithFormat:@"%@/%@.word",[Tools wordDownloadPath],wordFile.wordUrl];
            //
            NSURL *audioUrl = [[NSURL alloc] initFileURLWithPath:audioPath];

            //NSString *path = [[NSBundle mainBundle] pathForResource:@"Cocos2d-x_中文API部分文档.pdf" ofType:nil];
            
            //NSURL *file_URL = [NSURL fileURLWithPath:path];
            
            NSLog(@"%@",audioUrl);
            
            
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




#pragma mark -监听下载完成-

- (void)wordFileDownloadFinishhh:(NSNotification *)noti
{
    WordFileDownloader *wordFileD = noti.object;
    [self.locationWordsArray addObject:wordFileD.wordFile];
    
    NSData *Savedata = [NSKeyedArchiver archivedDataWithRootObject:self.locationWordsArray];
    
    [USER_D setObject:Savedata forKey:@"NoticeWordList"];
    
    [USER_D synchronize];
    
    NSLog(@"本地数组==%@",self.locationWordsArray);
    
    self.downloadBtn.downloadState = ButtonComplete;
    
    
}







- (void)lookkButtonClicked
{
    
    
}



-(void)getNoticeByID
{
    if (isNetWork) {
        [SVProgressHUD showWithStatus:@"内容更新中,请稍后"];
        
        [[YWNetRequest sharedInstance] requestNoticeDetailsWithId:self.noticeid WithSuccess:^(id respondsData) {
            //
            [self saveNoticContent:(NSDictionary* )respondsData];
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 60200){
            
                
                
                noticFileds.wordpptUrl = [[respondsData objectForKey:@"notice_info"] objectForKey:@"attach"];
                
                
                NSLog(@"%@",noticFileds.wordpptUrl);
                
                _word.wordUrl = noticFileds.wordpptUrl;
                
                
                self.addImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, kDeviceWidth, 150)];
                
                self.addImgV.backgroundColor = [UIColor whiteColor];
                [self.addImgV addSubview:self.fujianImgV];
                //[self.addImgV addSubview:self.wordpptUrlLb];
                [self.addImgV addSubview:self.downloadBtn];
                [self.addImgV addSubview:self.wordpptImgV];
                //
                self.addImgV.userInteractionEnabled = YES;
            
                
                //
                if ([noticFileds.wordpptUrl isEqualToString:@""]) {
                    
                    self.addImgV.hidden = YES;
                    
                }else {
                    
                    [self.view addSubview:self.addImgV];
                }
                
                
                
            }
            
        } failed:^(NSError *error) {
            //
            if (isNetWork) {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }else{
                [SVProgressHUD dismiss];
            }
            
        }];
        
    }
   
}



-(void)setNoticContent{
    
    self.titleLabel.text = noticFileds.noticTitle;
    self.tiemLabel.text = [TOOL convertUnixTime: noticFileds.noticDate timeType:2];
    self.nameLabel.text = noticFileds.fromUserName;
    if ((!noticFileds.toPersonName)||[noticFileds.toPersonName isEqualToString:@"<null>"]) {
        noticFileds.toPersonName = @"";
    }
    if ((!noticFileds.toDepartmentName)||[noticFileds.toDepartmentName isEqualToString:@"<null>"]) {
        noticFileds.toDepartmentName = @"";
    }
    self.forWhoLabel.text =[NSString stringWithFormat:@"%@ %@",noticFileds.toDepartmentName,noticFileds.toPersonName];
    self.contentText.text =noticFileds.noticContent;
    
    
    self.contentText.scrollEnabled = NO;
    [self.contentText setEditable:NO];
    CGRect frame = [[self contentText] frame];
    //frame.size.height = [TOOL getContentSizeHeightForTextView:self.contentText];
    frame.size.height = [TOOL getText:self.contentText.text MinHeightWithBoundsWidth:kDeviceWidth - 24 fontSize:16];
    
        frame.size.height += 40;
 //附件

    
    [self.addImgV setFrame:CGRectMake(0, self.contentText.frame.origin.y + frame.size.height + 20, kDeviceWidth, 150)];
    self.addImgV.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",noticFileds.wordpptUrl);
    
    if ([noticFileds.wordpptUrl isEqualToString:@""]) {
        
        self.addImgV.hidden = YES;
        
    }else {
        
        [self.view addSubview:self.addImgV];
    }
    

    
    
    
//
    self.contentText.frame = frame;
    frame = self.bgView.frame;
    frame.size.height = 150 + self.contentText.frame.size.height;
    self.bgView.frame = frame;
    CGSize newSize = CGSizeMake(kDeviceWidth, frame.size.height);
    
        newSize.height += 40;
    
    
    
    
    
    
    

    [self.totalBgView setContentSize:newSize];

    
    self.contentText.font = [UIFont systemFontOfSize:16];
    
}





- (void)saveNoticContent:(NSDictionary* )noticContent{
    
    if ([[noticContent objectForKey:@"code"] integerValue] == 60200) {
        //YNoticFileds* noticFile = [YNoticFileds new];
        noticFileds.noticContent = [[noticContent objectForKey:@"notice_info"] objectForKey:@"content"];
        noticFileds.noticDate = [[[noticContent objectForKey:@"notice_info"] objectForKey:@"posttime"] integerValue];
        noticFileds.toPersonName = [[noticContent objectForKey:@"notice_info"] objectForKey:@"posttoid"];
        noticFileds.toDepartmentName = [[noticContent objectForKey:@"notice_info"] objectForKey:@"posttopart"];
        noticFileds.fromUserName = [[noticContent objectForKey:@"notice_info"] objectForKey:@"post_name"];
        
        
        
        //新加
        noticFileds.wordpptUrl = [[noticContent objectForKey:@"notice_info"] objectForKey:@"attach"];

        //NSLog(@"%@",noticFileds.wordpptUrl);
        
        
        
        if(noticFileds.noticIsread == 0)
            [TOOL minusIconBadgeNumber];
        noticFileds.noticIsread = 1;
       
        NSLog(@"%@",noticFileds.toDepartmentName);
        if (!noticFileds.toDepartmentName ) {//|| [noticFile.toDepartmentName isEqualToString:@"null"]
            noticFileds.toDepartmentName = @"";
        }
        if ( !noticFileds.toPersonName) {//[noticFile.toPersonName isEqualToString:@"null"] ||
            noticFileds.toPersonName = @"";
        }
        noticFileds.noticID = [[noticContent objectForKey:@"notice_info"] objectForKey:@"id"];
        noticFileds.noticTitle = [[noticContent objectForKey:@"notice_info"] objectForKey:@"title"];
        
        if(self.fromPush||self.fromHomepage)
        {
            [noticDB deleteNoticWithNoticeId:noticFileds.noticID];
            noticFileds.upLoad = 1;
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //
                [noticDB saveNotic:noticFileds success:NO];
            });
            
            //[noticDB saveNotic:noticFileds success:NO];
            
        }
        else
        {
        [noticDB upLoadNoticContent:noticFileds];
            }
    }
    else
    {
        [self checkCodeByJson:noticContent];
    }
    
    //从数据库中找
    //noticFileds = [[noticDB findWithNoticID:self.noticeid limit:1] objectAtIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        noticFileds = [[noticDB findWithNoticID:self.noticeid limit:1] objectAtIndex:0];
        
        
        
        
        NSLog(@"%@",noticFileds.wordpptUrl);
        
        [self setNoticContent];
        
        [SVProgressHUD dismiss];
    });
    
    
    //[self setNoticContent];
    
//    [SVProgressHUD dismiss];
    
}






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














-(void)gotoback
{
//    if(self.fromPush)
//        [self dismissModalViewControllerAnimated:YES];
//    else
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
