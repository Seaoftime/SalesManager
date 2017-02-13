//
//  MoviePlayerController.m
//  Video
//
//  Created by User on 15/12/9.
//  Copyright © 2015年 FJY. All rights reserved.
//

#import "MoviePlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define kScreen_Width [[UIScreen mainScreen] bounds].size.width
#define kScreen_Height [[UIScreen mainScreen] bounds].size.height

@interface MoviePlayerController ()
@property(nonatomic,strong)AVPlayerLayer            * playerLayer;//播放需要的layer
@property(nonatomic,strong)AVPlayer                 * player; // 播放属性
@property(nonatomic,strong)AVPlayerItem             * playerItem; // 播放属性
@property(nonatomic,strong)UISlider                 * slider; // 进度条
@property(nonatomic,strong)UILabel                  * currentTimeLabel; // 当前播放时间
@property(nonatomic,strong)UIButton                 * startButton;
@property(nonatomic,strong)UIButton                 * nextButton;
@property(nonatomic,strong)UIButton                 * backButton;
@property(nonatomic,strong)UILabel                  * Title;
@property(nonatomic,strong)UILabel                  * systemTimeLabel; // 系统时间
@property(nonatomic,strong)UIView                   * topView;
@property(nonatomic,strong)UIView                   * backView;
@property(nonatomic,assign)CGPoint                    startPoint;
@property(nonatomic,assign)CGFloat                    systemVolume;
@property(nonatomic,assign)PanDirection               panDirection; // 定义一个实例变量，保存枚举值
@property(nonatomic,strong)UISlider                 * volumeViewSlider;
@property(nonatomic,strong)UIActivityIndicatorView  * activity; // 系统菊花
@property(nonatomic,strong)UIProgressView           * progress; // 缓冲条
@property(nonatomic,strong)UITapGestureRecognizer   * createGesture;
@property(nonatomic,strong)UIPanGestureRecognizer   * panGesture;
@property(nonatomic,strong)NSURL                    * urlStr;
@property(nonatomic,assign)NSInteger                  nextCount;
@property(nonatomic,readonly)BOOL                     isVolume; // 判断是否正在滑动音量
@property(nonatomic,assign)NSTimeInterval             sumTime; // 用来保存快进的总时长
@end

@implementation MoviePlayerController



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}




-(id)initWithURLStr:(NSURL*)aUrl
{
    self = [super init];
    if (self) {
        
        self.urlStr = aUrl;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _nextCount = -1;
    [self.view.layer addSublayer:self.playerLayer];
    [self.player play];
    [self.view     addSubview:self.backView];
    [self.backView addSubview:self.topView];
    [self.backView addSubview:self.progress];
    [self.backView addSubview:self.slider];
    [self.view     addSubview:self.activity];
    [self.backView addSubview:self.currentTimeLabel];
    [self.backView addSubview:self.startButton];
    [self.backView addSubview:self.nextButton];
    [self.topView  addSubview:self.backButton];
    [self.topView  addSubview:self.Title];
    [self.view     addGestureRecognizer:self.createGesture];
    [self.view     addGestureRecognizer:self.panGesture];
    [self.activity startAnimating];
    
    //延迟线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.backView.alpha = 0;
        }];
        
    });
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    
}

- (UIActivityIndicatorView*)activity
{
    if (_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.center = self.backView.center;
        
    }
    return _activity;
}
- (UIView*)topView
{
    if (!_topView) {
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Height, 50)];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.5;
       
    }
    return _topView;
}
- (UIView*)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Height, kScreen_Width)];
        _backView.backgroundColor = [UIColor clearColor];
        

        
    }
    return _backView;
}
- (UIProgressView*)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(102, kScreen_Width-20, kScreen_Height * 0.62, 15)];
        _progress.progressTintColor = [UIColor whiteColor];
        _progress.trackTintColor = [UIColor grayColor];
        
        }
    return _progress;
}
- (UISlider *)slider

{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, kScreen_Height * 0.62, 15)];
        _slider.center = CGPointMake(self.progress.center.x, self.progress.center.y-0.5);
        [_slider setThumbImage:[UIImage imageNamed:@"iconfont-yuanquan-2.png"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
//        _slider.thumbTintColor = [UIColor whiteColor];
       
    }
    return _slider;
}

