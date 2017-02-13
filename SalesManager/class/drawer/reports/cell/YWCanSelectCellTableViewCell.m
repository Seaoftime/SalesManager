//
//  YWCanSelectCellTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/4/13.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWCanSelectCellTableViewCell.h"

#import "YformFileds.h"


@interface YWCanSelectCellTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@end

@implementation YWCanSelectCellTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)setFileds:(YformFileds *)filed AndInfoDic:(NSDictionary *)dic
{

    NSString *string = [dic objectForKey:filed.formReferName];
    
    if ([string isEqualToString:@"(null)"] || !string || (string.length == 0))
    {
        [self setFrame:CGRectMake(0, 0, kDeviceWidth - 20, 0)];
        
    }else{
        
        //lb.text = [NSString stringWithFormat:@"%@",tempFormFiled.formName];
        self.fromLabel.text = [NSString stringWithFormat:@"%@",string];
        self.fromLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
        
    }




}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
