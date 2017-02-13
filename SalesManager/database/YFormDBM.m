//
//  YFormDBM.m
//  业务点点通IPad
//
//  Created by sm on 13-6-6.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "YFormDBM.h"
extern NSString* dataBasePath;
@implementation YFormDBM
- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) saveArea:(YformFileds *)area{
    
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO YformFileds"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:30];
    if (area.area) {
        [keys appendString:@"area,"];
        [values appendString:@"?,"];
        [arguments addObject:area.area];
        
        
    }
    if (area.sectionID) {
        [keys appendString:@"sectionID,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.sectionID]];
    }
    if (area.sectionTitle) {
        [keys appendString:@"sectionTitle,"];
        [values appendString:@"?,"];
        [arguments addObject:area.sectionTitle];
    }
    if (area.formID) {
        [keys appendString:@"formID,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.formID]];
    }
    if (area.formName) {
        [keys appendFormat:@"formName,"];
        [values appendString:@"?,"];
        [arguments addObject:area.formName];
    }if (area.formUnit) {
        [keys appendFormat:@"formUnit,"];
        [values appendString:@"?,"];
        [arguments addObject:area.formUnit];
    }if (area.formType) {
        [keys appendFormat:@"formType,"];
        [values appendString:@"?,"];
        [arguments addObject:area.formType];
    }if (area.formReferName) {
        [keys appendFormat:@"formReferName,"];
        [values appendString:@"?,"];
        [arguments addObject:area.formReferName];
    }if (area.need) {
        [keys appendFormat:@"need,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.need]];
    }if (area.gps) {
        [keys appendFormat:@"gps,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.gps]];
    }
    if (area.isReply) {
        [keys appendFormat:@"isReply,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.isReply]];
    }
    if (area.overdue) {
        [keys appendFormat:@"overdue,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.overdue]];
    }
    if (area.imageType) {
        [keys appendFormat:@"imageType,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.imageType]];
    }
    if (area.selectivity) {
        [keys appendFormat:@"selectivity,"];
        [values appendString:@"?,"];
        [arguments addObject:area.selectivity];
    }
    if (area.isImage) {
        [keys appendFormat:@"isImage,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.isImage]];
    }
    if (area.idSort) {
        [keys appendFormat:@"idSort,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInteger:area.idSort]];
    }
    
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"插入一条数据");
    [_db executeUpdate:query withArgumentsInArray:arguments];
    NSLog(@"%@",_db.lastError) ;
    }];
    
}


-(void)cleandataBase{
    [self executeSqlInBackground:@"DELETE FROM YformFileds"];
    NSLog(@"清空数据");
}


- (NSArray *) getForm:(NSString *)area{
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString* query = [NSString stringWithFormat:@"SELECT * FROM YformFileds where area = '%@' and formID is null and overdue = 1 ORDER BY idSort,sectionID ASC",area];
    FMResultSet * rs = [_db executeQuery:query];    
	while ([rs next]) {
        YformFileds* formFileds = [[YformFileds alloc] init];
        if (![[rs stringForColumn:@"sectionID"] isEqualToString:@"0"] && [[rs stringForColumn:@"overdue"] isEqualToString:@"1"]) {
            formFileds.sectionID = [rs intForColumn:@"sectionID"];
            formFileds.sectionTitle = [rs stringForColumn:@"sectionTitle"];
            formFileds.gps = [[rs stringForColumn:@"gps"] integerValue];
            formFileds.imageType = [rs intForColumn:@"imageType"];
            formFileds.isReply = [rs intForColumn:@"isReply"];
            formFileds.imageType = [rs intForColumn:@"imageType"];
            formFileds.isImage = [rs intForColumn:@"isImage"];
            [array addObject:formFileds];
        }
	}
	[rs close];
    }];
    return array;
    
}
- (NSArray *) getFormDetails:(NSString *)area inSectionID:(NSInteger)sectionID orSectionTitle:(NSString* )sectionTitle check:(BOOL)YN{
    
    __block  NSMutableArray * array = [[NSMutableArray alloc] init];

    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {
    NSString* query;
    if (!sectionID) {
        query = [NSString stringWithFormat:@"SELECT * FROM YformFileds where area = '%@' and sectionTitle = '%@' and formID is not null",area,sectionTitle];
        if (YN) query = [query stringByAppendingString:@" and overdue = 1"];
    }else{
        query = [NSString stringWithFormat:@"SELECT * FROM YformFileds where area = '%@' and sectionID = %d and formID is not null",area,sectionID];
        if (YN) query = [query stringByAppendingString:@" and overdue = 1"];

    }
    
    query = [query stringByAppendingFormat:@" ORDER BY idSort,formID ASC"];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSLog(@"%@",_db.lastError);
    
	while ([rs next]) {
        YformFileds* form = [YformFileds new];
        form.area = area;
        form.sectionID = [rs intForColumn:@"sectionID"];
        form.sectionTitle = [rs stringForColumn:@"sectionTitle"];
        form.formID = [rs intForColumn:@"formID"];
        form.formName = [rs stringForColumn:@"formName"];
        form.formUnit = [rs stringForColumn:@"formUnit"];
        form.formType = [rs stringForColumn:@"formType"];
        form.formReferName = [rs stringForColumn:@"formReferName"];
        form.need = [rs intForColumn:@"need"];
        form.overdue = [rs intForColumn:@"overdue"];
        form.gps = [rs intForColumn:@"gps"];
        form.selectivity = [rs stringForColumn:@"selectivity"];
        form.isReply = [rs intForColumn:@"isReply"];
        [array addObject:form];        
	}
	[rs close];
    }];
    return array;
    
    
}





-(int)getImageTypeBysectionID:(NSInteger )sectionID{
    
    __block int imageType = 0;
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString* query = [NSString stringWithFormat:@"SELECT * FROM YformFileds where sectionID = %d and formID is null and overdue = 1",sectionID];
    FMResultSet * rs = [_db executeQuery:query];
    while ([rs next]) {
        imageType = [rs intForColumn:@"imageType"];
	}
    [rs close];
        
    }];
    return imageType;
    
}


-(BOOL)checkWheatherNeed:(NSString* )gps InSectionID:(NSInteger )sectionID orSectionTitle:(NSString* )sectionTitle{
    __block BOOL YN = NO;
    [[[GCDataBaseManager shareDatabase] databaseQueue] inDatabase:^(FMDatabase *_db) {

    NSString* query;
    if (sectionID) {
        query = [NSString stringWithFormat:@"SELECT * FROM YformFileds where area = '信息汇报' and sectionID = %d and formID is null",sectionID];
    }else{
        query = [NSString stringWithFormat:@"SELECT * FROM YformFileds where area = '信息汇报' and sectionTitle = '%@' and formID is null",sectionTitle];
    }
    query = [query stringByAppendingFormat:@" ORDER BY formID DESC limit 100"];
    FMResultSet * rs = [_db executeQuery:query];
    while ([rs next]) {
        if ([rs stringForColumn:gps]) {
            YN = YES;
        }else{
            YN = NO;
        }
	}
    [rs close];
    }];
    
    return YN;
}

@end
