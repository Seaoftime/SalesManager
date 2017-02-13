//
//  XHIndicatorView.h
//  SalesManager
//
//  Created by Kris on 13-12-7.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XHIndicatorViewTypeSending     = 0,//正在发生
    XHIndicatorViewTypeFailure     = 1,//失败
    XHIndicatorViewTypeSuccess     = 2,
     XHIndicatorViewTypeSaveDraft  = 3//存为草稿
} XHIndicatorViewType;

@interface XHIndicatorView : UIView

@property (nonatomic, assign) XHIndicatorViewType type;

@end
