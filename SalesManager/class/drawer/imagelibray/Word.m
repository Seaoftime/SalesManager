//
//  Word.m
//  SalesManager
//
//  Created by TonySheng on 16/5/19.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import "Word.h"

@implementation Word



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //如果父类也遵守NSCoding协议，需要先调用super encodeWithCoder
    
    //在编码方法中，把需要编码的数以挨个进行编码
    [aCoder encodeObject:_wordName forKey:@"name"];
    [aCoder encodeObject:_wordUrl forKey:@"url"];
    
    
}


//解码方法
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    //在解码方法中，对编码过的属性逐一解码
    if (self) {
        _wordName = [[aDecoder decodeObjectForKey:@"name"] copy];
        _wordUrl = [[aDecoder decodeObjectForKey:@"url"] copy];
        
    }
    return self;
}




@end
