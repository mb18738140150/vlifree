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
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * busiPhone;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSNumber * orderState;
@property (nonatomic, strong)NSNumber * deliveryMoney;
@property (nonatomic, strong)NSNumber * allMoney;
@property (nonatomic, copy)NSString * nextphone;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, strong)NSNumber * payType;
@property (nonatomic, strong)NSNumber * isDeal;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
