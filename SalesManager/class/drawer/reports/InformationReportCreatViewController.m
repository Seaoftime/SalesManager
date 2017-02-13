//
//  InformationReportCreatViewController.m
//  SalesManager
//
//  Created by Kris on 13-12-3.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "InformationReportCreatViewController.h"
#import "YFormDBM.h"
#import "YformFileds.h"
#import "ReportFieldCell.h"
#import "ReportViewCell.h"
#import "ReportDatePickerCell.h"
#import "ReportMobileBoxCell.h"
#import "ReportNameBoxCell.h"
#import "ReportNumberCell.h"
#import "ReportSelectCell.h"
#import "ReportCheckBoxCell.h"
#import "ReportCheckBoxViewController.h"
#import "ReportAddressBoxCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YManagerUserInfoFileds.h"
#import "YManagerUserInfoDBM.h"
#import "SVProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequestDelegate.h"
#import "SVProgressHUD.h"
#import "XHLocationManager.h"
#import "YSummaryDBM.h"
#import "YSummaryFields.h"
#import "InformationReportViewController.h"
#import "InformationReportPickPersonViewController.h"

#import "MHImagePickerMutilSelector.h"
#import "GetCAMPhotoURL.h"
#import "ILBarButtonItem.h"
#import "CLLocation+YCLocation.h"
#import "YManagerUserInfoDBM.h"
#import "NSUserDefaults+Additions.h"
#import "TOOL.h"


//
#import "YWSelectObjectsVC.h"


typedef enum {
    InformationReportCreateTypeField      = 0,//单行
    InformationReportCreateTypeView       = 1,//多行
    InformationReportCreateTypeMobileBox  = 2,//电话
    InformationReportCreateTypeSelect     = 3,//单选
    InformationReportCreateTypeCheckBox   = 4,//多选
    InformationReportCreateTypeDatePicker = 5,//日期
    InformationReportCreateTypePicture    = 6,//图片
    InformationReportCreateTypeNumber     = 7,//数量
    InformationReportCreateTypeNameBox    = 8,//回复
    InformationReportCreateTypeAddressBox = 9,//地址
    InformationReportCreateTypeTimeBox    = 10//时间（日期+时间）
} InformationReportCreateType;


@interface InformationReportCreatViewController ()<UITableViewDelegate,UITableViewDataSource,ReportFieldCellDelegate,ReportViewCellDelegate,ReportDatePickerCellDelegate,ReportMobileBoxCellDelegate,ReportNameBoxCellDelegate,ReportNumberCellDelegate,ReportSelectCellDelegate,ReportAddressBoxCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GetCAMPhotoURLDelegate,MHImagePickerMutilSelectorDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    YFormDBM *formDBM;
    NSArray *formArray;//表单
    int flag;//标记tableview
    NSString *longitude;                   //经度
    NSString *latitude;                    //维度
    NSString *address;                     //位置
    NSMutableArray *picURLs;//图片地址
    NSMutableArray *receivePicURLs;//收到的图片地址
    YSummaryDBM *summaryDBM;
    
    ALAssetsLibrary *library;
    UIImagePickerController *imagePicker;
    NSMutableArray *urlAndImageArray;
    
    BOOL isScroll;
    BOOL isDraft;
}

@property (strong, nonatomic) IBOutlet UIView *sendView;
@property (strong, nonatomic) IBOutlet UIButton *addPictureButton;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UIView *pictureView;
@property (strong, nonatomic) IBOutlet UIView *locationView;

//
@property (weak, nonatomic) IBOutlet UIView *photoChoiceView;

- (IBAction)backToTop:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)addPicture:(id)sender;
- (IBAction)deletePicture:(id)sender;





@end

@implementation InformationReportCreatViewController


