//
//  YWbaseVC.h
//  SalesManager
//
//  Created by sky on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "YWErrorDBM.h"

@interface YWbaseVC : UIViewController<UIAlertViewDelegate>


-(void)checkCodeByJson:(NSDictionary* )json;

-(void)saveAnError:(NSString* )erreMsg;


@end
