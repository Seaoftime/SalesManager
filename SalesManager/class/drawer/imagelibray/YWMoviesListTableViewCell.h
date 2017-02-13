//
//  YWMoviesListTableViewCell.h
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MovieListDelegate <NSObject>

-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath;

@end


@interface YWMoviesListTableViewCell : UITableViewCell

@property (assign ,nonatomic) id<MovieListDelegate> delegate;

@property (strong,nonatomic) NSIndexPath *index;


@property (weak, nonatomic) IBOutlet UILabel *movieNameLb;

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

- (IBAction)downloadButtonClcked:(id)sender;

- (void)showData:(NSDictionary *)data;


@end
