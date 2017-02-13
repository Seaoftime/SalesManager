//
//  YWSeePictureVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-9.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
#import "PicNotesView.h"
@interface YWSeePictureVC : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *bigScrollView;
    UIScrollView *smallScrollView;
    NavigationView *naviView;
    NSMutableArray *scrollviewArray;
    PicNotesView *notesView;
    int totalPage;
    NSMutableArray *curImages;
    CGRect scrollFrame;
}
@property(nonatomic,strong)NSArray *photosInfo;                                 //传入的图片信息数组 class yPcitureFileds;
@property(nonatomic,assign)NSInteger isReport;
@property(nonatomic,assign)  int currentPic;
@property(nonatomic,strong)NSString *albumTitle;

@end

