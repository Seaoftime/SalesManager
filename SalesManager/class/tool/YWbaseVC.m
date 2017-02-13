//
//  YWbaseVC.m
//  SalesManager
//
//  Created by sky on 13-12-30.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "YWbaseVC.h"


@implementation YWbaseVC



-(void)checkCodeByJson:(NSDictionary* )json{
    NSString* sd;
    @try {
        
        sd = [json objectForKey:@"code"];

        sd = [sd substringFromIndex:2];
    }
    @catch (NSException *exception) {
        sd = [NSString stringWithFormat:@"%ld",[[json objectForKey:@"code"] integerValue]];
        sd = [sd substringFromIndex:2];
    }

    @try {
        switch ([sd integerValue]) {
            case 501:{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:Nil message:[json objectForKey:@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"现在就去", nil];
                alert.tag = 500501;
                [alert show];
            }
                break;
                
            case 403:{
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:Nil message:[json objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logOut" object:nil];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%d",buttonIndex);

    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ye-wu-dian-dian-tong/id592930826"]];
    }
}


-(void)saveAnError:(NSString* )erreMsg{
    
    YWErrorDBM* errDb = [[YWErrorDBM alloc]init];
    [errDb saveAnErrorInfo:erreMsg];
    
}


@end
