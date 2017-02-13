//
//  PicNotesView.m
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "PicNotesView.h"

@implementation PicNotesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PicNotesView"owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [self addSubview:tmpCustomView];
    }
    self.contentView.editable = NO;
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
