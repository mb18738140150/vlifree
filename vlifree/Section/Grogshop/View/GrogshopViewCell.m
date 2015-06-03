//
//  GrogshopViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GrogshopViewCell.h"


#define LEFT_SPACE 10
#define TOP_SPACE 15
#define IMAGE_SIZE 60
#define WIFI_IMAGE_WIDTH 12
#define SOLD_WIDTH 80
#define RIGTH_WIDTH 60
#define NAME_LABEL_WIDTH frame.size.width - 3 * LEFT_SPACE - IMAGE_SIZE
#define LABEL_HEIGTH IMAGE_SIZE / 3
#define LABEL_TEXTCOLOR [UIColor colorWithWhite:0.5 alpha:1];

@interface GrogshopViewCell ()

@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UIImageView * wifiImage;
@property (nonatomic, strong)UIImageView * parkImage;
@property (nonatomic, strong)UILabel * soldLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * distanceLabel;

@end

@implementation GrogshopViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}

- (void)createSubiew:(CGRect)frame
{
    if (!_icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _icon.image = [UIImage imageNamed:@"superMarket.png"];
        [self.contentView addSubview:_icon];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + LEFT_SPACE, TOP_SPACE, NAME_LABEL_WIDTH, LABEL_HEIGTH)];
        _nameLabel.text = @"北京五棵松体育馆快捷酒店";
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
        
        self.wifiImage = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + (LABEL_HEIGTH - WIFI_IMAGE_WIDTH) / 2, WIFI_IMAGE_WIDTH, WIFI_IMAGE_WIDTH)];
        _wifiImage.image = [UIImage imageNamed:@"wifi_on.png"];
//        _wifiImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_wifiImage];
        self.parkImage = [[UIImageView alloc] initWithFrame:CGRectMake(_wifiImage.right, _wifiImage.top, WIFI_IMAGE_WIDTH, WIFI_IMAGE_WIDTH)];
//        _parkImage.backgroundColor = [UIColor greenColor];
        _parkImage.image = [UIImage imageNamed:@"P_on.png"];
        [self.contentView addSubview:_parkImage];
        self.soldLabel = [[UILabel alloc] initWithFrame:CGRectMake(_parkImage.right, _nameLabel.bottom, SOLD_WIDTH, LABEL_HEIGTH)];
        _soldLabel.text = @"月售: 23";
        _soldLabel.font = [UIFont systemFontOfSize:14];
        _soldLabel.textColor = LABEL_TEXTCOLOR;
        [self.contentView addSubview:_soldLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - RIGTH_WIDTH, _soldLabel.top, RIGTH_WIDTH, LABEL_HEIGTH)];
//        _priceLabel.text = @"¥168起";
        _priceLabel.attributedText = [self customAttributedStringWithString:@"¥145元"];
        [self.contentView addSubview:_priceLabel];
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.left, _priceLabel.bottom, RIGTH_WIDTH, LABEL_HEIGTH)];
        _distanceLabel.text = @"1.2km";
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.textColor = LABEL_TEXTCOLOR;
        [self.contentView addSubview:_distanceLabel];
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + LEFT_SPACE, _soldLabel.bottom, frame.size.width - _wifiImage.left - LEFT_SPACE - RIGTH_WIDTH, LABEL_HEIGTH)];
        _addressLabel.text = @"万寿路商圈";
//        _addressLabel.backgroundColor = [UIColor redColor];
        _addressLabel.textColor = LABEL_TEXTCOLOR;
        [self.contentView addSubview:_addressLabel];
        
    }
}


- (NSAttributedString *)customAttributedStringWithString:(NSString *)string
{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange strRange = NSMakeRange(1, string.length - 2);
    NSRange yRange = NSMakeRange(0, 1);
    NSRange lastRange = NSMakeRange(str.length - 1, 1);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:yRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:yRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:lastRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:lastRange];
    return [str copy];
}



+ (CGFloat)cellHeigth
{
    return TOP_SPACE * 2 + IMAGE_SIZE;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
