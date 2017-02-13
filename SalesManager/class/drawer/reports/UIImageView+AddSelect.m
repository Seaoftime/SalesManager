//
//  UIImageView+AddSelect.m
//  SalesManager
//
//  Created by Kris on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "UIImageView+AddSelect.h"

@implementation UIImageView (AddSelect)

@dynamic selected;

bool _selected;

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected)
    {
        [self setImage:[UIImage imageNamed:@"pickPerson_selected@2x"]];
    }
    else
    {
        [self setImage:[UIImage imageNamed:@"pickPerson_unselected@2x"]];
    }
}

- (BOOL)selected
{
    return _selected;
}

@end