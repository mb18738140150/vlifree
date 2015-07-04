
//
//  TypeView.m
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TypeView.h"


#define LEFT_SPACE (self.width - 4 * BUTTON_WIDTH) / 5
#define TOP_SPACE 10
#define BUTTON_WIDTH 35
#define BUTTON_HEIGTH 55
#define IMAGE_SIZE BUTTON_WIDTH
#define LABEL_HEIGTH BUTTON_HEIGTH - IMAGE_SIZE

//#define BUTTON_COLOR [UIColor redColor]
#define BUTTON_COLOR [UIColor clearColor]

@implementation TypeView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    if (!_cakeBT) {
        
        UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, BUTTON_HEIGTH * 2 + TOP_SPACE * 3)];
        aView.backgroundColor = [UIColor whiteColor];
        [self addSubview:aView];
        
        
        UIImageView * snacksImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        snacksImageV.image = [UIImage imageNamed:@"snacks.png"];
        UILabel * snacksLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        snacksLB.textAlignment = NSTextAlignmentCenter;
        snacksLB.text = @"零食";
        snacksLB.textColor = TEXT_COLOR;
        self.snacksBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _snacksBT.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _snacksBT.backgroundColor = BUTTON_COLOR;
        [_snacksBT addSubview:snacksLB];
        [_snacksBT addSubview:snacksImageV];
        [aView addSubview:_snacksBT];
        
        UIImageView * fastFoodImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        fastFoodImageV.image = [UIImage imageNamed:@"fastFood.png"];
        UILabel * fastFoodLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        fastFoodLB.textAlignment = NSTextAlignmentCenter;
        fastFoodLB.text = @"快餐";
        fastFoodLB.textColor = TEXT_COLOR;
        self.fastFoodBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _fastFoodBT.frame = CGRectMake(LEFT_SPACE + _snacksBT.right, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _fastFoodBT.backgroundColor = BUTTON_COLOR;
        [_fastFoodBT addSubview:fastFoodLB];
        [_fastFoodBT addSubview:fastFoodImageV];
        [aView addSubview:_fastFoodBT];
        
        
        UIImageView * supermarketImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        supermarketImageV.image = [UIImage imageNamed:@"mark.png"];
        UILabel * supermarketLB = [[UILabel alloc] initWithFrame:CGRectMake(0, supermarketImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        supermarketLB.textAlignment = NSTextAlignmentCenter;
        supermarketLB.text = @"超市";
        supermarketLB.textColor = TEXT_COLOR;
        self.supermarketBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _supermarketBT.frame = CGRectMake(LEFT_SPACE + _fastFoodBT.right, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _supermarketBT.backgroundColor = BUTTON_COLOR;
        [_supermarketBT addSubview:supermarketLB];
        [_supermarketBT addSubview:supermarketImageV];
        [aView addSubview:_supermarketBT];
        
        
        UIImageView * cakeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        cakeImageV.image = [UIImage imageNamed:@"cake.png"];
        UILabel * cakeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        cakeLB.textAlignment = NSTextAlignmentCenter;
        cakeLB.text = @"蛋糕";
        cakeLB.textColor = TEXT_COLOR;
        self.cakeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _cakeBT.frame = CGRectMake(LEFT_SPACE + _supermarketBT.right, TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGTH);
        _cakeBT.backgroundColor = BUTTON_COLOR;
        [_cakeBT addSubview:cakeLB];
        [_cakeBT addSubview:cakeImageV];
        [aView addSubview:_cakeBT];
        
        UIImageView * milkTeaImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        milkTeaImageV.image = [UIImage imageNamed:@"milkTea.png"];
        UILabel * milkTeaLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        milkTeaLB.textAlignment = NSTextAlignmentCenter;
        milkTeaLB.text = @"奶茶";
        milkTeaLB.textColor = TEXT_COLOR;
        self.milkTeaBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _milkTeaBT.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _snacksBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _milkTeaBT.backgroundColor = BUTTON_COLOR;
        [_milkTeaBT addSubview:milkTeaLB];
        [_milkTeaBT addSubview:milkTeaImageV];
        [aView addSubview:_milkTeaBT];
        
        UIImageView * fruitImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        fruitImageV.image = [UIImage imageNamed:@"fruit.png"];
        UILabel * fruitLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        fruitLB.textAlignment = NSTextAlignmentCenter;
        fruitLB.text = @"水果";
        fruitLB.textColor = TEXT_COLOR;
        self.fruitBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _fruitBT.frame = CGRectMake(LEFT_SPACE + _milkTeaBT.right, TOP_SPACE + _fastFoodBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _fruitBT.backgroundColor = BUTTON_COLOR;
        [_fruitBT addSubview:fruitLB];
        [_fruitBT addSubview:fruitImageV];
        [aView addSubview:_fruitBT];
        
        
        UIImageView * dessertImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        dessertImageV.image = [UIImage imageNamed:@"dessert.png"];
        UILabel * dessertLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        dessertLB.textAlignment = NSTextAlignmentCenter;
        dessertLB.text = @"甜品";
        dessertLB.textColor = TEXT_COLOR;
        self.dessertBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _dessertBT.frame = CGRectMake(LEFT_SPACE + _fruitBT.right, TOP_SPACE + _supermarketBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _dessertBT.backgroundColor = BUTTON_COLOR;
        [_dessertBT addSubview:dessertLB];
        [_dessertBT addSubview:dessertImageV];
        [aView addSubview:_dessertBT];
        
        UIImageView * pastaImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        pastaImageV.image = [UIImage imageNamed:@"pasta.png"];
        UILabel * pastaLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, IMAGE_SIZE, LABEL_HEIGTH)];
        pastaLB.textAlignment = NSTextAlignmentCenter;
        pastaLB.text = @"面食";
        pastaLB.textColor = TEXT_COLOR;
        self.pastaBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _pastaBT.frame = CGRectMake(LEFT_SPACE + _dessertBT.right, TOP_SPACE + _cakeBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _pastaBT.backgroundColor = BUTTON_COLOR;
        [_pastaBT addSubview:pastaLB];
        [_pastaBT addSubview:pastaImageV];
        [aView addSubview:_pastaBT];
        
        _snacksBT.tag = 9000;
        _fastFoodBT.tag = 9001;
        _supermarketBT.tag = 9002;
        _cakeBT.tag = 9003;
        _milkTeaBT.tag = 9004;
        _fruitBT.tag = 9005;
        _dessertBT.tag = 9006;
        _pastaBT.tag = 9007;
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
