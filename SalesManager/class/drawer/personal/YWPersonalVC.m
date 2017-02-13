//
//  YWPersonalVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-23.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWPersonalVC.h"
#import "UIViewController+MMDrawerController.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequestDelegate.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "UINavigationBar+customBar.h"
@interface YWPersonalVC ()

@end

@implementation YWPersonalVC

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
    if (IS_IOS7) {
        self.navigationController.navigationBar.translucent = NO;
    }
    userInfoDB = [[YUserInfomationDBM alloc]init];
    userInfoFiles = [[YuserInfomationFileds alloc]init];
     userInfoFiles= [userInfoDB getUSerInfomations:userID :company_Code];
    if(!IS_IOS7)
        [self.navigationController.navigationBar customNavigationBar];

    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"首页" target:self selector:@selector(gotoback)];

    UILabel *titleText = [TOOL setTitleView:@"个人信息"];
    self.navigationItem.titleView = titleText;
    
    self.view.backgroundColor = BGCOLOR;
    
    self.portraitImage.layer.cornerRadius = 5.0;
    [self.portraitImage setClipsToBounds:YES];
    
    
    
    selectPortraitSheet =[[UIActionSheet alloc]
                  initWithTitle:Nil
                  delegate:self
                  cancelButtonTitle:@"取消"
                  destructiveButtonTitle:Nil
                  otherButtonTitles:@"拍照",@"选择本地图片",nil];
    
    
    [self createPersonInfoView];
    [self getPersonInfoData];
    
    
    if (KDeviceHeight == 480.000000) {
        [self.companyBgView setFrame:CGRectMake(0, self.companyBgView.frame.origin.y - 10, kDeviceWidth, self.companyBgView.frame.size.height)];
        
        [self.personalBgView setFrame:CGRectMake(0, self.personalBgView.frame.origin.y - 20, kDeviceWidth, self.personalBgView.frame.size.height)];
        
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (KDeviceHeight == 480.000000) {
//        [self.companyBgView setFrame:CGRectMake(0, self.companyBgView.frame.origin.y - 10, kDeviceWidth, self.companyBgView.frame.size.height)];
//        
//        [self.personalBgView setFrame:CGRectMake(0, self.personalBgView.frame.origin.y - 20, kDeviceWidth, self.personalBgView.frame.size.height)];
//        
//    }


}

-(void)getPersonInfoData
{
    [[YWNetRequest sharedInstance] requestPersonInfoDataWithSuccess:^(id respondsData) {
        //
        if ([[respondsData objectForKey:@"code"] integerValue] == 110200) {
            [self savePersonInfoData:respondsData];
        }
        
    } failed:^(NSError *error) {
        //
    }];
}

-(void)setPersonInfoView{
#if 0
    self.titleLabel.text = noticFileds.noticTitle;
    self.tiemLabel.text = [TOOL convertUnixTime: noticFileds.noticDate timeType:2];
    self.nameLabel.text = noticFileds.fromUserName;
    self.forWhoLabel.text =[NSString stringWithFormat:@"%@ %@",noticFileds.toPersonName,noticFileds.toDepartmentName];
    self.contentText.text =noticFileds.noticContent;
    CGSize size = [self.contentText.text sizeWithFont: [UIFont boldSystemFontOfSize:14.0]
                                    constrainedToSize: CGSizeMake(290.0f, 9999999.0f)
                                        lineBreakMode: NSLineBreakByWordWrapping];
    self.contentText.scrollEnabled = YES;
    [self.contentText setEditable:NO];
    [self.contentText setContentSize:size];
    if (self.contentText.contentSize.height <= self.contentText.frame.size.height) {
        [self.contentText setUserInteractionEnabled:NO];
    }
#endif
    
}

-(void)createPersonInfoView{
    
    [self.portraitImage setImageWithURL:[NSURL URLWithString:[userInfoFiles.userPicUrl stringByAppendingString:@"_small220190"]] placeholderImage:[UIImage imageNamed:@"personPhoto.png"]];
    NSLog(@"%@",userInfoFiles.userPicUrl);
self.companyIDLabel.text = userInfoFiles.companyCode;
self.companyNameLabel.text =  userInfoFiles.companyName;
self.personalIDLabel.text = userInfoFiles.userName;
self.personalNameLabel.text =  userInfoFiles.name;
self.personalPhoneNumberLabel.text = userInfoFiles.mobile;
self.personalPartmentLabel.text =  userInfoFiles.department;
self.personalPositionLabel.text = userInfoFiles.positionName;
}

- (void)savePersonInfoData:(NSDictionary* )personInfoData{
    if ([[personInfoData objectForKey:@"code"] integerValue] == 110200) {
        if (![[[personInfoData objectForKey:@"list_info"]objectForKey:@"userpic"]isEqualToString:@""])
        {
        NSString *smallPicURL =[NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"userpic"]];
            [self.portraitImage setImageWithURL:[NSURL URLWithString:[smallPicURL stringByAppendingString:@"_small220190"]] placeholderImage:[UIImage imageNamed:@"personPhoto.png"]];
        }
        self.companyIDLabel.text = [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"com_code"]];
        self.companyNameLabel.text =  [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"com_name"]];
        self.personalIDLabel.text = [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"user"]];
        self.personalNameLabel.text =  [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"name"]];
        self.personalPhoneNumberLabel.text = [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"mobile"]];
        self.personalPartmentLabel.text =  [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"department"]];
        self.personalPositionLabel.text = [NSString stringWithFormat:@"%@",[[personInfoData objectForKey:@"list_info"]objectForKey:@"positiontitle"]];
    }
    else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请求失败"
                                                     message:[personInfoData objectForKey:@"msg"]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    [SVProgressHUD dismiss];
}

