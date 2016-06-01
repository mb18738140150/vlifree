//
//  GrogshopOrderMD.h
//  vlifree
//
//  Created by 仙林 on 15/6/24.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrogshopOrderMD : NSObject


@property (nonatomic, copy)NSString * orderSn;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * storeIcon;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, copy)NSString * roomType;
@property (nonatomic, copy)NSString * checkinTime;
@property (nonatomic, copy)NSString * leaveTime;
@property (nonatomic, strong)NSNumber * totalDay;
@property (nonatomic, strong)NSNumber * payState;
@property (nonatomic, strong)NSNumber * refundState;
@property (nonatomic, strong)NSNumber * orderState;
@property (nonatomic, copy)NSString * createTime;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
