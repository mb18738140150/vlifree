//
//  ActivityReduce.h
//  vlifree
//
//  Created by 仙林 on 15/6/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityReduce : NSObject

- (id)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic, strong)NSNumber * activeType;
@property (nonatomic, strong)NSNumber * jMoney;
@property (nonatomic, strong)NSNumber * mMoney;
@property (nonatomic, strong)NSNumber * sMoney;


@end
