//
//  HotelModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/3.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject


@property (nonatomic, strong)NSNumber * hotelId;
@property (nonatomic, copy)NSString * hotelName;
@property (nonatomic, strong)NSNumber * wifiState;
@property (nonatomic, strong)NSNumber * parkState;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * price;
@property (nonatomic, strong)NSNumber * sold;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * hotelLat;
@property (nonatomic, copy)NSString * hotelLon;
@property (nonatomic, strong)NSNumber * distance;
@property (nonatomic, strong)NSNumber * firstReduce;

@property (nonatomic, strong)NSNumber * isFirstReduce;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
