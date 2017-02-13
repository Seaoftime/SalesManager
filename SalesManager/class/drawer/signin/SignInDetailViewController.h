//
//  SignInDetailViewController.h
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSignInDBM.h"

@class YSignInFields;

@interface SignInDetailViewController : YWbaseVC{
    YSignInDBM* signInDB;
    
    
}

@property (nonatomic, retain) YSignInFields* signInFileds;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isHome;

@end
