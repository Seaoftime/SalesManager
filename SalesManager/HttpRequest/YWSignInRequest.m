//
//  YWSignInRequest.m
//  SalesManager
//
//  Created by TonySheng on 16/4/21.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWSignInRequest.h"

@implementation YWSignInRequest




+ (void)getSigninListDataWithUrl:(NSString *)url withSuccess:(successDic)success withFail:(errorBlock)fail
{
    
    //NSString *strUrl = [NSString stringWithFormat:@"%@?mod=location&fun=get_list&user_id=%@&rand_code=%@&versions=%@&limit=%d&offset=%d&stype=1",API_headaddr,userDefaults.ID,userDefaults.randCode,VERSIONS,NUMBEROFONEPAGE,NUMBEROFONEPAGE*_dataCont];
    //

    NSMutableURLRequest *request = [self getRequestUrl:url andType:httpGet andBodyDic:nil];
    
    [self startHttpRequest:request andSuccessComplete:^(id successDic) {
        //
        
        success(successDic);
        
    } andFail:^(id error) {
        //
        
        fail(nil);
        
    }];
    
    
}





@end
