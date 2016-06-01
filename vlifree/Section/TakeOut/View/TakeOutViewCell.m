//
//  TakeOutViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TakeOutViewCell.h"
#import "MGSwipeButton.h"
#import "TakeOutModel.h"

#define LEFT_SPACE 10  
#define TOP_SPACE 10
#define IMAGE_SIZE 60
#define LABEL_HEIGTH 15
#define STATE_IMAGE_WIDTH 40
#define STATE_IMAGE_HEIGTH 14
#define LABEL_WIDTH 64
#define LABEL_TEXTCOLOR [UIColor colorWithWhite:0.5 alpha:1]

#define Viewwidth [UIScreen mainScreen].bounds

//#define LABEL_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1]
#define LABEL_COLOR [UIColor clearColor]
#define LABEL_FONT [UIFont systemFontOfSize:10]

@interface TakeOutViewCell ()
@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * soldLabel;//月售
@property (nonatomic, strong)UILabel * sendPriceLabel;// 起送价
@property (nonatomic, strong)UILabel * outsideOrderLB;// 配送费
@property (nonatomic, strong)UILabel * distanceLabel;// 距离
@property (nonatomic, strong)UILabel * sendTimeLabel;// 配送时间
@property (nonatomic, strong)UILabel * commentCountLabel;// 评论数
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIImageView * stateImage;
@property (nonatomic, strong)UIView * firstOrderV;
@property (nonatomic, strong)UIView * fullOrderV;

@end


@implementation TakeOutViewCell


- (void)createSubview:(CGRect)frame activityCount:(int)count
{
    [self.contentView removeAllSubviews];
//    if (!_icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _icon.layer.cornerRadius = 10;
        _icon.layer.masksToBounds = YES;
        _icon.image = [UIImage imageNamed:@"home_takeOut.png"];
        [self.contentView addSubview:_icon];
        
        self.IconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _IconButton.frame = _icon.bounds;
        [self.contentView addSubview:_IconButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + LEFT_SPACE, TOP_SPACE, frame.size.width - IMAGE_SIZE - 2 * LEFT_SPACE, LABEL_HEIGTH)];
        _nameLabel.text = @"陕西三民斋餐厅";
        _nameLabel.textColor = TEXT_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
    
    
    
        self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(Viewwidth.size.width - LEFT_SPACE - 50, _nameLabel.top, 50, TOP_SPACE)];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.backgroundColor = [UIColor whiteColor];
        _distanceLabel.textColor = LABEL_TEXTCOLOR;
        _distanceLabel.font = LABEL_FONT;
    _distanceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _distanceLabel.layer.borderWidth = 1;
        [self.contentView addSubview:_distanceLabel];
        
        
