//
//  YWCanNotSelectedTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/4/13.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWCanNotSelectedTableViewCell.h"



@interface YWCanNotSelectedTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *tomorningLabel;


@end

@implementation YWCanNotSelectedTableViewCell


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
    
    
    if ([filed.formType isEqualToString:@"datePicker"])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        
        
    }else if ([filed.formType isEqualToString:@"timebox"]){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *confromTimespStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey: filed.formReferName] intValue]]];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@ :",filed.formName];
        self.contentLabel.text = [NSString stringWithFormat:@"%@",confromTimespStr];
        self.contentLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
        
                
    } else {
        
        NSString *string = [dic objectForKey:filed.formReferName];
        
        if ([string isEqualToString:@""] || !string || (string.length == 0))
        {
            //[self setFrame:CGRectMake(0, 0, kDeviceWidth - 20, 0)];
            self.hidden = YES;
            //[self setFrame:CGRectMake(0, 0, 0, 0)];
            
        }else{
            
            if ([filed.formType isEqualToString:@"view"])
            {
                
                self.titleLabel.text = [NSString stringWithFormat:@"%@ :",filed.formName];
                self.contentLabel.text = [NSString stringWithFormat:@"%@",string];
                //self.contentLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
                //
                //
                
//                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"你写的太多了！" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                
//                if (self.contentLabel.text.length > 20) {
//                    [alertV show];
//                }
                
                
                
                
                
                self.contentLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
                
                CGRect frame = self.contentLabel.frame;
                
               
                frame.size.height = [TOOL getText:string MinHeightWithBoundsWidth:kDeviceWidth fontSize:17];
                
                [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, frame.size.height)];
  
                
            }else if ([filed.formType isEqualToString:@"addressbox"]){
                
                string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
                
                
                
            }else{
                
                self.titleLabel.text = [NSString stringWithFormat:@"%@ :",filed.formName];
                self.contentLabel.text = [NSString stringWithFormat:@"%@",string];
                //self.contentLabel.textColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
                self.contentLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
                
                CGRect frame = self.contentLabel.frame;
                frame.size.height = [TOOL getText:string MinHeightWithBoundsWidth:kDeviceWidth fontSize:17];
                [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, frame.size.height)];
                
            }
            
        }
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
