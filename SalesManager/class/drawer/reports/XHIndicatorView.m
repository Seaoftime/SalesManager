//
//  XHIndicatorView.m
//  SalesManager
//
//  Created by Kris on 13-12-7.
//  Copyright (c) 2013年 tianjing. All rights reserved.
//

#import "XHIndicatorView.h"

@interface XHIndicatorView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end


@implementation XHIndicatorView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 12, 12)];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(12 + 2, 2, 56, 10)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont systemFontOfSize:11];
        [self addSubview:_label];
        
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 47, 10);
        self.type = XHIndicatorViewTypeFailure;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 12, 12)];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(12 + 2, 2, 56, 10)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont systemFontOfSize:11];
        [self addSubview:_label];
    }
    return self;
}

double angle = 0;

- (void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0 * (M_PI / 180.0f));
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _imageView.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 10;
        switch (_type)
        {
            case XHIndicatorViewTypeSending:
            {
                [self startAnimation];
                break;
            }
            case XHIndicatorViewTypeFailure:
            {
                _imageView.transform = CGAffineTransformMakeRotation(0);
                break;
            }
            case XHIndicatorViewTypeSuccess:
            {
                _imageView.transform = CGAffineTransformMakeRotation(0);
                break;
            }
            default:
                break;
        }
    }];
    
}

- (void)setType:(XHIndicatorViewType)type
{
    _type = type;
    switch (type)
    {
        case XHIndicatorViewTypeSending:
        {
            //self.imageView.image = [UIImage imageNamed:@"XHIndicatorView_Sending@2x"];
            
            self.imageView.image = [UIImage imageNamed:@"加载中@2x"];
            
            self.label.textColor = [UIColor colorWithRed:0.000 green:0.569 blue:0.988 alpha:1.000];
            self.label.text = @"正在发送";
           
            
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 1;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = 1e100;
            [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            
            break;
        }
        case XHIndicatorViewTypeFailure:
        {
            [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
            //self.imageView.image = [UIImage imageNamed:@"XHIndicatorView_Failure@2x"];
            
            self.imageView.image = [UIImage imageNamed:@"错误@2x"];
            self.label.textColor = [UIColor colorWithRed:1.000 green:0.231 blue:0.188 alpha:1.000];
            self.label.text = @"发送失败";
            break;
        }
        case XHIndicatorViewTypeSaveDraft:
        {
            //[self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
           // self.imageView.image = [UIImage imageNamed:@"XHIndicatorView_Failure@2x"];
//           self.label.textColor = [UIColor colorWithRed:3/255.0 green:124/255.0 blue:61/255.0 alpha:1.000];
            self.label.text = @"";
            break;
        }

        case XHIndicatorViewTypeSuccess:
        {
            [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
            self.imageView.image = Nil;
            self.label.text = @"";
            break;
        }
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