//        self.stateImage = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + (LABEL_HEIGTH - STATE_IMAGE_HEIGTH) / 2, STATE_IMAGE_WIDTH, STATE_IMAGE_HEIGTH)];
//        _stateImage.image = [UIImage imageNamed:@"storeState_k.png"];
//        [self.contentView addSubview:_stateImage];
        
        
        self.sendPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 13, LABEL_WIDTH, TOP_SPACE)];
        _sendPriceLabel.text = @"起送价:¥34";
        _sendPriceLabel.textColor = LABEL_TEXTCOLOR;
        _sendPriceLabel.textAlignment = NSTextAlignmentCenter;
        _sendPriceLabel.font = LABEL_FONT;
        _sendPriceLabel.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_sendPriceLabel];
        
        UIView * separeteLine = [[UIView alloc]initWithFrame:CGRectMake(_sendPriceLabel.right, _sendPriceLabel.top, 1, _sendPriceLabel.height)];
        separeteLine.backgroundColor = LABEL_TEXTCOLOR;
        separeteLine.tag = 9999;
        [self.contentView addSubview:separeteLine];
        
        self.outsideOrderLB = [[UILabel alloc] initWithFrame:CGRectMake(_sendPriceLabel.right, _sendPriceLabel.top, LABEL_WIDTH, _sendPriceLabel.height)];
        _outsideOrderLB.text = @"外送费:¥15";
        _outsideOrderLB.textColor = LABEL_TEXTCOLOR;
        _outsideOrderLB.textAlignment = NSTextAlignmentCenter;
        _outsideOrderLB.font = LABEL_FONT;
        _outsideOrderLB.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_outsideOrderLB];
        
        self.sendTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Viewwidth.size.width - LEFT_SPACE - 50, _sendPriceLabel.top, 50, _sendPriceLabel.height)];
        _sendTimeLabel.textAlignment = NSTextAlignmentRight;
        _sendTimeLabel.backgroundColor = [UIColor whiteColor];
        _sendTimeLabel.textColor = LABEL_TEXTCOLOR;
        _sendTimeLabel.font = LABEL_FONT;
        [self.contentView addSubview:_sendTimeLabel];
        
        
        self.soldLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _sendPriceLabel.bottom + 13, LABEL_WIDTH * 2, TOP_SPACE)];
        _soldLabel.text = @"月售1033份";
        _soldLabel.textColor = LABEL_TEXTCOLOR;
        _soldLabel.textAlignment = NSTextAlignmentLeft;
        _soldLabel.font = LABEL_FONT;
        _soldLabel.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_soldLabel];
        
        self.commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(Viewwidth.size.width - LEFT_SPACE - 50, _soldLabel.top, 50, _soldLabel.height)];
        _commentCountLabel.textAlignment = NSTextAlignmentRight;
        _commentCountLabel.backgroundColor = [UIColor whiteColor];
        _commentCountLabel.textColor = LABEL_TEXTCOLOR;
        _commentCountLabel.font = LABEL_FONT;
        [self.contentView addSubview:_commentCountLabel];
        
        
//        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImage.left, _icon.bottom - LABEL_HEIGTH, frame.size.width - IMAGE_SIZE - 3 * LEFT_SPACE, LABEL_HEIGTH)];
//        _addressLabel.text = @"南京路东45号";
////        _addressLabel.textAlignment = NSTextAlignmentCenter;
//        _addressLabel.font = [UIFont systemFontOfSize:13];
//        _addressLabel.textColor = LABEL_TEXTCOLOR;
//        _addressLabel.backgroundColor = LABEL_COLOR;
//        [self.contentView addSubview:_addressLabel];
    /*
    for (int i = 0; i < count; i++) {
        UIImageView * activityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_addressLabel.left, _addressLabel.bottom + _addressLabel.height * i + 3, _addressLabel.height - 6, _addressLabel.height - 6)];
        activityIcon.tag = 2000 + i;
        [self.contentView addSubview:activityIcon];
        UILabel * activityLB = [[UILabel alloc] initWithFrame:CGRectMake(activityIcon.right + 3, activityIcon.top, _addressLabel.width - activityIcon.width - 3, activityIcon.height)];
        activityLB.tag = 3000 + i;
        activityLB.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:activityLB];
    }
    */
    
        
        self.fullOrderV = [[UIView alloc] initWithFrame:CGRectMake(_icon.left, _icon.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, LABEL_HEIGTH)];
        UIImageView * fullIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _fullOrderV.height, _fullOrderV.height)];
        fullIM.image = [UIImage imageNamed:@"jian.png"];
        [_fullOrderV addSubview:fullIM];
        UILabel * fullLB = [[UILabel alloc] initWithFrame:CGRectMake(fullIM.right + 3, fullIM.top, _fullOrderV.width - 6 - fullIM.right, fullIM.height)];
        fullLB.text = @"满单减免";
        fullLB.tag = 3000;
        fullLB.numberOfLines = 0;
        fullLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        fullLB.font = LABEL_FONT;
        [_fullOrderV addSubview:fullLB];
        [self.contentView addSubview:_fullOrderV];

        
        self.firstOrderV = [[UIView alloc] initWithFrame:CGRectMake(_fullOrderV.left, _fullOrderV.bottom + 7, self.width - 2 * LEFT_SPACE, LABEL_HEIGTH)];
        UIImageView * firstIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _firstOrderV.height, _firstOrderV.height)];
        firstIM.image = [UIImage imageNamed:@"shou.png"];
        [_firstOrderV addSubview:firstIM];
        UILabel * firstLB = [[UILabel alloc] initWithFrame:CGRectMake(firstIM.right + 3, firstIM.top, _firstOrderV.width - 6 - firstIM.right, firstIM.height)];
        firstLB.text = @"首单减免";
        firstLB.tag = 2000;
        firstLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        firstLB.font = LABEL_FONT;
        [_firstOrderV addSubview:firstLB];
        [self.contentView addSubview:_firstOrderV];
        
