//
//  NoticeCell.h
//  SalesManager
//
//  Created by tianjing on 13-12-4.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RTLabel.h"

@interface NoticeCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *stateView;

//@property(nonatomic,strong)IBOutlet RTLabel *bigTitle;

@property (weak, nonatomic) IBOutlet UILabel *bigTitle;


@property(nonatomic,strong)IBOutlet UILabel *smallTitle;
@property(nonatomic,strong)IBOutlet UIImageView *lineImage;
@property(nonatomic,strong)NSString *noticeID;



@end
