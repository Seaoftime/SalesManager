//
//  SwitchTypeViewController.m
//  SalesManager
//
//  Created by louis on 14-3-21.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "SwitchTypeViewController.h"
#import "TypeChoiceCell.h"
#import "UIImageView+WebCache.h"
#import "XLMediaZoom.h"
#import "YWLeftMenuViewController.h"
#import "MainViewController.h"
#import "MMDrawerVisualState.h"
@interface SwitchTypeViewController ()
@property (strong, nonatomic) XLMediaZoom *imageZoomView;
@end

@implementation SwitchTypeViewController

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
    [self GetData];
    _SelectIdArr = [[NSMutableArray alloc]init];
    _AllIdArr = [[NSMutableArray alloc]init];
}


- (void)GetData{
    
    if(isNetWork){
        
            [SVProgressHUD showWithStatus:@"获取中" maskType:SVProgressHUDMaskTypeBlack];
            NSString *RegisUrl = [NSString stringWithFormat:@"%@?mod=register&fun=formtypelist&versions=%@&stype=1",API_headaddr,VERSIONS];
    
    
            NSLog(@"%@",RegisUrl);
            
            [[YWNetRequest sharedInstance] requestRegisterSwitchTypeWithUrl:RegisUrl Success:^(id respondsData) {
                //
                if ([[respondsData objectForKey:@"code"] integerValue] == 11200){
                    [SVProgressHUD dismiss];

                    _SectionArr = [[NSMutableArray alloc] init];
                    NSEnumerator *enumeratorKey = [[respondsData objectForKey:@"formtypedata"] keyEnumerator];
                    for (NSString *key in enumeratorKey)
                    {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[respondsData objectForKey:@"formtypedata"] objectForKey:key]];
                        [_SectionArr addObject:dic];
                    }


                    for (NSMutableDictionary *tempDic in _SectionArr) {
                        [tempDic setObject:[[tempDic objectForKey:@"type"] allValues] forKey:@"type"];
                    }
                    NSLog(@"%@",_SectionArr);
                    
                    [self.MyTableView reloadData];
                    
                }else{
                    
                    NSString *ss =  [respondsData objectForKey:@"msg"];
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:ss];
                }

                
            } failed:^(NSError *error) {
                //
                if (isNetWork) {
                    
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"获取失败"];
                }else{
                    [SVProgressHUD dismiss];
                }
                
            }];
            
        }else{
            UIAlertView* aler = [[UIAlertView alloc]initWithTitle:nil message:@"无法连接到网络，请先设置网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [aler show];
        }

}

