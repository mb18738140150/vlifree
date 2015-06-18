//
//  UserInfo.m
//  vlifree
//
//  Created by 仙林 on 15/6/12.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserInfo.h"

static UserInfo * userInfo = nil;

@implementation UserInfo


+ (UserInfo *)shareUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc] init];
    });
    return userInfo;
}

- (void)setPropertyWithDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
