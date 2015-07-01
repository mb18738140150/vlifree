//
//  TOOrderViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TOOrderViewCell.h"

#define LEFT_SPACE 15
#define TOP_SPACE 5
#define IMAGE_SIZE 60
#define BUTTON_WIDTH 80
#define LABEL_HEIGHT 20

@interface TOOrderViewCell ()

@property (nonatomic, strong)UILabel * dateLabel;
@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * priceLabel;


@end


@implementation TOOrderViewCell




- (void)crateSubview:(CGRect)frame
{
    if (!_dateLabel) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, [TOOrderViewCell cellHeight] - 10)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 1)];
        lineView1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        [view addSubview:lineView1];
        
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, frame.size.width - BUTTON_WIDTH - 3 * LEFT_SPACE, LABEL_HEIGHT)];
        _dateLabel.text = @"05月13日 14:34";
        [view addSubview:_dateLabel];
        
//        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelButton.frame = CGRectMake(frame.size.width - BUTTON_WIDTH - LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, LABEL_HEIGHT);
//        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
//        [_cancelButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
//        [view addSubview:_cancelButton];
        
        UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _dateLabel.bottom, frame.size.width - 2 * LEFT_SPACE, 1)];
        lineView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        [view addSubview:lineView2];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, lineView2.bottom + TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"home_takeOut.png"];
        [view addSubview:_iconView];
        
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = _iconView.frame;
        [self.contentView addSubview:_iconButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 5, _iconView.top, frame.size.width - _iconView.right - 30, LABEL_HEIGHT)];
        _titleLabel.text = @"打牌小当1好套餐";
        [view addSubview:_titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
        _priceLabel.text = @"¥34";
        [view addSubview:_priceLabel];
        
        UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 1, view.width, 1)];
        lineView3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        [view addSubview:lineView3];
        
    }
}

+ (CGFloat)cellHeight
{
    return TOP_SPACE * 3 + IMAGE_SIZE + 2 + LABEL_HEIGHT + 10;
}

- (void)setTakeOutOrderMD:(TakeOutOrderMD *)takeOutOrderMD
{
    _takeOutOrderMD = takeOutOrderMD;
    __weak TOOrderViewCell * cell = self;
    [self.iconView setImageWithURL:[NSURL URLWithString:takeOutOrderMD.storeIcon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error != nil) {
            cell.iconView.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    self.dateLabel.text = takeOutOrderMD.time;
    self.titleLabel.text = takeOutOrderMD.storeName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", takeOutOrderMD.allMoney];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
