//
//  SelectCell.m
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "SelectCell.h"

@implementation SelectCell

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
    //if(IS_IOS7)
    
    //[self.contentView addSubview:self.simageView];
//    self.layer.borderWidth = 0.3;
//    self.layer.borderColor = [LINECOLOR CGColor];
    
    // Configure the view for the selected state
}


- (void)awakeFromNib
{
    //[self.contentView addSubview:self.simageView];

}






@end
