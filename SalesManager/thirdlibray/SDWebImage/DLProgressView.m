//
//  DLProgressView.m
//  iFang_ZSSLC
//
//  Created by David Lee on 4/10/13.
//  Copyright (c) 2013 CocoaDev2. All rights reserved.
//

#import "DLProgressView.h"

@implementation DLProgressView
@synthesize progress, drawProgress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(float)mprogress
{
    progress = mprogress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat radiusMinusLineWidth = 10;
    if (self.drawProgress)
    {
        if (progress > 0)
        {
            CGFloat startAngle = -M_PI / 2;
            CGFloat endAngle = startAngle + progress * 2 * M_PI;
            [self drawProgressArcWithStartAngle:startAngle endAngle:endAngle radius:radiusMinusLineWidth lineWidth:20];
        }
        [self drawProgressArcWithStartAngle:-M_PI / 2 endAngle:M_PI * 3 / 2 radius:24 lineWidth:4];
    }
}

- (void)drawProgressArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                  radius:radius
                                                              startAngle:startAngle
                                                                endAngle:endAngle
                                                               clockwise:YES];
    //TODO:cumstom color
    UIColor *cumstomColor = [UIColor colorWithRed:182/255.0 green:131/255.0 blue:104/255.0 alpha:1.0];
    [cumstomColor setStroke];// color of the progress bar
    progressCircle.lineWidth = lineWidth;
    [progressCircle strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];// alpha
}



@end
