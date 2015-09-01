//
//  RoomModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomModel : NSObject
/**
 *  房间图片
 */
@property (nonatomic, copy)NSString * icon;
/**
 *  是否推荐类型 1.推荐 2.不推荐
 */
@property (nonatomic, strong)NSNumber * recommendedType;
/**
 *  房间价格
 */
@property (nonatomic, strong)NSNumber * suitePrice;
/**
 *  房间名
 */
@property (nonatomic, copy)NSString * suiteName;
/**
 *  房间id
 */
@property (nonatomic, strong)NSNumber * suiteId;
/**
 *  房间库存
 */
@property (nonatomic, strong)NSNumber * stock;
/**
 *  房间说明
 */
@property (nonatomic, copy)NSString * intro;
/**
 *  房间图片列表
 */
@property (nonatomic, strong)NSArray * photos;

/**
 *  房间模型初始化方法
 *
 *  @param dic 房间信息字典
 *
 *  @return 房间模型对象
 */
- (id)initWithDictionary:(NSDictionary *)dic;


@end
