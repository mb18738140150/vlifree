//
//  UserLocation.h
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface UserLocation : NSObject


+ (UserLocation *)shareUserLocation;
@property (nonatomic, assign)CLLocationCoordinate2D userLocation;
@property (nonatomic, copy)NSString * city;
@property (nonatomic, copy)NSString * streetName;
@property (nonatomic, copy)NSString * streetNumber;
@property (nonatomic, copy)NSString * district;

@end
