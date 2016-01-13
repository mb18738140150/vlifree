//
//  BillingInfoView.m
//  vlifree
//
//  Created by 仙林 on 15/10/17.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "BillingInfoView.h"


#define LEFT_SPACE 10
#define TOP_SPACE 5
#define IMAGE_SIZE 30

#define LABEL_WIDTH 150
#define BUTTON_SIZE 100

@implementation BillingInfoView

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
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOP_SPACE, TOP_SPACE, self.width - 2 * TOP_SPACE - BUTTON_SIZE, IMAGE_SIZE)];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.width - TOP_SPACE - BUTTON_SIZE, _titleLabel.top, BUTTON_SIZE, 30);
        _button.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_button];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_button.right - 25, _button.top + 5, 15, 20)];
        _imageView.image = [UIImage imageNamed:@"image_gray.png"];
        _imageView.hidden = YES;
        [self addSubview:_imageView];
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
