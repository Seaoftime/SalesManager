//
//  XHUpPhotoView.m
//  SalesManager
//
//  Created by Kris on 13-12-7.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "XHUpPhotoView.h"

@implementation XHUpPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 300, 84);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.bounds = CGRectMake(0, 0, 300, 84);
        
        self.layer.borderWidth = .5f;
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [UIColor colorWithWhite:0.522 alpha:1.000].CGColor;
        
        
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
