//
//  FinishOrderViewController.h
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishOrderViewController : UIViewController

/**
 *  订单号
 */
@property (nonatomic, copy)NSString * orderID;
/**
 *  数据请求
 */
- (void)downloadData;

@end
