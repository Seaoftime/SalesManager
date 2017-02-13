//
//  MoviePlayerController.h
//  Video
//
//  Created by User on 15/12/9.
//  Copyright © 2015年 FJY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoviePlayerController : UIViewController
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger,PanDirection){
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved,
};

-(id)initWithURLStr:(NSURL*)aUrl;

@end
