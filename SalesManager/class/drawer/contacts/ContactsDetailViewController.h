//
//  ContactsDetailViewController.h
//  SalesManager
//
//  Created by Kris on 14-2-7.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YManagerUserInfoFileds;

@interface ContactsDetailViewController : UIViewController<UIActionSheetDelegate>

@property (strong, nonatomic) YManagerUserInfoFileds *user;

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIView *infoView1;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *qqLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIView *infoView2;
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (strong, nonatomic) IBOutlet UIButton *noticeButton;
@property (strong, nonatomic) IBOutlet UIButton *taskButton;



- (IBAction)sendNotice:(id)sender;
- (IBAction)sendTask:(id)sender;

@end
