



//
//  YWSeePictureVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-9.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWSeePictureVC2.h"
#import "DLImageView.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "YPcituresFileds.h"

#import "UIImageView+WebCache.h"
@interface YWSeePictureVC2 ()

@end

@implementation YWSeePictureVC2

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
    // Do any additional setup after loading the view, typically from a nib.
    scrollviewArray =[NSMutableArray new];
    bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,KDeviceHeight)];
    scrollFrame = bigScrollView.frame;
    
    bigScrollView.backgroundColor = [UIColor blackColor];
    
    bigScrollView.contentSize = CGSizeMake(kDeviceWidth*3, KDeviceHeight);// 设置内容大小
    bigScrollView.delegate = self;
    
    bigScrollView.pagingEnabled = YES;
    
    bigScrollView.showsHorizontalScrollIndicator = NO;//滚动的时候是否有水平的滚动条，默认是有的
    totalPage = (int)[self.photosInfo count];
    
    curImages=[[NSMutableArray alloc] init];
    
    
#if 0
    
    int a = 0;
    
    for (int i = 0; i <[self.photosInfo count]; i++) {
        
        UIScrollView *sv  =[[UIScrollView alloc] initWithFrame:CGRectMake(0+a, 0,kDeviceWidth,KDeviceHeight)];
        
        sv.pagingEnabled = NO;
        
        sv.scrollEnabled = YES;
        
        sv.backgroundColor = [UIColor blackColor];
        
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = YES;
        sv.delegate = self;
        CGSize newSize = CGSizeMake(kDeviceWidth,KDeviceHeight);
        [sv setContentSize:newSize];
        sv.minimumZoomScale = 1.0;
        sv.maximumZoomScale = 5.0;
        [sv setZoomScale:1.0];
        
        DLImageView *imageView = [[DLImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;//实现自动根据尺寸适应相框
        // imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        YPcituresFileds* pciture = [self.photosInfo objectAtIndex:i];
        UIImageView* aaa = [[UIImageView alloc]init];
        [aaa setImageWithURL:[NSURL URLWithString:pciture.photoUrl] ];
        
        [imageView setImageWithURL:[NSURL URLWithString:pciture.phtotBigPhotoUrl] placeholderImage:aaa.image ];
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [singleFingerOne setDelegate:self];
        [imageView addGestureRecognizer:singleFingerOne];     //imageView 增加触摸事件
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleFingerEvent:)];
        doubleTap.numberOfTouchesRequired = 1; //手指数
        doubleTap.numberOfTapsRequired = 2; //tap次数
        [doubleTap setDelegate:self];
        [imageView addGestureRecognizer:doubleTap];     //imageView 增加触摸事件
        [imageView setUserInteractionEnabled:YES];
        [singleFingerOne requireGestureRecognizerToFail:doubleTap];  //防止双击事件被单击拦截
        
        [scrollviewArray addObject:sv];
        [sv addSubview:imageView];
        [bigScrollView addSubview:sv];
        
        
        
        //
        a += kDeviceWidth;
        
    }
