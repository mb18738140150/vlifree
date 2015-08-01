//
//  GSOrderPayViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSOrderPayViewController : UIViewController

/**
 *  酒店id
 */
@property (nonatomic, strong)NSNumber * hotelId;
/**
 *  房间名
 */
@property (nonatomic, copy)NSString * roomName;
/**
 *  房间单价
 */
@property (nonatomic, strong)NSNumber * price;
/**
 *  房间id
 */
@property (nonatomic, strong)NSNumber * roomId;
/**
 *  当支付成功(或失败)的时候,调用这方法, 跳转到订单页面
 */
- (void)pushOrderDetailsVC;

@end
