
//
//  MenusViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MenusViewCell.h"

#define IMAGE_SIZE 50
#define LEFT_SPACE 10
#define TOP_SPACE 10
#define BUTTON_SIZE 30
#define LABEL_HEIGHT 20
#define PRICE_LABEL_WIDTH 80

//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]

@interface MenusViewCell ()

@property (nonatomic, strong)UIImageView * iconView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * soldCountLB;
@property (nonatomic, strong)UILabel * priceLabel;



@end



@implementation MenusViewCell


- (void)createSubview:(CGRect)frame
{
    if (!_iconView) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        _iconView.backgroundColor = VIEW_COLOR;
        _iconView.image = [UIImage imageNamed:@"home_grogshop.png"];
        [self.contentView addSubview:_iconView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + LEFT_SPACE, TOP_SPACE, frame.size.width - 2 * LEFT_SPACE - _iconView.right, LABEL_HEIGHT)];
        _nameLabel.text = @"双人套餐水煮牛肉套餐";
        [self.contentView addSubview:_nameLabel];
        
        self.soldCountLB = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, LABEL_HEIGHT)];
        _soldCountLB.text = @"月售453份";
        _soldCountLB.font = [UIFont systemFontOfSize:13];
        _soldCountLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self.contentView addSubview:_soldCountLB];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _iconView.bottom, PRICE_LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.text = @"23元/份";
        _priceLabel.backgroundColor = VIEW_COLOR;
        [self.contentView addSubview:_priceLabel];
        
        self.subtractBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _subtractBT.frame = CGRectMake(_nameLabel.right - 3 * BUTTON_SIZE, _priceLabel.bottom - BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE);
        _subtractBT.hidden = YES;
//        [_subtractBT setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
//        [_subtractBT setTitle:@"-" forState:UIControlStateNormal];
        [_subtractBT setBackgroundImage:[UIImage imageNamed:@"subtract.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_subtractBT];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subtractBT.right, _subtractBT.top, _subtractBT.width, _subtractBT.height)];
        _countLabel.text = @"0";
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_countLabel];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(_countLabel.right, _priceLabel.bottom - BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE);
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
//        [_addButton setTitle:@"+" forState:UIControlStateNormal];
//        [_addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
    }
}


+ (CGFloat)cellHeight
{
    return IMAGE_SIZE + LABEL_HEIGHT + 2 * TOP_SPACE;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