-(void)uploadPortrait
{
    [SVProgressHUD showWithStatus:@"正在上传图片"];
    
        NSString *urlString = [NSString stringWithFormat:@"%@/?mod=myphoto&fun=post&user_id=%@&rand_code=%@&versions=%@&stype=1",API_headaddr, userID,randCode,VERSIONS];
    NSLog(@"%@",urlString);
    ASIFormDataRequest *requests = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: urlString]];
    [requests setDelegate:self];
    [requests setRequestMethod:@"POST"];
    [requests addRequestHeader:@"Content-Type" value:@"photo"];
    NSData *imageData = UIImageJPEGRepresentation(compressedImage, 1.0);
    [requests addData:imageData withFileName:@"test.png" andContentType:@"image/jpeg" forKey:@"photo"];
    [requests setDidFinishSelector:@selector(headPortraitSuccess:)];//当成功后会自动触发 headPortraitSuccess 方法
    [requests setDidFailSelector:@selector(headPortraitFail:)];//如果失败会 自动触发 headPortraitFail 方法
    [requests setTimeOutSeconds:10];
    [requests startAsynchronous];
}

-(void)headPortraitSuccess:(ASIFormDataRequest* )requs{
    NSLog(@"%@",requs.responseString);
    NSDictionary* photoDic = [NSJSONSerialization JSONObjectWithData:[requs.responseString dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
   if([[photoDic objectForKey:@"code"]integerValue]==90200)
   {
       
       NSString *userpic = [photoDic objectForKey:@"url"];
    
       [[YWNetRequest sharedInstance] requestHeadPortraitDataWithUserPic:userpic Success:^(id respondsData) {
           //
           if([[respondsData objectForKey:@"code"] integerValue]==50200)
           {
               [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];
               self.portraitImage.image = compressedImage;
               userInfoFiles.userPicUrl = userpic;
               [userInfoDB  uploadPhotoUrl:userInfoFiles];
               YManagerUserInfoDBM *manauserinfo = [[YManagerUserInfoDBM alloc]init];
               YManagerUserInfoFileds* asd = [manauserinfo getPersonInfoByUserID:[userID integerValue] withPhotoUrl:YES withDepartment:0 withContacts:0];
               asd.userPhotoUrl = userpic;
               [manauserinfo  upLoadMyPicture:asd];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyPicture" object:nil];
           }
           else
           {
               [self checkCodeByJson:respondsData];
               
           }
           
       } failed:^(NSError *error) {
           //
           [SVProgressHUD dismiss];
           UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"图片发送失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [av show];
       }];
       

   }
    else
    {
         [SVProgressHUD showErrorWithStatus:@"上传失败"];
       
    }
    
}



-(void)headPortraitFail:(ASIFormDataRequest* )requs{
    [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    NSLog(@"%@",requs.responseString);
}


-(IBAction)selectPortrait:(id)sender
{
    
    [selectPortraitSheet showInView:self.view];
    
//   
    
}

#pragma mark- actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2)
    {;}
    else
    {
        NSUInteger sourceType;
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (buttonIndex == 0) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.navigationBar.translucent = NO;
        if(IS_IOS7)
        {
            imagePickerController.navigationBar.barTintColor = [UIColor colorWithRed:0.051 green:0.439 blue:0.737 alpha:1.000];
            //imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            imagePickerController.navigationBar.tintColor = [UIColor whiteColor];
        }
        else
            [imagePickerController.navigationController.navigationBar customNavigationBar];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    //NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    //UIImage *compressedImage = [UIImage imageWithData:imageData];
    compressedImage = [TOOL scaleImage:image toHeight:140.0 toWidth:140.0];
   // self.portraitImage.image = compressedImage;
    [self uploadPortrait];
}


-(void)gotoback
{
    self.homeNavi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.mm_drawerController setCenterViewController: self.homeNavi
                                   withCloseAnimation:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
