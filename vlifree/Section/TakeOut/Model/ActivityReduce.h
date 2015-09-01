//
//  ActivityReduce.h
//  vlifree
//
//  Created by 仙林 on 15/6/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityReduce : NSObject
/**
 *  初始化方法
 *
 *  @param dic 活动信息字典
 *
 *  @return 活动Model
 */
- (id)initWithDictionary:(NSDictionary *)dic;
/**
 *  活动类型 1.满减 2.首减
 */
@property (nonatomic, strong)NSNumber * activeType;
/**
 *  满减的减少钱
 */
@property (nonatomic, strong)NSNumber * jMoney;
/**
 *  满减的满钱
 */
@property (nonatomic, strong)NSNumber * mMoney;
/**
 *  首减钱
 */
@property (nonatomic, strong)NSNumber * sMoney;


@end
