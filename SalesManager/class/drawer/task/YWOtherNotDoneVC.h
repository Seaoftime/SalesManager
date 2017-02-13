//
//  YWOtherNotDoneVC.h
//  SalesManager
//
//  Created by tianjing on 13-12-6.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTaskDBM.h"

//#import "RTLabel.h"
#import "YSummaryReplyDBM.h"
@protocol YWDeleteTaskVCDelegate <NSObject>

-(void)deleteTaskDateInSection:(NSString*)section inRow:(NSString* )row;

@end

@interface YWOtherNotDoneVC : YWbaseVC<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIImageView *tapBgView;
    UIActionSheet *modifySheet;
    id<YWDeleteTaskVCDelegate>delegate;
    YTaskDBM* taskDB;
    YTaskFieleds* taskFilesd;
    YSummaryReplyDBM *TaskReplyDBM;
    UIBarButtonItem* rightButtonItem;
    BOOL firstview;
    CGRect replyViewFrame;
    CGRect backgroundScrollViewFrame;
    UIAlertView *backalertView;
}
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *sendLabel;


//@property (nonatomic,strong) IBOutlet RTLabel *receiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendPeople;

@property (weak, nonatomic) IBOutlet UILabel *receivePeople;

@property (nonatomic,strong) IBOutlet UILabel *sendTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *deadLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *deadTime;

@property (nonatomic,strong) IBOutlet UITextView *contentTxet;

@property (weak, nonatomic) IBOutlet UIImageView *bgImggView;

@property (weak, nonatomic) IBOutlet UILabel *deadLb;

@property (nonatomic,strong) IBOutlet UIImageView *bgView;
@property (nonatomic,strong) IBOutlet UIScrollView *totalBgView;
@property (nonatomic,strong) IBOutlet UIView *hasdoneBgView;
@property (nonatomic,strong) IBOutlet UITextView *noteTextView;
@property (nonatomic,strong) IBOutlet UIView *hasdelayBgView;
@property (nonatomic,strong) IBOutlet UIView *tootherBgView;
@property (nonatomic,strong) IBOutlet UIButton *toMeButton;
@property (nonatomic,strong) IBOutlet UIImageView *lineView;
@property(nonatomic,strong) NSString* taskID;
@property(nonatomic,assign) NSInteger autoIncremenID;
@property (nonatomic,assign)NSInteger toMe;
@property (nonatomic,assign)NSInteger hasDone;
@property (nonatomic,assign)NSInteger islocked;
@property (nonatomic,strong)NSMutableDictionary *taskData;
@property(nonatomic,strong)id<YWDeleteTaskVCDelegate>delegate;
@property(nonatomic,strong)NSString* inSection;
@property(nonatomic,strong)NSString* inRow;
@property(nonatomic,assign)BOOL fromPush;
@property(nonatomic,assign)BOOL fromHomepage;
@property(nonatomic,strong)IBOutlet UIView *replyBgView;

@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;


@property(nonatomic,strong)IBOutlet InsertTextField *replyField;



@property(nonatomic,strong)IBOutlet UITableView *replyTb;
@property(nonatomic,strong)IBOutlet UIButton *replyBtn;
@property(nonatomic,strong)NSMutableArray *replyListArray;

-(IBAction)fastReply:(id)sender;
-(IBAction)reply:(id)sender;

@end
