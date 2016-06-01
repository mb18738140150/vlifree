//
//  TOOrderViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TOOrderViewCell.h"

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

@interface TOOrderViewCell ()

@property (nonatomic, strong)UILabel * dateLabel;
@property (nonatomic, strong)UILabel * orderStateLB;
@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * mealCountLB;
@property (nonatomic, strong)UIButton * deleteorderBT;
@property (nonatomic, strong)UIButton * againorderBT;

@property (nonatomic, copy)DeleteBlock deleteBlock;
@property (nonatomic, copy)AgainOrderBlock againBlock;

@end


@implementation TOOrderViewCell


- (void)crateSubview:(CGRect)frame
{
    if (!_dateLabel) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.6];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [TOOrderViewCell cellHeight] - 10)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
//        UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 1)];
//        lineView1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
//        [view addSubview:lineView1];
        
        self.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        
        self.orderStateLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + 8, 60, LABEL_HEIGHT - 3)];
        self.orderStateLB.font = [UIFont systemFontOfSize:12];
        _orderStateLB.textColor = TEXT_COLOR;
        [view addSubview:_orderStateLB];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderStateLB.right, TOP_SPACE + 8, frame.size.width - 60 - 2 * LEFT_SPACE, LABEL_HEIGHT - 3)];
        _dateLabel.text = @"05月13日 14:34";
        _dateLabel.textColor = UIColorFromRGBA(0x999999, 1);
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:_dateLabel];
        
        
        
//        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelButton.frame = CGRectMake(frame.size.width - BUTTON_WIDTH - LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, LABEL_HEIGHT);
//        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
//        [_cancelButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
//        [view addSubview:_cancelButton];
        
//        UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _dateLabel.bottom, frame.size.width - 2 * LEFT_SPACE, 1)];
//        lineView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
//        [view addSubview:lineView2];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _orderStateLB.bottom + TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"home_takeOut.png"];
        [view addSubview:_iconView];
        
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = _iconView.frame;
        [self.contentView addSubview:_iconButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 5, _iconView.top, frame.size.width - _iconView.right - 30, LABEL_HEIGHT)];
        _titleLabel.text = @"打牌小当1好套餐";
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + TOP_SPACE * 2, 80, LABEL_HEIGHT)];
        _priceLabel.text = @"¥34";
        _priceLabel.textColor = TEXT_COLOR;
        _priceLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_priceLabel];
        
        self.mealCountLB = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 100 - LEFT_SPACE, _priceLabel.bottom - 12, 100, 12)];
        _mealCountLB.text = @"订单总个数:12";
        _mealCountLB.textAlignment = NSTextAlignmentRight;
        _mealCountLB.textColor = TEXT_COLOR;
        _mealCountLB.font = [UIFont systemFontOfSize:12];
        [view addSubview:_mealCountLB];

        
        UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _iconView.bottom + TOP_SPACE, view.width - LEFT_SPACE, 1)];
        lineView3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        [view addSubview:lineView3];
        
        self.deleteorderBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteorderBT.frame = CGRectMake(frame.size.width - 2 * BUTTON_WIDTH, lineView3.top, BUTTON_WIDTH, BUTTON_HEIGHT);
        [_deleteorderBT setTitle:@"删除订单" forState:UIControlStateNormal];
        [_deleteorderBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _deleteorderBT.backgroundColor = UIColorFromRGBA(0xEBEBEB, 1);
        _deleteorderBT.titleLabel.font = [UIFont systemFontOfSize:15];
//        [view addSubview:_deleteorderBT];
        [_deleteorderBT addTarget:self action:@selector(deleteorderBTAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.againorderBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _againorderBT.frame = CGRectMake(frame.size.width - BUTTON_WIDTH, lineView3.top, BUTTON_WIDTH, BUTTON_HEIGHT);
        [_againorderBT setTitle:@"再来一单" forState:UIControlStateNormal];
        [_againorderBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _againorderBT.backgroundColor = UIColorFromRGBA(0xE9471B, 1);
        _againorderBT.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_againorderBT];
        [_againorderBT addTarget:self action:@selector(againOrderBTAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

+ (CGFloat)cellHeight
{
    return TOP_SPACE * 4 + IMAGE_SIZE + 8 + BUTTON_HEIGHT + LABEL_HEIGHT - 3;
}

- (void)setTakeOutOrderMD:(TakeOutOrderMD *)takeOutOrderMD
{
    _takeOutOrderMD = takeOutOrderMD;
    
    int orderState = 0;
    orderState = takeOutOrderMD.orderState.intValue;
    switch (orderState) {
        case 1:
            self.orderStateLB.text = @"新订单";
            break;
        case 2:
            self.orderStateLB.text = @"未配送";
            break;
        case 3:
            self.orderStateLB.text = @"已配送";
            break;
        case 4:
            self.orderStateLB.text = @"已作废";
            break;
        case 5:
            self.orderStateLB.text = @"申请退款";
            break;
        case 6:
            self.orderStateLB.text = @"退款成功";
            break;
        case 7:
            self.orderStateLB.text = @"确认收货";
            break;
        default:
            break;
    }
    
    __weak TOOrderViewCell * cell = self;
    [self.iconView setImageWithURL:[NSURL URLWithString:takeOutOrderMD.storeIcon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error != nil) {
            cell.iconView.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    self.dateLabel.text = [self estimateTime:takeOutOrderMD.time];
    self.titleLabel.text = takeOutOrderMD.storeName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", takeOutOrderMD.allMoney];
    _mealCountLB.text = [NSString stringWithFormat:@"商品总数:%@", takeOutOrderMD.mealCount];
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

#pragma mark - 删除订单 、再来一单
- (void)deleteOrderAction:(DeleteBlock)deleteBlock
{
    _deleteBlock = [deleteBlock copy];
}
- (void)againOrderAction:(AgainOrderBlock)againBlock
{
    _againBlock = [againBlock copy];
}

- (void)deleteorderBTAction:(UIButton *)button
{
    _deleteBlock();
}

- (void)againOrderBTAction:(UIButton *)button
{
    _againBlock();
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
