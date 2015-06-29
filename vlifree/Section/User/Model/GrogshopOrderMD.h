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
@property (nonatomic, copy)NSString * checkinTime;
@property (nonatomic, copy)NSString * leaveTime;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSNumber * payState;
@property (nonatomic, copy)NSString * roomType;
@property (nonatomic, strong)NSNumber * totalDay;



- (id)initWithDictionary:(NSDictionary *)dic;

@end
