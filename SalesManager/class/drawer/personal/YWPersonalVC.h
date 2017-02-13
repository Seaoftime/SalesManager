//
//  YWPersonalVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-23.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUserInfomationDBM.h"
@interface YWPersonalVC : YWbaseVC<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActionSheet *selectPortraitSheet;
    //UIAlertController *alertController;
    
    UIImage *compressedImage;
    YUserInfomationDBM* userInfoDB;
    YuserInfomationFileds* userInfoFiles;
}
@property(nonatomic,strong)UINavigationController *homeNavi;
@property(nonatomic,strong)IBOutlet UIView *portraitBgView;
@property(nonatomic,strong)IBOutlet UIImageView *portraitImage;
@property(nonatomic,strong)IBOutlet UIView *companyBgView;
@property(nonatomic,strong)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *companyIDLabel;
@property(nonatomic,strong)IBOutlet UILabel *personalIDLabel;
@property(nonatomic,strong)IBOutlet UIView *personalBgView;
@property(nonatomic,strong)IBOutlet UILabel *personalNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *personalPhoneNumberLabel;
@property(nonatomic,strong)IBOutlet UILabel *personalPartmentLabel;
@property(nonatomic,strong)IBOutlet UILabel *personalPositionLabel;
@property(nonatomic,strong)IBOutlet UIButton *selectPortraitButton;
@property(nonatomic,strong)IBOutlet UIView *totalBgView;

-(IBAction)selectPortrait:(id)sender;
@end
