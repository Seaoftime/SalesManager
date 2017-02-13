//
//  YWMoviesListTableViewCell.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "YWMoviesListTableViewCell.h"

@implementation YWMoviesListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rename) name:@"rename" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reback) name:@"reback" object:nil];
}

//- (void)rename
//{
//    //self.downloadButton.tag = (int)self.index;
//    
//    if (self.downloadButton.tag == (int)self.index) {
//        [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
//        [self.downloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        self.downloadButton.enabled = NO;
//    }
////    [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
//
//}


- (void)reback
{
    //self.downloadButton.tag = (int)self.index;
    
    if (self.downloadButton.tag == (int)self.index - 1) {
        [self.downloadButton setTitle:@"下载完成" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor colorWithRed:4/255.0 green:123/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        self.downloadButton.enabled = NO;
    }
    //    [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reback) name:@"reback" object:nil];
    
    
}

- (IBAction)downloadButtonClcked:(id)sender {
    
    [self.delegate addDownLoadTaskAction:self.index];
    
    self.downloadButton.tag = (int)self.index;
    
    NSLog(@"%ld",self.downloadButton.tag);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:self];
    
}




- (void)showData:(NSDictionary *)data{
    
    self.movieNameLb.text = [data objectForKey:@"name"];
    
}



@end
