//
//  GSOrderViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSOrderViewCell.h"

#define LEFT_SPACE 15
#define TOP_SPACE 10
#define IMAGE_SIZE 50
#define BUTTON_WIDTH 80
#define BUTTON_HEIGHT 45
#define LABEL_HEIGHT 15
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
@interface GSOrderViewCell ()

@property (nonatomic, strong)UILabel * payStateLabel;
@property (nonatomic, strong)UILabel * dateLabel;
@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * gsNameLB;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * dateLB;
@property (nonatomic, strong)UILabel *leavelabel;
@property (nonatomic, strong)UIView * lineView3;
@property (nonatomic, strong)UIButton * cancleBT;

@property (nonatomic, copy) PushBlock pushBlock;
@property (nonatomic, copy) CancleOrderBlock cancleBlock;

@end


@implementation GSOrderViewCell


- (void)createSubview:(CGRect)frame
{
    if (!_gsNameLB) {
        
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 145)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.tag = 10000;
        [self.contentView addSubview:backView];
        
        self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + 8, 60, LABEL_HEIGHT - 3)];
        self.payStateLabel.font = [UIFont systemFontOfSize:12];
        _payStateLabel.textColor = TEXT_COLOR;
        [backView addSubview:_payStateLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_payStateLabel.right, TOP_SPACE + 8, frame.size.width - 60 - 2 * LEFT_SPACE, LABEL_HEIGHT - 3)];
        _dateLabel.text = @"05月13日 14:34";
        _dateLabel.textColor = UIColorFromRGBA(0x999999, 1);
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [backView addSubview:_dateLabel];
        
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _payStateLabel.bottom + TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.layer.cornerRadius = 10;
        _iconView.backgroundColor = [UIColor cyanColor];
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"home_takeOut.png"];
        [backView addSubview:_iconView];
        
        self.gsNameLB = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 5, _iconView.top , frame.size.width - 80, LABEL_HEIGHT)];
        _gsNameLB.font = [UIFont systemFontOfSize:15];
        _gsNameLB.text = @"如家快捷酒店";
        _gsNameLB.textColor = TEXT_COLOR;
        [backView addSubview:_gsNameLB];
        
        self.dateLB = [[UILabel alloc] initWithFrame:CGRectMake(_gsNameLB.left, _gsNameLB.bottom + 7, 200, LABEL_HEIGHT - 3)];
        _dateLB.font = [UIFont systemFontOfSize:12];
        _dateLB.numberOfLines = 0;
        _dateLB.text = @"入住:05月21日 离店:05月23日 共2天";
        _dateLB.textColor = UIColorFromRGBA(0x999999, 1);
        [backView addSubview:_dateLB];
        
        self.leavelabel = [[UILabel alloc] initWithFrame:CGRectMake(_gsNameLB.left, _dateLB.bottom + 4, 200, LABEL_HEIGHT - 3)];
        _leavelabel.font = [UIFont systemFontOfSize:12];
        _leavelabel.numberOfLines = 0;
        _leavelabel.text = @"入住:05月21日 离店:05月23日 共2天";
        _leavelabel.textColor = UIColorFromRGBA(0x999999, 1);
        [backView addSubview:_leavelabel];
        
        
        NSString * priceStr = @"¥299";
        NSString * roomStr = @"房型:总统套房130平米";
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@", priceStr, roomStr]];
        [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, priceStr.length)];
        [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, priceStr.length)];
        
        self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 100, _leavelabel.bottom - 15, 80, 20)];
