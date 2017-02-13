//
//  InformationReportDetailViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-3.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "InformationReportDetailViewController.h"
//#import "RTLabel.h"
#import "SVProgressHUD.h"
#import "YSummaryReplyDBM.h"
#import "YSummaryReplyFileds.h"
#import "YSummaryDBM.h"
#import "YSummaryFields.h"
#import "YFormDBM.h"
#import "YformFileds.h"
#import "YWSeePictureVC2.h"
#import "YManagerUserInfoDBM.h"
#import "YManagerUserInfoFileds.h"
#import "YPcituresFileds.h"
#import "InformationReportSelectViewController.h"
#import "ILBarButtonItem.h"
#import "DLImageView.h"
#import "UINavigationBar+customBar.h"

//
#import "UIView+Frame.h"
#import "UIView+Uitls.h"
#import "YWReportDetailsReplyTableViewCell.h"
#import "YWCanSelectCellTableViewCell.h"
#import "YWCanNotSelectedTableViewCell.h"
#import "TOOL.h"


typedef enum {
    InformationReportDetailTypeSingleLine = 0,      //单行
    InformationReportDetailTypeMultipleLines = 1,   //多行
    InformationReportDetailTypePhone = 2,           //电话
    InformationReportDetailTypeSingleChoice = 2,    //单选
    InformationReportDetailTypeMultipleChoice = 2,  //多选
    InformationReportDetailTypeDate = 2,            //日期
    InformationReportDetailTypePicture = 2,         //图片
    InformationReportDetailTypeNumber = 2,          //数量
    InformationReportDetailTypeReply = 2            //回复
} InformationReportDetailType;




@interface InformationReportDetailViewController ()<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    YSummaryReplyDBM *reportReplyDB;
    YSummaryDBM *reportContentDB;
    YFormDBM *formDB;
    NSArray *formData;
    NSDictionary *reportsDic;
    NSArray *pictureArray;
    NSMutableArray *replyArray;
    
    CGRect toolbarFrame;
    CGRect viewFrame;
    IBOutlet UIButton *tapButton;
    //
    CGFloat _keyBoardYOffSet;
    
    CGRect replyViewFrame;
    NSInteger _show;
    
    CGRect backgroundScrollViewFrame;
    
    //scrollView
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
}



@property(strong, nonatomic) IBOutlet UIScrollView *backgroundScrollView;  //背景

@property(strong, nonatomic) IBOutlet UIView *headView;  // head

//
@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;
@property (nonatomic, strong) UIImageView *imageV4;

//
@property(strong, nonatomic) IBOutlet UITableView *detailTableView;  // detail

@property(strong, nonatomic) IBOutlet UIView *pictureView;  // picture

@property(strong, nonatomic) IBOutlet UITableView *replyTableView;  //回复

/**
 *  回复
 */
@property (weak, nonatomic) IBOutlet UILabel *replyHeaderLabel;

@property (weak, nonatomic) IBOutlet UIImageView *replyLineIV;

//
@property(strong, nonatomic) IBOutlet UIBarButtonItem *footLeftButtonItem;
@property(strong, nonatomic) IBOutlet UIBarButtonItem *footRightButtonItem;
@property(strong, nonatomic) IBOutlet InsertTextField *footTextField;

@property(assign, nonatomic) CGFloat cellHeight;

@property(strong, nonatomic) UIView *lineV1;
@property(strong, nonatomic) UIView *lineV2;
@property(strong, nonatomic) UIView *lineV3;
@property (nonatomic ,strong) UIPanGestureRecognizer *panGesture;

//@property (weak, nonatomic) IBOutlet UIButton *tapButton;

@property (weak, nonatomic) IBOutlet UIImageView *replyLineImgV;

- (IBAction)makeTelephone:(id)sender;


- (IBAction)backToTop:(id)sender;
- (IBAction)quickReply:(id)sender;
- (IBAction)Reply:(id)sender;

@end

@implementation InformationReportDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        reportContentDB = [[YSummaryDBM alloc] init];
        reportReplyDB = [[YSummaryReplyDBM alloc] init];
        formDB = [[YFormDBM alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!IS_IOS7)
    {
        [self.navigationController.navigationBar customNavigationBar];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
    self.backgroundScrollView.backgroundColor = [UIColor colorWithRed:240/255.f  green:245/255.f  blue:246/255.f alpha:1];
    
    
    backgroundScrollViewFrame = self.backgroundScrollView.frame;
    
    if (_isPush) {
        
        if(_isHome)
        {
            self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
        }else{
            self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(xiaoshi)];
        }
        
    } else {
        
        self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    }
    
    //获取内容表单
    formData = [formDB getFormDetails:@"信息汇报" inSectionID:_summaryListField.sectionID orSectionTitle:nil check:NO];
    
    NSLog(@"%@", _summaryListField.summaryId);
    
    reportsDic = [reportContentDB findWithsummaryPostTime:_summaryListField.postTime];
    
    pictureArray = [reportContentDB findPhotoUrlWithPostTime:_summaryListField.postTime];
    
    replyArray = [NSMutableArray arrayWithArray:[reportReplyDB findSummaryReplyBySummaryID:_summaryListField.summaryId]];
    
    _show = 0;
    
    if (_summaryListField.timeStampList > _summaryListField.timeStampContent + 5)
    {
        [self getReportContent];
        
    }else{
        
        [self initViews];
    }
    
    
//    if (kDeviceWidth > 500.000000) {
//        [self.footTextField setFrame:CGRectMake(self.footTextField.frame.origin.x, self.footTextField.frame.origin.y, self.footTextField.frame.size.width - 10, self.footTextField.frame.size.height)];
//    }
    
    
    
    //添加手势
    [self addTapGesture];
    
    
}


