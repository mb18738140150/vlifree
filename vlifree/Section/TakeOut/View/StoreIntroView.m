//
//  StoreIntroView.m
//  vlifree
//
//  Created by 仙林 on 15/8/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "StoreIntroView.h"


#define LEFT_SPACE 10
#define TOP_SPACE 10
#define LABEL_HEIGHT 20
#define RIGHT_LB_WIDTH 75


#define LABEL_FONT [UIFont systemFontOfSize:15]
#define COLOT_TEXT [UIColor colorWithWhite:0.5 alpha:1]

@interface StoreIntroView ()


@property (nonatomic, strong)UILabel * introLB;
@property (nonatomic, strong)UILabel * typeLB;
@property (nonatomic, strong)UILabel * openTimeLB;
@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * telNumLB;
@property (nonatomic, strong)UILabel * sendPriceLB;
@property (nonatomic, strong)UILabel * outSendLB;
@property (nonatomic, strong)UILabel * distanceLB;




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
    UILabel * introTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    introTitleLB.text = @"餐厅简介";
    [self addSubview:introTitleLB];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, introTitleLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line1.backgroundColor = LINE_COLOR;
    [self addSubview:line1];
    
    self.introLB = [[UILabel alloc] initWithFrame:CGRectMake(introTitleLB.left, line1.bottom + TOP_SPACE, self.width - 2 * introTitleLB.left, LABEL_HEIGHT)];
    _introLB.text = @"百年老店, 值得信赖";
    _introLB.textColor = COLOT_TEXT;
    _introLB.font = LABEL_FONT;
    [self addSubview:_introLB];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _introLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line2.backgroundColor = LINE_COLOR;
    [self addSubview:line2];
    
    UILabel * storeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line2.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeLB.text = @"店铺信息";
    [self addSubview:storeLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, storeLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = LINE_COLOR;
    [self addSubview:line3];
    
    UILabel * storeTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line3.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeTypeLB.text = @"店铺类型:";
    storeTypeLB.textColor = COLOT_TEXT;
    storeTypeLB.font = LABEL_FONT;
    [self addSubview:storeTypeLB];
    
    self.typeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeTypeLB.right, storeTypeLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _typeLB.text = @"中式餐厅";
    _typeLB.textColor = COLOT_TEXT;
    _typeLB.font = LABEL_FONT;
    [self addSubview:_typeLB];
    
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _typeLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line4.backgroundColor = LINE_COLOR;
    [self addSubview:line4];
    
    
    UILabel * storeTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line4.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeTimeLB.text = @"营业时间:";
    storeTimeLB.textColor = COLOT_TEXT;
    storeTimeLB.font = LABEL_FONT;
    [self addSubview:storeTimeLB];
    
    self.openTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeTimeLB.right, storeTimeLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _openTimeLB.text = @"10:00-20:00";
    _openTimeLB.textColor = COLOT_TEXT;
    _openTimeLB.font = LABEL_FONT;
    [self addSubview:_openTimeLB];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _openTimeLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line5.backgroundColor = LINE_COLOR;
    [self addSubview:line5];
    
    
    UILabel * storeAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line5.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeAddressLB.text = @"店铺地址:";
    storeAddressLB.textColor = COLOT_TEXT;
    storeAddressLB.font = LABEL_FONT;
    [self addSubview:storeAddressLB];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeAddressLB.right, storeAddressLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _addressLB.text = @"未来路丹尼斯下";
    _addressLB.textColor = COLOT_TEXT;
    _addressLB.font = LABEL_FONT;
    [self addSubview:_addressLB];
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _addressLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line6.backgroundColor = LINE_COLOR;
    [self addSubview:line6];
    
    UILabel * storeTelLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line6.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeTelLB.text = @"电话:";
    storeTelLB.textColor = COLOT_TEXT;
    storeTelLB.font = LABEL_FONT;
    [self addSubview:storeTelLB];
    
    self.telNumLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeTelLB.right, storeTelLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _telNumLB.text = @"13788052976";
    _telNumLB.font = LABEL_FONT;
    _telNumLB.textColor = COLOT_TEXT;
    [self addSubview:_telNumLB];
    
    UIView * line7 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _telNumLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line7.backgroundColor = LINE_COLOR;
    [self addSubview:line7];
    
    
    UILabel * storeSendLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line7.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeSendLB.text = @"起送价:";
    storeSendLB.textColor = COLOT_TEXT;
    storeSendLB.font = LABEL_FONT;
    [self addSubview:storeSendLB];
    
    self.sendPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeSendLB.right, storeSendLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _sendPriceLB.text = @"¥12";
    _sendPriceLB.font = LABEL_FONT;
    _sendPriceLB.textColor = COLOT_TEXT;
    [self addSubview:_sendPriceLB];
    
    UIView * line8 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _sendPriceLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line8.backgroundColor = LINE_COLOR;
    [self addSubview:line8];
    
    
    
    UILabel * storeOutLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line8.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeOutLB.text = @"外送费:";
    storeOutLB.textColor = COLOT_TEXT;
    storeOutLB.font = LABEL_FONT;
    [self addSubview:storeOutLB];
    
    self.outSendLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeOutLB.right, storeOutLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _outSendLB.text = @"¥2";
    _outSendLB.textColor = COLOT_TEXT;
    _outSendLB.font = LABEL_FONT;
    [self addSubview:_outSendLB];
    
    UIView * line9 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _outSendLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line9.backgroundColor = LINE_COLOR;
    [self addSubview:line9];
    
    
    
    UILabel * storeDistanceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line9.bottom, RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    storeDistanceLB.text = @"服务距离:";
    storeDistanceLB.textColor = COLOT_TEXT;
    storeDistanceLB.font = LABEL_FONT;
    [self addSubview:storeDistanceLB];
    
    self.distanceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + storeDistanceLB.right, storeDistanceLB.top, self.width - 3 * LEFT_SPACE - RIGHT_LB_WIDTH, LABEL_HEIGHT)];
    _distanceLB.text = @"3公里";
    _distanceLB.font = LABEL_FONT;
    _distanceLB.textColor = COLOT_TEXT;
    [self addSubview:_distanceLB];
    
    UIView * line10 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _distanceLB.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, 1)];
    line10.backgroundColor = LINE_COLOR;
    [self addSubview:line10];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
