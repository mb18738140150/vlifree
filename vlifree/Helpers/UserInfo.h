//
//  UserInfo.h
//  vlifree
//
//  Created by 仙林 on 15/6/12.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const CollectCountCHange;
@interface UserInfo : NSObject
/**
 *  用户名
 */
@property (nonatomic, copy)NSString * name;
/**
 *  密码MD5值
 */
@property (nonatomic, copy)NSString * password;
/**
 *  手机号
 */
@property (nonatomic, strong)NSNumber * phoneNumber;
/**
 *  酒店订单数
 */
@property (nonatomic, strong)NSNumber * hotelOrderCount;
/**
 *  外卖订单数
 */
@property (nonatomic, strong)NSNumber * wakeoutOrderCount;
/**
 *  我的收藏个数
 */
@property (nonatomic, strong)NSNumber * collectCount;
/**
 *  用户id
 */
@property (nonatomic, strong)NSNumber * userId;
/**
 *  服务电话
 */
@property (nonatomic, copy)NSString * servicePhone;
/**
 *  用户单例创建方法
 *
 *  @return 用户单例对象
 */
+ (UserInfo *)shareUserInfo;
/**
 *  设置用户信息方法
 *
 *  @param dic 用户信息字典
 */
- (void)setPropertyWithDictionary:(NSDictionary *)dic;



@end
