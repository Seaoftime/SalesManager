//
//  InformationReportViewController.h
//  NewSaleMaster
//
//  Created by Kris on 13-12-2.
//  Copyright (c) 2013年 郑州悉知信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YformFileds;
@class YSummaryFields;

@interface InformationReportViewController : YWbaseVC<UISearchDisplayDelegate,UISearchBarDelegate>{
    NSMutableArray* upLoadReportArray;
}

@property (nonatomic,strong) UINavigationController *homeNavi;
@property (nonatomic,strong) YformFileds *formFiled;//记录栏目名称及id


- (void)addCell:(YSummaryFields *)aField;

@end
