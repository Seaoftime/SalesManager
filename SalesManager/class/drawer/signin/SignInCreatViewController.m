 //
//  SignInCreatViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SignInCreatViewController.h"
#import <MapKit/MapKit.h>
#import "XHLocationManager.h"
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"
#import "YSignInDBM.h"
#import "YSignInFields.h"
#import "SignInViewController.h"
#import "ILBarButtonItem.h"
#import "CLLocation+YCLocation.h"

@interface SignInCreatViewController ()<MKMapViewDelegate>
{
    NSString *latitude;
    NSString *longitude;
    SVAnnotation *annotation;
}

@property (strong, nonatomic) IBOutlet UIView *mapBackgoundView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITextView *remarkTextView;
@property (strong, nonatomic) IBOutlet UIView *locationBackgoundView;
@property (strong, nonatomic) NSTimer* timer;

- (IBAction)backToTop:(id)sender;
-(IBAction)upLoadSignIn:(id)sender;



@end

@implementation SignInCreatViewController



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
	// Do any additional setup after loading the view.
    
    latitude = nil;
    longitude = nil;
    
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
    /* Right bar button item */
    ILBarButtonItem *rightBtn = [ILBarButtonItem barItemWithTitle:@"发送"
                                                       themeColor:[UIColor whiteColor]
                                                           target:self
                                                           action:@selector(upLoadSignIn:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //地图背景图
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    if (userDefault.mapWithWifi)
    {
        
        if ([TOOL IsEnableWIFI])
        {
            /**
             地图
             
             - returns: <#return value description#>
             */
            if (kDeviceWidth > 700.000000) {
                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 400)];
            }else
                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 240)];
            
            
            
            self.mapView.delegate = self;
            [self.mapBackgoundView addSubview:self.mapView];
            [self.mapBackgoundView sendSubviewToBack:self.mapView];
            
            self.locationBackgoundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        }else{
            self.locationBackgoundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        }
    }else{
        
        if (kDeviceWidth > 700.000000) {
            self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 400)];
        }else
            self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 240)];

        
        [self.mapView setMapType:MKMapTypeStandard];
        self.mapView.delegate = self;
        [self.mapBackgoundView addSubview:self.mapView];
        [self.mapBackgoundView sendSubviewToBack:self.mapView];
        
        self.locationBackgoundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    }
    
    //签到备注
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
    }else{
        [self.activityIndicatorView stopAnimating];
        
        //self.locationLabel.text = @"定位失败";
        
        self.locationLabel.text = @"正在定位...";
        
        //NSLog(@"用户不允许定位，即没有在设置中开启定位");
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法获取你的位置信息" message:@"请到手机系统的【设置】->【隐私】->【定位服务】中开启定位服务，并允许业务云管家使用定位服务。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //[alertView show];
    }
    
    //地图定位
    [self startLocation];
    
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(startLocation) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startLocation
{
    //地图定位
    [[XHLocationManager sharedManager] locationRequest:^(CLLocation *location, NSError *error) {
        if (error == nil)
        {
            NSLog(@"%@",location);
            
            //火星坐标转成百度坐标，传给服务器用
            CLLocation *baidulocation = [location locationBaiduFromMars];
            latitude = [NSString stringWithFormat:@"%f",baidulocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",baidulocation.coordinate.longitude];
            
            NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
            if (userDefault.mapWithWifi)
            {
                if ([TOOL IsEnableWIFI])
                {
                    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05));
                    [self.mapView setRegion:region animated:NO];

                    if (!annotation) {
                        annotation = [[SVAnnotation alloc] initWithCoordinate:location.coordinate];
                    }else{
                        annotation.coordinate = location.coordinate;
                    }
                    
                    [self.mapView addAnnotation:annotation];
                }
            }else{
                MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05));
                [self.mapView setRegion:region animated:NO];
                
                if (!annotation) {
                    annotation = [[SVAnnotation alloc] initWithCoordinate:location.coordinate];
                }else{
                    annotation.coordinate = location.coordinate;
                }
                
                [self.mapView addAnnotation:annotation];
            }
        } else {
            NSLog(@"%@",error);
            [self.activityIndicatorView stopAnimating];
            self.locationLabel.text = @"定位失败";
        }
    } reverseGeocodeCurrentLocation:^(CLPlacemark *placemark, NSError *error) {
        [self.activityIndicatorView stopAnimating];
        if (error == nil) {
            NSLog(@"%@",placemark);
            self.locationLabel.text = placemark.name;
        } else {
            NSLog(@"%@",error);
            if ([self.locationLabel.text isEqualToString:@"        正在定位..."])
            {
                self.locationLabel.text = @"无法获取城市信息";
            }
        }
    }];
}

- (IBAction)backToTop:(id)sender
{
    if(self.remarkTextView.text.length > 0){
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"  message:@"返回后您填写的数据将会被抹掉，是否要继续" delegate:self cancelButtonTitle:@"不，继续编辑" otherButtonTitles:@"确定", nil];
    [alert show];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation1
{
    if([annotation1 isKindOfClass:[SVAnnotation class]])
    {
        static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(pulsingView == nil)
        {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation1 reuseIdentifier:identifier];
            pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            pulsingView.canShowCallout = YES;
        }
		
		return pulsingView;
    }
    
    return nil;
}


-(IBAction)upLoadSignIn:(id)sender
{
//    if ([self.locationLabel.text isEqualToString:@"        正在定位..."]||[self.locationLabel.text isEqualToString:@""]||[self.locationLabel.text isEqualToString:@"定位失败"])
    if (latitude == nil && longitude == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"无法定位不能签到" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        YSignInFields *signInField = [[YSignInFields alloc] init];
        signInField.upload = 0;
        signInField.longitude = longitude;
        signInField.latitude = latitude;
        signInField.signInContent = self.remarkTextView.text;
        signInField.signInTime = [[NSDate date] timeIntervalSince1970];
        if ([self.locationLabel.text isEqualToString:@"        正在定位..."])
        {
            self.locationLabel.text = @"无法获取城市信息";
        }
        signInField.myLocation = self.locationLabel.text;
        signInField.signInPersonID = userDefaults.ID;
        
        YSignInDBM *signInDBM = [[YSignInDBM alloc] init];
        [signInDBM saveSignIn:signInField];
        
        NSLog(@"%@",self.navigationController.viewControllers);
        
        SignInViewController *signInViewController = (SignInViewController *)[self.navigationController.viewControllers objectAtIndex:0];
        [signInViewController addCell:signInField];
        
        [self.remarkTextView resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
