//
//  AddressModel.h
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/**
 *  地址
 */
@property (nonatomic, copy)NSString * address;
/**
 *  电话号码
 */
@property (nonatomic, copy)NSString * phoneNumber;
/**
 *  地址id
 */
@property (nonatomic, strong)NSNumber * addressId;
/**
 *  是否默认地址
 */
@property (nonatomic, strong)NSNumber * isDefault;
/**
 *  是否选中
 */
@property (nonatomic, assign)BOOL selete;
/**
 *  初始化方法
 *
 *  @param dic 地址信息字典
 *
 *  @return 地址Model
 */
- (id)initWithDictionary:(NSDictionary *)dic;


@end
