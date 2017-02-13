//
//  YPicturesDBM.m
//  业务点点通
//
//  Created by Sky on 13-1-16.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "YPicturesDBM.h"
NSString* checkAlbumId;

@implementation YPicturesDBM



- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}
/**
 * @brief 创建数据库
 */


-(void)deletMyPictureAllPicture{
    [self executeSql:@"DELETE FROM YPcituresFileds WHERE albumID is null"];
}

-(void)cleanAlbum:(NSInteger )albumID{
    [self executeSql:[NSString stringWithFormat:@"DELETE FROM YPcituresFileds WHERE albumID is %d and localAlbumID is null",albumID]];
}
/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */

-(void)saveAlbumOrPhotos:(YPcituresFileds *)picture isPicture:(BOOL)pic{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
        

    NSString* query;
    if (pic) {
        query = [NSString stringWithFormat:@"select * from YPcituresFileds where photoID = %ld",(long)picture.photoID];
    }else{
        query = [NSString stringWithFormat:@"select * from YPcituresFileds where localAlbumID = %ld",(long)picture.localAlbumID];
        
    }
        
    FMResultSet *rs = [_db executeQuery:query];
        
    if ([rs next]) {
        
        if (pic) {
            
            [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YPcituresFileds SET photoTitle = '%@', photoUrl = '%@',phtotBigPhotoUrl = '%@' WHERE photoID = %ld and albumID = %ld" ,picture.photoTitle,picture.photoUrl,picture.phtotBigPhotoUrl,(long)picture.photoID,(long)picture.albumID]];
        }else{
            
            
            [_db executeUpdate:[NSString stringWithFormat:@"UPDATE YPcituresFileds SET albumTitle='%@',albumPhotoNumbers=%ld,localAlbumID = %ld,albumCoverUrl='%@',albumContetn = '%@' WHERE localAlbumID = %ld",picture.albumTitle,(long)picture.albumPhotoNumbers,(long)picture.localAlbumID,picture.albumCoverUrl,picture.albumContetn,(long)picture.localAlbumID]];
        }
    }else {
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YPcituresFileds"];
        NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
        NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
        if (picture.albumID) {
            [keys appendString:@"albumID,"];
            [values appendString:@"?,"];
            [arguments addObject:[NSNumber numberWithInteger:picture.albumID]];
            
            
        }
        if (picture.albumTitle) {
            [keys appendString:@"albumTitle,"];
            [values appendString:@"?,"];
            [arguments addObject:picture.albumTitle];
        }
        if (picture.albumCoverUrl) {
            [keys appendString:@"albumCoverUrl,"];
            [values appendString:@"?,"];
            [arguments addObject:picture.albumCoverUrl];
        }
        if (picture.albumContetn) {
            [keys appendFormat:@"albumContetn,"];
            [values appendString:@"?,"];
            [arguments addObject:picture.albumContetn];
        }
        
        if (pic) {
            
            if (picture.photoUrl) {
                [keys appendString:@"photoUrl,"];
                [values appendString:@"?,"];
                [arguments addObject:picture.photoUrl];
            }
            if (picture.photoID) {
                [keys appendFormat:@"photoID,"];
                [values appendString:@"?,"];
                [arguments addObject:[NSNumber numberWithInteger:picture.photoID]];
            }if (picture.photoTitle) {
                [keys appendFormat:@"photoTitle,"];
                [values appendString:@"?,"];
                [arguments addObject:picture.photoTitle];
            }if (picture.phtotBigPhotoUrl) {
                [keys appendFormat:@"phtotBigPhotoUrl,"];
                [values appendString:@"?,"];
                [arguments addObject:picture.phtotBigPhotoUrl];
            }
        }else{
            
            if (picture.albumPhotoNumbers) {
                [keys appendString:@"albumPhotoNumbers,"];
                [values appendString:@"?,"];
                [arguments addObject:[NSNumber numberWithInteger:picture.albumPhotoNumbers]];
            }
            
            if (picture.localAlbumID) {
                [keys appendFormat:@"localAlbumID,"];
                [values appendString:@"?,"];
                [arguments addObject:[NSNumber numberWithInteger:picture.localAlbumID]];
            }
            
        }
        
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];

        [_db executeUpdate:query withArgumentsInArray:arguments];

    }
        if (_db.lastError) NSLog(@"%@",[_db lastError]);
        [rs close];
    }];
    
    
}






