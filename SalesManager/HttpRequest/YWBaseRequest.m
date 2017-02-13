//
//  YWBaseRequest.m
//  SalesManager
//
//  Created by TonySheng on 16/4/19.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWBaseRequest.h"



@implementation YWBaseRequest


+ (NSMutableURLRequest *)getRequestUrl:(NSString *)url andType:(httpMethod)httpMethod andBodyDic:(NSDictionary *)bodyDic
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    switch (httpMethod) {
        case httpGet:
            request.HTTPMethod = @"GET";
            break;
        case httpPost:
            request.HTTPMethod = @"POST";
            break;
        case httpPut:
            request.HTTPMethod = @"PUT";
            break;
        case httpDelete:
            request.HTTPMethod = @"DELETE";
            break;
            
        default:
            break;
    }
    
    if (bodyDic) {
        NSMutableData *postData = [[NSMutableData alloc] init];
        
        for (NSString *key in [bodyDic allKeys]) {
            if (!postData.length) {
                [postData appendData:[[NSString stringWithFormat:@"%@=%@",key,[bodyDic objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
            }else {
            
                [postData appendData:[[NSString stringWithFormat:@"&%@=%@",key, [bodyDic objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            }
        }
        
        [request setHTTPBody:postData];
    }

    request.timeoutInterval = kTIMEOUT;
    
    return request;

}




+ (void)startHttpRequest:(NSMutableURLRequest *)request andSuccessComplete:(successDic)successDic andFail:(errorBlock)failError
{
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
                
        switch ([[responseDic objectForKey:@"code"] integerValue]) {
            case 40200:
            {
                
            
            
            
            
            }
                break;
            case 40201:
            {
                
                
                
            }
                
            default:{
            
               
                
            
            }
                break;
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        failError(nil);
    }];


}























@end
