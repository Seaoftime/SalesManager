//
//  SwitchTypeViewController.h
//  SalesManager
//
//  Created by louis on 14-3-21.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger  ROW;
    BOOL isCheck;
}
-(IBAction)bck:(id)sender;
-(IBAction)ConfirmClick:(id)sender;
@property(nonatomic,strong)IBOutlet UITableView *MyTableView;
@property(nonatomic,strong)NSMutableArray *SectionArr;
@property(nonatomic,strong)NSMutableArray *AllIdArr;
@property(nonatomic,strong)NSMutableArray *SelectIdArr;



@end
