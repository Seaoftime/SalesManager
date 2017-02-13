//
//  DownLoadProgressView.m
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "DownLoadProgressView.h"

@implementation DownLoadProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DownLoadProgressView"owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [self addSubview:tmpCustomView];
    }
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.cornerRadius = 10.0f;
    self.bgView.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    self.progressView.tintColor = [UIColor whiteColor];
    self.progressView.trackColor = [UIColor clearColor];
    self.progressView.startAngle = (3.0*M_PI)/2.0;
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