-(UILabel*)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.progress.frame.origin.x+self.progress.frame.size.width+15, kScreen_Width-33, kScreen_Height-10-self.progress.frame.origin.x-self.progress.frame.size.width-10,25)];
        _currentTimeLabel.text = @"00:00/00:00";
        //_currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:13];
        
        

    }
    return _currentTimeLabel;
    
}
#pragma mark - 播放和下一首按钮
- (UIButton*)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(15, kScreen_Width-35, 30, 30);
        if (self.player.rate == 1.0)
        {
            
            [_startButton setBackgroundImage:[UIImage imageNamed:@"pauseBtn@2x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_startButton setBackgroundImage:[UIImage imageNamed:@"playBtn@2x.png"] forState:UIControlStateNormal];
            
        }
       
        [_startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
       

    }
    return _startButton;
    
}

- (UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(60, kScreen_Width-35, 30, 30);
        
        [_nextButton setBackgroundImage:[UIImage imageNamed:@"nextPlayer@3x.png"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextButton;
}

#pragma mark - 返回按钮方法
- (UIButton*)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(15, 12, 40, 35);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"gobackBtn@2x.png"] forState:UIControlStateNormal];
        
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
    
}

#pragma mark - 创建标题
- (UILabel*)Title
{
    if (!_Title) {
        _Title = [[UILabel alloc]initWithFrame:CGRectMake(self.backButton.frame.origin.x+self.backButton.frame.size.width+20, 20,kScreen_Height-(self.backButton.frame.origin.x+self.backButton.frame.size.width+20)*2, 30)];
       //
        _Title.font = [UIFont systemFontOfSize:14];
        _Title.textColor = [UIColor whiteColor];
        _Title.textAlignment = NSTextAlignmentCenter;
    }
    return _Title;
    
}


#pragma mark - 创建 点按手势
- (UITapGestureRecognizer*)createGesture
{
    if (!_createGesture) {
        _createGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
    }
      return _createGesture;
    
}



#pragma mark - 创建 拖动手势
- (UIPanGestureRecognizer*)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        
    }
    return _panGesture;
    
}
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




/*
*
*  @return 创建播放器层
*/

-(AVPlayerLayer*)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, kScreen_Height, kScreen_Width);
        // playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    }
    return _playerLayer;
}
//*  初始化播放器
//*
//*  @return 播放器对象
//*/
-(AVPlayer *)player
{
    if (!_player) {
       
        _player=[AVPlayer playerWithPlayerItem:self.playerItem];
        //添加监听通知（KVO）
        [self addProgressObserver];
        [self addObserverToPlayerItem:self.playerItem];

        }
    return _player;
}
#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    AVPlayer * player = self.player;
    AVPlayerItem * playerItem = self.player.currentItem;
    UISlider * slider = self.slider;
    __weak  __typeof(self) weakSelf  = self;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        
        if(self.playerItem.status==AVPlayerStatusReadyToPlay)
        {
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            
            [weakSelf.activity startAnimating];
        }
        else
        {
            [weakSelf.activity startAnimating];
        }

        
        //当前时长进度
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([player currentTime]) % 60;//当前分钟
        
        NSInteger durMin = (NSInteger)playerItem.duration.value / playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)playerItem.duration.value / playerItem.duration.timescale % 60;//总分钟
        
        weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",proMin,proSec,durMin, durSec];
        NSLog(@"当前已经播放%.2fs.",current);
        NSLog(@"======%@",weakSelf.currentTimeLabel.text);
        if (current) {
            slider.maximumValue = 1;//总共时长
            slider.value = CMTimeGetSeconds([playerItem currentTime]) / (playerItem.duration.value / playerItem.duration.timescale);//当前进度 ;
        }
    }];
    
}
/**

 *  @return AVPlayerItem对象
 */
-(AVPlayerItem *)playerItem
{
    if (!_playerItem) {
       _playerItem =[AVPlayerItem playerItemWithURL:self.urlStr];
    }
   
    return _playerItem;
}
/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay)
        {
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            
            [self.activity stopAnimating];
        }
        else
        {
            [self.activity startAnimating];
        }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        
         float durMin = self.playerItem.duration.value / self.playerItem.duration.timescale ;//总秒
        self.progress.progress = totalBuffer/durMin;
        NSLog(@"共缓冲：%.2f",totalBuffer);
        
    }
}




#pragma mark - 横屏代码
- (BOOL)shouldAutorotate{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}


#pragma mark - slider滑动事件
- (void)progressSlider:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
        
        //    NSLog(@"%f", total);
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //    NSLog(@"dragedSeconds:%ld",dragedSeconds);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [self.player pause];
        
        [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            
            [self.player play];
            
        }];
        
    }
}





