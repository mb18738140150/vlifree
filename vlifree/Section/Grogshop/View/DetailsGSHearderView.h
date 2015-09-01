//
//  DetailsGSHearderView.h
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DescribeView;
@interface DetailsGSHearderView : UIView


//@property (nonatomic, copy)NSString * address;
//@property (nonatomic, copy)NSString * phone;
/**
 *  酒店轮播图图片数组
 */
@property (nonatomic, copy)NSArray *  iconUrlStingAry;
/**
 *  酒店地址
 */
@property (nonatomic, strong)DescribeView * addressView;
/**
 *  手机号码
 */
@property (nonatomic, strong)DescribeView * phoneView;
/**
 *  设备详情查看按钮
 */
@property (nonatomic, strong)UIButton * detailsBT;

//@property (nonatomic, strong)UIImageView * hotelImage;
/**
 *  WiFi
 */
@property (nonatomic, strong)UIImageView * wifiView;
/**
 *  停车场
 */
@property (nonatomic, strong)UIImageView * parkView;
/**
 *  餐厅
 */
@property (nonatomic, strong)UIImageView * foodView;

@end
