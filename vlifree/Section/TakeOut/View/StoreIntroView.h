//
//  StoreIntroView.h
//  vlifree
//
//  Created by 仙林 on 15/8/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreIntroHelpView.h"

@interface StoreIntroView : UIScrollView

@property (nonatomic, copy)NSString * describeImage;// 店铺图片
//@property (nonatomic, strong)UILabel *Describe; //店铺描述
//@property (nonatomic, strong)UILabel *StoreType;//店铺类型
//@property (nonatomic, strong)UILabel *BusTime;//营业时间
//@property (nonatomic, strong)UILabel *StoreAdress;//店铺地址
//@property (nonatomic, strong)UILabel *StoreTel;//店铺电话
//@property (nonatomic, strong)UILabel *StartSendMoney;//起送价
//@property (nonatomic, strong)UILabel *Delivery;//配送费
//@property (nonatomic, strong)UILabel *ServiceDis;//服务距离
//@property (nonatomic, strong)UILabel *DeliveryDis;// 配送区域
//@property (nonatomic, strong)UIButton *addressBT;// 查看地址按钮
@property (nonatomic, strong)StoreIntroHelpView * storeAddress;//地址
- (void)creatSoreWithDic:(NSDictionary *)dic;

@end
