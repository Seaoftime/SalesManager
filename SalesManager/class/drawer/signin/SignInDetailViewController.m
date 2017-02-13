//
//  SignInDetailViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SignInDetailViewController.h"
#import <MapKit/MapKit.h>
#import "SVPulsingAnnotationView.h"
#import "SVAnnotation.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "ILBarButtonItem.h"
#import "CLLocation+YCLocation.h"

@interface SignInDetailViewController () <MKMapViewDelegate>
{
	YManagerUserInfoDBM *userDBM;
}

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIView *contentBackgroundView;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mapBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *locationBackgoundView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backToTop:(id)sender;

@end

@implementation SignInDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    
	if (self) {
		signInDB = [[YSignInDBM alloc]init];
		userDBM = [[YManagerUserInfoDBM alloc] init];
	}
    
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	if (_isPush) {
		if (IS_IOS7) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
			self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
			self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
			self.navigationController.navigationBar.translucent = NO;
		}
        
        if (_isHome) {
            self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
        }else{
            self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(xiaoshi)];
        }
        
	}
	else {
//
        self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
	}
    
//	for (int i = 1; i <= 2; i++) {
//		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * i, kDeviceWidth, 0.5)];
//		view.backgroundColor = [UIColor colorWithRed:210 / 255. green:210 / 255. blue:210 / 255. alpha:1];
//        //view.backgroundColor = [UIColor redColor];
//		[_contentBackgroundView addSubview:view];
//	}
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kDeviceWidth, 0.5)];
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 62, kDeviceWidth, 0.5)];
    lineV1.backgroundColor = [UIColor colorWithRed:210 / 255. green:210 / 255. blue:210 / 255. alpha:1];
    lineV2.backgroundColor = [UIColor colorWithRed:210 / 255. green:210 / 255. blue:210 / 255. alpha:1];
    [_contentBackgroundView addSubview:lineV1];
    [_contentBackgroundView addSubview:lineV2];
    
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	if (userDefault.mapWithWifi) {
		if ([TOOL IsEnableWIFI]) {
//
			self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 240)];
			self.mapView.delegate = self;
			[self.mapBackgroundView addSubview:self.mapView];
			[self.mapBackgroundView sendSubviewToBack:self.mapView];
            
			self.locationBackgoundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
		}
		else {
			self.locationBackgoundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
		}
	}
	else {
        /**
         地图
         
         - returns: <#return value description#>
         */
		self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 240)];
        
		self.mapView.delegate = self;
		[self.mapBackgroundView addSubview:self.mapView];
		[self.mapBackgroundView sendSubviewToBack:self.mapView];
        
		self.locationBackgoundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
	}
    
    
	if (!_isPush) {
		_signInFileds = [[signInDB findWithSignInTime:_signInFileds limit:0] objectAtIndex:0];
	}
    
	if (!_signInFileds.signInContent) {
		[self getSignInContent:_signInFileds.signInID];
	}
	else {
		[self updateData];
	}
    
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    //self.contentTextView.font = [UIFont boldSystemFontOfSize:14];
}


