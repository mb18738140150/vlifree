//
//  StoreTypeModel.m
//  vlifree
//
//  Created by 仙林 on 16/4/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "StoreTypeModel.h"

@implementation StoreTypeModel
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
