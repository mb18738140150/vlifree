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
#define LABEL_HEIGTH IMAGE_SIZE / 3
#define STATE_IMAGE_WIDTH 40
#define STATE_IMAGE_HEIGTH 14
#define LABEL_WIDTH 64
#define LABEL_TEXTCOLOR [UIColor colorWithWhite:0.5 alpha:1]

//#define LABEL_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1]
#define LABEL_COLOR [UIColor clearColor]
#define LABEL_FONT [UIFont systemFontOfSize:10]

@interface TakeOutViewCell ()
@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * soldLabel;
@property (nonatomic, strong)UILabel * sendPriceLabel;
@property (nonatomic, strong)UILabel * outsideOrderLB;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIImageView * stateImage;
@property (nonatomic, strong)UIView * firstOrderV;
@property (nonatomic, strong)UIView * fullOrderV;

@end


@implementation TakeOutViewCell


- (void)createSubview:(CGRect)frame
{
    if (!_icon) {
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
        _nameLabel.font = [UIFont systemFontOfSize:19];
        [self.contentView addSubview:_nameLabel];
        
        self.stateImage = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + (LABEL_HEIGTH - STATE_IMAGE_HEIGTH) / 2, STATE_IMAGE_WIDTH, STATE_IMAGE_HEIGTH)];
        _stateImage.image = [UIImage imageNamed:@"storeState_k.png"];
        [self.contentView addSubview:_stateImage];
        
        self.soldLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImage.right, _stateImage.top, LABEL_WIDTH, _stateImage.height)];
        _soldLabel.text = @"月售1033份";
        _soldLabel.textColor = LABEL_TEXTCOLOR;
        _soldLabel.textAlignment = NSTextAlignmentCenter;
        _soldLabel.font = LABEL_FONT;
        _soldLabel.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_soldLabel];
        
        self.sendPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_soldLabel.right, _stateImage.top, LABEL_WIDTH, _stateImage.height)];
        _sendPriceLabel.text = @"起送价:¥34";
        _sendPriceLabel.textColor = LABEL_TEXTCOLOR;
        _sendPriceLabel.textAlignment = NSTextAlignmentCenter;
        _sendPriceLabel.font = LABEL_FONT;
        _sendPriceLabel.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_sendPriceLabel];
        
        self.outsideOrderLB = [[UILabel alloc] initWithFrame:CGRectMake(_sendPriceLabel.right, _stateImage.top, LABEL_WIDTH, _stateImage.height)];
        _outsideOrderLB.text = @"外送费:¥15";
        _outsideOrderLB.textColor = LABEL_TEXTCOLOR;
        _outsideOrderLB.textAlignment = NSTextAlignmentCenter;
        _outsideOrderLB.font = LABEL_FONT;
        _outsideOrderLB.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_outsideOrderLB];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImage.left, _icon.bottom - LABEL_HEIGTH, frame.size.width - IMAGE_SIZE - 3 * LEFT_SPACE, LABEL_HEIGTH)];
        _addressLabel.text = @"南京路东45号";
//        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = LABEL_TEXTCOLOR;
        _addressLabel.backgroundColor = LABEL_COLOR;
        [self.contentView addSubview:_addressLabel];
        self.firstOrderV = [[UIView alloc] initWithFrame:CGRectMake(_addressLabel.left, _addressLabel.bottom, _addressLabel.width, _addressLabel.height)];
        UIImageView * firstIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, _firstOrderV.height - 6, _firstOrderV.height - 6)];
        firstIM.image = [UIImage imageNamed:@"shou.png"];
        [_firstOrderV addSubview:firstIM];
        UILabel * firstLB = [[UILabel alloc] initWithFrame:CGRectMake(firstIM.right + 3, firstIM.top, _firstOrderV.width - 6 - firstIM.right, firstIM.height)];
        firstLB.text = @"首单减免";
        firstLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        firstLB.font = [UIFont systemFontOfSize:13];
        [_firstOrderV addSubview:firstLB];
        [self.contentView addSubview:_firstOrderV];
        
        self.fullOrderV = [[UIView alloc] initWithFrame:CGRectMake(_firstOrderV.left, _firstOrderV.bottom, _firstOrderV.width, _firstOrderV.height)];
        UIImageView * fullIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, _fullOrderV.height - 6, _fullOrderV.height - 6)];
        fullIM.image = [UIImage imageNamed:@"jian.png"];
        [_fullOrderV addSubview:fullIM];
        UILabel * fullLB = [[UILabel alloc] initWithFrame:CGRectMake(firstIM.right + 3, firstIM.top, _fullOrderV.width - 6 - firstIM.right, firstIM.height)];
        fullLB.text = @"满单减免";
        fullLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        fullLB.font = [UIFont systemFontOfSize:13];
        [_fullOrderV addSubview:fullLB];
        [self.contentView addSubview:_fullOrderV];
        
    }
}


+ (CGFloat)cellHeightWithTakeOutModel:(TakeOutModel *)takeOutModel
{
    CGFloat height = 2 * TOP_SPACE + IMAGE_SIZE;
    if ([takeOutModel.isFirstOrder isEqualToNumber:@YES]) {
        height += LABEL_HEIGTH;
    }
    if ([takeOutModel.isFull isEqualToNumber:@YES]) {
        height += LABEL_HEIGTH;
    }
    return height;
}

- (void)setTakeOutModel:(TakeOutModel *)takeOutModel
{
    _takeOutModel = takeOutModel;
    self.nameLabel.text = takeOutModel.storeName;
    if ([takeOutModel.storeState isEqualToNumber:@1]) {
        _stateImage.image = [UIImage imageNamed:@"storeState_k.png"];
    }else
    {
        _stateImage.image = [UIImage imageNamed:@"storeState_g.png"];
    }
    self.soldLabel.text = [NSString stringWithFormat:@"月售%@份", takeOutModel.sold];
    self.sendPriceLabel.text = [NSString stringWithFormat:@"起送价:%@", takeOutModel.sendPrice];
    self.outsideOrderLB.text = [NSString stringWithFormat:@"外送费:%@", takeOutModel.outSentMoney];
    self.addressLabel.text = takeOutModel.address;
    __weak TakeOutViewCell * cell = self;
    [self.icon setImageWithURL:[NSURL URLWithString:takeOutModel.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            cell.icon.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    
    if ([takeOutModel.isFirstOrder isEqualToNumber:@YES]) {
        self.firstOrderV.frame = CGRectMake(_addressLabel.left, _addressLabel.bottom, _addressLabel.width, _addressLabel.height);
        self.firstOrderV.hidden = NO;
    }else
    {
        self.firstOrderV.frame = CGRectMake(_addressLabel.left, _addressLabel.bottom, _addressLabel.width, 0);
        self.firstOrderV.hidden = YES;
    }
    if ([takeOutModel.isFull isEqualToNumber:@YES]) {
        self.fullOrderV.frame = CGRectMake(_firstOrderV.left, _firstOrderV.bottom, _firstOrderV.width, _addressLabel.height);
        self.fullOrderV.hidden = NO;
    }else
    {
        self.fullOrderV.frame = CGRectMake(_firstOrderV.left, _firstOrderV.bottom, _firstOrderV.width, 0);
        self.fullOrderV.hidden = YES;
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
