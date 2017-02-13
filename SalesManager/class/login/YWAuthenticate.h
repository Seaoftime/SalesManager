//
//  YWAuthenticate.h
//  SalesManager
//
//  Created by Sky on 16/3/31.
//  Copyright © 2016年 tianjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAuthenticate : NSObject<CLLocationManagerDelegate>

-(void)authenticateTripartite:(NSDictionary* )launOp;


@property (strong, nonatomic) CLLocationManager *locationManager;


@end
