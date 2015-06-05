//
//  UserLocation.h
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocation : NSObject


+ (UserLocation *)shareUserLocation;
@property (nonatomic, strong)CLLocation * location;
@property (nonatomic, strong)CLPlacemark * placemark;


@end
