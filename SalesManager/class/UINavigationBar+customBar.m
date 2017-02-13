//
//  UINavigationBar+customBar.m
//  cuntomNavigationBar
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UINavigationBar+customBar.h"

@implementation UINavigationBar (customBar)


- (void)customNavigationBar {
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:[UIImage imageNamed:@"top_panal_background@2x_meitu_1"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self drawRect:self.bounds];
    }
    
   // [self drawRoundCornerAndShadow];
}


- (void)drawRect:(CGRect)rect {
    
    [[UIImage imageNamed:@"top_panal_background@2x_meitu_1"] drawInRect:rect];
    
}

- (void)drawRoundCornerAndShadow {
    
    CGRect bounds = self.bounds;
    bounds.size.height +=10;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
//                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(0.0, 0.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
}




@end
