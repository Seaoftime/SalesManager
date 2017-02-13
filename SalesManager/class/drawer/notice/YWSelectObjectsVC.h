//
//  YWSelectObjectsVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  YWSelectObjectsVCDelegate<NSObject>

-(void)selectSendData:(NSMutableDictionary*)sendDic ;

@end

#import "NavigationView.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"

@interface YWSelectObjectsVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UIView *departmentBgView;
    UIView *peopleBgView;
    UITableView *departmentTB;
    UITableView *peopleTB;
    BOOL isAllSelected;
    int selectedPartNum;
    int selectedPeopleNum;
    NavigationView *naviView;
    UIButton *allSelectButton;
    UIImageView *allimageview;
    YManagerUserInfoDBM *userDBM;
    UISegmentedControl *segmentedControl;
    id<YWSelectObjectsVCDelegate>delegate;
    UISearchBar * mySearchBar;
    UISearchDisplayController *mySearchDisplayController;
    UIButton *naviViewrightBtton;
    UITableView *bottomTB;
    UIButton *bottomBtn;
    BOOL fromup;
    
}

@property(nonatomic,strong)NSMutableArray *departmentArray;
@property(nonatomic,strong)NSMutableArray *managerData;
@property(nonatomic,strong)NSMutableDictionary *sendData;
@property(nonatomic,strong)NSMutableDictionary *hasBeenSelectedData;
@property (nonatomic,strong) NSMutableArray *searchResultArray;
@property(nonatomic,strong)id<YWSelectObjectsVCDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *bottomDepartmentArray;
@property(nonatomic,strong)NSMutableArray *bottomPeopleArray;
@end
