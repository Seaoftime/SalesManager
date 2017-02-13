//
//  NoticeCell.m
//  SalesManager
//
//  Created by tianjing on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

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
    
    //self.bigTitle.font = [UIFont systemFontOfSize:BIGFONT];
    
    
    self.bigTitle.font = [UIFont systemFontOfSize:17];
    self.smallTitle.font = [UIFont systemFontOfSize:15];
    self.lineImage.backgroundColor = LINECOLOR;
    self.stateView.layer.borderWidth = 2.5f;
    self.stateView.layer.cornerRadius = 2.5f;
    self.backgroundColor = [UIColor whiteColor];
   // self.layer.borderColor = [LINECOLOR cgc];
    
    [self.lineImage setFrame:CGRectMake(0, self.lineImage.frame.origin.y + 0.5, kDeviceWidth, 0.5)];
    self.lineImage.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
}

@end
