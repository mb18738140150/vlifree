//
//  TWButton.m
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TWButton.h"

@implementation TWButton


+ (id)buttonWithType:(UIButtonType)buttonType
{
    UIButton * button = [UIButton buttonWithType:buttonType];
    if (button) {
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        button.imageView.contentMode = UIViewContentModeLeft;
    }
    return button;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width - 30;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    contentRect = CGRectMake(titleX, titleY, titleW, titleH);
    return contentRect;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 30;
    CGFloat imageH = 30;
    CGFloat imageX = contentRect.size.width - 31;
    CGFloat imageY = 2.5;
    contentRect = CGRectMake(imageX, imageY, imageW, imageH);
    return contentRect;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