- (void)addTapGesture
{

    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyTableViewTaped)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    
    [self.backgroundScrollView addGestureRecognizer:tableViewGesture];
    //
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(replyTableViewTaped)];
    self.panGesture.delegate = self;
//    [self.backgroundScrollView addGestureRecognizer:self.panGesture];

}


- (void)replyTableViewTaped
{

    [self.footTextField resignFirstResponder];
    [self.backgroundScrollView removeGestureRecognizer:self.panGesture];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{
    
    contentOffsetY = scrollView.contentOffset.y;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //NSLog(@"%f",self.backgroundScrollView.contentOffset.y);
    
    
    
    newContentOffsetY = scrollView.contentOffset.y;
    
    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {
        
        
        NSLog(@"up");
        
        
    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) {
        
        
        
        NSLog(@"down");
        
        //[self.backgroundScrollView addGestureRecognizer:self.panGesture];
        
    } else {
        
        
        NSLog(@"dragging");
        
    }
    
    
    if (scrollView.dragging) {
        //
        if ((scrollView.contentOffset.y - contentOffsetY) > 20.0f) {  // 向上拖拽
            
            //[self.footTextField becomeFirstResponder];
            
        } else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f) {   // 向下拖拽
            
            
            [self.backgroundScrollView addGestureRecognizer:self.panGesture];
            
        } else {
            
        }
        
    }
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    oldContentOffsetY = scrollView.contentOffset.y;
    
}




#pragma mark -视图

