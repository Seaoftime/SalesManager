//
//  YNewFeatureViewController.m
//  业务点点通
//
//  Created by Kris on 13-11-22.
//  Copyright (c) 2013年 Sky. All rights reserved.
//
#define LOGS_ENABLED NO
#import "YNewFeatureViewController.h"
#import "UIViewController+RECurtainViewController.h"
#import "DRDynamicSlideShow.h"
@interface YNewFeatureViewController ()
{
//    UIPageControl *pageControl;
}

@property (strong, nonatomic) DRDynamicSlideShow * slideShow;
@property (strong, nonatomic) NSArray * viewsForPages;

@property (strong, nonatomic) UIImageView *pageImageView;

@end

@implementation YNewFeatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.slideShow = [DRDynamicSlideShow new];
        self.viewsForPages = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (IS_IOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [self.slideShow setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.slideShow setAlpha:0];
    [self.slideShow setBackgroundColor:[UIColor whiteColor]];
    
    [self.slideShow setDidReachPageBlock:^(NSInteger reachedPage) {
        if (LOGS_ENABLED) NSLog(@"Current Page: %li", (long)reachedPage);
    }];
    
    [self.view addSubview:self.slideShow];
    
#pragma mark DRDynamicSlideShow Subviews
    
    self.viewsForPages = [[NSBundle mainBundle] loadNibNamed:@"featureViews" owner:self options:nil];
    
    [self setupSlideShowSubviewsAndAnimations];
    
    self.pageImageView = [[UIImageView alloc] init];
    self.pageImageView.image = [UIImage imageNamed:@"pageControl1.png"];
    [self.view addSubview:self.pageImageView];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"V%@",VERSIONS];;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor colorWithRed:0.176 green:0.176 blue:0.188 alpha:1.000];
    [self.view addSubview:versionLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];

    
    if (IS_4INCH)
    {
        self.pageImageView.frame = CGRectMake(138, self.slideShow.frame.size.height-40, 198, 10);
        versionLabel.frame = CGRectMake(130, self.slideShow.frame.size.height-25, 63, 16);
        button.frame = CGRectMake(90, 460, 126, 44);
    }else{
        self.pageImageView.frame = CGRectMake(138, self.slideShow.frame.size.height-15, 198, 10);
        versionLabel.frame = CGRectMake(0, self.slideShow.frame.size.height-20, 63, 16);
        button.frame = CGRectMake(90, 410, 126, 44);
    }
    

    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePageImageView:) name:@"changePageImageView" object:nil];
    
}

- (void)changePageImageView:(NSNotification *)aNotification
{
    NSInteger pageNum = [aNotification.object integerValue];
    NSLog(@"%d",pageNum);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pageImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pageControl%d.png",pageNum+1]];
    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackTranslucent;
}

- (void)pressButton:(id)sender
{
    if (self.slideShow.contentOffset.x >= 640)
    {
        UIStoryboard *mainStoryboard = nil;
        //    if (IS_4INCH) {
        //        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //    } else {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //    }
        
        UIViewController *next = [mainStoryboard instantiateViewControllerWithIdentifier:@"login"];
        
        [self curtainRevealViewController:next transitionStyle:RECurtainTransitionHorizontal];
    }
}



- (void)setupSlideShowSubviewsAndAnimations {
    for (UIView * pageView in self.viewsForPages) {
        CGFloat verticalOrigin = self.slideShow.frame.size.height/2-pageView.frame.size.height/2;
        
        for (UIView * subview in pageView.subviews) {
            [subview setFrame:CGRectMake(subview.frame.origin.x, verticalOrigin+subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height)];
            [self.slideShow addSubview:subview onPage:pageView.tag];
            NSLog(@"添加一张");
        }
    }
    
//    UILabel* versionLable = (UILabel* )[self.slideShow viewWithTag:110];
//    versionLable.text = [NSString stringWithFormat:@"V%@",VERSIONS];
    self.slideShow.contentSize = CGSizeMake(960, 0);
    
    
#pragma mark Page 0
    
    UIImageView * textImage = (UIImageView *)[self.slideShow viewWithTag:105];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:textImage page:0 keyPath:@"alpha" toValue:@0 delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:textImage page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(textImage.center.x+self.slideShow.frame.size.width, textImage.center.y+200)] delay:0]];

    UIImageView * image1 = (UIImageView *)[self.slideShow viewWithTag:101];
    UIImageView * image2 = (UIImageView *)[self.slideShow viewWithTag:102];
    UIImageView * image3 = (UIImageView *)[self.slideShow viewWithTag:103];
    UIImageView * image4 = (UIImageView *)[self.slideShow viewWithTag:104];
    
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image1 page:0 keyPath:@"alpha" toValue:@0 delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image2 page:0 keyPath:@"alpha" toValue:@0 delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image3 page:0 keyPath:@"alpha" toValue:@0 delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image4 page:0 keyPath:@"alpha" toValue:@0 delay:0]];
    
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image1 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(image1.center.x+self.slideShow.frame.size.width*2-100, image1.frame.origin.y-200)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image2 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(image2.center.x+self.slideShow.frame.size.width*2-200, image2.center.y-100)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image3 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(image3.center.x+self.slideShow.frame.size.width+200, image3.center.y-100)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:image4 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(image4.center.x+self.slideShow.frame.size.width-200, image4.center.y-100)] delay:0]];
    
    //已经OK
    
    
