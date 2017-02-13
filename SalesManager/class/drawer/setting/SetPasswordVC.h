//
//  SetPasswordVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordVC : YWbaseVC

@property(nonatomic,strong) IBOutlet UIImageView *bgImageView1;
@property(nonatomic,strong) IBOutlet UIImageView *bgImageView2;
@property(nonatomic,strong) IBOutlet UIImageView *bgImageView3;
@property(nonatomic,strong) IBOutlet UITextField *oldPasswordField;
@property(nonatomic,strong) IBOutlet UITextField *tnewPasswordField;
@property(nonatomic,strong) IBOutlet UITextField *renewPasswordField;
@property(nonatomic,strong) IBOutlet UIView *totalBgView;

@end
