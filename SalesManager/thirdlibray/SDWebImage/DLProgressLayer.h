//
//  DLProgressLayer.h
//  NewDLImageView
//
//  Created by David Lee on 4/11/13.
//  Copyright (c) 2013 David Lee. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface DLProgressLayer : CALayer
@property (assign, nonatomic)BOOL drawProgress;
@property (assign, nonatomic)CGFloat progress;
@end
