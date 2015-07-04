//
//  PayTypeView.m
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PayTypeView.h"


#define LEFT_SPACE 10
#define TOP_SPACE 5
#define IMAGE_SIZE 30

#define LABEL_WIDTH 100
#define BUTTON_SIZE 30

@implementation PayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    if (!_iconView) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        [self addSubview:_iconView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + TOP_SPACE, _iconView.top, LABEL_WIDTH, IMAGE_SIZE)];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:14];
//        _titleLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_titleLabel];
        self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.frame = CGRectMake(self.width - LEFT_SPACE - BUTTON_SIZE, _titleLabel.top, BUTTON_SIZE, BUTTON_SIZE);
//        _changeButton.backgroundColor = [UIColor orangeColor];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"changeBT_n.png"] forState:UIControlStateNormal];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"changeBT_s.png"] forState:UIControlStateSelected];
        [self addSubview:_changeButton];
        
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
