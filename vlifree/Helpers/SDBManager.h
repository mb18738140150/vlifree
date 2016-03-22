//
//  SDBManager.h
//  vlifree
//
//  Created by 仙林 on 16/3/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"
@interface SDBManager : NSObject
{
    NSString * _name;
}
@property (nonatomic, readonly)FMDatabase * database;

+(SDBManager *)defaultDBManager;
- (void)close;
@end
