//
//  OrderDetailsMD.m
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "OrderDetailsMD.h"
#import "OrderMenuMD.h"

@implementation OrderDetailsMD


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
    if ([key isEqualToString:@"WakeOutOrderDetail"]) {
        NSArray * array = (NSArray *)value;
        self.menusArray = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            OrderMenuMD * menuMD = [[OrderMenuMD alloc] initWithDictionary:dic];
            [self.menusArray addObject:menuMD];
        }
    }
}


@end