- (void)initViews
{
    reportsDic = [reportContentDB findWithsummaryPostTime:_summaryListField.postTime];
    
    YSummaryFields *summaryField =
    [[reportContentDB findWithsummaryID:_summaryListField.summaryId
                          BySummaryDate:_summaryListField.postTime
                            inSectionID:0
                                  limit:1
                               byUserID:0] objectAtIndex:0];
    
//    NSLog(@"%@", [[reportContentDB findWithsummaryID:_summaryListField.summaryId
//                                       BySummaryDate:_summaryListField.postTime
//                                         inSectionID:0
//                                               limit:1
//                                            byUserID:0] objectAtIndex:0]);
    
    [self.detailTableView reloadData];
    [self.replyTableView reloadData];
    
    
    /**
     *  头部
     */
    [self.headView setHidden:NO];
//    
    self.headView.backgroundColor = [UIColor whiteColor];

    //
    self.imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 17, 12, 12)];
    self.imageV1.backgroundColor = [UIColor clearColor];
    self.imageV1.image = [UIImage imageNamed:@"姓名"];
    
    self.imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 46 + 18, 12, 12)];
    self.imageV2.backgroundColor = [UIColor clearColor];
    self.imageV2.image = [UIImage imageNamed:@"时间"];
    
    self.imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 108, 12, 12)];
    self.imageV3.backgroundColor = [UIColor clearColor];
    self.imageV3.image = [UIImage imageNamed:@"邮件"];
    
    self.imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 155, 12, 12)];
    self.imageV4.backgroundColor = [UIColor clearColor];
    self.imageV4.image = [UIImage imageNamed:@"地址"];
    
    [self.headView addSubview:self.imageV1];
    [self.headView addSubview:self.imageV2];
    [self.headView addSubview:self.imageV3];
    [self.headView addSubview:self.imageV4];
    /**
     *  电话
     */
    [self.telBtn.layer setCornerRadius:5];
    [self.telBtn setClipsToBounds:YES];
    [self.telBtn setBackgroundColor:[UIColor colorWithRed:240/255.f  green:245/255.f  blue:246/255.f alpha:1]];

    /**
     *  设置分割线
     */

    self.lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 46, kDeviceWidth - 15 - self.telBtn.frame.size.width, 0.4)];
    self.lineV1.backgroundColor = [UIColor colorWithRed:196/255. green:196/255. blue:196/255. alpha:1];
    [self.headView addSubview:self.lineV1];
    
    self.lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 92, kDeviceWidth, 0.4)];
    //self.lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SCREENW - 15, 0.4)];
    self.lineV2.backgroundColor = [UIColor colorWithRed:196/255. green:196/255. blue:196/255. alpha:1];
    [self.headView addSubview:self.lineV2];
    
    self.lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0, 46 * 3, kDeviceWidth,0.3)];
    self.lineV3.backgroundColor = [UIColor colorWithRed:196/255. green:196/255. blue:196/255. alpha:1];
    [self.headView addSubview:self.lineV3];
    
    //姓名
    UILabel *nameLabel = (UILabel *)[self.headView viewWithTag:100];
    
    if (_isPush)
    {
        YManagerUserInfoDBM *userDBM = [[YManagerUserInfoDBM alloc] init];
        YManagerUserInfoFileds *user = [userDBM getPersonInfoByUserID:[_summaryListField.senderUserID integerValue]
                                                         withPhotoUrl:YES
                                                       withDepartment:NO
                                                         withContacts:YES];
        nameLabel.text = user.userName;
        //self.nameLabel.text = user.userName;
        
    }else{
        
        nameLabel.text = summaryField.senderName;
        // NSLog(@"%@", summaryField.senderName);
    }
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *confromTimespStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:summaryField.postTime]];
    
    UILabel *dateLabel = (UILabel *)[self.headView viewWithTag:101];
    dateLabel.text = confromTimespStr;
    
    //发送人
    UILabel *sendNameLabel = (UILabel *)[self.headView viewWithTag:102];
    sendNameLabel.text = summaryField.reciver;
    
    //定位
    if (_summaryFormFiled.gps)  //判断是否是有定位
    {
        NSLog(@"%@", summaryField.myLocation);
        if ([summaryField.myLocation isEqualToString:@"(null)"] ||
            [summaryField.myLocation isEqualToString:@""] ||
            !summaryField.myLocation) {
            
            //[self.headView setFrame:CGRectMake(10, 10, kDeviceWidth - 20, 105)];
            [self.headView setFrame:CGRectMake(0, 10, kDeviceWidth, 184 - 46)];
            
            UILabel *locationLabel = (UILabel *)[self.headView viewWithTag:103];
            locationLabel.text = @"";
            [self.lineV3 removeFromSuperview];
            [self.imageV4 removeFromSuperview];
            
        } else {
            
            [self.headView setFrame:CGRectMake(0, 10, kDeviceWidth, 184)];
            UILabel *locationLabel = (UILabel *)[self.headView viewWithTag:103];
            locationLabel.text = summaryField.myLocation;
            
        }
    } else {
        //[self.headView setFrame:CGRectMake(10, 10, kDeviceWidth - 20, 105)];
        [self.headView setFrame:CGRectMake(0, 10, kDeviceWidth, 184 - 46)];
        UILabel *locationLabel = (UILabel *)[self.headView viewWithTag:103];
        locationLabel.text = @"";
        [self.lineV3 removeFromSuperview];
        [self.imageV4 removeFromSuperview];
        
    }
    
    /**
     *  详情
     */
    //改变tableview外观
    [self.detailTableView setHidden:NO];
    
    CGRect frame = self.detailTableView.frame;
    [self.detailTableView setFrame:CGRectMake(0, self.headView.frame.size.height + self.headView.frame.origin.y + 10, kDeviceWidth, frame.size.height)];
    
    self.detailTableView.backgroundColor = [UIColor clearColor];

    //自适应tableview高度
    [self.detailTableView sizeToFit];
    NSLog(@"%@", NSStringFromCGRect(self.detailTableView.frame));
    NSLog(@"%@", NSStringFromCGSize(self.detailTableView.contentSize));
    [self.detailTableView layoutIfNeeded];
    NSLog(@"%@", NSStringFromCGSize(self.detailTableView.contentSize));
    CGSize size = self.detailTableView.contentSize;
    [self.detailTableView setFrame:CGRectMake(0, self.headView.frame.size.height + self.headView.frame.origin.y + 10, kDeviceWidth, size.height)];
    
    [self.backgroundScrollView setContentSize:CGSizeMake(320, self.detailTableView.frame.origin.y + self.detailTableView.frame.size.height + 10)];
    /**
     *  图片
     */
    //判断是否有图片
    if (pictureArray.count != 0)
    {
        [self.pictureView setHidden:NO];
        
        //自适应pictureView高度
        
        [self.pictureView setFrame:CGRectMake(0, self.detailTableView.frame.origin.y + self.detailTableView.frame.size.height + 10, kDeviceWidth, 82)];
        
        //改变contentsize
        [self.backgroundScrollView setContentSize:CGSizeMake(320, self.pictureView.frame.origin.y + self.pictureView.frame.size.height + 10)];
        
        //添加图片
        for (int i = 0; i < pictureArray.count; i++)
        {
            DLImageView *imageView = (DLImageView *)[self.pictureView viewWithTag:(i + 200)];
            [imageView setImageWithURL:[NSURL URLWithString:[[pictureArray objectAtIndex:i] stringByAppendingString:@"_small220190"]] placeholderImage:nil];
            [imageView.layer setCornerRadius:5];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPictuer:)];
            [imageView addGestureRecognizer:recognizer];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setBackgroundColor:[UIColor blackColor]];
            [imageView setClipsToBounds:YES];
        }
        
    }else{
        
        
        [self.pictureView setFrame:CGRectMake(0, self.detailTableView.frame.origin.y + self.detailTableView.frame.size.height, kDeviceWidth, 0)];
        NSLog(@"%@", NSStringFromCGRect(self.pictureView.frame));
        [self.pictureView setHidden:YES];
    }
    
    /**
     *  回复
     */
    
    [self.replyLineImgV setFrame:CGRectMake(0, self.replyLineImgV.frame.origin.y + 5, kDeviceWidth, 0.5)];
    self.replyLineImgV.backgroundColor = [UIColor colorWithRed:200/255.f  green:199/255.f  blue:204/255.f alpha:1];
    
    //是否有回复，添加回复列表
    if (_summaryFormFiled.isReply)
    {
        //显示toolBar
        [self.navigationController setToolbarHidden:NO];
        toolbarFrame = self.navigationController.toolbar.frame;
        
        
        NSLog(@"%@", NSStringFromCGRect(toolbarFrame));
        
        
        if (replyArray.count)
        {
//          
            _replyHeaderLabel.text = [NSString stringWithFormat:@"回复 (%lu)",(unsigned long)replyArray.count];
            
            UILabel *lb = [[UILabel alloc] init];
            lb.text = _replyHeaderLabel.text;
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:lb.text];
            
            NSRange clorRange = NSMakeRange(2, lb.text.length - 2);
            
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235/255.0 green:105/255.0 blue:65/255.0 alpha:1.0] range:clorRange];
            
            [_replyHeaderLabel setAttributedText:noteStr];
            [_replyHeaderLabel sizeToFit];
            //
            //
            [self.replyTableView sizeToFit];
            
            [self.replyTableView layoutIfNeeded];
            
            
            if (_isHome) {
                [self.replyTableView setFrame:CGRectMake(0, self.detailTableView.frame.origin.y + self.detailTableView.frame.size.height + 10, kDeviceWidth, size.height)];
                
            }else {
            
                [self.replyTableView setFrame:CGRectMake(0, self.detailTableView.frame.origin.y + self.detailTableView.frame.size.height + 10, kDeviceWidth, size.height + 100)];
            
            }
            
            
            self.replyLineIV.backgroundColor = [UIColor colorWithRed:196/255. green:196/255. blue:196/255. alpha:1];
            
            self.replyTableView.backgroundColor = [UIColor whiteColor];
            
            summaryField.replyNum = [replyArray count];
            
            //
            [self.replyTableView sizeToFit];
            
            [self.replyTableView layoutIfNeeded];
        
            CGSize size2 = self.replyTableView.contentSize;
            
            [self.replyTableView setFrame:CGRectMake(0, self.pictureView.frame.origin.y + self.pictureView.frame.size.height + 10, kDeviceWidth, size2.height)];
            [self.backgroundScrollView setContentSize: CGSizeMake(320, self.replyTableView.frame.origin.y + self.replyTableView.frame.size.height)];
            
            [self.replyTableView setHidden:NO];
        }
    } else {
        
        //隐藏toolBar
        [self.navigationController setToolbarHidden:YES];
    }

    //底部tabbar
    
    if (kDeviceWidth > 700) {
        
        [self.footTextField setFrame:CGRectMake(40, KDeviceHeight - 40, kDeviceWidth - 100, 40)];
    }
    
