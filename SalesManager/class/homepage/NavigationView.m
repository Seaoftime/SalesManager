//
//  NavigationView.m
//  TJtest
//
//  Created by tianjing on 13-11-28.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "NavigationView.h"
#define NAVIGATIONCOLOR [UIColor colorWithRed:48/255.f  green:135/255.f  blue:221/255.f alpha:1]
@implementation NavigationView
@synthesize titleLabel,leftButton,rightBtton;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationView" owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        
        [tmpCustomView setFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
        
        [self addSubview:tmpCustomView];
        
    }
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
