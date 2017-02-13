//
//  ImageSizeCell.m
//  TJtest
//
//  Created by tianjing on 13-11-27.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "ImageSizeCell.h"

@implementation ImageSizeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.294 green:0.353 blue:0.392 alpha:1.000];
        if(!IS_IOS7)
            self.backgroundColor = [UIColor colorWithRed:0.294 green:0.353 blue:0.392 alpha:1.000];
            }else{
        self.contentView.backgroundColor = [UIColor clearColor];
        if(!IS_IOS7)
         self.backgroundColor = [UIColor clearColor];
    }
    [self setBackgroundView:Nil];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.294 green:0.353 blue:0.392 alpha:1.000];
    }else{
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(16,11,24, 24)];
    [self.textLabel setFrame:CGRectMake(52, 16, self.frame.size.width, 13)];
    self.textLabel.font = [UIFont systemFontOfSize:17.0];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
}

@end
