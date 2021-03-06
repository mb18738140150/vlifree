//
//  DescribeView.m
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DescribeView.h"

#define LEFT_SPACE 20
#define IMAGE_SIZE 20
#define TOP_SPACE  (self.frame.size.height - IMAGE_SIZE) / 2

//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]

@implementation DescribeView


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
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
    _iconView.backgroundColor = VIEW_COLOR;
    [self addSubview:_iconView];
   
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 5, TOP_SPACE, self.width - _iconView.right - IMAGE_SIZE, IMAGE_SIZE)];
    _titleLable.font = [UIFont systemFontOfSize:15];
    _titleLable.textColor = TEXT_COLOR;
    _titleLable.backgroundColor = VIEW_COLOR;
    [self addSubview:_titleLable];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = self.bounds;
//    [_button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, self.height - 1, self.width - 2 * LEFT_SPACE, 1)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
