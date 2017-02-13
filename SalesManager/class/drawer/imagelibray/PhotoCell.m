//
//  PhotoCell.m
//  TbCells
//
//  Created by tianjing on 13-11-1.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell
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
    self.backgroundColor = [UIColor clearColor];
        // Configure the view for the selected state
    self.photoImage1.userInteractionEnabled = YES;
    self.photoImage2.userInteractionEnabled = YES;
    self.photoImage3.userInteractionEnabled = YES;
}



- (void)awakeFromNib
{
    



}


@end
