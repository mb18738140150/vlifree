//
//  CollectModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

/**
 *  商店id
 */
@property (nonatomic, strong)NSNumber * businessId;
/**
 *  商店名
 */
@property (nonatomic, copy)NSString * businessName;
/**
 *  商店类型 1.酒店 2.外卖
 */
@property (nonatomic, strong)NSNumber * businessType;
/**
 *  商店描述
 */
@property (nonatomic, copy)NSString * describe;
/**
 *  距离
 */
@property (nonatomic, strong)NSNumber * distance;
/**
 *  商店图片
 */
@property (nonatomic, copy)NSString * icon;
/**
 *  价格
 */
@property (nonatomic, strong)NSNumber * price;
/**
 *  月售
 */
@property (nonatomic, strong)NSNumber * sold;
/**
 *  商店位置纬度
 */
@property (nonatomic, copy)NSString * businessLat;
/**
 *  商店位置经度
 */
@property (nonatomic, copy)NSString * businessLon;
/**
 *  商店营业状态(只有外卖才有)
 */
@property (nonatomic, strong)NSNumber * storeState;
/**
 *  起送价(只有外卖才有)
 */
@property (nonatomic, strong)NSNumber * sendPrice;

/**
 *  商店Model初始化方法
 *
 *  @param dic 商店信息字典
 *
 *  @return Model对象
 */
- (id)initWithDictionary:(NSDictionary *)dic;

@end
