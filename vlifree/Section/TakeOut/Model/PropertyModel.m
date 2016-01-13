//
//  PropertyModel.m
//  vlifree
//
//  Created by 仙林 on 15/12/26.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PropertyModel.h"

@implementation PropertyModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.count = 0;
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
