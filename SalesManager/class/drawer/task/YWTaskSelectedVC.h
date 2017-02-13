//
//  YWTaskSelectedVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-12.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
@protocol  YWTaskSelectObjectsVCDelegate<NSObject>

-(void)selectTaskSendData:(NSMutableDictionary*)sendDic ;

@end
@interface YWTaskSelectedVC :UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
      UITableView *peopleTB;
      UISearchBar * mySearchBar;
      UISearchDisplayController *mySearchDisplayController;
      int selectedIndex;
    int selectedIndexSection;
      YManagerUserInfoDBM *userDBM;
      id<YWTaskSelectObjectsVCDelegate>delegate;
}
@property(nonatomic,strong)NSMutableArray *managerData;
@property(nonatomic,strong) id<YWTaskSelectObjectsVCDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *searchResultArray;
@end
