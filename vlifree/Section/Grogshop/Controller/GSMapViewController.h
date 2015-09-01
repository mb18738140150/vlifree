//
//  GSMapViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMapViewController : UIViewController
/**
 *  酒店名
 */
@property (nonatomic, copy)NSString * gsName;
/**
 *  酒店地址
 */
@property (nonatomic, copy)NSString * address;
/**
 *  酒店纬度
 */
@property (nonatomic, copy)NSString * lat;
/**
 *  酒店经度
 */
@property (nonatomic, copy)NSString * lon;

@end
