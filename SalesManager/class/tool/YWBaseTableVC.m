//
//  YWBaseTableVC.m
//  SalesManager
//
//  Created by sky on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWBaseTableVC.h"


@implementation YWBaseTableVC

-(void)checkCodeByJson:(NSDictionary* )json{
   
    NSString* sd;
    
    @try {
    
        @try {
            
            sd = [json objectForKey:@"code"];
            
            sd = [sd substringFromIndex:2];
        }
        @catch (NSException *exception) {
            sd = [NSString stringWithFormat:@"%ld",[[json objectForKey:@"code"] integerValue]];
            sd = [sd substringFromIndex:2];
        }
        switch ([sd integerValue]) {
            case 501:{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:Nil message:[json objectForKey:@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"现在就去", nil];
                [alert show];
            }
                break;
                
            case 403:{
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:Nil message:[json objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                
                [self performSelector:@selector(backLogIn) withObject:self afterDelay:1];
            }
                
                break;
                
                
            default:{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:Nil message:[json objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
                
                break;
        }
        
    }
    @catch (NSException *exception) {
    }
    
    
    [SVProgressHUD dismiss];
}

-(void)backLogIn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logOut" object:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ye-wu-dian-dian-tong/id592930826"]];
    }
}
-(void)saveAnError:(NSString* )erreMsg{
    
    YWErrorDBM* errDb = [[YWErrorDBM alloc]init];
    [errDb saveAnErrorInfo:erreMsg];
    
    
    
}

@end
