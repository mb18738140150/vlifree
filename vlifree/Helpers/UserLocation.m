//
//  UserLocation.m
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserLocation.h"

static UserLocation * location = nil;

@implementation UserLocation

+ (UserLocation *)shareUserLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[UserLocation alloc] init];
    });
    return location;
}


@end
