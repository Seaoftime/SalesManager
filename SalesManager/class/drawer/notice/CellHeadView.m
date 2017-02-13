//
//  CellHeadView.m
//  SalesManager
//
//  Created by tianjing on 13-12-19.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "CellHeadView.h"

@implementation CellHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CellHeadView"owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [self addSubview:tmpCustomView];
        tmpCustomView.backgroundColor = BGCOLOR;
        tmpCustomView.layer.borderColor = [LINECOLOR CGColor];
        tmpCustomView.layer.borderWidth = 0.5;
        
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
