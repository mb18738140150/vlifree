//
//  DetailTakeOutViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTakeOutViewController : UIViewController

/**
 *  商店名
 */
@property (nonatomic, copy)NSString * storeName;
/**
 *  商店id
 */
@property (nonatomic, strong)NSNumber * takeOutID;
/**
 *  起送价
 */
@property (nonatomic, strong)NSNumber * sendPrice;
/**
 *  外送费
 */
@property (nonatomic, strong)NSNumber * outSentMoney;
/**
 *  商店营业状态
 */
@property (nonatomic, strong)NSNumber * storeState;
/**
 *  微信登录获取授权码的方法
 *
 *  @param code 授权码
 */
- (void)getAccessToken:(NSString *)code;


@end