//    [self.footTextField setFrame:CGRectMake(45, KDeviceHeight - 40, kDeviceWidth - 90, 40)];
    

    [self.footTextField setFrame:CGRectMake(45, KDeviceHeight - 44, kDeviceWidth - 90, 33)];
    
    self.footTextField.layer.cornerRadius = 5;
    self.footTextField.layer.borderColor = [UIColor colorWithWhite:0.600 alpha:1.000].CGColor;
    self.footTextField.layer.borderWidth = 0.5;
    self.footTextField.returnKeyType = UIReturnKeySend;
    
}


- (IBAction)hideKeyboard:(UIButton *)sender
{
    [self.footTextField resignFirstResponder];
}


- (void)tapPictuer:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    //NSLog(@"%d", imageView.tag);
    
    YWSeePictureVC2 *seePictureVC2 = [[YWSeePictureVC2 alloc] init];
    seePictureVC2.currentPic = (int)imageView.tag - 200 + 1;
    seePictureVC2.isReport = 1;
    
    NSMutableArray *yparray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [pictureArray count]; i++)
    {
        YPcituresFileds *a = [YPcituresFileds new];
        a.phtotBigPhotoUrl =
        [[pictureArray objectAtIndex:i] stringByAppendingString:@"_bigimage"];
        [yparray addObject:a];
    }
    seePictureVC2.photosInfo = yparray;
    
    [self presentViewController:seePictureVC2 animated:YES completion:nil];
    
    
