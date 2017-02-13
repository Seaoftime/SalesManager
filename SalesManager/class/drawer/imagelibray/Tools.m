//
//  Tools.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "Tools.h"


#define FILE_M [NSFileManager defaultManager]


@implementation Tools

//下载文件夹
+ (NSString *)downloadPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Download"];
}


//临时存放（未下载完）
+ (NSString *)tempPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileTemp"];
}

//下载完成
+ (BOOL)isDownloadFinish:(Video*)file
{
    if ([FILE_M fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.mp4",[self downloadPath],file.videoName]]) {
        return YES;
    }else{
        return NO;
    }
}

//正在下载
+ (BOOL)isFileDownloading:(Video *)file
{
    if ([FILE_M fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.mp4",[self tempPath],file.videoName]]) {
        return YES;
    }else{
        return NO;
    }
}



//多个地方需要获取同一个路径 写个方法 代码简洁 避免错误
+ (NSString *)getFilePath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"downloadFile.plist"];
}



//自定义的数据对象归档路径
+ (NSString *)getCustomModelFilePath:(Video*)file
{
    // 获取tem文件夹路径
    NSString *tempPath = NSTemporaryDirectory();
    // 拼接文件名
    NSString *filePath = [tempPath stringByAppendingPathComponent:file.videoName];
    
    return filePath;
   
}
/**
 *  /////////////////////////////////////////
 */


+ (NSString *)wordDownloadPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WordDownload"];
    
}

+ (NSString *)wordTempPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WordFileTemp"];

}

+ (BOOL)wordIsDownloadFinish:(Word *)file
{
    if ([FILE_M fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.word",[self wordDownloadPath],file.wordName]]) {
        
        return YES;
        
    }else{
        return NO;
    }

}

+ (BOOL)wordIsFileDownloading:(Word *)file
{
    if ([FILE_M fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.word",[self wordTempPath],file.wordName]]) {
        
        return YES;
    }else{
        return NO;
    }

}


+ (NSString *)wordGetFilePath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"wordDownloadFile.plist"];


}

+ (NSString *)wordGetCustomModelFilePath:(Word *)file
{
    
    NSString *tempPath = NSTemporaryDirectory();
    //
    NSString *filePath = [tempPath stringByAppendingPathComponent:file.wordName];
    
    return filePath;
}





@end




















