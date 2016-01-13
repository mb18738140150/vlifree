//
//  StoreIntroView.m
//  vlifree
//
//  Created by 仙林 on 15/8/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "StoreIntroView.h"


#define LEFT_SPACE 10
#define TOP_SPACE 2
//#define LABEL_HEIGHT ([UIScreen mainScreen].bounds.size.height / 15)
#define LABEL_HEIGHT 40
#define RIGHT_LB_WIDTH 75


#define LABEL_FONT [UIFont systemFontOfSize:15]
#define COLOT_TEXT [UIColor colorWithWhite:0.5 alpha:1]

@interface StoreIntroView ()


//@property (nonatomic, strong)UILabel * introLB;
//@property (nonatomic, strong)UILabel * typeLB;
//@property (nonatomic, strong)UILabel * openTimeLB;
//@property (nonatomic, strong)UILabel * addressLB;
//@property (nonatomic, strong)UILabel * telNumLB;
//@property (nonatomic, strong)UILabel * sendPriceLB;
//@property (nonatomic, strong)UILabel * outSendLB;
//@property (nonatomic, strong)UILabel * distanceLB;
//
//


@end



@implementation StoreIntroView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:scroll];
    
    UILabel * introTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, RIGHT_LB_WIDTH , LABEL_HEIGHT)];
    introTitleLB.text = @"餐厅简介";
    [scroll addSubview:introTitleLB];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, introTitleLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line1.backgroundColor = LINE_COLOR;
    [scroll addSubview:line1];
    
    self.Describe = [[UILabel alloc] initWithFrame:CGRectMake(introTitleLB.left, line1.bottom + TOP_SPACE, self.width - 2 * introTitleLB.left, LABEL_HEIGHT)];
    //    _introLB.text = @"百年老店, 值得信赖";
    _Describe.textColor = COLOT_TEXT;
    _Describe.font = LABEL_FONT;
    _Describe.numberOfLines = 0;
    [scroll addSubview:_Describe];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _Describe.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line2.backgroundColor = LINE_COLOR;
    [scroll addSubview:line2];
    
    UILabel * storeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line2.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeLB.text = @"店铺信息";
    [scroll addSubview:storeLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, storeLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = LINE_COLOR;
    [scroll addSubview:line3];
    
    UILabel * storeTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line3.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeTypeLB.text = @"店铺类型:";
    storeTypeLB.textColor = COLOT_TEXT;
    storeTypeLB.font = LABEL_FONT;
    [scroll addSubview:storeTypeLB];
    
    self.StoreType = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeTypeLB.right, storeTypeLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _typeLB.text = @"中式餐厅";
    _StoreType.textColor = COLOT_TEXT;
    _StoreType.font = LABEL_FONT;
    [scroll addSubview:_StoreType];
    
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _StoreType.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line4.backgroundColor = LINE_COLOR;
    [scroll addSubview:line4];
    
    
    UILabel * storeTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line4.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeTimeLB.text = @"营业时间:";
    storeTimeLB.textColor = COLOT_TEXT;
    storeTimeLB.font = LABEL_FONT;
    [scroll addSubview:storeTimeLB];
    
    self.BusTime = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeTimeLB.right, storeTimeLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _openTimeLB.text = @"10:00-20:00";
    _BusTime.textColor = COLOT_TEXT;
    _BusTime.font = LABEL_FONT;
    [scroll addSubview:_BusTime];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _BusTime.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line5.backgroundColor = LINE_COLOR;
    [scroll addSubview:line5];
    
    
    UILabel * storeAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line5.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeAddressLB.text = @"店铺地址:";
    storeAddressLB.textColor = COLOT_TEXT;
    storeAddressLB.font = LABEL_FONT;
    [scroll addSubview:storeAddressLB];
    
    self.StoreAdress = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeAddressLB.right, storeAddressLB.top, self.width - 6 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _addressLB.text = @"未来路丹尼斯下";
    _StoreAdress.numberOfLines = 0;
    _StoreAdress.textColor = COLOT_TEXT;
    _StoreAdress.font = LABEL_FONT;
    [scroll addSubview:_StoreAdress];
    
    self.addressBT = [UIButton buttonWithType:UIButtonTypeSystem];
    [_addressBT setImage:[UIImage imageNamed:@"addressIcon"] forState:UIControlStateNormal];
    _addressBT.frame = CGRectMake(_StoreAdress.right, _StoreAdress.top, 3 * LEFT_SPACE, 3 * LEFT_SPACE);
    [scroll addSubview:_addressBT];
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _StoreAdress.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line6.backgroundColor = LINE_COLOR;
    [scroll addSubview:line6];
    
    UILabel * storeTelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line6.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeTelLB.text = @"电话:";
    storeTelLB.textColor = COLOT_TEXT;
    storeTelLB.font = LABEL_FONT;
    [scroll addSubview:storeTelLB];
    
    self.StoreTel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeTelLB.right, storeTelLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _telNumLB.text = @"13788052976";
    _StoreTel.font = LABEL_FONT;
    _StoreTel.textColor = COLOT_TEXT;
    [scroll addSubview:_StoreTel];
    
    UIView * line7 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _StoreTel.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line7.backgroundColor = LINE_COLOR;
    [scroll addSubview:line7];
    
    
    UILabel * storeSendLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line7.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeSendLB.text = @"起送价:";
    storeSendLB.textColor = COLOT_TEXT;
    storeSendLB.font = LABEL_FONT;
    [scroll addSubview:storeSendLB];
    
    self.StartSendMoney = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeSendLB.right, storeSendLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _sendPriceLB.text = @"¥12";
    _StartSendMoney.font = LABEL_FONT;
    _StartSendMoney.textColor = COLOT_TEXT;
    [scroll addSubview:_StartSendMoney];
    
    UIView * line8 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _StartSendMoney.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line8.backgroundColor = LINE_COLOR;
    [scroll addSubview:line8];
    
    
    
    UILabel * storeOutLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line8.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeOutLB.text = @"外送费:";
    storeOutLB.textColor = COLOT_TEXT;
    storeOutLB.font = LABEL_FONT;
    [scroll addSubview:storeOutLB];
    
    self.Delivery = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeOutLB.right, storeOutLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _outSendLB.text = @"¥2";
    _Delivery.textColor = COLOT_TEXT;
    _Delivery.font = LABEL_FONT;
    [scroll addSubview:_Delivery];
    
    UIView * line9 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _Delivery.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line9.backgroundColor = LINE_COLOR;
    [scroll addSubview:line9];
    
    
    
    UILabel * storeDistanceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line9.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeDistanceLB.text = @"服务距离:";
    storeDistanceLB.textColor = COLOT_TEXT;
    storeDistanceLB.font = LABEL_FONT;
    [scroll addSubview:storeDistanceLB];
    
    self.ServiceDis = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeDistanceLB.right, storeDistanceLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _distanceLB.text = @"3公里";
    _ServiceDis.font = LABEL_FONT;
    _ServiceDis.textColor = COLOT_TEXT;
    [scroll addSubview:_ServiceDis];
    
    UIView * line10 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _ServiceDis.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line10.backgroundColor = LINE_COLOR;
    [scroll addSubview:line10];
    
    UILabel * deliverdis = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line10.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    deliverdis.text = @"配送区域:";
    deliverdis.textColor = COLOT_TEXT;
    deliverdis.font = LABEL_FONT;
    [scroll addSubview:deliverdis];
    
    self.DeliveryDis = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + deliverdis.right, deliverdis.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    //    _DeliveryDis.text = @"3公里";
    _DeliveryDis.font = LABEL_FONT;
    _DeliveryDis.textColor = COLOT_TEXT;
    [scroll addSubview:_DeliveryDis];
    
    
    UIView * line11 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _DeliveryDis.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line11.backgroundColor = LINE_COLOR;
    [scroll addSubview:line11];
    
    scroll.contentSize = CGSizeMake(self.width, line11.bottom + TOP_SPACE);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
