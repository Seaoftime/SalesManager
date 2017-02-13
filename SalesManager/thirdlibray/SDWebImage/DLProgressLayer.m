//
//  DLProgressLayer.m
//  NewDLImageView
//
//  Created by David Lee on 4/11/13.
//  Copyright (c) 2013 David Lee. All rights reserved.
//

#import "DLProgressLayer.h"

@implementation DLProgressLayer
@synthesize drawProgress, progress;

- (id)init
{
    if (self = [super init])
    {}
    return self;
}

- (void)setProgress:(CGFloat)aprogress
{
    progress = aprogress;
    [self setNeedsDisplay];
}

- (void)setDrawProgress:(BOOL)isdrawProgress
{
    drawProgress = isdrawProgress;
    if (drawProgress == NO) {
        [self removeAllAnimations];
    }
    [self setNeedsDisplay];
}

- (void)redrawProgress
{
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame)/2 - 24, CGRectGetHeight(self.frame)/2 - 24, 48, 48);
    [super setNeedsDisplayInRect:frame];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat radiusMinusLineWidth = 10;
    if(drawProgress)
    {
        if (progress > 0)
        {
            CGFloat startAngle = -M_PI / 2;
            CGFloat endAngle = startAngle + progress * 2 * M_PI;
            [self drawProgressArcWithStartAngle:startAngle endAngle:endAngle radius:radiusMinusLineWidth lineWidth:20 inContext:ctx];
        }
        [self drawProgressArcWithStartAngle:-M_PI / 2 endAngle:M_PI * 3 / 2 radius:24 lineWidth:4 inContext:ctx];
    }
}

- (void)drawProgressArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth inContext:(CGContextRef)ctx
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    CGContextAddArc(ctx, center.x, center.y, radius, endAngle, startAngle, 1);
//    UIColor *cumstomColor = [UIColor colorWithRed:182/255.0 green:131/255.0 blue:104/255.0 alpha:1.0];
    CGContextSetRGBStrokeColor(ctx, 182/255.0, 131/255.0, 104/255.0, 1.0);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextStrokePath(ctx);
}
@end
