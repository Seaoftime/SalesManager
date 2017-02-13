//
//  DLWebImageView.h
//  NewDLImageView
//
//  Created by David Lee on 4/10/13.
//  Copyright (c) 2013 David Lee. All rights reserved.
//
// Thu-Apr-11 Updates:
// inherit from UIImageView
// replace progress view with progress layer
// remove unstable methods

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"
#import "DLProgressLayer.h"

@interface DLImageView : UIImageView <SDWebImageManagerDelegate>
{
    DLProgressLayer *progressLayer;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
