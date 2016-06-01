//
//  StoreIntroHelpView.m
//  vlifree
//
//  Created by 仙林 on 16/3/23.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "StoreIntroHelpView.h"

#define LEFT_SPACE 10
#define TOP_SPACE 14
#define IMAGE_SIZE 14

#define LABEL_WIDTH 70
#define BUTTON_SIZE 21

@implementation StoreIntroHelpView

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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP_SPACE, LABEL_WIDTH, IMAGE_SIZE)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        UIView * linView = [[UIView alloc]initWithFrame:CGRectMake(_titleLabel.right, TOP_SPACE , 1, IMAGE_SIZE)];
        linView.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
        [self addSubview:linView];
        
        self.informationLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right + LEFT_SPACE, TOP_SPACE, self.width - LABEL_WIDTH - 3 * LEFT_SPACE - BUTTON_SIZE, IMAGE_SIZE)];
        self.informationLabel.textColor = [UIColor grayColor];
        _informationLabel.numberOfLines = 0;
        self.informationLabel.font = [UIFont systemFontOfSize:12];
        _informationLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_informationLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.width - TOP_SPACE - BUTTON_SIZE, self.height / 2 - 10, BUTTON_SIZE, BUTTON_SIZE);
        _button.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_button];
        
    }
}



@end
