

//
//  HomeViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HomeViewCell.h"
#import "CollectModel.h"


#define LEFT_SPACE 5
#define TOP_SPACE 10
#define IMAGE_SIZE 60
#define LABEL_HEIGTH IMAGE_SIZE / 3
#define RIGHT_LEBEL_WIDTH 60
#define CENTRE_LABEL_WIDTH frame.size.width - IMAGE_SIZE - RIGHT_LEBEL_WIDTH - 4 * LEFT_SPACE //中间label的宽


//#define VIEW_COLOR [UIColor greenColor]
#define VIEW_COLOR [UIColor clearColor]

@interface HomeViewCell ()
/**
 *  图片
 */
@property (nonatomic, strong)UIImageView * icon;
/**
 *  商店名
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *  描述
 */
@property (nonatomic, strong)UILabel * detailLabel;
/**
 *  价格
 */
@property (nonatomic, strong)UILabel * priceLabel;
/**
 *  距离
 */
@property (nonatomic, strong)UILabel * distanceLabel;
/**
 *  月售
 */
@property (nonatomic, strong)UILabel * soldCountLabel;



@end




@implementation HomeViewCell



- (void)createSubview:(CGRect)frame
{
    if (!_icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _icon.layer.cornerRadius = 10;
        _icon.layer.masksToBounds = YES;
        _icon.backgroundColor = VIEW_COLOR;
//        _icon.image = [UIImage imageNamed:@"home_takeOut.png"];
        [self.contentView addSubview:_icon];
        
        self.IconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _IconButton.frame = _icon.bounds;
        [self.contentView addSubview:_IconButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + LEFT_SPACE, _icon.top, CENTRE_LABEL_WIDTH, LABEL_HEIGTH)];
        _titleLabel.backgroundColor = VIEW_COLOR;
//        _titleLabel.text = @"小肥羊";
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom, CENTRE_LABEL_WIDTH, LABEL_HEIGTH)];
        _detailLabel.backgroundColor = VIEW_COLOR;
//        _detailLabel.text = @"市中心100元可叠加免预约";
        _detailLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_detailLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _detailLabel.bottom, RIGHT_LEBEL_WIDTH, LABEL_HEIGTH)];
        _priceLabel.backgroundColor = VIEW_COLOR;
//        _priceLabel.text = @"¥100";
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + LEFT_SPACE, _icon.top, RIGHT_LEBEL_WIDTH, LABEL_HEIGTH)];
        _distanceLabel.backgroundColor = VIEW_COLOR;
//        _distanceLabel.text = @"2.5公里";
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self.contentView addSubview:_distanceLabel];
        self.soldCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + LEFT_SPACE, _priceLabel.top, RIGHT_LEBEL_WIDTH, LABEL_HEIGTH)];
        _soldCountLabel.backgroundColor = VIEW_COLOR;
        _soldCountLabel.font = [UIFont systemFontOfSize:14];
        _soldCountLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        _soldCountLabel.text = @"售出100";
        [self.contentView addSubview:_soldCountLabel];
    }
}


+ (CGFloat)cellHeigth
{
    return 2 * TOP_SPACE + IMAGE_SIZE;
}

- (void)setCollectModel:(CollectModel *)collectModel
{
    _collectModel = collectModel;
    self.titleLabel.text = collectModel.businessName;
    if (collectModel.describe) {
        
        NSMutableString * str = [[NSString stringWithFormat:@"<body>%@<body>", collectModel.describe] mutableCopy];
        //        NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[[str copy] dataUsingEncoding:NSUTF8StringEncoding]];
        //        parser.delegate = self;
        //        [parser parse];
        [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        while ([str rangeOfString:@"<"].location != NSNotFound) {
            NSRange range1 = [str rangeOfString:@"<"];
            NSRange range2 = [str rangeOfString:@">"];
            NSRange strRange = NSMakeRange(range1.location, range2.location - range1.location + 1);
            [str replaceCharactersInRange:strRange withString:@""];
            //        NSLog(@"%d, %d", strRange.location, strRange.length);
        }
        
        self.detailLabel.text = [str copy];
    }
    double m = [collectModel.distance doubleValue];
    if (m > 999.99) {
        double km = m / 1000.0;
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fKM", km];
    }else
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1fM", m];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", collectModel.price];
    self.soldCountLabel.text = [NSString stringWithFormat:@"已售%@", collectModel.sold];
    __weak HomeViewCell * cell = self;
    [self.icon setImageWithURL:[NSURL URLWithString:collectModel.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            cell.icon.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
