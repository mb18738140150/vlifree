//
//  IntegralView.m
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "IntegralView.h"

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define TOTALHEIGHT 250

@implementation IntegralView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _backButton.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, 30, 30);
    [_backButton setImage:[UIImage imageNamed:@"back_gray.png"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_backButton.right, _backButton.top, self.width - 2 * LEFT_SPACE - _backButton.width, _backButton.height)];
    _titleLabel.text = @"选择积分";
    _titleLabel.font = [UIFont systemFontOfSize:22];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _backButton.bottom + TOP_SPACE, self.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line1];
    
    self.giveupview = [[DetailsIntegralView alloc]initWithFrame:CGRectMake(0, line1.bottom, self.width, 50)];
    _giveupview.stateImageView.hidden = NO;
    [_giveupview.nameButton setTitle:@"放弃使用积分" forState:UIControlStateNormal];
    [self addSubview:_giveupview];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _giveupview.bottom, self.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2];
    
    self.useTotalview = [[DetailsIntegralView alloc]initWithFrame:CGRectMake(0, line2.bottom, self.width, 50)];
    [_useTotalview.nameButton setTitle:@"使用全部积分" forState:UIControlStateNormal];
    [self addSubview:_useTotalview];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, _useTotalview.bottom, self.width, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line3];
    
    self.choseIntegralview = [[DetailsIntegralView alloc]initWithFrame:CGRectMake(0, line3.bottom, self.width, 50)];
    [_choseIntegralview.nameButton setTitle:@"填写使用积分数量" forState:UIControlStateNormal];
    [self addSubview:_choseIntegralview];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, _choseIntegralview.bottom, self.width, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line4];
    
    self.totalLB = [[UILabel alloc]initWithFrame:CGRectMake(20, line4.bottom + 60, 140, 30)];
    _totalLB.text = @"您的积分还剩余:";
    _totalLB.textColor = [UIColor grayColor];
    _totalLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_totalLB];
    
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(_totalLB.right, _totalLB.top, self.width - 10 - _totalLB.width, 30)];
    _totalLabel.font = [UIFont systemFontOfSize:25];
    _totalLabel.textColor = [UIColor redColor];
    [self addSubview:_totalLabel];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
