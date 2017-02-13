//
//  YWCanSelectCellTableViewCell.h
//  SalesManager
//
//  Created by TonySheng on 16/4/13.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;

@interface YWCanSelectCellTableViewCell : UITableViewCell


@property (nonatomic, strong) YformFileds *formFields;


@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

- (void)setFileds:(YformFileds *)filed AndInfoDic:(NSDictionary *)dic;


@end
