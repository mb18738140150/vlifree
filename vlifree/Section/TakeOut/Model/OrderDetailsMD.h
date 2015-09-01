//
//  OrderDetailsMD.h
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailsMD : NSObject
/**
 *  订单状态
 */
@property (nonatomic, strong)NSNumber * storeState;
/**
 *  起送价
 */
@property (nonatomic, strong)NSNumber * sendPrice;
/**
 *  订单状态
 */
@property (nonatomic, strong)NSNumber * orderState;
/**
 *  商家id
 */
@property (nonatomic, strong)NSNumber * storeId;
/**
 *  是否已支付
 */
@property (nonatomic, strong)NSNumber * isPey;
/**
 *  支付方式
 */
@property (nonatomic, strong)NSNumber * PeyType;
/**
 *  商家名
 */
@property (nonatomic, copy)NSString *  storeName;
/**
 *  订单时间
 */
@property (nonatomic, copy)NSString * time;
/**
 *  商家电话
 */
@property (nonatomic, copy)NSString * busiPhone;
/**
 *  首单立减钱
 */
@property (nonatomic, strong)NSNumber * firstReduce;
/**
 *  满单减免钱
 */
@property (nonatomic, strong)NSNumber * fullReduce;
/**
 *  派送费
 */
@property (nonatomic, strong)NSNumber * deliveryMoney;
/**
 *  订单总钱数
 */
@property (nonatomic, strong)NSNumber * allMoney;
/**
 *  下单电话
 */
@property (nonatomic, copy)NSString * nextphone;
/**
 *  下单地址
 */
@property (nonatomic, copy)NSString * address;
/**
 *  餐盒费
 */
@property (nonatomic, strong)NSNumber * mealBoxMoney;
/**
 *  订单餐数组
 */
@property (nonatomic, strong)NSMutableArray * menusArray;
/**
 *  商店描述
 */
@property (nonatomic, copy)NSString * storeDecribe;
/**
 *  商店图片
 */
@property (nonatomic, copy)NSString * storeIcon;
/**
 *  是否已经评论
 */
@property (nonatomic, strong)NSNumber * isComment;
/**
 *  初始化方法
 *
 *  @param dic 订单详情字典
 *
 *  @return 订单模型(Model)对象
 */
- (id)initWithDictionary:(NSDictionary *)dic;


@end
