//
//  OrderMenuMD.h
//  vlifree
//
//  Created by 仙林 on 15/6/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderMenuMD : NSObject


@property (nonatomic, strong)NSNumber * count;
@property (nonatomic, strong)NSNumber * money;
@property (nonatomic, strong)NSNumber * foodId;
@property (nonatomic, copy)NSString * name;


- (id)initWithDictionary:(NSDictionary *)dic;

@end
