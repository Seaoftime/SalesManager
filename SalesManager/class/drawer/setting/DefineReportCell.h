//
//  DefineReportCell.h
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefineReportCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UIImageView* bgImageView;
//@property (nonatomic,strong)IBOutlet UITextView *textView;
@property (nonatomic,strong)IBOutlet UIButton *deleteButton;


@property (weak, nonatomic) IBOutlet UILabel *defineLab;




@end
