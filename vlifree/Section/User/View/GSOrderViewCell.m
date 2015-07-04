//
//  GSOrderViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSOrderViewCell.h"


@interface GSOrderViewCell ()

@property (nonatomic, strong)UILabel * gsNameLB;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * dateLB;

@end


@implementation GSOrderViewCell


- (void)createSubview:(CGRect)frame
{
    if (!_gsNameLB) {
        
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        self.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:250];
        self.gsNameLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 80, 25)];
//        _gsNameLB.font = [UIFont systemFontOfSize:20];
        _gsNameLB.text = @"如家快捷酒店";
        _gsNameLB.textColor = TEXT_COLOR;
        [self.contentView addSubview:_gsNameLB];
        
        NSString * priceStr = @"¥299";
        NSString * roomStr = @"房型:总统套房130平米";
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@", priceStr, roomStr]];
        [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, priceStr.length)];
        [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, priceStr.length)];
        
        self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(10, _gsNameLB.bottom, frame.size.width - 80, 20)];
        _priceLB.attributedText = [string copy];
        _priceLB.textColor = TEXT_COLOR;
        [self.contentView addSubview:_priceLB];
        
        self.dateLB = [[UILabel alloc] initWithFrame:CGRectMake(10, _priceLB.bottom, frame.size.width - 80, 20)];
        _dateLB.font = [UIFont systemFontOfSize:13];
        _dateLB.text = @"入住:05月21日 离店:05月23日 共2天";
        _dateLB.textColor = TEXT_COLOR;
        [self.contentView addSubview:_dateLB];
        
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame = CGRectMake(frame.size.width - 70, 10, 60, 25);
        _payButton.centerY = _priceLB.centerY;
        [_payButton setTitle:@"马上支付" forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _payButton.backgroundColor = MAIN_COLOR;
        _payButton.layer.cornerRadius = 3;
        _payButton.enabled = NO;
        [self.contentView addSubview:_payButton];
        
    }
}


- (void)setGrogshopOrderMD:(GrogshopOrderMD *)grogshopOrderMD
{
    _grogshopOrderMD = grogshopOrderMD;
    self.gsNameLB.text = grogshopOrderMD.name;
    NSString * priceStr = [NSString stringWithFormat:@"¥%@", grogshopOrderMD.money];
    NSString * roomStr = [NSString stringWithFormat:@"房型:%@", grogshopOrderMD.roomType];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@", priceStr, roomStr]];
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, priceStr.length)];
    [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, priceStr.length)];
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(priceStr.length, string.length - priceStr.length)];
    [string addAttributes:@{NSForegroundColorAttributeName : TEXT_COLOR} range:NSMakeRange(priceStr.length, string.length - priceStr.length)];
    self.priceLB.attributedText = [string copy];
    NSString * ruzhuDate = [grogshopOrderMD.checkinTime substringToIndex:9];
    NSString * lidianDate = [grogshopOrderMD.leaveTime substringToIndex:9];
    self.dateLB.text = [NSString stringWithFormat:@"入住:%@  离店:%@", ruzhuDate, lidianDate];
    if ([grogshopOrderMD.payState isEqualToNumber:@1]) {
        [self.payButton setTitle:@"完成支付" forState:UIControlStateDisabled];
        self.payButton.enabled = NO;
        _payButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    }else
    {
        [self.payButton setTitle:@"马上支付" forState:UIControlStateDisabled];
        _payButton.backgroundColor = MAIN_COLOR;
        self.payButton.enabled = YES;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
