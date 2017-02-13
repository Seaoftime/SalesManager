//
//  SelectCell.h
//  SalesManager
//
//  Created by tianjing on 13-12-11.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>


//#import "RTLabel.h"
@interface SelectCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView*simageView;

//@property(nonatomic,strong)IBOutlet RTLabel*nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
