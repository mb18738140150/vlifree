//
//  HotelModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/3.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject

/**
 *  酒店id
 */
@property (nonatomic, strong)NSNumber * hotelId;
/**
 *  酒店名字
 */
@property (nonatomic, copy)NSString * hotelName;
/**
 *  WiFi状态
 */
@property (nonatomic, strong)NSNumber * wifiState;
/**
 *  停车场状态
 */
@property (nonatomic, strong)NSNumber * parkState;
/**
 *  酒店图片
 */
@property (nonatomic, copy)NSString * icon;
/**
 *  酒店最低价格
 */
@property (nonatomic, strong)NSNumber * price;
/**
 *  酒店月售量
 */
@property (nonatomic, strong)NSNumber * sold;
/**
 *  酒店地址
 */
@property (nonatomic, copy)NSString * address;
/**
 *  酒店纬度
 */
@property (nonatomic, copy)NSString * hotelLat;
/**
 *  酒店经度
 */
@property (nonatomic, copy)NSString * hotelLon;
/**
 *  酒店离用户位置
 */
@property (nonatomic, strong)NSNumber * distance;
/**
 *  首单减免费
 */
@property (nonatomic, strong)NSNumber * firstReduce;
/**
 *  是否有首单减免 1.有 2.没有
 */
@property (nonatomic, strong)NSNumber * isFirstReduce;
/**
 *  初始化方法
 *
 *  @param dic 酒店信息字典
 *
 *  @return 酒店模型对象
 */
- (id)initWithDictionary:(NSDictionary *)dic;


@end