- (IBAction)sendBtnClick:(id)sender {
    
    
    //YWSelectObjectsVC *selectV = [[YWSelectObjectsVC alloc] init];
    //[self.navigationController pushViewController:selectV animated:YES];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        formDBM = [[YFormDBM alloc] init];
        _formFiled = [[YformFileds alloc] init];
        _selectPersonArray = [[NSMutableArray alloc] init];

        _selectPictureArray = [[NSMutableArray alloc] init];
        formArray = [[NSArray alloc] init];
        _creatDic = [[NSMutableDictionary alloc] init];
        flag = 0;
        picURLs = [[NSMutableArray alloc] init];
        receivePicURLs = [[NSMutableArray alloc] init];
        summaryDBM = [[YSummaryDBM alloc] init];
        
        urlAndImageArray = [[NSMutableArray alloc] initWithObjects: [NSMutableArray new], [NSMutableArray new], nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
//    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    [view setBackgroundColor:[UIColor clearColor]];
//    
//    [self.tableView addSubview:view];
    if (!isScroll) {
        NSDictionary *keyboardInfo = [notification userInfo];
        
        float during = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [self performSelector:@selector(afterFunction) withObject:nil afterDelay:during];
    }
    
}

- (void)afterFunction
{
    isScroll = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user.companyCode isEqualToString:LIMING1] || [user.companyCode isEqualToString:LIMING2])
    {
        YManagerUserInfoDBM *managerUserInfoDBM = [[YManagerUserInfoDBM alloc] init];
        self.selectPersonArray = [NSMutableArray arrayWithArray:[managerUserInfoDBM getManagersMembersIDByMyDepartMent]];
        
        //填充表单
//        [self reloadSendPeopleLabel];
    }
    
    if ([user.companyCode isEqualToString:LIMING1])
    {
        if (![self.selectPersonArray containsObject:@"2"])
        {
            [self.selectPersonArray addObject:@"2"];//添加lmzg
        }
        
        
        self.sendView.hidden = YES;
    }else if ([user.companyCode isEqualToString:LIMING2]){
        
        if (![self.selectPersonArray containsObject:@"1927"])
        {
            [self.selectPersonArray addObject:@"1927"];//添加lmzg
        }
        
        self.sendView.hidden = YES;
    }else{
        self.sendView.hidden = NO;
    }
    
    latitude = nil;
    longitude = nil;
    
    
    [self setTitle:[NSString stringWithFormat:@"新建%@",_formFiled.sectionTitle]];
    
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(backToTop:)];
    
     //Right bar button item
    ILBarButtonItem *rightBtn = [ILBarButtonItem barItemWithTitle:@"发送"
                                                       themeColor:[UIColor whiteColor]
                                                           target:self
                                                           action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    //获取信息汇报的表单
    formArray =  [formDBM getFormDetails:@"信息汇报" inSectionID:self.formFiled.sectionID orSectionTitle:nil check:YES];
    
    
    
    //判断是否需要上传图
    switch (self.formFiled.isImage)
    {
        case 0://不上传
            [_pictureView setHidden:YES];
            break;
        case 1://可以上传
            [_pictureView setHidden:NO];
            library = [[ALAssetsLibrary alloc] init];
            break;
        case 2://必须上传
            [_pictureView setHidden:NO];
            library = [[ALAssetsLibrary alloc] init];
            break;
        default:
            break;
    }
    
    
    //判断是否需要gps
    switch (self.formFiled.gps)
    {
        case 0://不上传
            [_locationView setHidden:YES];
            break;
            
        case 1://可以上传
        {
            if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
                
            }else{
                UILabel *gpsLabel = (UILabel *)[_locationView viewWithTag:100];
                //gpsLabel.text = @"定位失败";
                gpsLabel.text = @"正在定位...";
            }
            
            if (!self.formFiled.isImage) {
                
                [_locationView setFrame:CGRectMake(10, 10, 300, 20)];
                
            }
//
#warning 定位
            [self startLocation];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(startLocation) userInfo:nil repeats:YES];
            
            break;
        }
        case 2://必须上传
        {
            
            if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
                
            }else{
                UILabel *gpsLabel = (UILabel *)[_locationView viewWithTag:100];
                gpsLabel.text = @"定位失败";
                
                
                NSLog(@"用户不允许定位，即没有在设置中开启定位");
                //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法获取你的位置信息" message:@"请到手机系统的【设置】->【隐私】->【定位服务】中开启定位服务，并允许业务云管家使用定位服务。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                //[alertView show];
                
            }
            
            if (!self.formFiled.isImage) {
                [_locationView setFrame:CGRectMake(10, 10, 300, 20)];
            }
//
            [self startLocation];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(startLocation) userInfo:nil repeats:YES];
            
            break;
        }
            
        default:
            break;
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"%@%@%ld",userID,company_Code,(long)self.formFiled.sectionID];
    
    
    NSMutableArray *tempArray = (NSMutableArray *)[userDefaults objectForKey:keyName];
    
    if (tempArray) {
        _selectPersonArray = tempArray;
    }
    
    
    
}


