
//
//  UserViewCell.m
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserViewCell.h"
#import "UserModel.h"

#define ICON_SIZE 30
#define BUTTON_WIDTH 40
#define TOP_SPACE 10
#define LEFT_SPACE 10
#define RIGHT_SPACE 15

//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]

@interface UserViewCell ()

@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel * titleLabel;


@end


@implementation UserViewCell



- (void)createSubviewWithFrame:(CGRect)frame
{
    if (!_icon) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        UIView * cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_SPACE, frame.size.width, TOP_SPACE * 2 + ICON_SIZE)];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:cellBackgroundView];
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, ICON_SIZE, ICON_SIZE)];
        _icon.backgroundColor = VIEW_COLOR;
        [cellBackgroundView addSubview:_icon];
        
        self.modifyBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBT.frame = CGRectMake(frame.size.width - RIGHT_SPACE - BUTTON_WIDTH, TOP_SPACE, BUTTON_WIDTH, ICON_SIZE);
//        [_modifyBT setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        _modifyBT.backgroundColor = VIEW_COLOR;
        [cellBackgroundView addSubview:_modifyBT];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE + _icon.right, TOP_SPACE, _modifyBT.left - _icon.right - 2 * LEFT_SPACE, ICON_SIZE)];
        _titleLabel.backgroundColor = VIEW_COLOR;
        [cellBackgroundView addSubview:_titleLabel];
    }
}

+ (CGFloat)cellHeight
{
    return 4 * TOP_SPACE + ICON_SIZE;
}



- (void)setUserModel:(UserModel *)userModel
{
    _userModel = userModel;
    self.icon.image = [UIImage imageNamed:userModel.iconStr];
    self.titleLabel.text = userModel.title;
    if (userModel.buttonStr) {
        [self.modifyBT setAttributedTitle:userModel.buttonStr forState:UIControlStateNormal];
        if ([[userModel.buttonStr string] floatValue]) {
            [_modifyBT setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }else
    {
        _modifyBT.hidden = YES;
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
