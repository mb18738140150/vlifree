



//
//  ShoppingDetailsCarView.m
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ShoppingDetailsCarView.h"
#import "ShoppingMenuView.h"
#import "MenuModel.h"

#define MENU_VIEW_HEIGHT 40
#define BOTTOM_SPACE 20
#define LEFT_SPACE 20
#define TOP_SPACE 10

#define OTHER_LABEL_WIDTH 80
#define PRICE_LABEL_WIDTH 150
#define PRICE_LABEL_HEIGHT 25
#define LABEL_HEIGHT 20
#define CHANGE_BUTTON_WIDTH 80
#define CHANGE_BUTTON_HEIGHT 25

#define CAR_BUTTON_SIZE 45
#define COUNT_LABEL_SIZE 20

#define CLEAR_BUTTON_WIDTH 100

//#define VIEW_COLOR [UIColor orangeColor]
#define VIEW_COLOR [UIColor clearColor]


@interface ShoppingDetailsCarView ()

//@property (nonatomic, strong)UILabel * otherPriceLB;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * countLabel;



@end





@implementation ShoppingDetailsCarView


- (NSMutableArray *)menusArray
{
    if (!_menusArray) {
        self.menusArray = [NSMutableArray array];
    }
    return _menusArray;
}


- (instancetype)initWithFrame:(CGRect)frame withMneusArray:(NSMutableArray *)menusArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
        self.menusArray = menusArray;
        [self createSubviewWithMenusArray:menusArray];
    }
    return self;
}


- (void)createSubviewWithMenusArray:(NSMutableArray *)array
{
    [self removeAllSubviews];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - array.count * MENU_VIEW_HEIGHT - LABEL_HEIGHT * 2 - BOTTOM_SPACE * 3, self.width, array.count * MENU_VIEW_HEIGHT + LABEL_HEIGHT * 2 + BOTTOM_SPACE * 3)];
    view.tag = 1000;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, self.height - BOTTOM_SPACE - LABEL_HEIGHT, PRICE_LABEL_WIDTH, PRICE_LABEL_HEIGHT)];
    _priceLabel.backgroundColor = VIEW_COLOR;
    _priceLabel.text = @"¥23";
    _priceLabel.font = [UIFont systemFontOfSize:22];
    _priceLabel.textColor = MAIN_COLOR;
    [self addSubview:_priceLabel];
    
    self.changeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBT.frame = CGRectMake(self.width - CHANGE_BUTTON_WIDTH - LEFT_SPACE, _priceLabel.top, CHANGE_BUTTON_WIDTH, CHANGE_BUTTON_HEIGHT);
    //        [_changeButton setTitle:@"选好了" forState:UIControlStateNormal];
    //        _changeButton.layer.backgroundColor = MAIN_COLOR.CGColor;
    [_changeBT setBackgroundImage:[UIImage imageNamed:@"change_n.png"] forState:UIControlStateNormal];
    [_changeBT setBackgroundImage:[UIImage imageNamed:@"change_d.png"] forState:UIControlStateDisabled];
    [self addSubview:_changeBT];
//    double allPrice = 0;
//    NSInteger allCount = 0;
    for (int i = 0; i < array.count; i++) {
        NSMutableArray * smallAry = [array objectAtIndex:i];
        MenuModel * menuMD = [smallAry firstObject];
        ShoppingMenuView * menuView = [[ShoppingMenuView alloc] initWithFrame:CGRectMake(0, _priceLabel.top - BOTTOM_SPACE - MENU_VIEW_HEIGHT * (i + 1), self.width, MENU_VIEW_HEIGHT)];
        [menuView.addButton addTarget:self action:@selector(addmenu:) forControlEvents:UIControlEventTouchUpInside];
        menuView.tag = 5000 + i;
        menuView.addButton.tag = 3000 + i;
        menuView.subtractBT.tag = 4000 + i;
        [menuView.subtractBT addTarget:self action:@selector(subtractMenu:) forControlEvents:UIControlEventTouchUpInside];
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        menuView.menuNameLB.text = menuMD.name;
        menuView.priceLabel.text = [NSString stringWithFormat:@"¥%g", [menuMD.price doubleValue] * smallAry.count];
//        allPrice += [menuMD.price doubleValue] * smallAry.count;
//        allCount += smallAry.count;
        menuView.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)smallAry.count];
        [self addSubview:menuView];
        if (i == array.count - 1) {
            break;
        }
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, menuView.top, self.width - 2 * LEFT_SPACE, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [self addSubview:lineView];
    }
    UIView * otherView = [[UIView alloc] initWithFrame:CGRectMake(0, _priceLabel.top - BOTTOM_SPACE - array.count * MENU_VIEW_HEIGHT - LABEL_HEIGHT - 2 * TOP_SPACE, self.width, LABEL_HEIGHT + TOP_SPACE)];
    otherView.tag = 2000;
    /*
    self.otherPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, OTHER_LABEL_WIDTH, LABEL_HEIGHT)];
//    _otherPriceLB.backgroundColor = [UIColor greenColor];
    _otherPriceLB.text = @"餐具费¥2";
    _otherPriceLB.textAlignment = NSTextAlignmentCenter;
    _otherPriceLB.textColor = [UIColor colorWithWhite:0.6 alpha:1];
//    [otherView addSubview:_otherPriceLB];
    */
    self.clearCarBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearCarBT.frame = CGRectMake(otherView.width - LEFT_SPACE - CLEAR_BUTTON_WIDTH, TOP_SPACE, CLEAR_BUTTON_WIDTH, LABEL_HEIGHT);
    [_clearCarBT setTitle:@"清空购物车" forState:UIControlStateNormal];
    [_clearCarBT setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
//    [_clearCarBT addTarget:self action:@selector(clearShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [otherView addSubview:_clearCarBT];
    [self addSubview:otherView];
    
    self.shoppingCarBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingCarBT.frame = CGRectMake(0, otherView.top - CAR_BUTTON_SIZE, CAR_BUTTON_SIZE, CAR_BUTTON_SIZE);
//    _shoppingCarBT.center = CGPointMake(_otherPriceLB.centerX, _shoppingCarBT.centerY);
    _shoppingCarBT.center = CGPointMake(LEFT_SPACE + OTHER_LABEL_WIDTH / 2, _shoppingCarBT.centerY);
    [_shoppingCarBT setBackgroundImage:[UIImage imageNamed:@"shoppingCar.png"] forState:UIControlStateNormal];
//    [_shoppingCarBT addTarget:self action:@selector(removeDetailsView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shoppingCarBT];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _shoppingCarBT.top, COUNT_LABEL_SIZE, COUNT_LABEL_SIZE)];
    _countLabel.center = CGPointMake(_shoppingCarBT.right, _countLabel.centerY);
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    _countLabel.text = [NSString stringWithFormat:@"%ld", (long)[self getAllCount]];
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.layer.cornerRadius = COUNT_LABEL_SIZE / 2;
    [self addSubview:_countLabel];
    double allPrice = [self getAllPrice];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%g", allPrice];
}