- (void)startLocation
{
    UILabel *gpsLabel = (UILabel *)[_locationView viewWithTag:100];
    
    [[XHLocationManager sharedManager] locationRequest:^(CLLocation *location, NSError *error) {
        if (error == nil) {
            NSLog(@"%@",location);
            
            //火星坐标转成百度坐标，传给服务器用
            CLLocation *baidulocation = [location locationBaiduFromMars];
            latitude = [NSString stringWithFormat:@"%f",baidulocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",baidulocation.coordinate.longitude];
            
        } else {
            NSLog(@"%@",error);
            gpsLabel.text = @"定位失败";
        }
    } reverseGeocodeCurrentLocation:^(CLPlacemark *placemark, NSError *error) {
        if (error == nil) {
            NSLog(@"%@",placemark);
            address = placemark.name;
            [gpsLabel setText:address];
        } else {
            NSLog(@"%@",error);
            if ([gpsLabel.text isEqualToString:@"正在定位..."])
            {
                gpsLabel.text = @"无法获取到城市信息";
            }
        }
    }];
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UILabel *label = (UILabel *)[self.sendView viewWithTag:100];
    label.font = [UIFont systemFontOfSize:14];

    if (_selectPersonArray.count == 0) {
        label.text = @"";
    }else if (_selectPersonArray.count <= 3){
        YManagerUserInfoDBM *userDBM = [[YManagerUserInfoDBM alloc] init];
        NSMutableString *nameString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i = 0; i<_selectPersonArray.count; i++) {
            YManagerUserInfoFileds *userFiled = [userDBM getPersonInfoByUserID:[[_selectPersonArray objectAtIndex:i] integerValue] withPhotoUrl:NO withDepartment:NO withContacts:NO];
            if (i == _selectPersonArray.count-1) {
                [nameString appendString:userFiled.userName];
            }else{
                [nameString appendString:[NSString stringWithFormat:@"%@、",userFiled.userName]];
            }
        }
        
        label.text = nameString;
        
    }else{
        
        YManagerUserInfoDBM *userDBM = [[YManagerUserInfoDBM alloc] init];
        NSMutableString *nameString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i = 0; i< 3; i++) {
            YManagerUserInfoFileds *userFiled = [userDBM getPersonInfoByUserID:[[_selectPersonArray objectAtIndex:i] integerValue]withPhotoUrl:NO withDepartment:NO withContacts:NO];
            if (i == 2) {
                [nameString appendString:[NSString stringWithFormat:@"%@等%lu人",userFiled.userName,(unsigned long)_selectPersonArray.count]];
            }else{
                [nameString appendString:[NSString stringWithFormat:@"%@、",userFiled.userName]];
            }
        }
        
        label.text = nameString;
    }
    NSLog(@"%@",label);
}

- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}



#pragma mark - navigationbar item action

- (IBAction)backToTop:(id)sender
{
    [self resignKeyBoardInView:self.tableView];
    
    BOOL flag1 = NO;
    
    for (YformFileds *tempFormFiled in formArray)
    {
        NSLog(@"%@",tempFormFiled.formName);
        
        NSString *string;
        
        if ([tempFormFiled.formType isEqualToString:@"datePicker"])
        {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[_creatDic objectForKey:tempFormFiled.formReferName] intValue]]];
            
            NSString *nowString = [formatter stringFromDate:[NSDate date]];
            
            
            
            if (![nowString isEqualToString:string]) {
                flag1 = YES;
            }
            
        }else{
            string = [_creatDic objectForKey:tempFormFiled.formReferName];
            if (string) {
                flag1 = YES;
            }
        }
    }
    

    if (flag1) {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"返回后您填写的数据将会被抹掉，是否要继续" delegate:self cancelButtonTitle:@"不，我还要编辑" otherButtonTitles:@"确定", nil];
//        [alert show];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否存草稿？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    switch (buttonIndex) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            isDraft = YES;
            NSLog(@"%d", isDraft);
            [self sendReport];
        }
        default:
            break;
    }

}

