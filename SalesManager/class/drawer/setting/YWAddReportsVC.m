//
//  YWAddReportsVC.m
//  SalesManager
//
//  Created by tianjing on 14-1-3.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "YWAddReportsVC.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height


@interface YWAddReportsVC ()

@property (nonatomic, strong) UIView *bgV;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;

@end

@implementation YWAddReportsVC

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = BGCOLOR;
    
//
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
   UIButton* rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(newReport) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    UILabel *titleText;
    if(self.prepareAdd == YES)
    titleText = [TOOL setTitleView:@"添加自定义快捷回复"];
    else
    titleText = [TOOL setTitleView:@"编辑自定义快捷回复"];
    self.navigationItem.titleView=titleText;
    
    
    self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    self.bgV.backgroundColor = [UIColor whiteColor];
    
    addTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 0, SCREENW - 24, 200)];
    
    addTextView.font = [UIFont systemFontOfSize:14.0];
    //addTextView.layer.borderColor = [BORDERCOLOR CGColor];
    holderLabel = [[UILabel alloc]initWithFrame:CGRectMake(4,8, 280, 15)];
    holderLabel.backgroundColor = [UIColor clearColor];
    holderLabel.font = [UIFont systemFontOfSize:14.0];
    holderLabel.textColor = LINECOLOR;
    if(self.prepareAdd)
    {
         holderLabel.text = @"输入新的回复语";
    }
    else
    {
        holderLabel.text = @"";
        addTextView.text = self.prepareEditString;
    }
   
    [addTextView addSubview:holderLabel];
    addTextView.delegate = self;
    [self.view addSubview:self.bgV];
    [self.bgV addSubview:addTextView];
    
//
    [addTextView becomeFirstResponder];

}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        holderLabel.text = @"输入新的回复语";
    }else{
        holderLabel.text = @"";
    }
    
    
    
//    if (textView.text.length > 20) {
//        //NSLog(@"%ld",(unsigned long)text.text.length);
//        textLengthAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                     message:@"超过最大字数不能输入了"
//                                                    delegate:self
//                                           cancelButtonTitle:@"Ok"
//                                           otherButtonTitles:nil, nil];
//        
//        [textLengthAlert show];
//        
//        
//    }
    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (addTextView == textView)
    {
        if ([aString length] > 20) {
            textView.text = [aString substringToIndex:20];
            if (!textLengthAlert) {
                textLengthAlert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"超过最大字数不能输入了"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil, nil];
                
                [textLengthAlert show];
            }
            return NO;
        }
    }
    return YES;
    
}







-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    textLengthAlert = nil;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [addTextView resignFirstResponder];
}
-(void)gotoback
{
           [self.navigationController popViewControllerAnimated:YES];
}

-(void)newReport
{
        if(![addTextView.text isEqualToString:@""])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString*filePath = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
            if (![fileManager fileExistsAtPath:filePath])
            {
                [TOOL createFileWithName:@"tYWdefinedReport.plist"];
            }
            //self.defineReportsData =[NSMutableArray arrayWithContentsOfFile:filePath];
            self.defineReportsData = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:filePath]];
            if(self.prepareAdd )
             [self.defineReportsData insertObject:[NSString stringWithFormat:@"%@", addTextView.text]atIndex:0];
            else
             [self.defineReportsData replaceObjectAtIndex:self.atIndex withObject:[NSString stringWithFormat:@"%@", addTextView.text]];
            NSString *file = [TOOL fullPathWithFileName:@"tYWdefinedReport.plist"];
            [self.defineReportsData writeToFile:file atomically:YES];
            NSLog(@"define:%@",self.defineReportsData);
        }
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
