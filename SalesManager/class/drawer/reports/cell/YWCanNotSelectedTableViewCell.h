//
//  YWCanNotSelectedTableViewCell.h
//  SalesManager
//
//  Created by TonySheng on 16/4/13.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;

@interface YWCanNotSelectedTableViewCell : UITableViewCell


@property (nonatomic, strong) YformFileds *formFields;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;








- (void)setFileds:(YformFileds *)filed AndInfoDic:(NSDictionary *)dic;



@end