//    }
}


+ (CGFloat)cellHeightWithTakeOutModel:(TakeOutModel *)takeOutModel
{
//    CGFloat height = 2 * TOP_SPACE + IMAGE_SIZE + takeOutModel.activityArray.count * LABEL_HEIGTH;
    CGFloat height = 2 * TOP_SPACE + IMAGE_SIZE;
    
    if ([takeOutModel.isFull isEqualToNumber:@YES]) {
        NSMutableString * string = [NSMutableString string];
        for (ActivityReduce * activity in takeOutModel.activityArray) {
            if ([activity.activeType isEqualToNumber:@1]) {
                [string appendFormat:@"满%@减%@,", activity.mMoney, activity.jMoney];
            }
        }
        [string appendString:@"（在线支付专享）"];
        CGSize size = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - LEFT_SPACE - IMAGE_SIZE, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil] context:nil].size;
        
        if (size.height < LABEL_HEIGTH) {
            height += LABEL_HEIGTH + 15;
        }else
        {
            height += size.height + 15;
        }
        
    }
    
    if ([takeOutModel.isFirstOrder isEqualToNumber:@YES]) {
        if ([takeOutModel.isFull isEqualToNumber:@YES]) {
            height += LABEL_HEIGTH + 7;
        }else
        {
            height += LABEL_HEIGTH + 15;
        }
    }
    
    return height ;
}