//判断哪些是必填项目
- (BOOL)isDone
{
    //判断发送人员
    UILabel *label = (UILabel *)[self.sendView viewWithTag:100];
    if ([label.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发送人员不能为空，请填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    //判断项目内容是否填写
    for (YformFileds *tempFormFiled in formArray)
    {
        if (tempFormFiled.need == 1)
        {
            NSLog(@"%@", [_creatDic objectForKey:tempFormFiled.formReferName]);
            if (![_creatDic objectForKey:tempFormFiled.formReferName] || [[_creatDic objectForKey:tempFormFiled.formReferName] isEqualToString:@""] || [[_creatDic objectForKey:tempFormFiled.formReferName] isEqualToString:@"(null)"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@不能为空，请填写",tempFormFiled.formName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
    }
    
    //判断图片
    if (self.formFiled.isImage == 2)
    {
        if (![[urlAndImageArray objectAtIndex:0] count])
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"您还没有添加任何图片" message:@"请添加图片后再执行此操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    
    //判断定位
    if (self.formFiled.gps == 2)
    {
//        UILabel *gpsLabel = (UILabel *)[_locationView viewWithTag:100];
//        if ([gpsLabel.text isEqualToString:@"正在定位..."] || [gpsLabel.text isEqualToString:@""]||[gpsLabel.text isEqualToString:@"定位失败"])
        if (longitude == nil || latitude == nil)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"无法定位" message:@"请获得定位信息后提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }

    return YES;
}

- (void)done:(id)sender
{
    if ([self isDone])
    {
        [self resignKeyBoardInView:self.tableView];
        
        //首先传图片，然后拿到url在上传汇报
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([[urlAndImageArray objectAtIndex:0] count] ) {
            NSThread* upload = [[NSThread alloc]initWithTarget:self selector:@selector(startUpLoadFun) object:nil];
            [upload start];
            
            ASINetworkQueue *queue = [[ASINetworkQueue alloc] init];
            [queue setMaxConcurrentOperationCount:1];
            [queue setShouldCancelAllRequestsOnFailure:YES];
            [queue setDelegate: self];
            
//            [queue setRequestDidFinishSelector:@selector(queueComplete:)];
            NSDate* dates = [NSDate date];
            
            for (NSInteger i = [[urlAndImageArray objectAtIndex:0] count] -1; i >= 0 ;  i--) {
                CGFloat compressPoint = 0.9;
                
                
                NSString *url = [NSString stringWithFormat:@"%@?mod=myphoto&fun=post&user_id=%@&rand_code=%@&versions=%@&stype=1", API_headaddr, user.ID, user.randCode, VERSIONS];
                NSLog(@"%@",url);
                
                
                ASIFormDataRequest *requests = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
                [requests setDelegate:self];
                [requests setRequestMethod:@"POST"];
                requests.tag = i;
                
                
                [requests addRequestHeader:@"Content-Type" value:@"photo"];
                [requests addPostValue:[[urlAndImageArray objectAtIndex:0] objectAtIndex:i] forKey:@"content"];
                [requests addPostValue:@"testalbum" forKey:@"album"];
                
                
                NSString* PhotoTitle = [NSString stringWithFormat:@"%ld", (long)[dates timeIntervalSince1970]];
                int  x=arc4random()%100000;
                PhotoTitle = [PhotoTitle stringByAppendingString:[NSString stringWithFormat:@"_%i",x]];
                
                NSURL *imageUrl= [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[urlAndImageArray objectAtIndex:0] objectAtIndex:i]]];
                
                [library assetForURL:imageUrl resultBlock:^(ALAsset *asset)  {
                    UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    NSMutableData *imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(image, compressPoint)];
                    [requests addData:imageData withFileName:PhotoTitle andContentType:@"image/jpeg" forKey:@"photo"];
                    [requests addPostValue:PhotoTitle forKey:@"title"];
                    [requests setDidFinishSelector:@selector(headPortraitSuccesss:)];//当成功后会自动触发 headPortraitSuccess 方法
                    [requests setDidFailSelector:@selector(headPortraitFail:)];//如果失败会 自动触发 headPortraitFail 方法
                    [requests setTimeOutSeconds:30];
                    NSLog(@"%@",requests);
                    [queue addOperation:requests];
                }failureBlock:^(NSError *error) {
                    NSLog(@"error=%@",error);
                }
                 ];
            }
            [queue setQueueDidFinishSelector:@selector(queueDidFinish:)];
            [queue go];
            
        }else{
            
            [self sendReport];
        }
    }
}

- (void)sendReport
{
    //接收人
    NSMutableString *personString = [[NSMutableString alloc] initWithString:@""];
    YManagerUserInfoDBM *userDBM = [[YManagerUserInfoDBM alloc] init];
    for (int i = 0; i<_selectPersonArray.count; i++) {
        YManagerUserInfoFileds *userFiled = [userDBM getPersonInfoByUserID:[[_selectPersonArray objectAtIndex:i] integerValue] withPhotoUrl:NO withDepartment:NO withContacts:NO];
        if (i == _selectPersonArray.count-1) {
            [personString appendString:[NSString stringWithFormat:@"%@",userFiled.userName]];
        }else{
            [personString appendString:[NSString stringWithFormat:@"%@,",userFiled.userName]];
        }
    }
    NSLog(@"%@",personString);
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyName = [NSString stringWithFormat:@"%@%@%ld",userID,company_Code,(long)self.formFiled.sectionID];
    [userDefaults setObject:self.selectPersonArray forKey:keyName];
    
    int nowTime;
    //发送时间
//    if (_isEdit) {
//        nowTime = _editPosttime;
//    }else{
        nowTime = [[NSDate date] timeIntervalSince1970];
//    }
    
    
    //储存日志内容
    for (NSString *key in [_creatDic allKeys])
    {
        YSummaryFields *summaryField = [[YSummaryFields alloc] init];
        summaryField.postTime = nowTime;
        summaryField.sectionID = self.formFiled.sectionID;
        summaryField.formName = key;
        summaryField.formValue = [_creatDic objectForKey:key];
        
        [summaryDBM saveSummaryContent:summaryField];
    }
    
    
    //储存日志列表内容
    YSummaryFields *summaryField = [[YSummaryFields alloc] init];
    summaryField.postTime = nowTime;
    summaryField.reciver = personString;
    summaryField.reciverID = [_selectPersonArray componentsJoinedByString:@","];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    summaryField.senderName = user.name;
    summaryField.senderUserID = user.ID;
    summaryField.myLocation = address;
    summaryField.isMine = 1;
    if (isDraft) {
        summaryField.upload = 4;
    }else{
        summaryField.upload = 0;
    }
    
    summaryField.latitude = latitude;
    summaryField.longitude = longitude;
    summaryField.sectionID = self.formFiled.sectionID;
    
    NSMutableString *contentStrings = [[NSMutableString alloc] init];
    for (YformFileds *tempFormFiled in formArray)
    {
        NSLog(@"%@",tempFormFiled.formName);
        
        NSString *string;
        
        if ([tempFormFiled.formType isEqualToString:@"datePicker"])
        {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[_creatDic objectForKey:tempFormFiled.formReferName] intValue]]];
        }else{
            string = [_creatDic objectForKey:tempFormFiled.formReferName];
        }
        
        NSLog(@"%@",[_creatDic objectForKey:tempFormFiled.formReferName]);
        [contentStrings appendFormat:@"%@:%@%@  ",tempFormFiled.formName,string,tempFormFiled.formUnit];
    }
    NSLog(@"%@",contentStrings);
    summaryField.summaryPreview = contentStrings;
    [summaryDBM saveSummaryList:summaryField];
    
    
    if (self.formFiled.isImage)
    {
        //图片url
        NSLog(@"%@",receivePicURLs);
        
        for (NSString *string in receivePicURLs)
        {
            //储存日志图片
            [summaryDBM savePhotoUrl:string byPostTime:nowTime];
        }
    }
    
    InformationReportViewController *reportVC = (InformationReportViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [reportVC addCell:summaryField];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (IBAction)addPicture:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    
    // Show the action sheet
    [sheet showInView:self.view];
    
}

- (IBAction)deletePicture:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.hidden = YES;
    
    UIImageView *image = (UIImageView *)[_pictureView viewWithTag:(200+button.tag-300)];
    image.image = nil;
    
    [[urlAndImageArray objectAtIndex:0] removeObjectAtIndex:(button.tag-300)];
    [[urlAndImageArray objectAtIndex:1] removeObjectAtIndex:(button.tag-300)];

    NSLog(@"%@",urlAndImageArray);

    if ([[urlAndImageArray objectAtIndex:0] count]) {
        [self moveAddButton];
    }else{
        [_addPictureButton setFrame:CGRectMake(13, 13, 59, 59)];
    }
}

- (IBAction)sendBtnClic:(id)sender {
}

- (IBAction)sendButtonClick:(id)sender {
}

#pragma mark - UIActionSheetDelegate methods


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex)
    {
        case 0:
        {
            [GetCAMPhotoURL showInViewController:self];
        }
            break;
        case 1:
        {
            [MHImagePickerMutilSelector showInViewController:self init:[urlAndImageArray objectAtIndex:0] :[urlAndImageArray objectAtIndex:1] :4];
        }
            break;
        default:
            break;
    }

}


