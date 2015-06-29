//
//  TakeOutModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeOutModel : NSObject

@property (nonatomic, strong)NSNumber * storeId;
@property (nonatomic, copy)NSString * storeName;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * storeState;
@property (nonatomic, strong)NSNumber * sendPrice;
@property (nonatomic, strong)NSNumber * sold;
@property (nonatomic, strong)NSNumber * outSentMoney;
@property (nonatomic, strong)NSNumber * peyType;
@property (nonatomic, copy)NSString * address;
@property (nonatomic, strong)NSNumber * isFirstOrder;
@property (nonatomic, strong)NSNumber * isFull;
@property (nonatomic, strong)NSNumber * mealBoxMoney;

- (id)initWithDictionary:(NSDictionary *)dic;



@end
