//
//  HeaderView.m
//  TJtest
//
//  Created by tianjing on 13-11-27.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HeaderView"owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [self addSubview:tmpCustomView];
        //self.signinButton.backgroundColor = [UIColor colorWithRed:95/255.f green:180/255.f blue:63/255.f alpha:0.5];
        self.portraitView.layer.cornerRadius = 10.0;
        self.portraitView.layer.borderColor = [[UIColor whiteColor]CGColor];
        self.portraitView.layer.borderWidth = 2.5;
        [self.portraitView setClipsToBounds:YES];
        
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
