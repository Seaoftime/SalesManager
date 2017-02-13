//
//  YWSettingVC.h
//  SalesManager
//
//  Created by tianjing on 13-11-29.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateView.h"
@interface YWSettingVC : UIViewController<UIActionSheetDelegate>
{
    UpdateView *updateView;
    NSString *mostVersion;
    
    __weak IBOutlet UILabel *_getNewVersionImage;
    
}



@property (weak, nonatomic) IBOutlet UITableView *setttingTV;


@property(nonatomic,strong) UINavigationController *homeNavi;
@property(nonatomic,strong)IBOutlet UIImageView *bgImage1;
@property(nonatomic,strong)IBOutlet UIImageView *bgImage2;
@property(nonatomic,strong)IBOutlet UIImageView *bgImage3;
@property(nonatomic,strong)IBOutlet UISwitch *switchPic;
@property(nonatomic,strong)IBOutlet UISwitch *switchMap;
@property(nonatomic,strong)IBOutlet UIView *totalBgView;
@property(nonatomic,strong)IBOutlet UIButton *logOutButton;
@property(nonatomic,assign)BOOL fromPush;





@end
