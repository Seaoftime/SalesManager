//
//  AlbumCell.h
//  SalesManager
//
//  Created by tianjing on 13-12-2.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UIImageView *albumImage;
@property(nonatomic,retain)IBOutlet UILabel *albumName;
@property(nonatomic,assign)NSInteger albumID;


@property (weak, nonatomic) IBOutlet UIImageView *lineImageVi;






@end
