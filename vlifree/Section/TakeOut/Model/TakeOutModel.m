//
//  TakeOutModel.m
//  vlifree
//
//  Created by 仙林 on 15/6/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TakeOutModel.h"

@implementation TakeOutModel



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
    if ([key isEqualToString:@"ActivityReduce"]) {
        NSArray * array = (NSArray *)value;
        self.ActivityArray = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            ActivityReduce * activityRD = [[ActivityReduce alloc] initWithDictionary:dic];
            [self.ActivityArray addObject:activityRD];
        }
    }
}



@end
