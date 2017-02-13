//
//  UpdateView.h
//  SalesManager
//
//  Created by tianjing on 13-12-10.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateView : UIView
@property(nonatomic,strong)IBOutlet UILabel* versionLabel;
@property(nonatomic,strong)IBOutlet UITextView* contentView;
@property(nonatomic,strong)IBOutlet UIButton* updateButton;
@property(nonatomic,strong)IBOutlet UIButton* delayButton;

@end
