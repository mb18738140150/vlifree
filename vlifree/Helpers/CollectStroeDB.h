//
//  CollectStroeDB.h
//  vlifree
//
//  Created by 仙林 on 16/3/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectStoreModel.h"
#import "FMDatabase.h"

@interface CollectStroeDB : NSObject
{
    FMDatabase * _db;
}

//+(CollectStroeDB *)shareCollectStoreDB;

//添加
- (BOOL) insert:(CollectStoreModel *)model;

// 删除
- (BOOL) deletemodel:(CollectStoreModel *)model;

// 检索列表
- (BOOL)retrieveList:(CollectStoreModel *)model;
@end
