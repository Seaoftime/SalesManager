//
//  YWPrepareDoneVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-6.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWPrepareDoneVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
#import "SDWebImageManager.h"
@interface YWPrepareDoneVC ()

@end

@implementation YWPrepareDoneVC
extern NSString* userid;
extern NSString* randcode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    taskDBM = [[YTaskDBM alloc]init];
    taskFields = [[taskDBM findautoIncremenID:self.autoIncremenID limit:0 isMine:9] objectAtIndex:0];
    
    self.contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, kDeviceWidth, 150)];
    self.contentView.delegate =self;
//    self.contentView.layer.borderWidth = 0.5;
//    self.contentView.layer.cornerRadius = 5.0;
//    self.contentView.layer.borderColor = [BORDERCOLOR CGColor];
    
    [self.view addSubview:self.contentView];
    
    holderLabel = [[UILabel alloc]initWithFrame:CGRectMake(2,2, 280, 15)];
    
    holderLabel.backgroundColor = [UIColor clearColor];
    
    
    holderLabel.font = [UIFont systemFontOfSize:14.0];
    holderLabel.textColor = LINECOLOR;
    holderLabel.text = @"请输入完成备注（1000字以内，可以为空）";
    [self.contentView addSubview:holderLabel];
    
    
    self.view.backgroundColor = BGCOLOR;
    
    
//    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(16, 20, 50, 44)];
//    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal ];    UIBarButtonItem* backItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(gotoback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
   // [rightButton setBackgroundImage:[UIImage imageNamed:@"creatReport_done@2x"] forState:UIControlStateNormal ];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    
    UILabel *titleText = [TOOL setTitleView:@"填写任务备注"];
    self.navigationItem.titleView=titleText;
    self.navigationController.navigationBar.backgroundColor = NAVIGATIONCOLOR;
}

-(void)done
{
    [SVProgressHUD showWithStatus:@"发送中。。。"];
    
    [[YWNetRequest sharedInstance] requestPrepareDoneVCDataWithTaskId:self.taskID WithContentText:self.contentView.text WithSuccess:^(id respondsData) {
        //
        if([[respondsData objectForKey:@"code"]integerValue]==80200)
        {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            taskFields.taskFinishedContent = self.contentView.text;
            taskFields.taskWhetherFinished = 1;
            taskFields.upLoad = 1;
            taskFields.timeStampContent = [[respondsData objectForKey:@"lastdotime"]integerValue];
            taskFields.timeStampList = [[respondsData objectForKey:@"lastdotime"]integerValue];
            [taskDBM uploadTaskContent:taskFields];
        }
        else
        {
            [self checkCodeByJson:respondsData];
        }
        [SVProgressHUD dismiss];

    } failed:^(NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.contentView == textView)
    {
        if ([aString length] > 1000) {
            textView.text = [aString substringToIndex:1000];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入完成备注（1000字以内，可以为空）"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        holderLabel.text = @"请输入完成备注（1000字以内，可以为空）";
    }else{
        holderLabel.text = @"";
    }
}

-(void)gotoback
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
