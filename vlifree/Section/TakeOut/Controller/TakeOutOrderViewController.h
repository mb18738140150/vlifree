//
//  TakeOutOrderViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeOutOrderViewController : UIViewController
/**
 *  商店名
 */
@property (nonatomic, copy)NSString * storeName;
/**
 *  订单信息字典
 */
@property (nonatomic, copy)NSDictionary * orderDic;
/**
 *  购物车数组
 */
@property (nonatomic, strong)NSMutableArray * shopArray;
/**
 *  商店id
 */
@property (nonatomic, strong)NSNumber * takeOutId;
/**
 *  餐盒费
 */
@property (nonatomic, strong)NSNumber * mealBoxMoney;

/**
 *  支付成功或者失败调起的方法
 */
- (void)pushFinishOrderVC;

@end