- (void)updateData {
	@try {
		YManagerUserInfoFileds *user = [userDBM getPersonInfoByUserID:[_signInFileds.signInPersonID intValue]  withPhotoUrl:NO withDepartment:NO withContacts:NO];
        
		_nameLabel.text = user.userName;
		_timeLabel.text = [TOOL convertUnixTime:_signInFileds.signInTime timeType:1];
        
        
		if ([_signInFileds.signInContent isEqualToString:@""] || [_signInFileds.signInContent isEqualToString:@"(null)"]) {
			self.contentTextView.text = @"无备注信息";
		}
		else {
			self.contentTextView.text = _signInFileds.signInContent;
		}
        NSLog(@"%@", NSStringFromCGRect(self.contentTextView.frame));

        CGRect textViewFrame = self.contentTextView.frame;
//        textViewFrame.size.height = [TOOL getContentSizeHeightForTextView:self.contentTextView];
        
        textViewFrame.size.height = [TOOL getText:self.contentTextView.text MinHeightWithBoundsWidth:kDeviceWidth - 24 fontSize:14] + 20;
        
        self.contentTextView.frame = textViewFrame;
		NSLog(@"%@", NSStringFromCGRect(self.contentTextView.frame));
        
        if ([_signInFileds.myLocation isEqualToString:@"无法获取城市信息"]) {
            _locationLabel.text = @"";
        }else{
           _locationLabel.text = _signInFileds.myLocation;
        }
		
		CGRect frame = _contentBackgroundView.frame;
		[_contentBackgroundView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height)];
        
		frame = _mapBackgroundView.frame;
		[_mapBackgroundView setFrame:CGRectMake(frame.origin.x, _contentBackgroundView.frame.origin.y + _contentBackgroundView.frame.size.height + 10, frame.size.width, frame.size.height)];
        
        [self.scrollView setContentSize:CGSizeMake(320, _mapBackgroundView.frame.origin.y+_mapBackgroundView.frame.size.height+10)];
        
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		if (userDefault.mapWithWifi) {
			if ([TOOL IsEnableWIFI]) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:[_signInFileds.latitude doubleValue] longitude:[_signInFileds.longitude doubleValue]];
                location = [location locationMarsFromBaidu];
                
				[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000) animated:YES];
                
				SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:location.coordinate];
				[self.mapView addAnnotation:annotation];
			}
		}
		else {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[_signInFileds.latitude doubleValue] longitude:[_signInFileds.longitude doubleValue]];
            location = [location locationMarsFromBaidu];
			[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000) animated:YES];
            
			SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:location.coordinate];
			[self.mapView addAnnotation:annotation];
		}
	}
	@catch (NSException *exception)
	{
		YWErrorDBM *ad = [[YWErrorDBM alloc]init];
		[ad saveAnErrorInfo:[NSString stringWithFormat:@"Class:%@\nFun:%s\n", self.class, __FUNCTION__]];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)backToTop:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)xiaoshi {
	[self.navigationController dismissViewControllerAnimated:YES completion: ^{
	}];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation> )annotation {
	if ([annotation isKindOfClass:[SVAnnotation class]]) {
		static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
		if (pulsingView == nil) {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
			pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
			pulsingView.canShowCallout = YES;
		}
        
		return pulsingView;
	}
    
	return nil;
}

#pragma mark - 获取签到详情

- (void)getSignInContent:(NSString *)signInID {
    
	if (isNetWork) {
		
        [[YWNetRequest sharedInstance] requestgetSignInDetailsWithSignInId:signInID WithSuccess:^(id respondsData) {
            //
            if ([[respondsData objectForKey:@"code"] integerValue] == 40200)
            {
                YSignInFields *signInFileds = [YSignInFields new];
                signInFileds.signInContent = [[respondsData objectForKey:@"location_info"] objectForKey:@"content"];
                signInFileds.signInTime = [[[respondsData objectForKey:@"location_info"] objectForKey:@"time"] integerValue];
                signInFileds.longitude = [[respondsData objectForKey:@"location_info"] objectForKey:@"longitude"];
                signInFileds.latitude = [[respondsData objectForKey:@"location_info"] objectForKey:@"latitude"];
                signInFileds.signInID = [[respondsData objectForKey:@"location_info"] objectForKey:@"id"];
                signInFileds.signInTitle = [[respondsData objectForKey:@"location_info"] objectForKey:@"title"];
                signInFileds.upload = 1;
                signInFileds.signInPersonID = [[respondsData objectForKey:@"location_info"] objectForKey:@"user_id"];
                signInFileds.myLocation = [[respondsData objectForKey:@"location_info"] objectForKey:@"address"];
                if (_isPush) {
                    [signInDB saveSignIn:signInFileds];
                }else{
                    [signInDB upLoadSignIn:signInFileds];
                }
                _signInFileds = [[signInDB findWithSignInTime:_signInFileds limit:0] objectAtIndex:0];
                
                [self updateData];
                NSLog(@"加载成功");
            }
            
        } failed:^(NSError *error) {
            //
            if (isNetWork) {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
            else {
                [SVProgressHUD dismiss];
            }
            
        }];

        
        
	}
}

@end
