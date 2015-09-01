//
//  FacilityViewController.h
//  vlifree
//
//  Created by 仙林 on 15/7/4.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  设备详情页面
 */
@interface FacilityViewController : UIViewController

/**
 *  设备字典
 */
@property (nonatomic, strong)NSDictionary * detailsDic;
/**
 *  商家描述
 */
@property (nonatomic, copy)NSString * describe;


@end
