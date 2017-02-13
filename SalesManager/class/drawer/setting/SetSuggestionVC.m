//
//  SetSuggestionVC.m
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SetSuggestionVC.h"
#import "TOOL.h"
//#import "AFJSONRequestOperation.h"


#import "SVProgressHUD.h"
extern NSString* userid;
extern NSString* randcode;

@interface SetSuggestionVC ()

@end

@implementation SetSuggestionVC

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
    self.view.backgroundColor = BGCOLOR;
//    self.suggestionText.layer.borderWidth = 0.5;
//    self.suggestionText.layer.cornerRadius = 5.0;
//    self.suggestionText.layer.borderColor = [BORDERCOLOR CGColor];
    
    
    self.suggestionText.delegate = self;
//
    self.navigationItem.leftBarButtonItem = [TOOL getBarButtonItemWithTitle:@"返回" target:self selector:@selector(gotoback)];
    
    UIButton* rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(240, 20, 50, 44)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    UIBarButtonItem* downloadItem= [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = downloadItem;
    
    UILabel *titleText = [TOOL setTitleView:@"意见反馈"];
    self.navigationItem.titleView=titleText;
    
    [self.suggestionText becomeFirstResponder];
    
}

-(void)gotoback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -textviewdelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.holderLabel.text = @"请填写你的反馈意见";
    }else{
        self.holderLabel.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.suggestionText == textView)
    {
        if ([aString length] > 1000) {
            textView.text = [aString substringToIndex:1000];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"超过最大字数不能输入了"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

-(void)done
{
    if(self.suggestionText.text.length == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"输入为空，请检查"
                                                     message:Nil
                                                    delegate:nil
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else
    {
    [SVProgressHUD showSuccessWithStatus:@"感谢您的宝贵意见！"];
    NSString *stype = @"1";
    NSString *urls =API_postSuggestion(API_headaddr,userID,randCode,self.suggestionText.text,@"iPhone",VERSIONS,stype);//API_postSuggestion(API_headaddr,userDefaults.ID,userDefaults.randCode,self.suggestionText.text,@"",versions,stype);
    NSLog(@"%@",urls);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urls]];
        [request setTimeoutInterval:kTIMEOUT];
        
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                                                        
//                                                    }
//                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                        
//                                                    }];
//    [operation start];
        
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
