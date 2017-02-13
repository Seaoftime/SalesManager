//
//  YPcituresFileds.h
//  业务点点通
//
//  Created by Sky on 13-1-16.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPcituresFileds : NSObject

@property (nonatomic, copy) NSString* autoIncremenID;
@property (nonatomic, assign) NSInteger albumID;
@property (nonatomic, copy) NSString* albumTitle;
@property (nonatomic, assign) NSInteger albumPhotoNumbers;
@property (nonatomic, copy) NSString* albumCoverUrl;
@property (nonatomic, copy) NSString* albumContetn;
@property (nonatomic, assign) NSInteger photoID;
@property (nonatomic, copy) NSString* photoTitle;
@property (nonatomic, copy) NSString* photoUrl;
@property (nonatomic, copy) NSString* phtotBigPhotoUrl;
@property (nonatomic, assign) NSInteger is_cover;
@property (nonatomic, copy) NSString* photoContent;


@property (nonatomic, assign) NSInteger localAlbumID;

@property (nonatomic, assign) NSInteger localPhotoID;


//
//@property (nonatomic, copy)NSString* obligate1;     //个人图库 不为空
//@property (nonatomic, copy)NSString* myPhotoAlbumID;
//@property (nonatomic, copy)NSString* myPhotoAlbumName;
//@property (nonatomic, copy)NSString* myPhotoAlbumTitlePage;





@end
