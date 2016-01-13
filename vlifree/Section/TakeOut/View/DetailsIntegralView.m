//
//  DetailsIntegralView.m
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "DetailsIntegralView.h"

@implementation DetailsIntegralView

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
    self.stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 22, 6, 6)];
    _stateImageView.image = [UIImage imageNamed:@"dian.png"];
    _stateImageView.layer.cornerRadius = 6;
    _stateImageView.layer.masksToBounds = YES;
    _stateImageView.hidden = YES;
    [self addSubview:_stateImageView];
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nameButton.frame = CGRectMake(_stateImageView.right + 12, 10, 150, 30) ;
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self addSubview:_nameButton];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
