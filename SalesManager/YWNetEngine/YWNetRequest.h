//
//  YWNetEngine.h
//  SalesManager
//
//  Created by TonySheng on 16/4/25.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlockType) (id respondsData);
typedef void (^FailedBlockType) (NSError *error);

@interface YWNetRequest : NSObject


+ (instancetype)sharedInstance;



/**
 *  登陆
 */
//login
- (void)requestLoginDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 *  首页
 */
//homePage
- (void)requestHomePageDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//homepage - getAllUserInfo
- (void)requestHomePageGetAllUserInfoDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//homepage - checkWithErrorMsg
- (void)requestHomePagecheckWithErrorMsgDataWithasd:(NSString *)asd Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//homepage - getForm
- (void)requestHomePagegetFormDataWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 *  个人信息
 */
//headPortraitSuccess
- (void)requestHeadPortraitDataWithUserPic:(NSString *)usepic Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getPersonInfoData
- (void)requestPersonInfoDataWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
/**
 *  通知
 */
- (void)requestNoticeDataWithLimit:(int)limit WithOffset:(int)offset WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//uploadNotice
- (void)requestNoticeuploadNoticeWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//详情 getNoticeByID
- (void)requestNoticeDetailsWithId:(NSString *)Id WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//sendNoticeData
- (void)requestSendNoticeDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getAllMember
- (void)requestgetAllMemberWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
/**
 *  签到
 */
//getListlimit
- (void)requestgetSignInListWithDataCount:(int)dataCount WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//upLoadSignIn
- (void)requestUploadSignInDataWithSignInTime:(NSString *)signinTime WithTime:(NSInteger)time WithLatitude:(NSString *)latitude WithLongtitude:(NSString *)longtitude WithLocation:(NSString *)location WithContent:(NSString *)content WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getSignInContent
- (void)requestgetSignInDetailsWithSignInId:(NSString *)signId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
/**
 *  任务
 */
//getTaskDataList
- (void)requestgetTaskDataListWithDataCount:(int)dataCount Withaaa:(int)aaa WithStype:(NSString *)stype WithIsmine:(NSString *)ismine WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//uploadTask
- (void)requestUploadTaskWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getDoneTaskData 详情
- (void)requestTaskDetailsWithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getOtherNotDoneTaskData 详情
- (void)requestgetNotDoneTaskDetailsDataWithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//deleteTaskByID 详情
- (void)requestDeleteTaskDetailsWithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//reply 详情
- (void)requestTaskReplyWithText:(NSString *)text WithTaskId:(NSString *)taskId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
// sendTaskData
- (void)requestSendTaskDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//postEditTask
- (void)requestPostEditTaskDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//done
- (void)requestPrepareDoneVCDataWithTaskId:(NSString *)taskId WithContentText:(NSString *)contentText WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 *  信息汇报
 */
//uploadReport
- (void)requestReportDataWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getSummaryList
- (void)requestReportDataWithDataCount:(NSInteger)dataCount WithSectionId:(NSInteger)sectionId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

//getReportContent 详情
- (void)requestReportDetailsWithSummaryId:(NSString *)summaryId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//Reply
- (void)requestReportDetailsWithSummaryId:(NSString *)summaryId WithReplyContent:(NSString *)replyContet WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 *  imageLib 图库
 */
//getalbumData
- (void)requestLibraryDataWithDataCount:(int)dataCount WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//beginDownloadPicUrls
- (void)requestDownloadPicsWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//getphotoData
- (void)requestPicInAlbumWithAlbumId:(int)albumId WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 *  Setting 设置
 */
//actionSheet 注销
- (void)requestSettingWithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//修改密码
- (void)requestSettingSetPasswordWithUrl:(NSString *)url WithSuccess:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

/**
 *  注册
 */

- (void)requestRegisterWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

//提交资料
- (void)requestRegisterSubmitZiliaoWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;
//SwitchTypeViewController
- (void)requestRegisterSwitchTypeWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;




/**
 *  找回密码
 */

//reset
- (void)requestResetPasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

//forget 获取验证码
- (void)requestForgotPasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

//changePassword 确定
- (void)requestChangePasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;

//modifyPassword
- (void)requestModifyPasswordWithUrl:(NSString *)url Success:(SuccessBlockType)successBlock failed:(FailedBlockType)failedBlock;










@end
