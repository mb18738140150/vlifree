//
//  OnlinePayViewController.h
//  vlifree
//
//  Created by 仙林 on 15/10/16.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayTypeView.h"

@interface OnlinePayViewController : UIViewController

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
// 支付钱
@property (nonatomic, assign)double totalMoney;
// 未减免前总价格
@property (nonatomic, assign)double allMoney;

@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * phone;
@property (nonatomic, copy)NSString * remarks;
@property (nonatomic, copy)NSString * orderID;

@property (nonatomic, strong)NSMutableDictionary * jsondic;

- (void)pushFinishOrderVC;

@end
