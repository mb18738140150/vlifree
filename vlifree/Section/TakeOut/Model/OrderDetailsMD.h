//
//  OrderDetailsMD.h
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailsMD : NSObject


@property (nonatomic, strong)NSNumber * orderState;
@property (nonatomic, strong)NSNumber * isPey;
@property (nonatomic, strong)NSNumber * PeyType;
@property (nonatomic, copy)NSString *  storeName;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * busiPhone;
@property (nonatomic, strong)NSNumber * firstReduce;
@property (nonatomic, strong)NSNumber * fullReduce;
@property (nonatomic, strong)NSNumber * deliveryMoney;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, copy)NSString * nextphone;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, strong)NSNumber * mealBoxMoney;
@property (nonatomic, strong)NSMutableArray * menusArray;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
