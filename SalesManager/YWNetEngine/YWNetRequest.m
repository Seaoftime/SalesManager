//
//  YWNetEngine.m
//  SalesManager
//
//  Created by TonySheng on 16/4/25.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWNetRequest.h"

#import "AFNetworking.h"

@interface YWNetRequest ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;


@end

@implementation YWNetRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _httpManager = [[AFHTTPRequestOperationManager alloc] init];
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static YWNetRequest *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[YWNetRequest alloc] init];
    });
    return s_instance;
}

#pragma mark - GET -

- (void)GET:(NSString*)url success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock{
    
    //配置可以接受的类型  包括：  text/html
    NSMutableSet *contentTypeSet = [NSMutableSet setWithSet:_httpManager.responseSerializer.acceptableContentTypes];
    [contentTypeSet addObject:@"text/html"];
    _httpManager.responseSerializer.acceptableContentTypes = contentTypeSet;
    
    [_httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    
}


#pragma mark - request -
- (void)requestLoginDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestHomePageDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestHomePageGetAllUserInfoDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestHomePagecheckWithErrorMsgDataWithasd:(NSString *)asd Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *urls =API_postSuggestion(API_headaddr,userID,randCode,asd,@"iPhone",VERSIONS,@"1");
    [self GET:urls success:successBlock failed:failedBlock];
    
}

- (void)requestHomePagegetFormDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestHeadPortraitDataWithUserPic:(NSString *)usepic Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    NSString *urls = API_sendPortrait(API_headaddr,userID,randCode,usepic,VERSIONS,stype);
    
    urls = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self GET:urls success:successBlock failed:failedBlock];
    
}

- (void)requestPersonInfoDataWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    //API_getPersonInfo(headaddr,userID,randCode,userID,VERSIONS,stype)
    NSString *urls = API_getPersonInfo(API_headaddr,userID,randCode,userID,VERSIONS,stype);
    
    urls = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:urls success:successBlock failed:failedBlock];
    
}

- (void)requestNoticeDataWithLimit:(int)limit WithOffset:(int)offset WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *urls = API_getNoticeList(API_headaddr,userID,randCode,limit,offset,VERSIONS,1);
    
    NSLog(@"%@",urls);
    
    [self GET:urls success:successBlock failed:failedBlock];
    
}

- (void)requestNoticeuploadNoticeWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestNoticeDetailsWithId:(NSString *)Id WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    NSString *urls = API_getNoticeById(API_headaddr,userID,randCode,Id,VERSIONS,stype)  ;
    
    NSLog(@"%@",urls);
    
    [self GET:urls success:successBlock failed:failedBlock];
    
}

- (void)requestSendNoticeDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];
    
}
- (void)requestgetAllMemberWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *url = @"http://yewu.feesun.com/ywapi/commerber.php?userid=600001&randcode=0831bf45eb174bbd493971d662f9795c&option=get_list&limit=300&offset=&minid=&name=&status=&partnameid=&lgroup=";
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestgetSignInListWithDataCount:(int)dataCount WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults* userDefaults = [NSUserDefaults   standardUserDefaults];
    NSString *strUrl = [NSString stringWithFormat:@"%@?mod=location&fun=get_list&user_id=%@&rand_code=%@&versions=%@&limit=%d&offset=%d&stype=1",API_headaddr,userDefaults.ID,userDefaults.randCode,VERSIONS,NUMBEROFONEPAGE,NUMBEROFONEPAGE * dataCount];
    
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:strUrl success:successBlock failed:failedBlock];
    
}

- (void)requestUploadSignInDataWithSignInTime:(NSString *)signinTime WithTime:(NSInteger)time WithLatitude:(NSString *)latitude WithLongtitude:(NSString *)longtitude WithLocation:(NSString *)location WithContent:(NSString *)content WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@?mod=location&fun=addsign&user_id=%@&rand_code=%@&location_value[title]=%@&location_value[time]=%ld&location_value[latitude]=%@&location_value[longitude]=%@&location_value[address]=%@&location_value[content]=%@&versions=%@&stype=1", API_headaddr, userDefaults.ID, userDefaults.randCode, signinTime, time, latitude, longtitude, location, content,VERSIONS];
    
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self GET:strUrl success:successBlock failed:failedBlock];
    
}

- (void)requestgetSignInDetailsWithSignInId:(NSString *)signId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@?mod=location&fun=get&user_id=%@&rand_code=%@&id=%@&versions=%@&stype=1", API_headaddr, user.ID, user.randCode, signId, VERSIONS];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:strUrl success:successBlock failed:failedBlock];
    
}

