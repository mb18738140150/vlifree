//
//  NSString+NSString_MD5.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_MD5)

/**
 *  MD5加密方法
 *
 *  @return 返回加密后全部小写的MD5值字符串
 */
- (NSString *)md5;
/**
 *  验证是否是正确的手机号
 *
 *  @param str 手机号码
 *
 *  @return 如果是正确手机好返回 YES, 反之 NO;
 */
+ (BOOL)isTelPhoneNub:(NSString *)str;

@end
