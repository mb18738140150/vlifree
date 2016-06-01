
//
//  GrogshopHeaderView.m
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GrogshopHeaderView.h"

#define TOP_SPACE 10
#define LEFT_SPACE ((self.width - 4 * BUTTON_WIDTH) / 5)
#define BUTTON_WIDTH 68
#define BUTTON_HEIGHT 28

//#define BUTTON_COLOR [UIColor redColor]
#define BUTTON_COLOR [UIColor clearColor]


@implementation GrogshopHeaderView


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
    if (!_allButton) {
        self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allButton.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
//        [_allButton setBackgroundImage:[UIImage imageNamed:@"all_n"] forState:UIControlStateNormal];
//        [_allButton setBackgroundImage:[UIImage imageNamed:@"all_s"] forState:UIControlStateSelected];
        [_allButton setTitle:@"综合排序" forState:UIControlStateNormal];
        _allButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_allButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateSelected];
        [_allButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _allButton.selected = YES;
        _allButton.backgroundColor = BUTTON_COLOR;
        [self addSubview:_allButton];
        
        self.priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceButton.frame = CGRectMake(_allButton.right + LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
//        [_priceButton setBackgroundImage:[UIImage imageNamed:@"price_n"] forState:UIControlStateNormal];
//        [_priceButton setBackgroundImage:[UIImage imageNamed:@"price_s"] forState:UIControlStateSelected];
        [_priceButton setTitle:@"价格最低" forState:UIControlStateNormal];
        _priceButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_priceButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateSelected];
        [_priceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _priceButton.backgroundColor = BUTTON_COLOR;
        [self addSubview:_priceButton];
        
        self.distanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _distanceButton.frame = CGRectMake(_priceButton.right + LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
//        [_distanceButton setBackgroundImage:[UIImage imageNamed:@"distance_n"] forState:UIControlStateNormal];
//        [_distanceButton setBackgroundImage:[UIImage imageNamed:@"distance_s"] forState:UIControlStateSelected];
        [_distanceButton setTitle:@"离我最近" forState:UIControlStateNormal];
        _distanceButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_distanceButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateSelected];
        [_distanceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _distanceButton.backgroundColor = BUTTON_COLOR;
        [self addSubview:_distanceButton];
        
        self.soldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _soldButton.frame = CGRectMake(_distanceButton.right + LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
//        [_soldButton setBackgroundImage:[UIImage imageNamed:@"sold_n"] forState:UIControlStateNormal];
//        [_soldButton setBackgroundImage:[UIImage imageNamed:@"sold_s"] forState:UIControlStateSelected];
        [_soldButton setTitle:@"销量最高" forState:UIControlStateNormal];
        _soldButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_soldButton setTitleColor:BACKGROUNDCOLOR forState:UIControlStateSelected];
        [_soldButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _soldButton.backgroundColor = BUTTON_COLOR;
        [self addSubview:_soldButton];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 0.8)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.7];
        [self addSubview:lineView];
    }
}


+ (CGFloat)viewHeight
{
    return BUTTON_HEIGHT + 2 * TOP_SPACE;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
