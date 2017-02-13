//
//  TypeChoiceCell.h
//  SalesManager
//
//  Created by louis on 14-3-21.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeChoiceCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *SelectImgView;
@property(nonatomic,strong)IBOutlet UIImageView *BgImgView;
@property(nonatomic,strong)IBOutlet UIButton *KuoDaBtn;
@property(nonatomic,strong)IBOutlet UIButton *Imgbtn;
@property(nonatomic,strong)IBOutlet UILabel *Titlelbl;
@property(nonatomic,strong)IBOutlet UILabel *Contentlbl;
@end