//        _priceLB.attributedText = [string copy];
        _priceLB.font = [UIFont systemFontOfSize:15];
        _priceLB.textAlignment = NSTextAlignmentRight;
        _priceLB.textColor = TEXT_COLOR;
        [backView addSubview:_priceLB];
        
        self.lineView3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _iconView.bottom + TOP_SPACE, backView.width - LEFT_SPACE, 1)];
        _lineView3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        [backView addSubview:_lineView3];
        
        self.cancleBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBT.frame = CGRectMake(frame.size.width - 2 * BUTTON_WIDTH, _lineView3.top, BUTTON_WIDTH, BUTTON_HEIGHT);
        [_cancleBT setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancleBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleBT.backgroundColor = UIColorFromRGBA(0xEBEBEB, 1);
        _cancleBT.titleLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:_cancleBT];
        [_cancleBT addTarget:self action:@selector(cancleBTAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _payButton.frame = CGRectMake(frame.size.width - 70, 10, 60, 25);
//        _payButton.centerY = _priceLB.centerY;
//        [_payButton setTitle:@"马上支付" forState:UIControlStateNormal];
//        _payButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        _payButton.backgroundColor = MAIN_COLOR;
//        _payButton.layer.cornerRadius = 3;
//        _payButton.enabled = NO;
//        [self.contentView addSubview:_payButton];
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame = CGRectMake(frame.size.width - BUTTON_WIDTH, _lineView3.top, BUTTON_WIDTH, BUTTON_HEIGHT);
        [_payButton setTitle:@"马上支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.backgroundColor = UIColorFromRGBA(0xE9471B, 1);
        _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:_payButton];
        [self.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
- (void)payAction:(UIButton *)button
{
    _pushBlock();
   
}

- (void)setBlock:(PushBlock)block
{
    self.pushBlock = [block copy];
}

- (void)cancleBTAction:(UIButton *)button
{
    _cancleBlock();
}
- (void)cancleOrderAction:(CancleOrderBlock)cancleBlock
{
    _cancleBlock = [cancleBlock copy];
}

- (void)setGrogshopOrderMD:(GrogshopOrderMD *)grogshopOrderMD
{
    _grogshopOrderMD = grogshopOrderMD;
    self.gsNameLB.text = grogshopOrderMD.name;
//    NSString * priceStr = [NSString stringWithFormat:@"¥%@", grogshopOrderMD.money];
//    NSString * roomStr = [NSString stringWithFormat:@"房型:%@", grogshopOrderMD.roomType];
//    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@", priceStr, roomStr]];
//    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, priceStr.length)];
//    [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, priceStr.length)];
//    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(priceStr.length, string.length - priceStr.length)];
//    [string addAttributes:@{NSForegroundColorAttributeName : TEXT_COLOR} range:NSMakeRange(priceStr.length, string.length - priceStr.length)];
//    self.priceLB.attributedText = [string copy];
    
    self.priceLB.text = [NSString stringWithFormat:@"¥%@", grogshopOrderMD.money];
    CGSize pricesize = [self.priceLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.priceLB.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.priceLB.frame = CGRectMake(self.width - pricesize.width - LEFT_SPACE, _leavelabel.bottom - 15, pricesize.width, 20);
    
//    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
//    fomatter.dateFormat = @"yyyy/MM/dd H:mm:ss";
//    NSDateFormatter * fomatter1 = [[NSDateFormatter alloc]init];
//    fomatter1.dateFormat = @"yyyy/MM/dd";
//    NSDate * rezhuDate = [fomatter dateFromString:grogshopOrderMD.checkinTime];
//    NSString * ruzhuStr = [fomatter1 stringFromDate:rezhuDate];
//    if ([grogshopOrderMD.checkinTime containsString:@" "]) {
//        NSArray * ruzhuArr = [grogshopOrderMD.checkinTime componentsSeparatedByString:@" "];
//        self.dateLB.text = [NSString stringWithFormat:@"入住:%@", ruzhuArr[0]];
//    }else
//    {
//        self.dateLB.text = grogshopOrderMD.checkinTime;
//    }
    
    NSDateFormatter * matter = [[NSDateFormatter alloc] init];
    //    [matter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    matter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate * checkdate = [matter dateFromString:grogshopOrderMD.checkinTime];
    
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd";
    self.dateLB.text = [fomatter stringFromDate:checkdate];
    
    NSDate * leaveDate = [matter dateFromString:grogshopOrderMD.leaveTime];
    self.leavelabel.text = [fomatter stringFromDate:leaveDate];
    
//    NSArray * leaveArr = [grogshopOrderMD.leaveTime componentsSeparatedByString:@" "];
//    self.leavelabel.text = [NSString stringWithFormat:@"离店:%@", leaveArr[0]];
    
    __weak GSOrderViewCell * cell = self;
    [self.iconView setImageWithURL:[NSURL URLWithString:grogshopOrderMD.storeIcon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error != nil) {
            cell.iconView.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    
    if ([grogshopOrderMD.orderState isEqualToNumber:@6]) {
        self.payStateLabel.text = @"退款成功";
        self.lineView3.hidden = YES;
        self.payButton.hidden = YES;
        self.cancleBT.hidden = YES;
        UIView * backView = [self.contentView viewWithTag:10000];
        backView.height = 100;
//        [self.payButton setTitle:@"退款成功" forState:UIControlStateDisabled];
//        self.payButton.enabled = NO;
//        _payButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    }else if ([grogshopOrderMD.orderState isEqualToNumber:@4])
    {
        self.payStateLabel.text = @"已作废";
        self.lineView3.hidden = YES;
        self.payButton.hidden = YES;
        self.cancleBT.hidden = YES;
        UIView * backView = [self.contentView viewWithTag:10000];
        backView.height = 100;
//        [self.payButton setTitle:@"已作废" forState:UIControlStateDisabled];
//        self.payButton.enabled = NO;
//        _payButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    }else
    {
        if ([grogshopOrderMD.payState isEqualToNumber:@1]) {
            self.payStateLabel.text = @"完成支付";
            self.lineView3.hidden = YES;
            self.payButton.hidden = YES;
            self.cancleBT.hidden = YES;
            UIView * backView = [self.contentView viewWithTag:10000];
            backView.height = 100;
//            [self.payButton setTitle:@"完成支付" forState:UIControlStateDisabled];
//            self.payButton.enabled = NO;
//            _payButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        }else
        {
            self.payStateLabel.text = @"未支付";
            self.lineView3.hidden = NO;
            self.payButton.hidden = NO;
            self.cancleBT.hidden = NO;
            UIView * backView = [self.contentView viewWithTag:10000];
            backView.height = 145;
            [self.payButton setTitle:@"马上支付" forState:UIControlStateDisabled];
            _payButton.backgroundColor = MAIN_COLOR;
            self.payButton.enabled = YES;
        }

    }
    self.dateLabel.text = [self estimateTime:grogshopOrderMD.createTime];
    
}

- (NSString *)estimateTime:(NSString *)dateStr
{
    /*
     NSDateFormatter * matter = [[NSDateFormatter alloc] init];
     //    [matter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
     matter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
     NSDate * date = [matter dateFromString:dateStr];
     
     NSCalendar *userCalendar = [NSCalendar currentCalendar];
     unsigned int unitFlags = NSCalendarUnitDay;
     NSDateComponents *components = [userCalendar components:unitFlags fromDate:date toDate:[NSDate date] options:0];
     NSInteger days = [components day];
     NSString * timeStr = nil;
     NSDateFormatter * matter1 = [[NSDateFormatter alloc] init];
     //    [matter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
     matter1.dateFormat = @"HH:mm:ss";
     if (days < 1) {
     timeStr = [NSString stringWithFormat:@"今天 %@", [matter1 stringFromDate:date]];
     }else if (days >  (1) && days < 2)
     {
     timeStr = [NSString stringWithFormat:@"昨天 %@", [matter1 stringFromDate:date]];
     }else
     {
     timeStr = dateStr;
     }
     NSLog(@"%@, %@", date, [NSDate date]);
     return timeStr;
     */
    NSDateFormatter * matter = [[NSDateFormatter alloc] init];
    //    [matter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    matter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate * date = [matter dateFromString:dateStr];
    
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString * dateStr1 = [fomatter stringFromDate:date];
    NSTimeInterval secondsPerDay = 24.0 * 60.0 * 60.0;
    NSDate *today = [NSDate date];
    NSDate *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]) {
        return [NSString stringWithFormat:@"今天 %@", [dateStr1 substringFromIndex:10]];
    }else if ([dateString isEqualToString:yesterdayString])
    {
        return [NSString stringWithFormat:@"昨天 %@", [dateStr1 substringFromIndex:10]];
    }
    return dateStr1;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
