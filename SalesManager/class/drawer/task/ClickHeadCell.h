//
//  ClickHeadCell.h
//  StretchTable
//
//  Created by tianjing on 14-2-28.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickHeadCell : UIView

@property(nonatomic,strong)IBOutlet UILabel *departmentLabel;
@property(nonatomic,strong)IBOutlet UIButton *allSelectedBtn;
@property(nonatomic,strong)IBOutlet UIButton *stretchBtn;
@property(nonatomic,assign) BOOL isStretchState;
@end
