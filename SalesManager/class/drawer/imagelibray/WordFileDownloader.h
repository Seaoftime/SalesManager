//
//  WordFileDownloader.h
//  SalesManager
//
//  Created by TonySheng on 16/5/19.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tools.h"
#import "ASIHTTPRequest.h"
//
#import "Word.h"


@interface WordFileDownloader : NSObject<ASIProgressDelegate>


@property (nonatomic, strong) Word  *wordFile;
//
@property (nonatomic, strong) ASIHTTPRequest *request;





/**
 *  文档
 */

- (id)initWithWordFile:(Word *)wordFile;

- (void)startDownloadWord;

- (void)cancelDownloadWord;

- (BOOL)isDownloadingWord;




@end
