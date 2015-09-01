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

/**
 *  用户位置单例创建方法
 *
 *  @return 用户位置单例对象
 */
+ (UserLocation *)shareUserLocation;
/**
 *  用户位置坐标
 */
@property (nonatomic, assign)CLLocationCoordinate2D userLocation;
/**
 *  用户位置城市
 */
@property (nonatomic, copy)NSString * city;
/**
 *  用户位置街道
 */
@property (nonatomic, copy)NSString * streetName;
/**
 *  用户位置门牌号
 */
@property (nonatomic, copy)NSString * streetNumber;
/**
 *  用户位置区名
 */
@property (nonatomic, copy)NSString * district;

@end
