//
//  CouponView.m
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "CouponView.h"

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define TOTALHEIGHT 250

@implementation CouponView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _backButton.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, 30, 30);
    [_backButton setImage:[UIImage imageNamed:@"back_gray.png"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_backButton.right, _backButton.top, self.width - 2 * LEFT_SPACE - _backButton.width, _backButton.height)];
    _nameLabel.text = @"优惠券选择";
    _nameLabel.font = [UIFont systemFontOfSize:22];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _backButton.bottom + TOP_SPACE, self.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line1];
    
    self.stateImageview = [[UIImageView alloc]initWithFrame:CGRectMake(_backButton.right, line1.bottom + 22, 6, 6)];
    _stateImageview.image = [UIImage imageNamed:@"dian.png"];
    _stateImageview.layer.cornerRadius = 6;
    _stateImageview.layer.masksToBounds = YES;
    _stateImageview.hidden = NO;
    [self addSubview:_stateImageview];
    
    self.noCouponButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.noCouponButton.frame = CGRectMake(_stateImageview.right + 14, line1.bottom + TOP_SPACE, 150, 30) ;
    [_noCouponButton setTitle:@"不使用优惠券抵消" forState:UIControlStateNormal];
    [_noCouponButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_noCouponButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self addSubview:_noCouponButton];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _noCouponButton.bottom + TOP_SPACE, self.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self addSubview:line2];
    
    self.couponTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, line2.bottom + 5, self.width, 243)];
    [self.couponTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_couponTableView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
