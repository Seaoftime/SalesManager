//
//  RegisSuccessViewController.h
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisSuccessViewController : UIViewController
{
    IBOutlet UIView *contentBackgroundView;
    IBOutlet UIButton *LoginBtn;
    
    
    IBOutlet UILabel *CompanyNumlbl;
    IBOutlet UILabel *ManagerNumlbl;
    IBOutlet UILabel *Passwordlbl;
    
    
}


-(IBAction)LoginClick:(id)sender;

@end
