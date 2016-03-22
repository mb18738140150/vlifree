//
//  CollectStroeDB.m
//  vlifree
//
//  Created by 仙林 on 16/3/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "CollectStroeDB.h"
#define TableName @"CollectStore"
static CollectStroeDB * collectSDManager = nil;

@implementation CollectStroeDB
//+(CollectStroeDB *)defaultDBManager
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        collectSDManager = [[CollectStroeDB alloc]init];
//    });
//    return collectSDManager;
//}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _db = [SDBManager defaultDBManager].database;
        [self createDataBase];
    }
    return self;
}

// 创建表结构
- (void)createDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",TableName]];
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        NSLog(@"数据库已经存在");
    }else
    {
        // TODO:插入新的数据库
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (title text,bussid integer,busstype integer)", TableName];
        BOOL res = [_db executeUpdate:sql];
        if (res) {
            NSLog(@"数据库创建成功");
        }else
        {
            NSLog(@"数据库创建失败");
        }
    }
    
    
}

// 插入数据
- (BOOL)insert:(CollectStoreModel *)model
{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT OR REPLACE INTO %@", TableName];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
    if (model.businessName) {
        [keys appendString:@"title,"];
        [values appendString:@"?,"];
        [arguments addObject:model.businessName];
    }
    if (model.businessId) {
        [keys appendString:@"bussid,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:model.businessId]];
    }
    if (model.businessType) {
        [keys appendString:@"busstype,"];
        [values appendString:@"?,"];
        [arguments addObject:[NSNumber numberWithInt:model.businessType]];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",[keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    if([_db executeUpdate:query withArgumentsInArray:arguments])
    {
        //        NSLog(@"插入一条数据成功%@",[NSString stringWithFormat:@"%lld", _db.lastInsertRowId]);
        return YES;
    }
    else
    {
        NSLog(@"插入一条数据失败");
        return NO;
    }

}
// 删除数据
- (BOOL)deletemodel:(CollectStoreModel *)model
{
   return  [_db executeUpdate:@"DELETE FROM CollectStore WHERE bussid = ?",[NSNumber numberWithInt:model.businessId]];
}

// 检索列表
- (BOOL)retrieveList:(CollectStoreModel *)model
{
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM CollectStore"];
    BOOL isHave = NO;
    while ([resultSet next]) {
        int bussid = [[resultSet stringForColumn:@"bussid"] intValue];
        if (model.businessId == bussid) {
            isHave = YES;
            return isHave;
        }
    }
    
    return isHave;
}

@end