- (void)addmenu:(UIButton *)button
{
    NSMutableArray * smallAry = [self.menusArray objectAtIndex:button.tag - 3000];
    MenuModel * menu = [smallAry firstObject];
    menu.count += 1;
    [smallAry addObject:menu];
    ShoppingMenuView * menuView = (ShoppingMenuView *)button.superview;
    menuView.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)smallAry.count];
    if (self.sendPrice != nil) {
       self.priceLabel.text = [NSString stringWithFormat:@"¥%g(%@起送)", [self getAllPrice], self.sendPrice];
    }else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", [self getAllPrice]];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"¥%ld", (long)[self getAllCount]];
}

- (void)subtractMenu:(UIButton *)button
{
    NSMutableArray * smallAry = [self.menusArray objectAtIndex:button.tag - 4000];
    MenuModel * menuMD = [smallAry firstObject];
    menuMD.count -= 1;
    [smallAry removeLastObject];
    ShoppingMenuView * menuView = (ShoppingMenuView *)button.superview;
    menuView.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)smallAry.count];
    if (self.sendPrice != nil) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g(%@起送)", [self getAllPrice], self.sendPrice];
    }else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", [self getAllPrice]];
    }
    self.countLabel.text = [NSString stringWithFormat:@"¥%ld", (long)[self getAllCount]];
    if (smallAry.count == 0) {
        UIView * view = [self viewWithTag:1000];
        view.height = view.height - MENU_VIEW_HEIGHT;
        view.top = view.top + MENU_VIEW_HEIGHT;
        UIView * otherView = [self viewWithTag:2000];
        otherView.top += MENU_VIEW_HEIGHT;
        self.shoppingCarBT.top += MENU_VIEW_HEIGHT;
        self.countLabel.top += MENU_VIEW_HEIGHT;
        
        for (int i = 0; i < self.menusArray.count; i++) {
            ShoppingMenuView * menuV = (ShoppingMenuView *)[self viewWithTag:5000 + i];
            if (button.tag - 4000 < i) {
                menuV.top += MENU_VIEW_HEIGHT;
                menuV.tag -= 1;
                menuV.subtractBT.tag -= 1;
                menuV.addButton.tag -= 1;
            }
        }
        [self.menusArray removeObject:smallAry];
        [menuView removeFromSuperview];
    }
}


- (double)getAllPrice
{
    double allPrice = 0;
    for (int i = 0; i < self.menusArray.count; i++) {
        NSMutableArray * ary = [self.menusArray objectAtIndex:i];
        MenuModel * menu = [ary firstObject];
        allPrice += [menu.price doubleValue] * ary.count;
    }
    if (allPrice < [self.sendPrice doubleValue] || [self getAllCount] == 0) {
        self.changeBT.enabled = NO;
    }else
    {
        self.changeBT.enabled = YES;
    }
//    if (self.mealBoxMoney) {
////        allPrice += [self getAllCount] * self.mealBoxMoney.doubleValue;
//    }
    return allPrice;
}


- (NSInteger)getAllCount
{
    NSInteger allCount = 0;
    for (int i = 0; i < self.menusArray.count; i++) {
        NSMutableArray * ary = [self.menusArray objectAtIndex:i];
        allCount += ary.count;
    }
//    self.otherPriceLB.text = [NSString stringWithFormat:@"餐具费¥%g", self.mealBoxMoney.doubleValue * allCount];
    return allCount;
}

- (void)setSendPrice:(NSNumber *)sendPrice
{
    _sendPrice = sendPrice;
    if (sendPrice != nil) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g(%@起送)", [self getAllPrice], self.sendPrice];
    }else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", [self getAllPrice]];
    }
}

//- (void)setMealBoxMoney:(NSNumber *)mealBoxMoney
//{
//    _mealBoxMoney = mealBoxMoney;
//    self.otherPriceLB.text = [NSString stringWithFormat:@"餐具费¥%@", mealBoxMoney];
//    [self getAllPrice];
//}

- (void)removeDetailsView:(UIButton *)button
{
    [self removeFromSuperview];
}




- (void)dealloc
{
    NSLog(@"购物车销毁");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
