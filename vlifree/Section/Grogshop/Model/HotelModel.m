//
//  HotelModel.m
//  vlifree
//
//  Created by 仙林 on 15/6/3.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HotelModel.h"

@implementation HotelModel


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