-(void)cleandataBase{
    
   [self executeSql:@"DELETE FROM YPcituresFileds"];
}




-(void) cleanListData{
    [self executeSql:@"DELETE FROM YPcituresFileds WHERE albumPhotoNumbers is not null"];
}



- (NSArray *) findWithautoIncremenID:(NSString *) autoIncremenID limit:(int) limit {
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString * query = @"SELECT * FROM YPcituresFileds WHERE albumPhotoNumbers is not null";
    if (!autoIncremenID) {
        query = [query stringByAppendingFormat:@" ORDER BY albumID DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" and autoIncremenID > %@ ORDER BY albumID DESC limit %d",autoIncremenID,limit];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
	while ([rs next]) {
        YPcituresFileds* picture = [YPcituresFileds new];
        picture.albumID = [rs intForColumn:@"albumID"];
        //        picture.albumPhotoNumbers = [rs stringForColumn:@"albumPhotoNumbers"];
        //        picture.albumContetn = [rs stringForColumn:@"albumContetn"];
        picture.albumCoverUrl = [rs stringForColumn:@"albumCoverUrl"];
        picture.albumTitle  = [rs stringForColumn:@"albumTitle"];
        picture.albumPhotoNumbers = [rs intForColumn:@"albumPhotoNumbers"];
        [array addObject:picture];
	}
	[rs close];
    if (_db.lastError) NSLog(@"%@",[_db lastError]);
    NSLog(@"image count %ld",array.count);
    }];
    return array;
    
}


- (NSArray *) findWithAlbumID:(NSInteger ) albumID limit:(int) limit {
    
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM YPcituresFileds WHERE albumPhotoNumbers is null  and albumID = %d",albumID];
    query = [query stringByAppendingFormat:@" ORDER BY photoID DESC limit %d",limit];
    FMResultSet * rs = [_db executeQuery:query];
	while ([rs next]) {
        YPcituresFileds* picture = [YPcituresFileds new];
        picture.photoID = [rs intForColumn:@"photoID"];
        //        picture.photoTitle = [rs stringForColumn:@"photoTitles"];
        //        picture.phtotBigPhotoUrl = [rs stringForColumn:@"phtotBigPhotoUrl"];
        picture.photoUrl = [rs stringForColumn:@"photoUrl"];
        picture.phtotBigPhotoUrl = [rs stringForColumn:@"phtotBigPhotoUrl"];
        //        picture.photoContent  = [rs stringForColumn:@"photoContent"];
        picture.photoTitle = [rs stringForColumn:@"photoTitle"];
        picture.photoContent = [rs stringForColumn:@"photoContent"];
        
        
        [array addObject:picture];
	}
    if (_db.lastError) NSLog(@"%@",[_db lastError]);
	[rs close];
    }];
    return array;
}


- (NSArray *) findWithAllPhotos:(NSString *) autoIncremenID limit:(int) limit {
    
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM YPcituresFileds WHERE albumPhotoNumbers is null and albumID is not null"];
    
    if (!autoIncremenID) {
        query = [query stringByAppendingFormat:@" ORDER BY photoID DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" and autoIncremenID > %@ ORDER BY photoID DESC limit %d",autoIncremenID,limit];
    }
    
    
    FMResultSet * rs = [_db executeQuery:query];
	while ([rs next]) {
        YPcituresFileds* picture = [YPcituresFileds new];
        picture.photoID = [rs intForColumn:@"photoID"];
        //        picture.photoTitle = [rs stringForColumn:@"photoTitles"];
        //        picture.phtotBigPhotoUrl = [rs stringForColumn:@"phtotBigPhotoUrl"];
        picture.photoUrl = [rs stringForColumn:@"photoUrl"];
        picture.phtotBigPhotoUrl = [rs stringForColumn:@"phtotBigPhotoUrl"];
        //        picture.photoContent  = [rs stringForColumn:@"photoContent"];
        picture.photoTitle = [rs stringForColumn:@"photoTitle"];
        picture.photoContent = [rs stringForColumn:@"photoContent"];
        [array addObject:picture];
	}
    if (_db.lastError) NSLog(@"%@",[_db lastError]);
	[rs close];
    }];
    return array;
}





@end
