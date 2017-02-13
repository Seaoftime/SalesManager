//
//  ContactsDetailViewController.m
//  SalesManager
//
//  Created by Kris on 14-2-7.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "ContactsDetailViewController.h"
#import "ILBarButtonItem.h"
#import "YManagerUserInfoFileds.h"
#import "YWEditAddTaskVC.h"
#import "YWNewNoticeViewController.h"
#import "XLMediaZoom.h"

#import "UIImageView+WebCache.h"

@interface ContactsDetailViewController ()

@property (strong, nonatomic) XLMediaZoom *imageZoomView;

- (IBAction)makeaCall:(UIButton *)sender;

@end

@implementation ContactsDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
//    /* Left bar button item */
//    ILBarButtonItem *leftBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"back"]
//                                                   selectedImage:nil
//                                                          target:self
//                                                          action:@selector(backToTop:)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(10, 20, 50, 44)];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* aa = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
    //填充数据
    [self.photoImageView setImageWithURL:[NSURL URLWithString:self.user.userPhotoUrl] placeholderImage:[UIImage imageNamed:@"personPhoto@2x"]];
    
    
    
    self.nameLabel.text = self.user.userName;
    self.phoneLabel.text = self.user.userPhoneNumber;
    self.qqLabel.text = @"";
    self.emailLabel.text = self.user.userEMail;
    self.departmentLabel.text = self.user.userDepartmentName;

    self.positionLabel.text = self.user.positionTitle;
    
  
    

    
    //修改样式
    self.view.backgroundColor = BGCOLOR;
    
    self.photoImageView.layer.cornerRadius = 5;
	self.photoImageView.clipsToBounds = YES;
    [self.photoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTouch:)]];
    
// 
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults.position isEqualToString:@"1"])
    {
        self.noticeButton.hidden = NO;
        self.taskButton.hidden = NO;
    }else{
        self.noticeButton.hidden = YES;
        self.taskButton.hidden = YES;
    }
    
    
//    if (SCREENW > 700.000000) {
//        [self.departmentLabel setFrame:CGRectMake(SCREENW - self.departmentLabel.frame.size.width - 15, self.departmentLabel.frame.origin.y, self.departmentLabel.frame.size.width, self.departmentLabel.frame.size.height)];
//    }
    
    [self.departmentLabel setFrame:CGRectMake(kDeviceWidth - self.departmentLabel.frame.size.width - 25, self.departmentLabel.frame.origin.y, self.departmentLabel.frame.size.width + 10, self.departmentLabel.frame.size.height)];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (XLMediaZoom *)imageZoomView
{
    if (_imageZoomView) return _imageZoomView;
    
    _imageZoomView = [[XLMediaZoom alloc] initWithAnimationTime:@(0.5) image:self.photoImageView blurEffect:YES];
    _imageZoomView.tag = 1;
    _imageZoomView.backgroundColor = [UIColor blackColor];
    
    return _imageZoomView;
}

- (void)imageDidTouch:(UIGestureRecognizer *)recognizer
{
//    [self.photoImageView setImageWithURL:[NSURL URLWithString:self.user.userPhotoUrl]];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.imageZoomView];
    [self.imageZoomView show];
    
}

- (void)backToTop:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendNotice:(id)sender
{
    YWNewNoticeViewController *vc = [[YWNewNoticeViewController alloc]init];
    vc.fromContacts = @"1";
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"0" forKey:@"all"];
    [dic setObject:[NSArray array] forKey:@"partid"];
    [dic setObject:[NSArray array] forKey:@"partname"];
    [dic setObject: [NSArray arrayWithObject:[NSString stringWithFormat:@"%i",self.user.userID]] forKey:@"peopleid"];
    [dic setObject:[NSArray arrayWithObject:self.user.userName]forKey:@"peoplename"];
    vc.sendPeopleData = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sendTask:(id)sender
{
    YWEditAddTaskVC *vc = [[YWEditAddTaskVC alloc]init];
    vc.isAdd = @"1";
    vc.selectedppString = self.user.userName;
    vc.selectedPID = [NSString stringWithFormat:@"%i",self.user.userID];
    vc.fromContacts = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)makeaCall:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:[NSString stringWithFormat:@"打电话给 %@（%@）",self.user.userName,self.user.userPhoneNumber], [NSString stringWithFormat:@"发短信给 %@（%@）",self.user.userName,self.user.userPhoneNumber], [NSString stringWithFormat:@"复制号码 %@",self.user.userPhoneNumber],nil];
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    switch (buttonIndex)
    {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.user.userPhoneNumber]]];
            
            
            
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.user.userPhoneNumber]]];
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.user.userPhoneNumber]]];
        }
            break;
        case 2:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.user.userPhoneNumber;
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }
            break;
        default:
            break;
    }
    
}

@end
