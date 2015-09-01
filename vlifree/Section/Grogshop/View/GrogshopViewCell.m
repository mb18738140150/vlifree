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
#define WIFI_IMAGE_WIDTH 10
#define SOLD_WIDTH 80
#define RIGTH_WIDTH 60
#define NAME_LABEL_WIDTH frame.size.width - 3 * LEFT_SPACE - IMAGE_SIZE
#define LABEL_HEIGTH IMAGE_SIZE / 3
#define LABEL_TEXTCOLOR [UIColor colorWithWhite:0.5 alpha:1];

@interface GrogshopViewCell ()
/**
 *  酒店图片试图
 */
@property (nonatomic, strong)UIImageView * icon;
/**
 *  酒店名字文字框
 */
@property (nonatomic, strong)UILabel * nameLabel;
/**
 *  WiFi
 */
@property (nonatomic, strong)UIImageView * wifiImage;
/**
 *  停车场
 */
@property (nonatomic, strong)UIImageView * parkImage;
/**
 *  售量
 */
@property (nonatomic, strong)UILabel * soldLabel;
/**
 *  地址
 */
@property (nonatomic, strong)UILabel * addressLabel;
/**
 *  价格
 */
@property (nonatomic, strong)UILabel * priceLabel;
/**
 *  距离
 */
@property (nonatomic, strong)UILabel * distanceLabel;
/**
 *  首单减免
 */
@property (nonatomic, strong)UIView * firstOrderV;

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
        _icon.layer.cornerRadius = 10;
        _icon.layer.masksToBounds = YES;
//        _icon.backgroundColor = [UIColor blueColor];
//        _icon.userInteractionEnabled = YES;
        [self.contentView addSubview:_icon];
        
        self.IconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _IconButton.frame = _icon.bounds;
        [self.contentView addSubview:_IconButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + LEFT_SPACE, TOP_SPACE, NAME_LABEL_WIDTH, LABEL_HEIGTH)];
        _nameLabel.text = @"北京五棵松体育馆快捷酒店";
        _nameLabel.textColor = TEXT_COLOR;
//        _nameLabel.font = [UIFont systemFontOfSize:18];
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
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textColor = LABEL_TEXTCOLOR;
        [self.contentView addSubview:_distanceLabel];
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + LEFT_SPACE, _soldLabel.bottom, frame.size.width - _wifiImage.left - LEFT_SPACE - RIGTH_WIDTH, LABEL_HEIGTH)];
        _addressLabel.text = @"万寿路商圈";
//        _addressLabel.backgroundColor = [UIColor redColor];
        _addressLabel.textColor = LABEL_TEXTCOLOR;
        _addressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_addressLabel];
        
        self.firstOrderV = [[UIView alloc] initWithFrame:CGRectMake(_addressLabel.left, _addressLabel.bottom, _addressLabel.width, _addressLabel.height)];
        UIImageView * firstIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, _firstOrderV.height - 6, _firstOrderV.height - 6)];
        firstIM.image = [UIImage imageNamed:@"shou.png"];
        [_firstOrderV addSubview:firstIM];
        UILabel * firstLB = [[UILabel alloc] initWithFrame:CGRectMake(firstIM.right + 3, firstIM.top, _firstOrderV.width - 6 - firstIM.right, firstIM.height)];
        firstLB.text = @"首单减免";
        firstLB.tag = 2000;
        firstLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        firstLB.font = [UIFont systemFontOfSize:13];
        [_firstOrderV addSubview:firstLB];
        [self.contentView addSubview:_firstOrderV];
        
        
    }
}


- (void)setHotelModel:(HotelModel *)hotelModel
{
    _hotelModel = hotelModel;
    self.nameLabel.text = hotelModel.hotelName;
    self.priceLabel.attributedText = [self customAttributedStringWithString:[NSString stringWithFormat:@"¥%@起", hotelModel.price]];
    self.addressLabel.text = hotelModel.address;
    self.soldLabel.text = [NSString stringWithFormat:@"月售:%@", hotelModel.sold];
    if ([hotelModel.wifiState isEqual:@YES]) {
        self.wifiImage.image = [UIImage imageNamed:@"wifi_on.png"];
    }else
    {
        self.wifiImage.image = [UIImage imageNamed:@"wifi_off.png"];
    }
    
    if ([hotelModel.parkState isEqual:@YES]) {
        self.parkImage.image = [UIImage imageNamed:@"P_on.png"];
    }else
    {
        self.parkImage.image = [UIImage imageNamed:@"P_off.png"];
    }
    double r = [hotelModel.distance integerValue];
    if (r > 999.99) {
        double km = r / 1000.0;
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fKM", km];
    }else
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fM", r];
    }
    [self.icon setImageWithURL:[NSURL URLWithString:hotelModel.icon]];
    GrogshopViewCell * cell = self;
    [self.icon setImageWithURL:[NSURL URLWithString:hotelModel.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        cell.IconButton.enabled = YES;
        if (error) {
            cell.icon.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    
    if ([hotelModel.isFirstReduce isEqualToNumber:@YES]) {
        self.firstOrderV.hidden = NO;
        UILabel * aLabel = (UILabel *)[self.firstOrderV viewWithTag:2000];
        aLabel.text = [NSString stringWithFormat:@"首单立减%@", hotelModel.firstReduce];
    }else
    {
        self.firstOrderV.hidden = YES;
    }
    
}


- (NSAttributedString *)customAttributedStringWithString:(NSString *)string
{
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange strRange = NSMakeRange(1, string.length - 2);
    NSRange yRange = NSMakeRange(0, 1);
    NSRange lastRange = NSMakeRange(str.length - 1, 1);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:yRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:yRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:lastRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:lastRange];
    return [str copy];
}



+ (CGFloat)cellHeigthWithIsFirstReduce:(NSNumber *)isFirstReduce
{
    if ([isFirstReduce isEqualToNumber:@1]) {
        return TOP_SPACE * 2 + IMAGE_SIZE * 4 / 3;
    }
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
