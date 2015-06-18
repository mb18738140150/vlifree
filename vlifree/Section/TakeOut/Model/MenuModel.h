//
//  MenuModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, assign)NSInteger count;
@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * Id;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, strong)NSNumber * price;
@property (nonatomic, strong)NSNumber * soldCount;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
