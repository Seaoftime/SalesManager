//
//  YWBaseTableVC.h
//  SalesManager
//
//  Created by sky on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWErrorDBM.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface YWBaseTableVC : UITableViewController<UIAlertViewDelegate>


-(void)checkCodeByJson:(NSDictionary* )json;
-(void)saveAnError:(NSString* )erreMsg;

@end