#pragma mark - GetCAMPhotoURLDelegate

-(void)imagePickerGetCAMPhotoURL:(NSString*)CAMPhotoURL thumbimage:(UIImage*)thumbnail
{
    NSLog(@"%@",CAMPhotoURL);
    NSLog(@"%@",thumbnail);
    if (![[urlAndImageArray objectAtIndex:0] containsObject:CAMPhotoURL]) {
        [[urlAndImageArray objectAtIndex:0] addObject:CAMPhotoURL];
        [[urlAndImageArray objectAtIndex:1] addObject:thumbnail];
    }
    
    NSLog(@"%@",urlAndImageArray);
    [self moveAddButton];
}

#pragma mark - MHImagePickerMutilSelectorDelegate

-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)urlAndimageArray
{
    NSLog(@"%@",urlAndimageArray);
    
    for (int i=0; i<[[urlAndimageArray objectAtIndex:0] count]; i++) {
        NSString *string = [[urlAndimageArray objectAtIndex:0] objectAtIndex:i];
        if (![[urlAndImageArray objectAtIndex:0] containsObject:string]) {
            [[urlAndImageArray objectAtIndex:0] addObject:string];
            [[urlAndImageArray objectAtIndex:1] addObject:[[urlAndimageArray objectAtIndex:1] objectAtIndex:i]];
        }
    }
    NSLog(@"%@",urlAndImageArray);
    [self moveAddButton];
}
#pragma mark - 移动图片