//    [self.navigationController setNavigationBarHidden:YES];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:seePictureVC2 animated:YES];
//    
////    [self.navigationController setNavigationBarHidden:NO];
//    self.hidesBottomBarWhenPushed = NO;
    
}

NSString *phoneNum;


- (IBAction)makeTelephone:(id)sender
{
    YManagerUserInfoDBM *userDBM = [[YManagerUserInfoDBM alloc] init];
    YManagerUserInfoFileds *user = [userDBM
                                    getPersonInfoByUserID:[_summaryListField.senderUserID integerValue]
                                    withPhotoUrl:YES
                                    withDepartment:NO
                                    withContacts:YES];
    //弹出actionsheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:[user.userPhoneNumber stringByAppendingFormat:
                                                     @"(%@)", user.userName],
                                  nil];
    
    phoneNum = user.userPhoneNumber;
    
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"%d", buttonIndex);
    if (buttonIndex == 0) {
        
        NSURL *phoneURL =
        [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section;
{
    if (tableView == self.replyTableView) {
        return replyArray.count;
        
    }
    
    return formData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //回复table
    if (tableView == self.replyTableView)
    {
        static NSString *CellIdentifier = @"reply";
        YWReportDetailsReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWReportDetailsReplyTableViewCell" owner:self options:nil] lastObject];
    
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.replyFields = [replyArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    
    YformFileds *tempFormFiled = [formData objectAtIndex:indexPath.row];
    
    if ([tempFormFiled.formType isEqualToString:@"checkbox"])
    {
        static NSString *CellIdentifier = @"canSelect";
        YWCanSelectCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWCanSelectCellTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setFileds:tempFormFiled AndInfoDic:reportsDic];
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"cannot";
        
        YWCanNotSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YWCanNotSelectedTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setFileds:tempFormFiled AndInfoDic:reportsDic];
        
        return cell;
    }
    
    
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.replyTableView) {
        
        YSummaryReplyFileds *replyFields = [replyArray objectAtIndex:indexPath.row];
        
        return [TOOL getText:replyFields.replyContent MinHeightWithBoundsWidth:kDeviceWidth fontSize:17] + 38;
        
        //return 55;
        
    }else if (tableView == self.detailTableView){
        
        YformFileds *tempFormFiled = [formData objectAtIndex:indexPath.row];
        
        NSString *string = [reportsDic objectForKey:tempFormFiled.formReferName];
    
        //
        if ([string isEqualToString:@""] || !string || (string.length == 0)) {
            
            return 0;
            
        }else {
            
            if (kDeviceWidth < 350.000000) {
                if (string.length > 300) {
                    
                    return [TOOL getText:string MinHeightWithBoundsWidth:kDeviceWidth - 20 fontSize:17];
                }else
                    return [TOOL getText:string MinHeightWithBoundsWidth:kDeviceWidth - 20 fontSize:17] + 40;
            }else
                return [TOOL getText:string MinHeightWithBoundsWidth:kDeviceWidth - 20 fontSize:17] + 40;
        }
        
    }else {
    
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.detailTableView)
    {
        YformFileds *tempFormFiled = [formData objectAtIndex:indexPath.row];
        if ([tempFormFiled.formType isEqualToString:@"checkbox"])
        {
            [self.navigationController setToolbarHidden:YES animated:YES];
            [self performSegueWithIdentifier:@"toSelectView" sender:indexPath];
            [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
        }
    }
    
}

//消除选中效果
- (void)deselect
{
    [self.detailTableView deselectRowAtIndexPath:[self.detailTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - navigation

- (IBAction)backToTop:(id)sender {
    [self.footTextField resignFirstResponder];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xiaoshi {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = sender;
    YformFileds *tempFormFiled = [formData objectAtIndex:indexPath.row];
    
    NSArray *array =
    [(NSString *)[reportsDic objectForKey:tempFormFiled.formReferName]
     componentsSeparatedByString:@","];
    
    InformationReportSelectViewController *selectVC =
    [segue destinationViewController];
    
    selectVC.titleString = tempFormFiled.formName;
    selectVC.dataArray = array;
}

- (void)getReportContent
{
    if (isNetWork) {
        [SVProgressHUD showWithStatus:@"正在加载"];
        
        [[YWNetRequest sharedInstance] requestReportDetailsWithSummaryId:_summaryListField.summaryId WithSuccess:^(id respondsData) {
            //
            [SVProgressHUD dismiss];
            if ([[respondsData objectForKey:@"code"] integerValue] == 30200) {
                [self saveReportsContent:respondsData];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
            
        } failed:^(NSError *error) {
            //
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];

       
    }
}

- (void)saveReportsContent:(NSDictionary *)reportContent {
    
    if (!_summaryListField.isread) [TOOL minusIconBadgeNumber];
    YSummaryFields *report = [[YSummaryFields alloc] init];
    report.timeStampList = [[[reportContent objectForKey:@"diary_info"] objectForKey:@"lastdotime"] integerValue];
    report.timeStampContent = report.timeStampList;
    report.isreply = [[[reportContent objectForKey:@"diary_info"] objectForKey:@"is_reply"] integerValue];
    report.isread = 1;
    report.postTime = [[[reportContent objectForKey:@"diary_info"] objectForKey:@"posttime"] integerValue];
    report.myLocation = [[reportContent objectForKey:@"diary_info"] objectForKey:@"address"];
    report.reciver = [[reportContent objectForKey:@"diary_info"] objectForKey:@"toid"];
    report.senderUserID = [[reportContent objectForKey:@"diary_info"] objectForKey:@"formuserid"];
    report.summaryId = [[reportContent objectForKey:@"diary_info"] objectForKey:@"id"];
    report.upload = 1;
    report.sectionID = [[[reportContent objectForKey:@"diary_info"] objectForKey:@"formtype"] integerValue];
    [reportContentDB saveSummaryList:report];
    
    _summaryListField = report;
    
    //测试消息推送
    if (_isPush) {
        if (!_summaryFormFiled) {
            _summaryFormFiled = [[YformFileds alloc] init];
        }
        _summaryFormFiled.isReply =
        [formDB checkWheatherNeed:@"isreply"
                      InSectionID:_summaryListField.sectionID
                   orSectionTitle:nil];
        
        _summaryListField.sectionID = [[[reportContent objectForKey:@"diary_info"]
                                        objectForKey:@"formtype"] intValue];
        //获取内容表单
        formData = [formDB getFormDetails:@"信息汇报" inSectionID:_summaryListField.sectionID orSectionTitle:nil check:NO];
    }
    
    for (int i = 0; i < formData.count; i++) {
        YformFileds *formFileds = [formData objectAtIndex:i];
        YSummaryFields *reportFileds = [YSummaryFields new];
        reportFileds.postTime = report.postTime;
        reportFileds.sectionID = _summaryListField.sectionID;
        reportFileds.formName = formFileds.formReferName;
        reportFileds.formValue =
        [[[reportContent objectForKey:@"diary_info"] objectForKey:@"tag"]
         objectForKey:formFileds.formReferName];
        [reportContentDB saveSummaryContent:reportFileds];
    }
    
    @try {
        NSArray *pictureArr = [[NSArray alloc] init];
        pictureArr =
        [[reportContent objectForKey:@"diary_info"] objectForKey:@"picurl"];
        
        
    }
    @catch (NSException *exception) {
    }
    
    NSArray *array =
    [[reportContent objectForKey:@"diary_info"] objectForKey:@"replycontent"];
    
    YSummaryReplyFileds *summaryReply = [[YSummaryReplyFileds alloc] init];
    [reportReplyDB cleanReply:[[reportContent objectForKey:@"diary_info"]
                               objectForKey:@"id"]];
    
    int i = 0;
    
    for (id object in array) {
        
        summaryReply.summaryID =
        [[reportContent objectForKey:@"diary_info"] objectForKey:@"id"];
  
        summaryReply.replyDate = [[object valueForKey:@"reply_time"] integerValue];
        summaryReply.replyPerson = [object valueForKey:@"replyer"];
        summaryReply.replyContent = [object valueForKey:@"reply"];
        
        [reportReplyDB saveSummaryReply:summaryReply];
        
        NSLog(@"%d", i);
        i++;
    }
    
    replyArray =
    [NSMutableArray arrayWithArray:[reportReplyDB findSummaryReplyBySummaryID:
                             _summaryListField.summaryId]];
    pictureArray =
    [reportContentDB findPhotoUrlWithPostTime:_summaryListField.postTime];
    [self initViews];
    
}

- (IBAction)quickReply:(id)sender {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
    if (![fileManager fileExistsAtPath:filePath]) {
        [TOOL createFileWithName:@"tYWdefinedReport.plist"];
    }
    
    NSMutableArray *titles = [NSMutableArray
                              arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
    
    UIAlertView *alertView;
    if (titles.count > 0) {
        alertView = [[UIAlertView alloc] initWithTitle:@"快速回复"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:nil];
        for (NSString *title in titles) {
            [alertView addButtonWithTitle:title];
        }
    } else {
        alertView =
        [[UIAlertView alloc] initWithTitle:@"快速回复"
                                   message:@"暂无数据，请在‘个人设置’中进行设定"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:nil];
    }
    
    [alertView show];
}

/**
 *  发送
 *
 *  @param sender
 */

- (IBAction)Reply:(id)sender
{
    //键盘收不收 影响footbar 的收放
    [self.footTextField resignFirstResponder];
    
    if (isNetWork) {
        [SVProgressHUD showWithStatus:@"正在发送..."];
        self.footRightButtonItem.enabled = NO;
        
        [[YWNetRequest sharedInstance] requestReportDetailsWithSummaryId:_summaryListField.summaryId WithReplyContent:self.footTextField.text WithSuccess:^(id respondsData) {
            //
            [SVProgressHUD dismiss];
            if ([[respondsData objectForKey:@"code"] integerValue] == 30200)
            {
                self.replyTableView.hidden = NO;
                self.footRightButtonItem.enabled = NO;
                
                YSummaryReplyFileds *aSumaryReply = [[YSummaryReplyFileds alloc] init];
                aSumaryReply.replyContent = self.footTextField.text;
                //NSLog(@"%@", self.footTextField.text);
                aSumaryReply.summaryID = _summaryListField.summaryId;
                aSumaryReply.replyDate = [[respondsData objectForKey:@"posttime"] integerValue];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                aSumaryReply.replyPerson = userDefaults.name;
                [reportReplyDB saveSummaryReply:aSumaryReply];
                
                if (replyArray ) {
                    [replyArray addObject:aSumaryReply];
                }else
                    replyArray = [NSMutableArray arrayWithArray:[reportReplyDB findSummaryReplyBySummaryID: _summaryListField.summaryId]];
                
                [self.replyTableView reloadData];
                
                //[self.replyTableView sizeToFit];
                
                [self.replyTableView layoutIfNeeded];
                
                //
                
                if (replyArray.count) {
                    _replyHeaderLabel.text = [NSString stringWithFormat:@"回复 (%lu)",(unsigned long)replyArray.count];
                    
                    UILabel *lb = [[UILabel alloc] init];
                    lb.text = _replyHeaderLabel.text;
                    
                    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:lb.text];
                    
                    NSRange clorRange = NSMakeRange(2, lb.text.length - 2);
                    
                    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235/255.0 green:105/255.0 blue:65/255.0 alpha:1.0] range:clorRange];
                    
                    [_replyHeaderLabel setAttributedText:noteStr];
                    //[_replyHeaderLabel sizeToFit];
                    
                    
                    //

                }else {
                }
                
                _show = 1;
                
                CGSize size = self.replyTableView.contentSize;
                self.replyTableView.frame =
                CGRectMake(0, self.pictureView.frame.origin.y + self.pictureView.frame.size.height + 10, kDeviceWidth, size.height);
                //NSLog(@"%@", NSStringFromCGRect(self.replyTableView.frame));
                
                
                
                [self.backgroundScrollView setContentSize: CGSizeMake(kDeviceWidth, self.replyTableView.frame.origin.y + self.replyTableView.frame.size.height)];                            
                
                self.footTextField.text = @"";
                
                
                if (kDeviceWidth > 500.000000) {
                    if (replyArray.count > 4) {
                        //滚动到底部
                        CGPoint bottomOffset = CGPointMake(0, self.backgroundScrollView.contentSize.height - self.backgroundScrollView.bounds.size.height + self.navigationController.toolbar.frame.size.height);
                        
                        [self.backgroundScrollView setContentOffset:bottomOffset animated:YES];
                        
                        
                    }
                    
                }else {
                
                    //滚动到底部
                    
                    
                    CGPoint bottomOffset = CGPointMake(0, self.backgroundScrollView.contentSize.height - self.backgroundScrollView.bounds.size.height + self.navigationController.toolbar.frame.size.height);
                    
                    CGPoint bottomOffset1 = CGPointMake(0, 0);
                    
                    
                    
//                    if () {
//                        [self.backgroundScrollView setContentOffset:bottomOffset animated:YES];
//                    }else {
//                    
//                    
//                        [self.backgroundScrollView setContentOffset:bottomOffset1  animated:YES];
//                    }
                    
                    //[self.backgroundScrollView setContentOffset:bottomOffset animated:YES];
                    
                
                    if (self.backgroundScrollView.contentSize.height > (KDeviceHeight- 70)) {
                        [self.backgroundScrollView setContentOffset:bottomOffset animated:YES];
                    }else {
                    
                    
                        [self.backgroundScrollView setContentOffset:bottomOffset1  animated:YES];
                    }

                }
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }
            [self.footTextField resignFirstResponder];
            
            
            
        } failed:^(NSError *error) {
            //
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            [self.footTextField resignFirstResponder];
            
        }];
        
    }
    
}

#pragma mark - Toolbar animation helpers


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_summaryFormFiled.isReply)
    {
        [self.navigationController setToolbarHidden:NO];
    }
    
    // Listen for will show/hide notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShoww:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidee:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //
    _keyBoardYOffSet = 0;
    
}

    
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Stop listening for keyboard notifications
    
    //
  
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



#pragma mark - KeyBoard -

- (void)keyboardWillShoww:(NSNotification *)noti
{
    
    //tabbar移动
    
    NSDictionary *userInfo = [noti userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardFrame];
    
    [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, toolbarFrame.origin.y - keyboardFrame.size.height, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    
//
//    if (self.backgroundScrollView.contentSize.height > (KDeviceHeight- 70)) {
//        
//        [self.backgroundScrollView setFrame:CGRectMake(backgroundScrollViewFrame.origin.x, backgroundScrollViewFrame.origin.y, backgroundScrollViewFrame.size.width, KDeviceHeight - 64 - keyboardFrame.size.height)];
//        
//
//    }
    
    [self.backgroundScrollView setFrame:CGRectMake(backgroundScrollViewFrame.origin.x, backgroundScrollViewFrame.origin.y, backgroundScrollViewFrame.size.width, KDeviceHeight - 64 - keyboardFrame.size.height)];
//
    
    
    [UIView commitAnimations];
    
    
    CGPoint bottomOffset = CGPointMake(0, self.backgroundScrollView.contentSize.height-self.backgroundScrollView.bounds.size.height + 43);
    
    //CGPoint bottomOffset2 = CGPointMake(0, self.backgroundScrollView.contentSize.height-self.backgroundScrollView.bounds.size.height + 34);
    

    
    if (self.backgroundScrollView.contentSize.height > (KDeviceHeight- keyboardFrame.size.height - 50)) {
        
       [self.backgroundScrollView setContentOffset:bottomOffset animated:YES];
        
        
    }
    
//    if (!replyArray.count) {
//        [self.backgroundScrollView setContentOffset:bottomOffset2 animated:YES];
//    }
//
    
    //NSLog(@"%f",self.backgroundScrollView.contentOffset.y);//280 230
    
    
    [self.backgroundScrollView addGestureRecognizer:self.panGesture];
    
}


- (void)keyboardWillHidee:(NSNotification *)noti
{
//
    NSDictionary *userInfo = [noti userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardFrame];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];


//    if (([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)) {
//        [self.backgroundScrollView setFrame:CGRectMake(self.backgroundScrollView.frame.origin.x, self.backgroundScrollView.frame.origin.y, kDeviceWidth, self.backgroundScrollView.frame.size.height + keyboardFrame.size.height)];
//        //[self.backgroundScrollView setFrame:CGRectMake(backgroundScrollViewFrame.origin.x, backgroundScrollViewFrame.origin.y, backgroundScrollViewFrame.size.width, KDeviceHeight - 64 + keyboardFrame.size.height)];
//    }else
//        [self.backgroundScrollView setFrame:CGRectMake(self.backgroundScrollView.frame.origin.x, self.backgroundScrollView.frame.origin.y, kDeviceWidth, self.backgroundScrollView.frame.size.height + keyboardFrame.size.height)];
//
    
    [self.backgroundScrollView setFrame:CGRectMake(self.backgroundScrollView.frame.origin.x, self.backgroundScrollView.frame.origin.y, kDeviceWidth, self.backgroundScrollView.frame.size.height + keyboardFrame.size.height)];
    
    
    self.navigationController.toolbar.frame = toolbarFrame;

    
    [UIView commitAnimations];
    
   // NSLog(@"%f",self.backgroundScrollView.contentOffset.y);//399 //171
    
    //NSLog(@"%f",keyboardFrame.size.height);
    
    
    [self.backgroundScrollView removeGestureRecognizer:self.panGesture];
    
}

#pragma mark - event -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //[self.view endEditing:YES];


}

#pragma mark - UITextFieldDelegate methods

// Override to dynamically enable/disable the send button based on user typing
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = self.footTextField.text.length - range.length + string.length;
    if (length > 0) {
        self.footRightButtonItem.enabled = YES;
    } else {
        self.footRightButtonItem.enabled = NO;
    }
    return YES;
}


//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (self.footTextField.text.length > 0) {
//        self.footRightButtonItem.enabled = YES;
//    }else
//        self.footRightButtonItem.enabled = NO;
//
//
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length != 0) {
        [self Reply:nil];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Check if there is any message to send
    if (self.footTextField.text.length)
    {
        // Resign the keyboard
        [textField resignFirstResponder];
        
        // Clear the textField and disable the send button
        self.footRightButtonItem.enabled = YES;
    }else{
        self.footRightButtonItem.enabled = NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
        if (![fileManager fileExistsAtPath:filePath]) {
            [TOOL createFileWithName:@"tYWdefinedReport.plist"];
        }
        NSMutableArray *titles = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
        
        self.footTextField.text = [titles objectAtIndex:buttonIndex - 1];
        self.footRightButtonItem.enabled = YES;
    }
}

@end
