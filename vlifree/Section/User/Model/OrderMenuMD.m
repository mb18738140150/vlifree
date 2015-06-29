//
//  OrderMenuMD.m
//  vlifree
//
//  Created by 仙林 on 15/6/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "OrderMenuMD.h"

@implementation OrderMenuMD


- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