- (void)requestgetTaskDataListWithDataCount:(int)dataCount Withaaa:(int)aaa WithStype:(NSString *)stype WithIsmine:(NSString *)ismine WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *url = API_getTaskList(API_headaddr,userDefaults.ID,userDefaults.randCode,NUMBEROFONEPAGE,dataCount * NUMBEROFONEPAGE,aaa,VERSIONS,stype,@"",@"",ismine,@"");
    
    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestUploadTaskWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    
    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestTaskDetailsWithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    NSString *url = API_getTaskById(API_headaddr,userID,randCode,taskId,VERSIONS,stype);
    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestgetNotDoneTaskDetailsDataWithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = API_getTaskById(API_headaddr,userDefaults.ID,userDefaults.randCode,taskId,VERSIONS,stype);
    
    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestDeleteTaskDetailsWithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url =API_lockTask(API_headaddr,userDefaults.ID,userDefaults.randCode,taskId,@"1",VERSIONS,stype);
    [self GET:url success:successBlock failed:failedBlock];
    
}

- (void)requestTaskReplyWithText:(NSString *)text WithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl = API_sendTaskReply(API_headaddr, user.ID, user.randCode, VERSIONS, @"1", text, taskId);
    
    [self GET:strUrl success:successBlock failed:failedBlock];
}


- (void)requestReportDataWithDataCount:(NSInteger)dataCount WithSectionId:(NSInteger)sectionId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@?mod=diary&fun=get_listx&user_id=%@&rand_code=%@&versions=%@&limit=%i&offset=%li&formtypeid=%ld&stype=1", API_headaddr, user.ID, user.randCode, VERSIONS, NUMBEROFONEPAGE,NUMBEROFONEPAGE * dataCount,sectionId];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:strUrl success:successBlock failed:failedBlock];
}

- (void)requestReportDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    
    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestReportDetailsWithSummaryId:(NSString *)summaryId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl =
    [NSString stringWithFormat:@"%@?mod=diary&fun=get&user_id=%@&rand_code="
     "%@&id=%@&versions=%@&stype=1",
     API_headaddr, user.ID, user.randCode,
     summaryId, VERSIONS];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:strUrl success:successBlock failed:failedBlock];
    
}

- (void)requestReportDetailsWithSummaryId:(NSString *)summaryId WithReplyContent:(NSString *)replyContet WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl = [NSString
                        stringWithFormat:@"%@?mod=diary&fun=replypost&&user_id=%@&rand_code=%@&"
                        "id=%@&diary_value[reply]=%@&versions=%@&stype=1",
                        API_headaddr, user.ID, user.randCode,
                        summaryId, replyContet,
                        VERSIONS];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:strUrl success:successBlock failed:failedBlock];
}

- (void)requestSendTaskDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];

}

- (void)requestPostEditTaskDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestPrepareDoneVCDataWithTaskId:(NSString *)taskId WithContentText:(NSString *)contentText WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    
    NSString *urls = API_noteTask(API_headaddr,userID,randCode,taskId, contentText,VERSIONS, stype);//API_getTaskById(API_headaddr,userDefaults.ID,userDefaults.randCode,self.taskID,versions,stype);
    
    [self GET:urls success:successBlock failed:failedBlock];

}

- (void)requestLibraryDataWithDataCount:(int)dataCount WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    //NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *urls =API_getAlbumList(API_headaddr,userDefaults.ID,userDefaults.randCode,VERSIONS,stype,NUMBEROFONEPAGE,dataCount * NUMBEROFONEPAGE);
    [self GET:urls success:successBlock failed:failedBlock];
}

- (void)requestDownloadPicsWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSString *stype = @"1";
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *urls = API_getAllPhotos(API_headaddr,userDefaults.ID,userDefaults.randCode,@"",VERSIONS,stype);
    
    [self GET:urls success:successBlock failed:failedBlock];

}

- (void)requestPicInAlbumWithAlbumId:(int)albumId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    NSString *stype = @"1";
    
    NSString *urls = API_getPhotoListFromAlbum(API_headaddr, userID, randCode, albumId, VERSIONS, stype, 1000, 0);
    
    [self GET:urls success:successBlock failed:failedBlock];
}


- (void)requestSettingWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *urls = [NSString stringWithFormat:@"%@?mod=loginout&user_id=%@&rand_code=%@&versions=%@&token=1&stype=1",API_headaddr,user.ID,user.randCode,VERSIONS];
    
    urls = [urls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    [self GET:urls success:successBlock failed:failedBlock];

}

- (void)requestSettingSetPasswordWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestRegisterWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];

}

- (void)requestRegisterSubmitZiliaoWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];

}

- (void)requestRegisterSwitchTypeWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    [self GET:url success:successBlock failed:failedBlock];

}

- (void)requestResetPasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    [self GET:url success:successBlock failed:failedBlock];

}

- (void)requestForgotPasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    [self GET:url success:successBlock failed:failedBlock];
}

- (void)requestChangePasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{

    [self GET:url success:successBlock failed:failedBlock];
}


- (void)requestModifyPasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock
{
    [self GET:url success:successBlock failed:failedBlock];

}


@end












