//
//  YWPicInAlbumVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-2.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PullingRefreshTableView.h"
#import "YPicturesDBM.h"
@interface YWPicInAlbumVC : YWbaseVC<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    //PullingRefreshTableView *photoListTable;
    
    int _dataCount;
    YPicturesDBM* pictureDB;
}
@property(nonatomic,assign)NSInteger albumID;
@property(nonatomic,strong)NSMutableArray *photoList;
@property(nonatomic,strong)NSString *albumTitle;
@property(nonatomic,assign)NSInteger photoCount;

@property(nonatomic,strong) UITableView *photoListTable;

-(void)getphotoData;
@end
