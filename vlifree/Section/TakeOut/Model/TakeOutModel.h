//
//  TakeOutModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityReduce.h"

@interface TakeOutModel : NSObject
/**
 *  商店id
 */
@property (nonatomic, strong)NSNumber * storeId;
/**
 *  商店名
 */
@property (nonatomic, copy)NSString * storeName;
/**
 *  商店图片
 */
@property (nonatomic, copy)NSString * icon;
/**
 *  商店营业状态 1.营业 0.不营业
 */
@property (nonatomic, strong)NSNumber * storeState;
/**
 *  起送价
 */
@property (nonatomic, strong)NSNumber * sendPrice;
/**
 *  月售
 */
@property (nonatomic, strong)NSNumber * sold;
/**
 *  配送费
 */
@property (nonatomic, strong)NSNumber * outSentMoney;
/**
 *  是否在配送范围 YES或者NO
 */
@property (nonatomic, strong)NSNumber * peyType;
/**
 *  距离
 */
@property (nonatomic, strong)NSNumber * distance;
/**
 *  配送时间
 */
@property (nonatomic, strong)NSNumber * sendTime;
/**
 *  评论数
 */
@property (nonatomic, strong)NSNumber * commentCount;
/**
 *  商店地址
 */
@property (nonatomic, copy)NSString * address;
/**
 *  是否有首单立减
 */
@property (nonatomic, strong)NSNumber * isFirstOrder;
/**
 *  是否有满减
 */
@property (nonatomic, strong)NSNumber * isFull;
/**
 *  餐盒费
 */
@property (nonatomic, strong)NSNumber * mealBoxMoney;
/**
 *  活动数组
 */
@property (nonatomic, strong)NSMutableArray * activityArray;
/**
 *  初始化方法
 *
 *  @param dic 商店信息字典
 *
 *  @return 外卖Model
 */
- (id)initWithDictionary:(NSDictionary *)dic;



@end