#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton *)button
{
    if (button.selected)
    {
        [self.player play];
        [button setBackgroundImage:[UIImage imageNamed:@"pauseBtn@2x.png"] forState:UIControlStateNormal];
        
    } else {
        [self.player pause];
        [button setBackgroundImage:[UIImage imageNamed:@"playBtn@2x.png"] forState:UIControlStateNormal];
        
    }
    button.selected =!button.selected;
    
}
#pragma mark - 下一影片按钮方法
- (void)nextButton:(UIButton *)button
{
//    _nextCount +=1;
//    NSArray * arr = @[SHIPIN_Two,SHIPIN_One,SHIPIN_Two,SHIPIN_One,SHIPIN_Two];
//    self.urlStr = [NSURL URLWithString:arr[_nextCount]];
//    
//    [self removeNotification];
//    [self removeObserverFromPlayerItem:self.player.currentItem];
//    //切换视频
//    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
//    [self addObserverToPlayerItem:self.playerItem];
//    [self addNotification];
//    
//    if (_nextCount==arr.count-1) {
//        self.nextButton.enabled = NO;
//    }
//    else
//    {
//        self.nextButton.enabled = YES;
//    }
    

}


#pragma mark - 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.backView.alpha == 1) {
        [UIView animateWithDuration:1 animations:^{
            
            self.backView.alpha = 0;
        }];
    } else if (self.backView.alpha == 0){
        [UIView animateWithDuration:1 animations:^{
            
            self.backView.alpha = 1;
        }];
    }
    if (self.backView.alpha == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1 animations:^{
                
                self.backView.alpha = 0;
            }];
            
        });
        
    }
}

#pragma mark - pan水平移动的方法
-(void)panAction:(UIPanGestureRecognizer*)pan
{
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self.view];
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            //            NSLog(@"x:%f  y:%f",veloctyPoint.x, veloctyPoint.y);
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                _panDirection = PanDirectionHorizontalMoved;
                // 取消隐藏
                self.backView.alpha = 1;
               
                // 给sumTime初值
                _sumTime = CMTimeGetSeconds(self.player.currentTime);
            }
            else if (x < y){ // 垂直移动
                _panDirection = PanDirectionVerticalMoved;
                // 显示音量控件
                self.backView.alpha = 1;
                // 开始滑动的时候，状态改为正在控制音量
                _isVolume = YES;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (_panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (_panDirection) {
                case PanDirectionHorizontalMoved:{
                    // ⚠️在滑动结束后，视屏要跳转
                    CMTime dragedCMTime = CMTimeMake(_sumTime, 1);
                    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
                    [self.player play];
                        }];
                    self.backView.alpha = 0;
                    // 把sumTime滞空，不然会越加越多
                    _sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                   
                    // 且，把状态改为不再控制音量
                    _isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - pan垂直移动的方法
- (void)verticalMoved:(CGFloat)value
{
    NSInteger index = (NSInteger)value;
       if(index>0)
        {
            if(index%5==0)
            {//每10个像素声音减一格
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>0.1)
                {
                    _systemVolume = _systemVolume-0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        else
        {
            if(index%5==0)
            {//每10个像素声音增加一格
                NSLog(@"+x ==%ld",index);
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>=0 && _systemVolume<1)
                {
                    _systemVolume = _systemVolume+0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }

}

#pragma mark - pan水平移动的方法
- (void)horizontalMoved:(CGFloat)value
{

    // 每次滑动需要叠加时间
    _sumTime += value / 200;
    // 需要限定sumTime的范围
    if (_sumTime > CMTimeGetSeconds([self.playerItem duration])) {
        _sumTime = CMTimeGetSeconds([self.playerItem duration]);
    }else if (_sumTime < 0){
        _sumTime = 0;
    }
  
    
       //当前时长进度
    NSInteger proMin =   (NSInteger)_sumTime / 60;//当前秒
    NSInteger proSec =   (NSInteger)_sumTime % 60;//当前分钟
    
    NSInteger durMin = (NSInteger)self.playerItem.duration.value / self.playerItem.duration.timescale / 60;//总秒
    NSInteger durSec = (NSInteger)self.playerItem.duration.value / self.playerItem.duration.timescale % 60;//总分钟
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld",proMin,proSec,durMin, durSec];
    
       // 转换成CMTime才能给player来控制播放进度
    
    CMTime dragedCMTime = CMTimeMake(_sumTime, 1);

//    self.slider.maximumValue = 1;//总共时长
//    self.slider.value = _sumTime/(self.playerItem.duration.value / self.playerItem.duration.timescale);//当前进度 ;
//

    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){

        [self.player play];

    }];

}




- (void)moviePlayDidEnd:(id)sender
{
   
    [self.player pause];
    [self dismissViewControllerAnimated:YES completion:^{
    
        [self removeNotification];
        [self removeObserverFromPlayerItem:self.player.currentItem];
         }];
    
}
- (void)backButtonAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.player pause];
        [self removeNotification];
        [self removeObserverFromPlayerItem:self.player.currentItem];
    }];
}



@end
