//
//  AlbumCell.m
//  SalesManager
//
//  Created by tianjing on 13-12-2.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
           }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [self.lineImageVi setFrame:CGRectMake(0, self.lineImageVi.frame.origin.y, kDeviceWidth, 0.5)];
    self.lineImageVi.backgroundColor = [UIColor colorWithRed:200/255.f  green:199/255.f  blue:204/255.f alpha:1];

    self.albumImage.layer.cornerRadius = 5.0;
    [self.albumImage setClipsToBounds:YES];
    

}

@end
