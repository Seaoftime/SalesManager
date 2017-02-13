//
//  YWBaseRequest.h
//  SalesManager
//
//  Created by TonySheng on 16/4/19.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWBaseBlock.h"


typedef enum : NSUInteger {

    httpGet,
    httpPost,
    httpPut,
    httpDelete,

} httpMethod;


@interface YWBaseRequest : YWBaseBlock

@property (nonatomic, strong) NSOperationQueue *queue;

+ (NSMutableURLRequest *)getRequestUrl:(NSString *)url andType:(httpMethod)httpMethod andBodyDic:(NSDictionary *)bodyDic;

+ (void)startHttpRequest:(NSMutableURLRequest *)request andSuccessComplete:(successDic)successDic andFail:(errorBlock)failError;




@end
