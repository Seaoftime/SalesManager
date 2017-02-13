//
//  YWSaveTaskContent.h
//  SalesManager
//
//  Created by 碧天 杨 on 13-12-20.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTaskDBM.h"
@class YTaskFieleds;

@interface YWSaveTaskContent : NSObject{
    
}

-(void)saveTaskContent:(NSDictionary* )task;



-(void)saveTask:(YTaskFieleds* )taskFileds isNew:(BOOL)isNew;



@end
