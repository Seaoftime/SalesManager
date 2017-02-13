//
//  UIView+ShakeView.m
//  SalesManager
//
//  Created by louis on 14-3-20.
//  Copyright (c) 2014年 tianjing. All rights reserved.
//

#import "UIView+ShakeView.h"

@implementation UIView (ShakeView)
//int x = 6;

//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , x , 0 );
//}
//
//
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , x , 0 );
//}

- (void)ShakeMyView
{
    CAKeyframeAnimation *keyAn1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn1 setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn1 setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn1 setKeyTimes:times];
    [self.layer addAnimation:keyAn1 forKey:@"ViewAnim"];
}

@end
