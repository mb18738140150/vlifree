//
//  TakeOutOrderMD.h
//  vlifree
//
//  Created by 仙林 on 15/6/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeOutOrderMD : NSObject


@property (nonatomic, copy)NSString * orderID;
@property (nonatomic, copy)NSString * storeIcon;
@property (nonatomic, copy)NSString * storeName;
@property (nonatomic, strong)NSNumber * storeId;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * busiPhone;
//@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSNumber * orderState;
@property (nonatomic, strong)NSNumber * deliveryMoney;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, copy)NSString * nextphone;
@property (nonatomic, copy)NSString * address;
//@property (nonatomic, strong)NSNumber * payType;
//@property (nonatomic, strong)NSNumber * isDeal;
@property (nonatomic, strong)NSNumber * firstReduce;
@property (nonatomic, strong)NSNumber * fullReduce;
@property (nonatomic, strong)NSNumber * mealBoxMoney;
@property (nonatomic, strong)NSNumber * reduceCard;//优惠券
@property (nonatomic, strong)NSNumber * discount;//打折
@property (nonatomic, strong)NSNumber * internal;//积分
@property (nonatomic, strong)NSNumber * mealCount;// 订单菜品数量

- (id)initWithDictionary:(NSDictionary *)dic;


@end
