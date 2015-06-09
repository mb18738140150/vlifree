//
//  DetailsGSViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGSViewCell.h"


#define LEFT_SPACE 15
#define TOP_SPACE 10
#define IMAGE_SIZE 60
#define LABEL_HEIGHT (IMAGE_SIZE / 3)
#define BUTTON_WIDTH 70
#define RIGHT_IMAGE_SIZE 10
#define LABEL_WIDTH (self.width - 2 * LEFT_SPACE - _iconView.right)

@interface DetailsGSViewCell ()

@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * nameLable;
@property (nonatomic, strong)UILabel * priceLabel;


@end


@implementation DetailsGSViewCell



- (void)createSubviewWithFrame:(CGRect)frame
{
    if (!_iconView) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.image = [UIImage imageNamed:@"home_grogshop.png"];
        [self addSubview:_iconView];
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, _iconView.top, LABEL_WIDTH, LABEL_HEIGHT)];
        _nameLable.text = @"总统套房";
        [self addSubview:_nameLable];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, _nameLable.bottom, LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.text = @"¥235";
        _priceLabel.textColor = [UIColor redColor];
        [self addSubview:_priceLabel];
        
        self.reserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reserveButton.frame = CGRectMake(frame.size.width - BUTTON_WIDTH - RIGHT_IMAGE_SIZE - LEFT_SPACE, _priceLabel.top, BUTTON_WIDTH, LABEL_HEIGHT + 5);
        _reserveButton.backgroundColor = MAIN_COLOR;
        [_reserveButton setTitle:@"预定" forState:UIControlStateNormal];
        _reserveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _reserveButton.layer.cornerRadius = 5;
        [self addSubview:_reserveButton];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;

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
