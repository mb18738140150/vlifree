//
//  NSString+NSString_MD5.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/14.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "NSString+NSString_MD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (NSString_MD5)


- (NSString *)md5
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

#pragma mark - 手机号码验证
+ (BOOL)isTelPhoneNub:(NSString *)str
{
    if (str.length < 11)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        return NO;
    }
    else
    {
        NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:str];
        if (!isMatch) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

@end
