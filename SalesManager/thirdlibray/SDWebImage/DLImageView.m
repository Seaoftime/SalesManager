//
//  DLWebImageView.m
//  NewDLImageView
//
//  Created by David Lee on 4/10/13.
//  Copyright (c) 2013 David Lee. All rights reserved.
//

#import "DLImageView.h"

@implementation DLImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        progressLayer =[DLProgressLayer layer];
        progressLayer.frame = self.frame;
        [self.layer addSublayer:progressLayer];
    }
    return self;
}

#pragma mak - query image in cache & web

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url && progressLayer.drawProgress == NO)
    {
        progressLayer.drawProgress = YES;
        progressLayer.progress = 0.01f;
        NSLog(@"Request");
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    @synchronized(self)
    {
        [[SDWebImageManager sharedManager] cancelForDelegate:self];
        progressLayer.drawProgress = NO;
        progressLayer.progress = 0;
        
        //        mProgress = 0;
        //        [self redrawProgress];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    [self setNeedsLayout];
    progressLayer.drawProgress = NO;
    progressLayer.progress = 0;
    NSLog(@"Request End");
    //    mProgress = 0;
    //    drawProgress = NO;
    //    [self redrawProgress];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    progressLayer.drawProgress = NO;
    progressLayer.progress = 0;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didUpdateWithProgress:(CGFloat)progress forURL:(NSURL *)url
{
    progressLayer.progress = progress;
}

@end
