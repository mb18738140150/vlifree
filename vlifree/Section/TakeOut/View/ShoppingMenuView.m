//
//  ShoppingMenuView.m
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ShoppingMenuView.h"


#define LEFT_SPACE 10
#define TOP_SPACE 10

#define LABEL_HEIGHT 20
#define PRICE_LABEL_WIDTH 60
#define BUTTON_SIZE 30
#define COUNT_LABEL_SIZE BUTTON_SIZE

//#define VIEW_COLOR [UIColor magentaColor]
#define VIEW_COLOR [UIColor clearColor]


@interface ShoppingMenuView ()



@end


@implementation ShoppingMenuView


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
    if (!_menuNameLB) {
        self.menuNameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width - PRICE_LABEL_WIDTH - 3 * BUTTON_SIZE - 5 * LEFT_SPACE, LABEL_HEIGHT)];
        _menuNameLB.backgroundColor = VIEW_COLOR;
        _menuNameLB.adjustsFontSizeToFitWidth = YES;
        _menuNameLB.text = @"香干回锅肉";
        _menuNameLB.textColor = [UIColor grayColor];
        [self addSubview:_menuNameLB];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuNameLB.right + LEFT_SPACE, TOP_SPACE, PRICE_LABEL_WIDTH, LABEL_HEIGHT)];
        _priceLabel.textColor = MAIN_COLOR;
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.backgroundColor = VIEW_COLOR;
        _priceLabel.text = @"¥39";
        [self addSubview:_priceLabel];
        
        self.subtractBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _subtractBT.frame = CGRectMake(_priceLabel.right + 2 * LEFT_SPACE, (self.height - BUTTON_SIZE) / 2, BUTTON_SIZE, BUTTON_SIZE);
        [_subtractBT setBackgroundImage:[UIImage imageNamed:@"subtract.png"] forState:UIControlStateNormal];
        [self addSubview:_subtractBT];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subtractBT.right, _subtractBT.top, COUNT_LABEL_SIZE, COUNT_LABEL_SIZE)];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = @"34";
        [self addSubview:_countLabel];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(_countLabel.right, _subtractBT.top, BUTTON_SIZE, BUTTON_SIZE);
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        //        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        //        [_addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_addButton];
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