- (void)setTakeOutModel:(TakeOutModel *)takeOutModel
{
    _takeOutModel = takeOutModel;
    self.nameLabel.text = takeOutModel.storeName;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", [takeOutModel.distance doubleValue] / 1000];
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
    
    CGRect distanceRect = [self.distanceLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.distanceLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.distanceLabel.frame = CGRectMake(Viewwidth.size.width - LEFT_SPACE - distanceRect.size.width - 2, _nameLabel.top, distanceRect.size.width + 2, TOP_SPACE);

    NSString * sendpriceStr = [NSString stringWithFormat:@"起送价￥%@", takeOutModel.sendPrice];
    NSDictionary * attributeforsendPrice = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:BACKGROUNDCOLOR};
    CGRect sendpriceRect = [sendpriceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, self.sendPriceLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.sendPriceLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 13, sendpriceRect.size.width, TOP_SPACE);
    NSMutableAttributedString * sendpriceMstr = [[NSMutableAttributedString alloc]initWithString:sendpriceStr];
    [sendpriceMstr setAttributes:attributeforsendPrice range:NSMakeRange(3, sendpriceStr.length - 3)];
    self.sendPriceLabel.attributedText = sendpriceMstr;
    
    UIView * separeteLine = [self.contentView viewWithTag:9999];
    separeteLine.frame = CGRectMake(_sendPriceLabel.right + 2, _sendPriceLabel.top, 1, _sendPriceLabel.height);
    
    self.outsideOrderLB.text = [NSString stringWithFormat:@"外送费￥%@", takeOutModel.outSentMoney];
    CGRect outsideOrderRect = [self.outsideOrderLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.outsideOrderLB.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.outsideOrderLB.frame = CGRectMake(separeteLine.right + 2, _sendPriceLabel.top, outsideOrderRect.size.width, _sendPriceLabel.height);
    
    self.sendTimeLabel.text = [NSString stringWithFormat:@"%@分钟送达", takeOutModel.sendTime];
    CGRect sendTimeRect = [self.sendTimeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.sendTimeLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.sendTimeLabel.frame = CGRectMake(Viewwidth.size.width - LEFT_SPACE - sendTimeRect.size.width, _sendPriceLabel.top, sendTimeRect.size.width, _sendPriceLabel.height);
    
    
    self.soldLabel.text = [NSString stringWithFormat:@"月售%@单", takeOutModel.sold];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@评论", takeOutModel.commentCount];
    CGRect commentCountRect = [self.commentCountLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.commentCountLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    self.commentCountLabel.frame = CGRectMake(Viewwidth.size.width - LEFT_SPACE - commentCountRect.size.width, _soldLabel.top, commentCountRect.size.width, _soldLabel.height);
//    self.addressLabel.text = takeOutModel.address;
    
    
    __weak TakeOutViewCell * cell = self;
    [self.icon setImageWithURL:[NSURL URLWithString:takeOutModel.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            cell.icon.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    /*
    for (int i = 0; i < takeOutModel.activityArray.count; i++) {
        ActivityReduce * activityRD = [takeOutModel.activityArray objectAtIndex:i];
        UIImageView * imageV = (UIImageView *)[self.contentView viewWithTag:2000 + i];
        UILabel * aLabel = (UILabel *)[self.contentView viewWithTag:3000 + i];
        if ([activityRD.activeType isEqualToNumber:@2]) {
            imageV.image = [UIImage imageNamed:@"shou.png"];
            aLabel.text = [NSString stringWithFormat:@"首单减%@", activityRD.sMoney];
        }else
        {
            imageV.image = [UIImage imageNamed:@"jian.png"];
            aLabel.text = [NSString stringWithFormat:@"满%@减%@", activityRD.mMoney, activityRD.jMoney];
        }
    }
    */
    
    if ([takeOutModel.isFull isEqualToNumber:@YES]) {
        self.fullOrderV.frame = CGRectMake(_icon.left, _icon.bottom + TOP_SPACE * 3 / 2, _fullOrderV.width, LABEL_HEIGTH);
        self.fullOrderV.hidden = NO;
        UILabel * aLabel = (UILabel *)[self.fullOrderV viewWithTag:3000];
        NSMutableString * string = [NSMutableString string];
        for (ActivityReduce * activity in takeOutModel.activityArray) {
            if ([activity.activeType isEqualToNumber:@1]) {
                [string appendFormat:@"满%@减%@;", activity.mMoney, activity.jMoney];
            }
        }
        [string appendString:@"（在线支付专享）"];
        aLabel.text = [string copy];
        CGSize size = [aLabel sizeThatFits:CGSizeMake(aLabel.width, CGFLOAT_MAX)];
        aLabel.height = size.height;
        _fullOrderV.height = aLabel.bottom + 3;
    }else
    {
        self.fullOrderV.frame = CGRectMake(_icon.left, _icon.bottom, _fullOrderV.width, 0);
        self.fullOrderV.hidden = YES;
    }
    
    
    if ([takeOutModel.isFirstOrder isEqualToNumber:@YES]) {
        
        if ([takeOutModel.isFull isEqualToNumber:@YES]) {
            self.firstOrderV.frame = CGRectMake(_icon.left, _fullOrderV.bottom + 7, _firstOrderV.width, LABEL_HEIGTH);
        }else
        {
            self.firstOrderV.frame = CGRectMake(_icon.left, _icon.bottom + TOP_SPACE*3/2, _firstOrderV.width, LABEL_HEIGTH);
        }
        
//        self.firstOrderV.frame = CGRectMake(_icon.left, _soldLabel.bottom + TOP_SPACE, self.width - 2 * LEFT_SPACE, LABEL_HEIGTH);
        self.firstOrderV.hidden = NO;
        UILabel * aLabel = (UILabel *)[self.firstOrderV viewWithTag:2000];
        for (ActivityReduce * activity in takeOutModel.activityArray) {
            if ([activity.activeType isEqualToNumber:@2]) {
                aLabel.text = [NSString stringWithFormat:@"首单立减%@", activity.sMoney];
            }
        }
    }else
    {
        self.firstOrderV.frame = CGRectMake(_icon.left, _fullOrderV.bottom , self.width - 2 * LEFT_SPACE, 0);
        self.firstOrderV.hidden = YES;
    }
    
    if ([takeOutModel.isFull boolValue] == 1 || [takeOutModel.isFirstOrder boolValue] == 1) {
        UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _icon.bottom + 5, self.width - 2 * LEFT_SPACE, 1)];
        lineview.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
        [self.contentView addSubview:lineview];
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
