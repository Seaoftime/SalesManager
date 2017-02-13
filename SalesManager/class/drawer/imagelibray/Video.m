//
//  Video.m
//  SalesManager
//
//  Created by TonySheng on 16/5/17.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "Video.h"

@implementation Video

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //如果父类也遵守NSCoding协议，需要先调用super encodeWithCoder
    
    //在编码方法中，把需要编码的数以挨个进行编码
    [aCoder encodeObject:_videoName forKey:@"name"];
    [aCoder encodeObject:_videoTime forKey:@"time"];
    [aCoder encodeObject:_videoURL forKey:@"url"];
    [aCoder encodeObject:_videoImage forKey:@"image"];
   
}


//解码方法
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    //在解码方法中，对编码过的属性逐一解码
    if (self) {
        _videoName = [[aDecoder decodeObjectForKey:@"name"] copy];
        _videoTime = [[aDecoder decodeObjectForKey:@"time"] copy];
        _videoURL = [[aDecoder decodeObjectForKey:@"url"] copy];
        _videoImage = [[aDecoder decodeObjectForKey:@"image"] copy];
       
    }
    return self;
}

@end