#endif
    
    [self.view addSubview:bigScrollView];
    [self refreshScrollView];
    
    YPcituresFileds* pciture2 = [self.photosInfo objectAtIndex:(self.currentPic-1)];
    
    notesView = [[PicNotesView alloc]initWithFrame:CGRectMake(0, (KDeviceHeight-68), kDeviceWidth, 58)];
    //notesView.backgroundColor = [UIColor redColor];
    notesView.indexLabel.frame = CGRectMake(kDeviceWidth/2 - 20, 0, 40, 40);
    
    //notesView.center = CGPointMake(kDeviceWidth/2 , (KDeviceHeight-68));
    
    notesView.indexLabel.text = [NSString stringWithFormat:@"%i/%i",self.currentPic,(int)self.photosInfo.count];
    notesView.contentView.text = pciture2.photoContent;
    
    if([notesView.contentView.text isEqualToString:@""])
    {
        notesView.contentView.hidden = YES;
    }
    else
    {
        notesView.contentView.hidden = NO;
    }
    [self.view addSubview:notesView];
    notesView.alpha = 1.0;
    //  [bigScrollView setContentOffset:CGPointMake(kDeviceWidth * self.currentPic, 0)];
    
    naviView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    naviView.bgImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //
    naviView.titleLabel.frame = CGRectMake(kDeviceWidth/2 - 100, 10, 200, 64);
    
    naviView.titleLabel.text = self.albumTitle;
    naviView.titleLabel.textColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    [naviView.leftButton setFrame:CGRectMake(10, 20, 50, 44)];
    [naviView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    naviView.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.leftButton setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [naviView.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [naviView.leftButton  addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    
    
    [naviView.rightBtton setFrame:CGRectMake(kDeviceWidth - 100, 10, 100, 64)];
    
    [naviView.rightBtton  setTitle:@"保存" forState:UIControlStateNormal];
    naviView.rightBtton.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView.rightBtton  addTarget:self action:@selector(savePic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviView];
    //naviView.hidden = YES;
    naviView.alpha = 1.0;
}

- (void) refreshScrollView
{
    NSArray *subViews=[bigScrollView subviews];
    if([subViews count]!=0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSLog(@"%i",_currentPic);
    [self getDisplayImagesWithCurpage:_currentPic];
    int a =0;
    
    for (int i = 0; i<3; i++) {
        UIScrollView *sv  =[[UIScrollView alloc] initWithFrame:CGRectMake(0+a, 0,kDeviceWidth,KDeviceHeight)];
        sv.pagingEnabled = NO;
        sv.scrollEnabled = YES;
        sv.backgroundColor = [UIColor blackColor];
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = YES;
        sv.delegate = self;
        CGSize newSize = CGSizeMake(kDeviceWidth,KDeviceHeight);
        [sv setContentSize:newSize];
        sv.minimumZoomScale = 1.0;
        sv.maximumZoomScale = 5.0;
        [sv setZoomScale:1.0];
        
        DLImageView *imageView = [[DLImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;//实现自动根据尺寸适应相框
        // imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        YPcituresFileds* pciture = [curImages objectAtIndex:i];
        UIImageView* aaa = [[UIImageView alloc]init];
        [aaa setImageWithURL:[NSURL URLWithString:pciture.photoUrl] ];
        
        [imageView setImageWithURL:[NSURL URLWithString:pciture.phtotBigPhotoUrl] placeholderImage:aaa.image];
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [singleFingerOne setDelegate:self];
        [imageView addGestureRecognizer:singleFingerOne];     //imageView 增加触摸事件
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleFingerEvent:)];
        doubleTap.numberOfTouchesRequired = 1; //手指数
        doubleTap.numberOfTapsRequired = 2; //tap次数
        [doubleTap setDelegate:self];
        [imageView addGestureRecognizer:doubleTap];     //imageView 增加触摸事件
        [imageView setUserInteractionEnabled:YES];
        [singleFingerOne requireGestureRecognizerToFail:doubleTap];  //防止双击事件被单击拦截
        [sv addSubview:imageView];
        [bigScrollView addSubview:sv];
        
        a += kDeviceWidth;
    }
    [bigScrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
}

- (NSArray*) getDisplayImagesWithCurpage:(int)page
{
    NSInteger pre=[self validPageValue:_currentPic-1];
    NSInteger last=[self validPageValue:_currentPic+1];
    if([curImages count]!=0)    [curImages removeAllObjects];
    [curImages addObject: [self.photosInfo objectAtIndex:pre-1]];
    [curImages addObject:[self.photosInfo objectAtIndex:_currentPic-1]];
    [curImages addObject:[self.photosInfo objectAtIndex:last-1]];
    return curImages;
}

- (NSInteger)validPageValue:(NSInteger)value
{
    if(value==0)    value=totalPage;    //value＝1为第一张，value=0为前面一张
    if(value==totalPage+1)  value=1;
    return value;
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == bigScrollView)
    {
        int x=scrollView.contentOffset.x;
        if(x>=2*scrollFrame.size.width) //往下翻一张
        {
            _currentPic = (int)[self validPageValue:_currentPic+1];
            [self refreshScrollView];
        }
        
        if(x<=0)
        {
            _currentPic = (int)[self validPageValue:_currentPic-1];
            [self refreshScrollView];
        }
    }
}

-(void)handleSingleFingerEvent:(UIGestureRecognizer *)gesture{
    if (  naviView.alpha == 0.0) {
        [UIView animateWithDuration:0.4 animations:^{
            naviView.alpha = 1.0;
            notesView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:0.4 animations:^{
            naviView.alpha = 0.0;
            notesView.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)handleDoubleFingerEvent:(UIGestureRecognizer *)gesture{
    //NSLog(@"offset:%f",bigScrollView.contentOffset.x);
    //int atIndex = bigScrollView.contentOffset.x/320;
    int atIndex = bigScrollView.contentOffset.x/kDeviceWidth;
    
    NSArray *subViews=[bigScrollView subviews];
    
    UIScrollView *s = [subViews objectAtIndex:atIndex];
    
    float newScale= 0;
    if (s.zoomScale<=1.0) {
        newScale=s.zoomScale * 2.0;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [s zoomToRect:zoomRect animated:YES];
    }
    else
    {
        [s setZoomScale:1.0 animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.view.frame.size.height / scale;
    zoomRect.size.width  = self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

-(void)savePic
{
    //int indexPic = bigScrollView.contentOffset.x/kDeviceWidth;
    
    YPcituresFileds* picInfo = [self.photosInfo objectAtIndex:_currentPic-1];
    NSString *ccmd5Path = [TOOL convertCCMD5Path:picInfo.phtotBigPhotoUrl];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:ccmd5Path])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:ccmd5Path];
        //  [naviView.leftButton setImage:image forState:UIControlStateNormal];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:),nil);
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"图片未加载成功，保存失败"];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showSuccessWithStatus:@"保存失败"];
        });
    }
    
}


-(void)gotoback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -scrollview delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    [scrollView setZoomScale:scale animated:YES];
    [scrollView setZoomScale:scale animated:YES];
}

//3、将要结束拖拽，手指已拖动过view并准备离开手指的那一刻，注意：当属性pagingEnabled为YES时，此函数不被调用
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}
//4、已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
//5、view将要开始减速，view滑动之后有惯性
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}
//6、view已经停止滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == bigScrollView)
    {
        // NSLog(@"%f",scrollView.contentOffset.x);
        // int indexPic = scrollView.contentOffset.x/kDeviceWidth;
        
        /**
         *  图片下面显示  第几张
         */
        YPcituresFileds* picInfo = [self.photosInfo objectAtIndex:self.currentPic-1];
        notesView.indexLabel.text = [NSString stringWithFormat:@"%i/%lu",self.currentPic,(unsigned long)[self.photosInfo count]];
        notesView.contentView.text = [picInfo photoContent];
        if([notesView.contentView.text isEqualToString:@""])
        {
            notesView.contentView.hidden = YES;
        }
        else
        {
            notesView.contentView.hidden = NO;
        }
        
        // naviView.titleLabel.text = [picInfo albumTitle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

