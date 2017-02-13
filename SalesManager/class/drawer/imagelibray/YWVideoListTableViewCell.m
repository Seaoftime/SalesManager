//
//  YWVideoListTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWVideoListTableViewCell.h"


#define lineColor  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]


@implementation YWVideoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5, kDeviceWidth, 0.5)];
    lineV.backgroundColor = lineColor;
    [self addSubview:lineV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    NSLog(@"======111111111111====");
    
    
    
}


//- (void)showData:(NSDictionary *)data{
//    
//    self.videoNameLb.text = [data objectForKey:@"name"];
//    
//}


@end
