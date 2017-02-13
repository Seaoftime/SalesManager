//
//  SignInViewController.h
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSignInDBM.h"
//#import "PullingRefreshTableView.h"
@interface SignInViewController : YWBaseTableVC <UIScrollViewDelegate>{
    YSignInDBM*                         _signInDB;
    //IBOutlet PullingRefreshTableView*   _signInTableView;
    
    //UITableView *_signInTableV;
    
    
    IBOutlet UITableView *_signInTableV;
    
    int                                 _dataCont;
    NSMutableArray*                     _signInData;
    NSMutableArray*                     upLoadSignInArrary;
}

@property (nonatomic,strong) UINavigationController *homeNavi;
@property (nonatomic, assign) BOOL isFast;

- (void)addCell:(YSignInFields *)aField;

- (IBAction)pressAddSignButton;

@end
