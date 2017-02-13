//
//  ClickHeadCell.m
//  StretchTable
//
//  Created by tianjing on 14-2-28.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "ClickHeadCell.h"

@implementation ClickHeadCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ClickHeadCell"owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [self addSubview:tmpCustomView];
    }
    [self.stretchBtn setImage:[UIImage imageNamed:@"closeArrow"] forState:UIControlStateNormal];
//    self.layer.borderColor = [[UIColor colorWithRed:139/255. green:139/255. blue:139/255. alpha:1]CGColor];
//    self.layer.borderWidth = 0.5;
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
