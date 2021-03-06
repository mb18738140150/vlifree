//
//  DetailsGSViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGSViewCell.h"
#import "RoomModel.h"

#define LEFT_SPACE 15
#define TOP_SPACE 10
#define IMAGE_SIZE 60
#define LABEL_HEIGHT (IMAGE_SIZE / 3)
#define BUTTON_WIDTH 70
#define RIGHT_IMAGE_SIZE 10
#define LABEL_WIDTH (self.width - 2 * LEFT_SPACE - _iconView.right)

@interface DetailsGSViewCell ()
/**
 *  房间图片
 */
@property (nonatomic, strong)UIImageView * iconView;
/**
 *  房间名
 */
@property (nonatomic, strong)UILabel * nameLable;
/**
 *  房间价格
 */
@property (nonatomic, strong)UILabel * priceLabel;
/**
 *  房间说明
 */
@property (nonatomic, strong)UILabel * introLabel;

@end


@implementation DetailsGSViewCell



- (void)createSubviewWithFrame:(CGRect)frame
{
    if (!_iconView) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"home_grogshop.png"];
        [self addSubview:_iconView];
        
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = _iconView.frame;
        [self addSubview:_iconButton];
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, _iconView.top, LABEL_WIDTH, LABEL_HEIGHT)];
        _nameLable.text = @"总统套房";
        _nameLable.textColor = TEXT_COLOR;
        _nameLable.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLable];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, _nameLable.bottom, LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.text = @"¥235";
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = [UIColor redColor];
        [self addSubview:_priceLabel];
        
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, _priceLabel.bottom, LABEL_WIDTH, LABEL_HEIGHT)];
        _introLabel.text = @"¥235";
        _introLabel.font = [UIFont systemFontOfSize:13];
        _introLabel.textColor = TEXT_COLOR;
        [self addSubview:_introLabel];
        
        self.reserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reserveButton.frame = CGRectMake(frame.size.width - BUTTON_WIDTH - RIGHT_IMAGE_SIZE - LEFT_SPACE, _priceLabel.top, BUTTON_WIDTH, LABEL_HEIGHT);
        _reserveButton.backgroundColor = MAIN_COLOR;
        [_reserveButton setTitle:@"有房" forState:UIControlStateNormal];
        [_reserveButton setTitle:@"满房" forState:UIControlStateDisabled];
        _reserveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _reserveButton.layer.cornerRadius = 5;
        [self addSubview:_reserveButton];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

+ (CGFloat)cellHeight
{
    return 2 * TOP_SPACE + IMAGE_SIZE;
}


- (void)setRoomModel:(RoomModel *)roomModel
{
    _roomModel = roomModel;
    __weak DetailsGSViewCell * cell = self;
    [self.iconView setImageWithURL:[NSURL URLWithString:roomModel.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error != nil || image == nil) {
            cell.iconView.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    self.nameLable.text = roomModel.suiteName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", roomModel.suitePrice];
    if ([roomModel.stock isEqualToNumber:@0]) {
        self.reserveButton.enabled = NO;
        _reserveButton.backgroundColor = [UIColor grayColor];
    }else
    {
        self.reserveButton.enabled = YES;
        _reserveButton.backgroundColor = MAIN_COLOR;
    }
    self.introLabel.text = roomModel.intro;
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
