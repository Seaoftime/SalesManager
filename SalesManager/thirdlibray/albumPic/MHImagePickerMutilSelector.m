//
//  MHMutilImagePickerViewController.m
//  doujiazi
//
//  Created by Shine.Yuan on 12-8-7.
//  Copyright (c) 2012年 mooho.inc. All rights reserved.
//

#import "MHImagePickerMutilSelector.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UINavigationBar+customBar.h"

#define IOS_VERSION_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))


#define kScreenHeight 480

@interface MHImagePickerMutilSelector ()

@end

@implementation MHImagePickerMutilSelector

@synthesize imagePicker;
@synthesize delegate;

- (id)init:(NSArray* )aseturls :(NSArray* )photosContent :(int)aImageNum
{
    self = [super init];
    if (self) {
        assetUrls = [[NSMutableArray alloc]initWithArray:aseturls];
        photosContents = [[NSMutableArray alloc]initWithArray:photosContent];
        imageNum = aImageNum;
        [self.view setBackgroundColor:[UIColor clearColor]];
        }
    return self;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IS_IOS7) {
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        navigationController.navigationBar.translucent = NO;
        navigationController.view.backgroundColor = BGCOLOR;
    }else{
        [navigationController.navigationBar customNavigationBar];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (navigationController.viewControllers.count>=2)
    {
        float height1 = self.view.frame.size.height-131;
        float height2 = 131;
        if (IS_IOS7) {
            
        }else{
            if (IS_4INCH) {
                height1 += 20;
            }else{
                height1 -= 44;
            }
        }
        
        //[[viewController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, height1)];
        [[viewController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, kDeviceWidth, height1)];
        
        
        
#pragma mark - 照片选择视图 -
        //        selectedPan=[[UIView alloc] initWithFrame:CGRectMake(0, height1, 320, height2)];
        
        selectedPan=[[UIView alloc] initWithFrame:CGRectMake(0, height1, kDeviceWidth, height2)];
        
        
        selectedPan.backgroundColor = [UIColor clearColor];
        selectedPan.userInteractionEnabled = YES;
        [viewController.view addSubview:selectedPan];
        
        //        UIImageView* imv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 131)];
        
        UIImageView* imv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 131)];
        
        
        //        [imv setImage:[UIImage imageNamed:@"img_imagepicker_mutilselectbg"]];
        imv.backgroundColor = [UIColor blackColor];
        imv.alpha = .7;
        [selectedPan addSubview:imv];
        
        textlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 13, 300, 14)];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont systemFontOfSize:14.0f]];
        [textlabel setTextColor:[UIColor whiteColor]];
        //        [textlabel setText:@"当前选中0张(最多20张)"];
        [textlabel setText:[NSString stringWithFormat:@"当前选中0张(最多%d张)",imageNum]];
        [selectedPan addSubview:textlabel];
        
        UIButton*   btn_done=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn_done setFrame:CGRectMake(kDeviceWidth - 80, -2, 80, 44)];
        
        
        
        [btn_done setBackgroundImage:[UIImage imageNamed:@"按钮背景宽.png"] forState:UIControlStateNormal];
        [btn_done setTitle:@"完成" forState:UIControlStateNormal];
        [btn_done setTintColor:[UIColor whiteColor]];
        [btn_done addTarget:self action:@selector(doneHandler) forControlEvents:UIControlEventTouchUpInside];
        [selectedPan addSubview:btn_done];
        
        tbv=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, 90, kDeviceWidth) style:UITableViewStylePlain];
        
        tbv.transform = CGAffineTransformMakeRotation(M_PI * -90 / 180);
        
        
        tbv.center = CGPointMake(kDeviceWidth/2, 131-90/2);
        
        
        [tbv setRowHeight:100];
        [tbv setShowsVerticalScrollIndicator:NO];
        
        
        [tbv setPagingEnabled:YES];
        tbv.dataSource = self;
        tbv.delegate = self;
        
        [tbv setBackgroundColor:[UIColor clearColor]];
        
        
        [tbv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [selectedPan addSubview:tbv];
        
        
        
        [self updateTableView];
        
    }else{
        //        [pics removeAllObjects];
        
        
    }
        
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    NSLog(@"%s",__FUNCTION__);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



//- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
//{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                   animationControllerForOperation:(UINavigationControllerOperation)operation
//                                                fromViewController:(UIViewController *)fromVC
//                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0);
//{
//    NSLog(@"%s",__FUNCTION__);
//}


-(void)doneHandler
{
    if (delegate && [delegate respondsToSelector:@selector(imagePickerMutilSelectorDidGetImages:)]) {
        NSArray* asd = [NSArray arrayWithObjects:assetUrls,photosContents,nil];
        [delegate performSelector:@selector(imagePickerMutilSelectorDidGetImages:) withObject:asd];
    }
    [self close];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return assetUrls.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger row=indexPath.row;
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    
    NSURL *imageUrl= [NSURL URLWithString:[assetUrls objectAtIndex:indexPath.row]];
    [assetLibrary assetForURL:imageUrl resultBlock:^(ALAsset *asset)  {
        UIView* rotateView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 90 , 90)];
        [rotateView setBackgroundColor:[UIColor clearColor]];
        rotateView.transform=CGAffineTransformMakeRotation(M_PI * 90 / 180);
        rotateView.center=CGPointMake(45, 40);
        [rotateView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:rotateView];
        
        UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
        UIImageView* imv=[[UIImageView alloc] initWithImage:image];
        [imv setFrame:CGRectMake(5, 5, 80, 80)];
        [imv setClipsToBounds:YES];
        [imv setContentMode:UIViewContentModeScaleAspectFit];
        [imv.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imv.layer setBorderWidth:2.0f];
        [rotateView addSubview:imv];
        
        UIButton* btn_delete=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_delete setFrame:CGRectMake(74, 0, 21, 21)];
        [btn_delete setImage:[UIImage imageNamed:@"creatReport_upPhoto_delete.png"] forState:UIControlStateNormal];
        //        [btn_delete setCenter:CGPointMake(80, 4)];
        [btn_delete addTarget:self action:@selector(deletePicHandler:) forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setTag:row];
        [rotateView addSubview:btn_delete];
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
    return  cell;
}

-(void)deletePicHandler:(UIButton*)btn
{
    [photosContents removeObjectAtIndex:btn.tag];
    [assetUrls removeObjectAtIndex:btn.tag];
    [self updateTableView];
}

-(void)updateTableView
{
    textlabel.text=[NSString stringWithFormat:@"当前选中%i张(最多%d张)",assetUrls.count,imageNum];
    
    [tbv reloadData];
    
    if (assetUrls.count>3) {
        CGFloat offsetY=tbv.contentSize.height-tbv.frame.size.height-(320-90);
        [tbv setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }else{
        [tbv setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    if (assetUrls.count>=20) {
    if (assetUrls.count>=imageNum) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多添加%d张图片",imageNum]];
    }else{
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSLog(@"info is %@",info);
        BOOL isContain = [assetUrls containsObject:[assetURL absoluteString]];
        if (isContain) {
            [SVProgressHUD showErrorWithStatus:@"图片已添加"];
        }else{
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset)  {
                //UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            [photosContents addObject:[UIImage imageWithCGImage:asset.thumbnail]];
            [assetLibrary release];
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
            }
            ];
            [assetUrls addObject:[assetURL absoluteString]];
            [self updateTableView];
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self close];
}

-(void)close
{
    [imagePicker dismissModalViewControllerAnimated:YES];
    [assetUrls removeAllObjects];
    [photosContents removeAllObjects];
    photosContents = nil;
    assetUrls = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+(void)showInViewController:(UIViewController<UIImagePickerControllerDelegate,MHImagePickerMutilSelectorDelegate> *)vc init:(NSArray* )aseturls :(NSArray* )photosContent :(int)aImageNum
{
    
    
    MHImagePickerMutilSelector* imagePickerMutilSelector=[[MHImagePickerMutilSelector alloc] init:aseturls :photosContent :aImageNum];//自动释放
    imagePickerMutilSelector.delegate=vc;//设置代理
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    
    
    picker.delegate = imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
    [picker setAllowsEditing:NO];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.navigationController.delegate = imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector

    
    imagePickerMutilSelector.imagePicker=picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
    
    [vc presentModalViewController:picker animated:YES];
    
    [picker release];
}

@end
