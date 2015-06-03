//
//  ShoppingCartView.m
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ShoppingCartView.h"


#define LEFT_SPACE 30
#define IMAGE_TOP (-10)
#define IMAGE_SIZE 45
#define LABEL_WIDTH 80
#define LABEL_HEIGHT 25
#define BUTTON_WIDTH 80
#define BUTTON_HEIGHT 25
#define COUNT_LABEL_SIZE 20
#define BUTTON_RIGHT_SPACE 15


@implementation ShoppingCartView


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
    if (!_changeButton) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [self addSubview:lineView];
//        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, IMAGE_TOP, IMAGE_SIZE, IMAGE_SIZE)];
//        imageV.image = [UIImage imageNamed:@"shoppingCar.png"];
//        [self addSubview:imageV];
        
        self.shoppingCarBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _shoppingCarBT.frame = CGRectMake(LEFT_SPACE, IMAGE_TOP, IMAGE_SIZE, IMAGE_SIZE);
        [_shoppingCarBT setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateNormal];
        [self addSubview:_shoppingCarBT];
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _shoppingCarBT.top, COUNT_LABEL_SIZE, COUNT_LABEL_SIZE)];
        _countLabel.center = CGPointMake(_shoppingCarBT.right, _countLabel.centerY);
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.layer.backgroundColor = [UIColor redColor].CGColor;
        _countLabel.text = @"0";
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.layer.cornerRadius = COUNT_LABEL_SIZE / 2;
        [self addSubview:_countLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shoppingCarBT.right + LEFT_SPACE, 0, LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.center = CGPointMake(_priceLabel.centerX, self.height / 2);
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.text = @"¥0元";
        [self addSubview:_priceLabel];
        
        self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.frame = CGRectMake(self.width - BUTTON_WIDTH - BUTTON_RIGHT_SPACE, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
        _changeButton.center = CGPointMake(_changeButton.centerX, self.height / 2);
//        [_changeButton setTitle:@"选好了" forState:UIControlStateNormal];
//        _changeButton.layer.backgroundColor = MAIN_COLOR.CGColor;
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"change_n.png"] forState:UIControlStateNormal];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"change_d.png"] forState:UIControlStateDisabled];
        
        _changeButton.layer.cornerRadius = 5;
        _changeButton.enabled = NO;
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
