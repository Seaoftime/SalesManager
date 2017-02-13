//
//  NavigationView.h
//  TJtest
//
//  Created by tianjing on 13-11-28.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationView : UIView
{

}
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIButton *leftButton;
@property (nonatomic,weak) IBOutlet UIButton *rightBtton;
@property (nonatomic,strong)IBOutlet UIImageView *bgImageView;



@end
