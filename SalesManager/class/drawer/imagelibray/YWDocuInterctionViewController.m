//
//  YWDocuInterctionViewController.m
//  SalesManager
//
//  Created by TonySheng on 16/5/10.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWDocuInterctionViewController.h"
#import "NavigationView.h"

@interface YWDocuInterctionViewController ()<UIDocumentInteractionControllerDelegate>


@property (nonatomic, retain) UIDocumentInteractionController *docController;



@end

@implementation YWDocuInterctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = BGCOLOR;
    
    [self open];
}


#pragma mark - documentInteractionControllerDelegate -

- (void)open
{
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"aa.docx" ofType:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:self.path ofType:nil];
    //NSLog(@"%@",path);
    NSURL *file_URL = [NSURL fileURLWithPath:path];
    
    if (_docController == nil) {
        
        //_docController = [[UIDocumentInteractionController alloc] init];
        
        _docController = [UIDocumentInteractionController interactionControllerWithURL:file_URL];
        _docController.delegate = self;
        
        
    }else {
        
        _docController.URL = file_URL;
    }
    
    NSLog(@"%@",_docController.gestureRecognizers);
    
    //直接显示预览
    
    [_docController presentPreviewAnimated:YES];
    //[_docController presentOpenInMenuFromRect:CGRectMake(760, 20, 100, 100) inView:self.view animated:YES];
    
    
}



- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return  self.view.frame;
}


//点击done
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    //[_docController dismissMenuAnimated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
