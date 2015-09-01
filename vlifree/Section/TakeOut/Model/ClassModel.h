//
//  ClassModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
/**
 *  分类id
 */
@property (nonatomic, strong)NSNumber * Id;
/**
 *  分类名
 */
@property (nonatomic, copy)NSString * title;
/**
 *  初始化方法
 *
 *  @param dic 菜品分类信息字典
 *
 *  @return 菜品分类Model
 */
- (id)initWithDictionary:(NSDictionary *)dic;

@end