- (void)moveAddButton
{
    NSMutableArray *images = [urlAndImageArray objectAtIndex:1];
    for (int i=0; i<4; i++) {
        UIImageView *image = (UIImageView *)[_pictureView viewWithTag:(200+i)];
        [image setImage:nil];
        [image.layer setCornerRadius:5];
        [image setClipsToBounds:YES];
        
        UIButton *button = (UIButton *)[_pictureView viewWithTag:(300+i)];
        button.hidden = YES;
    }
    
    for (int i=0; i<images.count ; i++)
    {
        UIImageView *image = (UIImageView *)[_pictureView viewWithTag:(200+i)];
        [image setImage:[images objectAtIndex:i]];
        
        UIButton *button = (UIButton *)[_pictureView viewWithTag:(300+i)];
        button.hidden = NO;
        
        [_addPictureButton setFrame:CGRectMake(85+i*72, 13, 59, 59)];
        if (i >= 3) {
            _addPictureButton.hidden = YES;
        }else{
            _addPictureButton.hidden = NO;
        }
    }
    NSLog(@"%@",picURLs);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return formArray.count;
}

- (InformationReportCreateType)returnTypeFormString:(NSString *)aString
{
    InformationReportCreateType type;
    
    if ([aString isEqualToString:@"field"]) {
        type = InformationReportCreateTypeField;
    }else if ([aString isEqualToString:@"view"]) {
        type = InformationReportCreateTypeView;
    }else if ([aString isEqualToString:@"datePicker"]) {
        type = InformationReportCreateTypeDatePicker;
    }else if ([aString isEqualToString:@"select"]) {
        type = InformationReportCreateTypeSelect;
    }else if ([aString isEqualToString:@"checkbox"]) {
        type = InformationReportCreateTypeCheckBox;
    }else if ([aString isEqualToString:@"number"]) {
        type = InformationReportCreateTypeNumber;
    }else if ([aString isEqualToString:@"namebox"]) {
        type = InformationReportCreateTypeNameBox;
    }else if ([aString isEqualToString:@"mobilebox"]) {
        type = InformationReportCreateTypeMobileBox;
    }else if ([aString isEqualToString:@"addressbox"]) {
        type = InformationReportCreateTypeAddressBox;
    }else if ([aString isEqualToString:@"timebox"]) {
        type = InformationReportCreateTypeTimeBox;
    }else{
        type = 0;
    }
    
    NSLog(@"%D",type);
    
    return type;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取表单数据
    YformFileds *tempFormFiled = (YformFileds *)[formArray objectAtIndex:indexPath.row];
    
    //    field','view','datePicker','select','checkbox','number','namebox','mobilebox'
    
    switch ([self returnTypeFormString:tempFormFiled.formType])
    {
            
        case InformationReportCreateTypeField:
        {
            ReportFieldCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportFieldCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            cell.textField.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            
            return cell;
        }
        case InformationReportCreateTypeView:
        {
            ReportViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportViewCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.textView.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            cell.formFiled = tempFormFiled;
            return cell;
        }
        case InformationReportCreateTypeDatePicker:
        {
            ReportDatePickerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportDatePickerCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            //            cell.dateLabel.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            return cell;
        }
        case InformationReportCreateTypeSelect:
        {
            ReportSelectCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportSelectCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            cell.selectTextField.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            return cell;
        }
        case InformationReportCreateTypeCheckBox:
        {
            ReportCheckBoxCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportCheckBoxCell" owner:self options:nil] lastObject];
            cell.formFiled = tempFormFiled;
            cell.selectTextField.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            return cell;
        }
        case InformationReportCreateTypeNumber:
        {
            ReportNumberCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportNumberCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            cell.textField.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            
            return cell;
        }
        case InformationReportCreateTypeNameBox:
        {
            ReportNameBoxCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportNameBoxCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            cell.textField.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            
            return cell;
        }
        case InformationReportCreateTypeMobileBox:
        {
            ReportMobileBoxCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportMobileBoxCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            cell.textField.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            return cell;
        }
        case InformationReportCreateTypeAddressBox:
        {
            ReportAddressBoxCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportAddressBoxCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.formFiled = tempFormFiled;
            cell.informationReportCreatViewController = self;
            return cell;
        }
        case InformationReportCreateTypeTimeBox:
        {
            ReportDatePickerCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportDatePickerCell" owner:self options:nil] lastObject];
            cell.delegate = self;
            cell.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            cell.formFiled = tempFormFiled;
            
            //            cell.dateLabel.text =  [_creatDic objectForKey:tempFormFiled.formReferName];
            return cell;
        }
        default:
            break;
    }
    UITableViewCell *cell = nil;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取表单数据
    YformFileds *tempFormFiled = (YformFileds *)[formArray objectAtIndex:indexPath.row];
    
    if([self returnTypeFormString:tempFormFiled.formType] == InformationReportCreateTypeView)
    {
        return 94;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YformFileds *tempFormFiled = (YformFileds *)[formArray objectAtIndex:indexPath.row];
    
    if([self returnTypeFormString:tempFormFiled.formType] == InformationReportCreateTypeCheckBox)
    {
        [self performSegueWithIdentifier:@"toCheckBox" sender:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toCheckBox"])
    {
        NSIndexPath *indexPath = sender;
        YformFileds *tempFormFiled = (YformFileds *)[formArray objectAtIndex:indexPath.row];
        
        ReportCheckBoxViewController *checkBoxViewController = [segue destinationViewController];
        checkBoxViewController.formFiled = tempFormFiled;
        checkBoxViewController.reportCheckBoxCell = (ReportCheckBoxCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        checkBoxViewController.informationReportCreatVC = self;
    }
    
    if ([segue.identifier isEqualToString:@"new_selectPeople"])
    {
        InformationReportPickPersonViewController *pickPersonVC = [segue destinationViewController];
        pickPersonVC.selectPersonArray = _selectPersonArray;
    }
}





#pragma mark - cell delegate

- (void)reportFieldCell:(ReportFieldCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    if (cell.isDone) {
//
        [cell.textField resignFirstResponder];isScroll = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    [_creatDic addEntriesFromDictionary:dic];
    
    
}

- (void)reportViewCell:(ReportViewCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    
    if (cell.isDone) {
//
        [cell.textView resignFirstResponder];isScroll = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    [_creatDic addEntriesFromDictionary:dic];
    
    //NSLog(@"%@",_creatDic);
}

- (void)reportDatePickerCell:(ReportDatePickerCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    [_creatDic addEntriesFromDictionary:dic];
    
    
}

- (void)reportMobileBoxCell:(ReportMobileBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    
    if (cell.isDone) {
//
        
        [cell.textField resignFirstResponder];isScroll = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    [_creatDic addEntriesFromDictionary:dic];
    
    
    
}

- (void)reportNameBoxCell:(ReportNameBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    
    if (cell.isDone) {
//
        
        [cell.textField resignFirstResponder];isScroll = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    [_creatDic addEntriesFromDictionary:dic];
    
    //NSLog(@"%@",_creatDic);
}

- (void)reportNumberCell:(ReportNumberCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    
    if (cell.isDone) {
//
        
        [cell.textField resignFirstResponder];isScroll = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    [_creatDic addEntriesFromDictionary:dic];
    

}


- (void)reportCheckBoxCell:(ReportCheckBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    [_creatDic addEntriesFromDictionary:dic];
    
    
}

- (void)reportSelectCell:(ReportSelectCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);
    [_creatDic addEntriesFromDictionary:dic];
    
}



- (void)reportAddressBoxCell:(ReportAddressBoxCell *)cell didEndEditingWithDictionary:(NSDictionary *)dic
{
    //NSLog(@"%@",dic);isScroll = NO;
    [_creatDic addEntriesFromDictionary:dic];
    
}


#pragma mark - uploadimagedelegate

-(void)startUpLoadFun
{
    [SVProgressHUD showWithStatus:@"图片上传中，请稍后"];
}

//- (void)queueComplete:(ASINetworkQueue *)queue
//{
//    [SVProgressHUD dismiss];
//}


-(void)headPortraitFail:(ASIFormDataRequest* )requs
{
    NSLog(@"%@",requs.responseString);
    [SVProgressHUD showWithStatus:@"上传失败"];
}



-(NSString* )getPath:(NSString* )url{
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    const char *str = [url UTF8String];
    
    CC_MD5(str, strlen(str), r);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //下载路径
    
    NSString* downloadPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    
    
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    NSString* newDownloadPath = [downloadPath stringByAppendingPathComponent:filename];
    return newDownloadPath;
}

- (void)saveToApp:(NSDictionary *)photoDic
{
//
    
}

-(void)headPortraitSuccesss:(ASIFormDataRequest* )requs
{
    NSLog(@"%@",requs.responseString);
    //[SVProgressHUD showSuccessWithStatus:@"上传成功"];
    NSString* content = @"testcontent";//[selectPhotosContents objectAtIndex:requs.tag];
    NSLog(@"内容为%@",content);
    
    NSDictionary* photoDic = [NSJSONSerialization JSONObjectWithData:[requs.responseString dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    
    NSString* code = [[photoDic objectForKey:@"code"] stringValue];
    NSLog(@"%@",photoDic);
    
    
    if ([code isEqualToString:@"90200"])
    {
        if (![receivePicURLs containsObject:[photoDic objectForKey:@"url"]])
        {
            [receivePicURLs addObject:[photoDic objectForKey:@"url"]];
            
            if (receivePicURLs.count == [[urlAndImageArray objectAtIndex:0] count])
            {
                
                [self sendReport];
                
            }
        }
        
    }
    
    
    
}

-(void)queueDidFinish:(ASINetworkQueue* )que
{
    NSLog(@"%@",que.userInfo);
    
    [SVProgressHUD dismiss];
    
}

#pragma mark - defaultReviveSummaryPeroson


- (void)defaultReciveSummaryPerson:(NSString *)defaultReciveSummaryPerson BySectionId:(NSString* )sectionId byPersons:(NSString* )persons
{
    NSUserDefaults* asd = [NSUserDefaults standardUserDefaults];
    
    [asd setObject:persons forKey:[@"defaultsReviceSummaryPersons" stringByAppendingFormat:@"%@%@%@",asd.userName,asd.companyCode,sectionId]];
    [asd synchronize];
}


- (NSString* )defaultReciveSummaryPersonbySectionId:(NSString* )sectionID{
    NSUserDefaults* asd = [NSUserDefaults standardUserDefaults];
    return [asd stringForKey:[@"defaultsReviceSummaryPersons" stringByAppendingFormat:@"%@%@%@",asd.userName,asd.companyCode,sectionID]];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    
    if (isScroll) {
        
        
        [self resignKeyBoardInView:self.tableView];
    }
    
    isScroll = NO;
}


@end
