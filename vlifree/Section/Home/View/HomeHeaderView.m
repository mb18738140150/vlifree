//
//  HomeHeaderView.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HomeHeaderView.h"


#define LEFT_SPACE (self.width - 3 * BUTTON_WIDTH) / 4
#define TOP_SPACE 20
#define BUTTON_WIDTH 60
#define BUTTON_HEIGTH 100
#define IMAGE_SIZE BUTTON_WIDTH
#define LABEL_HEIGTH BUTTON_HEIGTH - IMAGE_SIZE

//#define BUTTON_COLOR [UIColor redColor]
#define BUTTON_COLOR [UIColor clearColor]

@implementation HomeHeaderView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubview];
    }
    return self;
}

- (void)createSubview
{
    if (!_grogshopBT) {
        
        UIImageView * grogshopImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        grogshopImageV.image = [UIImage imageNamed:@"home_grogshop.png"];
        UILabel * grogshopLB = [[UILabel alloc] initWithFrame:CGRectMake(0, grogshopImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        grogshopLB.textAlignment = NSTextAlignmentCenter;
        grogshopLB.text = @"微酒店";
        self.grogshopBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _grogshopBT.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _grogshopBT.backgroundColor = BUTTON_COLOR;
        [_grogshopBT addSubview:grogshopLB];
        [_grogshopBT addSubview:grogshopImageV];
        [self addSubview:_grogshopBT];
        
        UIImageView * takeOutImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        takeOutImageV.image = [UIImage imageNamed:@"home_takeOut.png"];
        UILabel * takeOutLB = [[UILabel alloc] initWithFrame:CGRectMake(0, takeOutImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        takeOutLB.textAlignment = NSTextAlignmentCenter;
        takeOutLB.text = @"微外卖";
        
        self.takeOutBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _takeOutBT.frame = CGRectMake(_grogshopBT.right + LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _takeOutBT.backgroundColor = BUTTON_COLOR;
        [_takeOutBT addSubview:takeOutImageV];
        [_takeOutBT addSubview:takeOutLB];
        [self addSubview:_takeOutBT];
        
        UIImageView * supermarketImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        supermarketImageV.image = [UIImage imageNamed:@"superMarket.png"];
        UILabel * supermarketLB = [[UILabel alloc] initWithFrame:CGRectMake(0, supermarketImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        supermarketLB.textAlignment = NSTextAlignmentCenter;
        supermarketLB.text = @"微超市";
        
        self.supermarketBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _supermarketBT.frame = CGRectMake(_takeOutBT.right + LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _supermarketBT.backgroundColor = BUTTON_COLOR;
        [_supermarketBT addSubview:supermarketImageV];
        [_supermarketBT addSubview:supermarketLB];
        [self addSubview:_supermarketBT];
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
