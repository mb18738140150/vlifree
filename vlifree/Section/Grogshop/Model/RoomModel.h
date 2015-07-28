//
//  RoomModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomModel : NSObject

@property (nonatomic, copy)NSString * icon;
@property (nonatomic, strong)NSNumber * recommendedType;
@property (nonatomic, strong)NSNumber * suitePrice;
@property (nonatomic, copy)NSString * suiteName;
@property (nonatomic, strong)NSNumber * suiteId;
@property (nonatomic, strong)NSNumber * stock;
@property (nonatomic, copy)NSString * intro;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
