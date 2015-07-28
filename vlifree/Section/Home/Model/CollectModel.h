//
//  CollectModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject


@property (nonatomic, strong)NSNumber * businessId;
@property (nonatomic, copy)NSString * businessName;
@property (nonatomic, strong)NSNumber * businessType;
@property (nonatomic, copy)NSString * describe;
@property (nonatomic, strong)NSNumber * distance;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * price;
@property (nonatomic, strong)NSNumber * sold;
@property (nonatomic, copy)NSString * businessLat;
@property (nonatomic, copy)NSString * businessLon;
@property (nonatomic, strong)NSNumber * storeState;
@property (nonatomic, strong)NSNumber * sendPrice;


- (id)initWithDictionary:(NSDictionary *)dic;

@end
