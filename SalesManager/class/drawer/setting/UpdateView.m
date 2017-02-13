//
//  UpdateView.m
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "UpdateView.h"

@implementation UpdateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"UpdateView"owner:self options:nil];
        UIView *tmpCustomView = [nib objectAtIndex:0];
        [self addSubview:tmpCustomView];
        
        self.contentView.editable = NO;
        
        self.updateButton.layer.borderWidth = 1.5;
        self.updateButton.layer.cornerRadius = 5.0;
        self.updateButton.layer.borderColor = [[UIColor colorWithRed:13/255.0 green:112/255.0 blue:140/255.0 alpha:1.0]CGColor];
        
        self.delayButton.layer.borderWidth = 1.5;
        self.delayButton.layer.cornerRadius = 5.0;
        self.delayButton.layer.borderColor = [[UIColor colorWithRed:13/255.0 green:112/255.0 blue:140/255.0 alpha:1.0]CGColor];
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
