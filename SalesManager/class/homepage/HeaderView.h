//
//  HeaderView.h
//  TJtest
//
//  Created by tianjing on 13-11-27.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UILabel *departmentLabel;
@property(nonatomic,strong) IBOutlet UIImageView *portraitView;
@property(nonatomic,strong) IBOutlet UIButton *signinButton;
@end