-(IBAction)KuodaClick:(UIButton*)sender
{
    TypeChoiceCell *selectCell;
    selectCell = (TypeChoiceCell *)[_MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag%100) inSection:(sender.tag/100)]];
    
    _imageZoomView = [[XLMediaZoom alloc] initWithAnimationTime:@(0.5) image:selectCell.BgImgView blurEffect:YES];
    _imageZoomView.tag = 1;
    _imageZoomView.backgroundColor = [UIColor blackColor];

    [[[[UIApplication sharedApplication] delegate] window] addSubview:_imageZoomView];
    [_imageZoomView show];
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _SectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_SectionArr objectAtIndex:section] objectForKey:@"type"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TypeChoiceCell *cell = (TypeChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"TypeChoiceCell"];
    
    if (cell==nil) {
        cell = (TypeChoiceCell*)[[[NSBundle mainBundle] loadNibNamed:@"TypeChoiceCell" owner:self options:nil] objectAtIndex:0];
        cell.KuoDaBtn.tag = indexPath.section*100 + indexPath.row;
        [cell.KuoDaBtn addTarget:self action:@selector(KuodaClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Imgbtn setImage:[UIImage imageNamed:@"放大镜.png"] forState:UIControlStateNormal];
 }
    if ([_SelectIdArr containsObject:[[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"formtypeid"]]) {
        cell.SelectImgView.image = [UIImage imageNamed:@"pickPerson_selected@2x.png"];
        cell.BgImgView.layer.borderWidth = 2;
        cell.BgImgView.layer.borderColor = [UIColor colorWithRed:14.0/255.0 green:122.0/255.0 blue:255/255.0 alpha:1.0].CGColor;
    }else{
        cell.SelectImgView.image = [UIImage imageNamed:@"pickPerson_unselected@2x.png"];
        cell.BgImgView.layer.borderWidth = 0;
        cell.BgImgView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.Titlelbl.text = [[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Contentlbl.text = [[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"msg"];
  
    [cell.BgImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.111151.com/ywadmin/images/worklog/%@",[[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"pic"]]]placeholderImage:[UIImage imageNamed:@"noContent@2x"]];
   
    return cell;
    }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [[_SectionArr objectAtIndex:section]objectForKey:@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TypeChoiceCell *selectCell = (TypeChoiceCell *)[tableView cellForRowAtIndexPath:indexPath];

    selectCell.SelectImgView.image = [UIImage imageNamed:@"pickPerson_selected@2x.png"];
    selectCell.BgImgView.layer.borderWidth = 2;
    selectCell.BgImgView.layer.borderColor = [UIColor colorWithRed:14.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    if (![_SelectIdArr containsObject:[[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"formtypeid"]]) {
        [_SelectIdArr addObject:[[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"formtypeid"]];
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TypeChoiceCell *selectCell = (TypeChoiceCell *)[tableView cellForRowAtIndexPath:indexPath];
    selectCell.SelectImgView.image = [UIImage imageNamed:@"pickPerson_unselected@2x.png"];
    selectCell.BgImgView.layer.borderWidth = 0;
    selectCell.BgImgView.layer.borderColor = [UIColor clearColor].CGColor;
    if ([_SelectIdArr containsObject:[[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"formtypeid"]]) {
        [_SelectIdArr removeObject:[[[[_SectionArr objectAtIndex:indexPath.section]objectForKey:@"type"]objectAtIndex:indexPath.row] objectForKey:@"formtypeid"]];
    }
}
-(IBAction)ConfirmClick:(id)sender
{
    if (!_SelectIdArr.count>0) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择模板类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }else if (isNetWork){
        NSString *string = [_SelectIdArr componentsJoinedByString:@","];
        NSLog(@"string:%@",string);
        [SVProgressHUD showWithStatus:@"提交中" maskType:SVProgressHUDMaskTypeBlack];
        NSString *RegisUrl = [NSString stringWithFormat:@"%@?mod=register&fun=addformtype&versions=%@&stype=1&user_id=%@&rand_code=%@&formtype=%@",API_headaddr,VERSIONS,RegisUserID,RegisRandcode,string];
        
        
        NSLog(@"%@",RegisUrl);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:RegisUrl]];
        [request setTimeoutInterval:kTIMEOUT];
        
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//        AFJSONRequestOperation *operation =
//        [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
//            NSLog(@"%@",JSON);
//            
//            if ([[JSON objectForKey:@"code"] integerValue] == 11200)
//            {
//                [SVProgressHUD dismiss];
//                [self performSelectorOnMainThread:@selector(succeed) withObject:nil waitUntilDone:YES];
//                
//            }else{
//                NSString *ss =  [JSON objectForKey:@"msg"];
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showErrorWithStatus:ss];
//            }
//        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//            NSLog(@"%@",error);
//            
//            if (isNetWork) {
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showErrorWithStatus:@"提交失败"];
//            }else{
//                [SVProgressHUD dismiss];
//            }
//        }];
//        [operation start];
        
        
    }else{
        UIAlertView* aler = [[UIAlertView alloc]initWithTitle:nil message:@"无法连接到网络，请先设置网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [aler show];
    }
    

}
-(void)succeed
{
    YWLeftMenuViewController *leftVC = [[YWLeftMenuViewController alloc]
                                        init];
    MainViewController * drawerController = [[MainViewController alloc]
                                             initWithCenterViewController:leftVC.navSlideSwitchVC
                                             leftDrawerViewController:leftVC
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:220];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setShouldStretchDrawer:NO];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:1.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    drawerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:drawerController animated:YES completion:Nil];
}
-(IBAction)bck:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要放弃注册吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    av.delegate=self;
    [av show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self performSegueWithIdentifier:@"back5" sender:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