#pragma mark Page 1
    UIImageView * part2Image1 = (UIImageView *)[self.slideShow viewWithTag:201];
    UIImageView * part2Image2 = (UIImageView *)[self.slideShow viewWithTag:202];
    UIImageView * part2Image3 = (UIImageView *)[self.slideShow viewWithTag:203];
    UIImageView * part2Image4 = (UIImageView *)[self.slideShow viewWithTag:204];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Image1 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Image1.center.x-650, part2Image1.frame.origin.y+250)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Image1 page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    
    
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Image2 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Image2.center.x-650, part2Image2.center.y-100)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Image3 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Image3.center.x+600, part2Image3.center.y-100)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Image4 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Image4.center.x+500, part2Image4.center.y+300)] delay:0]];

    UIImageView * part2Lable1 = (UIImageView *)[self.slideShow viewWithTag:211];
    UIImageView * part2Lable2 = (UIImageView *)[self.slideShow viewWithTag:212];
    UIImageView * part2Lable3 = (UIImageView *)[self.slideShow viewWithTag:213];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Lable1 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Lable1.center.x, part2Lable1.center.y-300)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Lable1 page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Lable2 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Lable2.center.x, part2Lable2.center.y-250)] delay:.7]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Lable2 page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Lable3 page:0 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(part2Lable3.center.x, part2Lable3.center.y-200)] delay:1.7]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:part2Lable3 page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    
    
    UIImageView * logos = (UIImageView *)[self.slideShow viewWithTag:200];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:logos page:0 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    
#pragma mark Page 2
    
    
    UIImageView * aroundView = (UIImageView *)[self.slideShow viewWithTag:304];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:aroundView page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    

    UIImageView * lable3 = (UIImageView *)[self.slideShow viewWithTag:303];
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:lable3 page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0.75]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:lable3 page:1 keyPath:@"transform" fromValue:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(-0.9)] toValue:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(0)] delay:0]];
    
    
    UIImageView* buttonIn = (UIImageView *)[self.slideShow viewWithTag:302];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:buttonIn page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:.99]];
    
    
    UIImageView* start31 = (UIImageView *)[self.slideShow viewWithTag:311];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start31 page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    UIImageView* start32 = (UIImageView *)[self.slideShow viewWithTag:312];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start32 page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    UIImageView* start33 = (UIImageView *)[self.slideShow viewWithTag:313];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start33 page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    UIImageView* start35 = (UIImageView *)[self.slideShow viewWithTag:315];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start35 page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];
    UIImageView* start34 = (UIImageView *)[self.slideShow viewWithTag:314];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start34 page:1 keyPath:@"alpha" fromValue:@0 toValue:@1 delay:0]];

    
    
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start31 page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(start31.center.x-300, start31.frame.origin.y)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start32 page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(start32.frame.origin.x-300, start32.frame.origin.y)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start33 page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(start33.frame.origin.x+200, start33.frame.origin.y)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start34 page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(start34.frame.origin.x+200, start34.frame.origin.y)] delay:0]];
    [self.slideShow addAnimation:[DRDynamicSlideShowAnimation animationForSubview:start35 page:1 keyPath:@"center" toValue:[NSValue valueWithCGPoint:CGPointMake(start35.frame.origin.x-300, start35.frame.origin.y)] delay:0]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.slideShow setAlpha:1];
    } completion:nil];
}

@end
