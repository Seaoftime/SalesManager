//
//  YWWordListTableViewCell.h
//  SalesManager
//
//  Created by TonySheng on 16/5/18.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WordDownloadBtn.h"

@interface YWWordListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *wordNameLb;

@property (weak, nonatomic) IBOutlet WordDownloadBtn *downloadBtn;





@end
