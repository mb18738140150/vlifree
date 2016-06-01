
//
//  TypeView.m
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TypeView.h"
#import "StoreTypeModel.h"

#define BUTTON_WIDTH ([UIScreen mainScreen].bounds.size.width / 4)
#define LEFT_SPACE (BUTTON_WIDTH / 5)
#define TOP_SPACE 10
#define BUTTON_HEIGTH ([UIScreen mainScreen].bounds.size.width / 4)
#define IMAGE_SIZE (BUTTON_WIDTH * 3 / 5)
#define LABEL_HEIGTH (BUTTON_WIDTH / 5)
#define Text_Font [UIFont systemFontOfSize:14]
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
    NSArray * iconarr = @[@"美食.png",@"甜品、饮食.png",@"水果.png",@"超市.png", @"零食小吃.png", @"鲜花蛋糕.png", @"送药上门.png", @"蔬菜.png"];;
    NSArray * typetitleArr = @[@"美食",  @"甜品饮食", @"水果",@"超市",@"零食小吃", @"鲜花蛋糕", @"送药上门",  @"蔬菜"];
    
        
        UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, BUTTON_HEIGTH * 2 + 10)];
        aView.backgroundColor = [UIColor whiteColor];
        [self addSubview:aView];
        
    
        UIImageView * snacksImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        snacksImageV.image = [UIImage imageNamed:iconarr[0]];
        UILabel * snacksLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        snacksLB.textAlignment = NSTextAlignmentCenter;
        snacksLB.font = [UIFont systemFontOfSize:14];
        snacksLB.textColor = TEXT_COLOR;
    
    snacksLB.text = typetitleArr[0];
    snacksImageV.image = [UIImage imageNamed:iconarr[0]];
    
        self.snacksBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _snacksBT.frame = CGRectMake(0  , 0, BUTTON_WIDTH, BUTTON_HEIGTH);
        _snacksBT.backgroundColor = BUTTON_COLOR;
        [_snacksBT addSubview:snacksLB];
        [_snacksBT addSubview:snacksImageV];
        [aView addSubview:_snacksBT];
    
    
    
        UIImageView * fastFoodImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        fastFoodImageV.image = [UIImage imageNamed:iconarr[1]];
        UILabel * fastFoodLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        fastFoodLB.textAlignment = NSTextAlignmentCenter;
        fastFoodLB.font = Text_Font;
        fastFoodLB.textColor = TEXT_COLOR;
    fastFoodLB.text = typetitleArr[1];
    fastFoodImageV.image = [UIImage imageNamed:iconarr[1]];
        self.fastFoodBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _fastFoodBT.frame = CGRectMake( _snacksBT.right, 0, BUTTON_WIDTH, BUTTON_HEIGTH);
        _fastFoodBT.backgroundColor = BUTTON_COLOR;
        [_fastFoodBT addSubview:fastFoodLB];
        [_fastFoodBT addSubview:fastFoodImageV];
        [aView addSubview:_fastFoodBT];
        
    
    
    
        UIImageView * supermarketImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        supermarketImageV.image = [UIImage imageNamed:iconarr[2]];
        UILabel * supermarketLB = [[UILabel alloc] initWithFrame:CGRectMake(0, supermarketImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        supermarketLB.textAlignment = NSTextAlignmentCenter;
        supermarketLB.font = Text_Font;
        supermarketLB.textColor = TEXT_COLOR;
    supermarketLB.text = typetitleArr[2];
    supermarketImageV.image = [UIImage imageNamed:iconarr[2]];
        self.supermarketBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _supermarketBT.frame = CGRectMake(_fastFoodBT.right, 0, BUTTON_WIDTH, BUTTON_HEIGTH);
        _supermarketBT.backgroundColor = BUTTON_COLOR;
        [_supermarketBT addSubview:supermarketLB];
        [_supermarketBT addSubview:supermarketImageV];
        [aView addSubview:_supermarketBT];
        
    
    
           UIImageView * cakeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        cakeImageV.image = [UIImage imageNamed:iconarr[3]];
        UILabel * cakeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        cakeLB.textAlignment = NSTextAlignmentCenter;
        cakeLB.font = Text_Font;
        cakeLB.textColor = TEXT_COLOR;
    cakeLB.text = typetitleArr[3];
    cakeImageV.image = [UIImage imageNamed:iconarr[3]];
        self.cakeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _cakeBT.frame = CGRectMake( _supermarketBT.right, 0, BUTTON_WIDTH, BUTTON_HEIGTH);
        _cakeBT.backgroundColor = BUTTON_COLOR;
        [_cakeBT addSubview:cakeLB];
        [_cakeBT addSubview:cakeImageV];
        [aView addSubview:_cakeBT];
    
    
    
    
        UIImageView * milkTeaImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        milkTeaImageV.image = [UIImage imageNamed:iconarr[4]];
        UILabel * milkTeaLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        milkTeaLB.textAlignment = NSTextAlignmentCenter;
        milkTeaLB.font = Text_Font;
        milkTeaLB.textColor = TEXT_COLOR;
    milkTeaLB.text = typetitleArr[4];
    milkTeaImageV.image = [UIImage imageNamed:iconarr[4]];
        self.milkTeaBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _milkTeaBT.frame = CGRectMake(0,  _snacksBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _milkTeaBT.backgroundColor = BUTTON_COLOR;
        [_milkTeaBT addSubview:milkTeaLB];
        [_milkTeaBT addSubview:milkTeaImageV];
        [aView addSubview:_milkTeaBT];
    
    
    
    
        UIImageView * fruitImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        fruitImageV.image = [UIImage imageNamed:iconarr[5]];
        UILabel * fruitLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        fruitLB.textAlignment = NSTextAlignmentCenter;
        fruitLB.font = Text_Font;
        fruitLB.textColor = TEXT_COLOR;
    fruitLB.text = typetitleArr[5];
    fruitImageV.image = [UIImage imageNamed:iconarr[5]];
        self.fruitBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _fruitBT.frame = CGRectMake( _milkTeaBT.right, _fastFoodBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _fruitBT.backgroundColor = BUTTON_COLOR;
        [_fruitBT addSubview:fruitLB];
        [_fruitBT addSubview:fruitImageV];
        [aView addSubview:_fruitBT];
        
    
        UIImageView * dessertImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        dessertImageV.image = [UIImage imageNamed:iconarr[6]];
        UILabel * dessertLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        dessertLB.textAlignment = NSTextAlignmentCenter;
        dessertLB.font = Text_Font;
        dessertLB.textColor = TEXT_COLOR;
    dessertLB.text = typetitleArr[6];
    dessertImageV.image = [UIImage imageNamed:iconarr[6]];
        self.dessertBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _dessertBT.frame = CGRectMake( _fruitBT.right, _supermarketBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _dessertBT.backgroundColor = BUTTON_COLOR;
        [_dessertBT addSubview:dessertLB];
        [_dessertBT addSubview:dessertImageV];
        [aView addSubview:_dessertBT];
    
    
    
        UIImageView * pastaImageV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, LEFT_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
        pastaImageV.image = [UIImage imageNamed:iconarr[7]];
        UILabel * pastaLB = [[UILabel alloc] initWithFrame:CGRectMake(0, snacksImageV.bottom, BUTTON_WIDTH, LABEL_HEIGTH)];
        pastaLB.textAlignment = NSTextAlignmentCenter;
        pastaLB.font = Text_Font;
        pastaLB.textColor = TEXT_COLOR;
    pastaLB.text = typetitleArr[7];
    pastaImageV.image = [UIImage imageNamed:iconarr[7]];
        self.pastaBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _pastaBT.frame = CGRectMake( _dessertBT.right,  _cakeBT.bottom, BUTTON_WIDTH, BUTTON_HEIGTH);
        _pastaBT.backgroundColor = BUTTON_COLOR;
        [_pastaBT addSubview:pastaLB];
        [_pastaBT addSubview:pastaImageV];
        [aView addSubview:_pastaBT];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, aView.bottom - 0.3, aView.width, .3)];
        bottomView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
        [aView addSubview:bottomView];
        
        _snacksBT.tag = 9000;
        _fastFoodBT.tag = 9001;
        _supermarketBT.tag = 9002;
        _cakeBT.tag = 9003;
        _milkTeaBT.tag = 9004;
        _fruitBT.tag = 9005;
        _dessertBT.tag = 9006;
        _pastaBT.tag = 9007;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
