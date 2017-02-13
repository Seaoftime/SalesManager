//
//  RegistPhoneViewController.h
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistPhoneViewController : UIViewController<UIAlertViewDelegate>
//-(IBAction)bck:(id)sender;
-(IBAction)ResignDown:(id)sender;
//-(IBAction)ConfirmClick:(id)sender;
//-(IBAction)HidenClick:(id)sender;
@property(nonatomic,strong)IBOutlet UITextField *PhoneNumField;
@property(nonatomic,strong)IBOutlet UIView *PhoneNumView;
@property(nonatomic,strong)IBOutlet UIButton *ConfirmBtn;
@property(nonatomic,strong)IBOutlet UIImageView *BackImgView;
@property(nonatomic,strong)IBOutlet UIView *BackView;




@end

