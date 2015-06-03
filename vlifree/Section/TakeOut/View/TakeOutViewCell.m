//
//  TakeOutViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TakeOutViewCell.h"
#import "MGSwipeButton.h"

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


@end


@implementation TakeOutViewCell


- (void)createSubview:(CGRect)frame
{
    if (!_icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _icon.image = [UIImage imageNamed:@"home_takeOut.png"];
        [self.contentView addSubview:_icon];
        
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
        
    }
}


+ (CGFloat)cellHeight
{
    return 2 * TOP_SPACE + IMAGE_SIZE;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
