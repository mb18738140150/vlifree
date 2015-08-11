//
//  UCSCallService.h
//  yzxapisdk
//
//  Created by tongkucky on 14-4-2.
//  Copyright (c) 2014年 yzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSVerifyEvent.h"

@interface UCSVerifyService : NSObject

/**
 * 初始化实例及代理设置
 */
- (UCSVerifyService *)initWithDelegate:(id<UCSVerifyEventDelegate>)delegate;

/*
 * 获取云验证码
 * @param sid  String 开发者主账号
 * @param appid  String 开发者应用id
 * @param appName  String 开发者针对该应用的定义
 * @param codetype  int 验证码下发方式 1:短信 2:语音
 * @param phone  String 用户手机号
 * @param minutes int 验证码有效时间（秒）
 * @param business 业务类型 1: 注册，2：绑定手机
 */
-(void)getVerificationCode:(NSString *)sid withAppid:(NSString *)appid withAppName:(NSString *)appName withCodetype:(int)codetype withPhone:(NSString *)phone withSeconds:(int)seconds withBusiness:(int)business withSign:(NSString *)sign;


/**
 * 验证码验证
 * @param sid  String 开发者主账号
 * @param appid  String 开发者应用id
 * @param phone  String 用户手机号
 * @param verifycode  String 验证码
 */
-(void)doVerificationCode:(NSString *)sid withAppid:(NSString *)appid withPhone:(NSString *)phone withVerifycode:(NSString *)verifycode;

@end
