//
//  RegisSettingViewController.h
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegisSettingViewController : YWbaseVC<UITextFieldDelegate>
-(IBAction)ResignDown:(id)sender;
-(IBAction)SubmitClick:(id)sender;

@property(nonatomic,strong)IBOutlet UIView *CompanyView;
@property(nonatomic,strong)IBOutlet UIView *MessageView;
@property(nonatomic,strong)IBOutlet UIView *NameView;
@property(nonatomic,strong)IBOutlet UIView *ManagerView;
@property(nonatomic,strong)IBOutlet UIView *PasswordView;
@property(nonatomic,strong)IBOutlet UIView *ConfirmPassView;


@property (weak, nonatomic) IBOutlet UITextField *companyField;

//@property(nonatomic,strong)IBOutlet UITextField *companyField;
@property(nonatomic,weak)IBOutlet UITextField *messageField;
@property(nonatomic,weak)IBOutlet UITextField *nameField;
@property(nonatomic,weak)IBOutlet UITextField *managerField;
@property(nonatomic,weak)IBOutlet UITextField *passwordField;
@property(nonatomic,weak)IBOutlet UITextField *confirmPassField;
@property(nonatomic,weak)IBOutlet UIButton *submitBtn;
@property(nonatomic,weak)IBOutlet UIScrollView *MyScrollView;





@end
