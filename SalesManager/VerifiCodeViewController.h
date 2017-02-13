//
//  VerifiCodeViewController.h
//  SalesManager
//
//  Created by louis on 14-3-18.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ShakeView.h"
@interface VerifiCodeViewController : UIViewController
{
    int secondsCountDown;
    int time;
    NSTimer *countDownTimer;
    NSTimer *OutTimer;
    BOOL isOutTime;
}
-(IBAction)bck:(id)sender;
-(IBAction)ResignDown:(id)sender;
-(IBAction)SubmitClick:(id)sender;
-(IBAction)CallVerifiClick:(id)sender;
-(IBAction)RegetVerifiClick:(id)sender;
//@property(nonatomic,strong)IBOutlet UITextField *VerifiCodeField;
@property(nonatomic,strong)IBOutlet UIButton *ReVerifiBtn;
@property(nonatomic,strong)IBOutlet UIView *TimeView;
@property(nonatomic,strong)IBOutlet UIView *VerifiCodeView;
@property(nonatomic,strong)IBOutlet UILabel *Timelbl;
@property(nonatomic,strong)IBOutlet UIButton *SubmitBtn;
@property(nonatomic,strong)IBOutlet UILabel *MessageLbl;
@property(nonatomic,strong)IBOutlet UIButton *CallVerifiBtn;

- (IBAction)submitButtonClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *VerifiCodeField;







@end















