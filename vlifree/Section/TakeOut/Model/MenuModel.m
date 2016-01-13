//
//  MenuModel.m
//  vlifree
//
//  Created by 仙林 on 15/6/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenuModel.h"
#import "PropertyModel.h"
@implementation MenuModel


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
    if ([key isEqualToString:@"AttrList"]) {
        NSArray * array = value;
        self.PropertyList = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            PropertyModel * model = [[PropertyModel alloc]initWithDictionary:dic];
            [self.PropertyList addObject:model];
        }
    }
}



@end
