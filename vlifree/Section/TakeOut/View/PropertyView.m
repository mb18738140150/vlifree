//
//  PropertyView.m
//  vlifree
//
//  Created by 仙林 on 15/12/26.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PropertyView.h"

#define LEFT_SPACE 10
#define TOP_SPACE 5
#define LABEL_HEIGHT 20
#define FONT_LABEL [UIFont systemFontOfSize:15]
#define BUTTON_SIZE 30
@implementation PropertyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, self.width * 2 / 5 - LEFT_SPACE, LABEL_HEIGHT)];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right, _nameLabel.top, self.width / 5, LABEL_HEIGHT)];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = MAIN_COLOR;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_priceLabel];
    
    self.integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.right, _priceLabel.top, self.width / 10, LABEL_HEIGHT)];
    _integralLabel.layer.cornerRadius = 5;
    _integralLabel.layer.masksToBounds = YES;
    _integralLabel.adjustsFontSizeToFitWidth = YES;
    _integralLabel.textColor = [UIColor whiteColor];
    _integralLabel.backgroundColor = MAIN_COLOR;
    _integralLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_integralLabel];
    
    self.subtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _subtractButton.frame = CGRectMake(_integralLabel.right, 0, BUTTON_SIZE, BUTTON_SIZE);
//    [_subtractButton setImage:[UIImage imageNamed:@"subtract.png"] forState:UIControlStateNormal];
    [_subtractButton setBackgroundImage:[UIImage imageNamed:@"subtract.png"] forState:UIControlStateNormal];
    [self addSubview:_subtractButton];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(_subtractButton.right, _integralLabel.top, self.width - _subtractButton.right - BUTTON_SIZE, LABEL_HEIGHT)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_countLabel];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addButton.frame = CGRectMake(_countLabel.right, 0, BUTTON_SIZE, BUTTON_SIZE) ;
    [_addButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
//    [_addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self addSubview:_addButton];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
