//
//  DetailsGrogshopViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsGrogshopViewController : UIViewController
/**
 *  酒店id
 */
@property (nonatomic, strong)NSNumber * hotelID;
/**
 *  酒店名字
 */
@property (nonatomic, copy)NSString * hotelName;
/**
 *  酒店维度
 */
@property (nonatomic, copy)NSString * lat;
/**
 *  酒店经度
 */
@property (nonatomic, copy)NSString * lon;
/**
 *  酒店首页图片
 */
@property (nonatomic, copy)NSString * icon;

/**
 *  微信登陆调用
 *
 *  @param code 当没有登陆的时候, 在这也没登陆, 在APPdelete获取了微信code后调用这个方法登陆.
 */
- (void)getAccessToken:(NSString *)code;

@end
