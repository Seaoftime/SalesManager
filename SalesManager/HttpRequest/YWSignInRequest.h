//
//  YWSignInRequest.h
//  SalesManager
//
//  Created by TonySheng on 16/4/21.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWBaseRequest.h"

@interface YWSignInRequest : YWBaseRequest




//签到列表
+ (void)getSigninListDataWithUrl:(NSString *)url withSuccess:(successDic)success withFail:(errorBlock)fail;




@end
