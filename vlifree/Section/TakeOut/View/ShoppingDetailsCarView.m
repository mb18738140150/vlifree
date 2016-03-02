



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
#import "PropertyModel.h"

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

@property (nonatomic, strong)UIScrollView * scrollview;

@property (nonatomic, assign)int menuNumber;

@property (nonatomic, strong)NSMutableArray * menuPropertyArry;

@end





@implementation ShoppingDetailsCarView


- (NSMutableArray *)menusArray
{
    if (!_menusArray) {
        self.menusArray = [NSMutableArray array];
    }
    return _menusArray;
}

- (NSMutableArray *)menuPropertyArry
{
    if (!_menuPropertyArry ) {
        self.menuPropertyArry = [NSMutableArray array];
    }
    return _menuPropertyArry;
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
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _priceLabel.top - BOTTOM_SPACE - MENU_VIEW_HEIGHT * (array.count), self.width, MENU_VIEW_HEIGHT * (array.count))];
    [self addSubview:_scrollview];
    _scrollview.backgroundColor = [UIColor clearColor];
    
    self.menuNumber = 0;
    
    if (self.menuPropertyArry.count != 0) {
        [self.menuPropertyArry removeAllObjects];
    }
    
    for (int i = 0; i < array.count; i++) {
//        NSMutableArray * smallAry = [array objectAtIndex:i];
//        MenuModel * menuMD = [smallAry firstObject];
        MenuModel * menuMD = [array objectAtIndex:i];
        NSLog(@"*************%@", menuMD.name);
        
        if (menuMD.PropertyList.count != 0) {
            
            for (int j = 0; j < menuMD.PropertyList.count; j++) {
                PropertyModel * propertyModel = [menuMD.PropertyList objectAtIndex:j];
                if (propertyModel.count == 0) {
                    ;
                }else
                {
                    [self.menuPropertyArry addObject:propertyModel];
                    ShoppingMenuView * menuView = [[ShoppingMenuView alloc] initWithFrame:CGRectMake(0,  MENU_VIEW_HEIGHT * (_menuNumber), self.width, MENU_VIEW_HEIGHT)];
                    [menuView.addButton addTarget:self action:@selector(addmenu:) forControlEvents:UIControlEventTouchUpInside];
                    menuView.tag = 5000 + i;
                    menuView.addButton.tag = 3000 + _menuNumber;
                    menuView.subtractBT.tag = 4000 + _menuNumber;
                    [menuView.subtractBT addTarget:self action:@selector(subtractMenu:) forControlEvents:UIControlEventTouchUpInside];
                    menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
                    
                    
                    menuView.menuNameLB.text = [NSString stringWithFormat:@"%@(%@)", menuMD.name, propertyModel.styleName];
                    menuView.priceLabel.text = [NSString stringWithFormat:@"¥%g", propertyModel.stylePrice * propertyModel.count];
                    //        allPrice += [menuMD.price doubleValue] * smallAry.count;
                    //        allCount += smallAry.count;
                    menuView.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)propertyModel.count];
                    
                    [_scrollview addSubview:menuView];
                    //                if (i == array.count - 1) {
                    //                    break;
                    //                }
                    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, menuView.bottom - 1, self.width - 2 * LEFT_SPACE, 1)];
                    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
                    [_scrollview addSubview:lineView];
                    
                    _menuNumber++;
                }
            }

        }else
        {
            [self.menuPropertyArry addObject:menuMD];
            ShoppingMenuView * menuView = [[ShoppingMenuView alloc] initWithFrame:CGRectMake(0,  MENU_VIEW_HEIGHT * (_menuNumber), self.width, MENU_VIEW_HEIGHT)];
            [menuView.addButton addTarget:self action:@selector(addmenu:) forControlEvents:UIControlEventTouchUpInside];
            menuView.tag = 5000 + i;
            menuView.addButton.tag = 3000 + _menuNumber;
            menuView.subtractBT.tag = 4000 + _menuNumber;
            [menuView.subtractBT addTarget:self action:@selector(subtractMenu:) forControlEvents:UIControlEventTouchUpInside];
            menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            
            
            menuView.menuNameLB.text = menuMD.name;
            menuView.priceLabel.text = [NSString stringWithFormat:@"¥%g", [menuMD.price doubleValue] * menuMD.count];
            //        allPrice += [menuMD.price doubleValue] * smallAry.count;
            //        allCount += smallAry.count;
            menuView.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)menuMD.count];
            
            [_scrollview addSubview:menuView];
            _menuNumber++;
            if (i == array.count - 1) {
                break;
            }
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, menuView.bottom - 1, self.width - 2 * LEFT_SPACE, 1)];
            lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
            [_scrollview addSubview:lineView];
        }
        
    }
    view.frame = CGRectMake(0, self.height - _menuNumber * MENU_VIEW_HEIGHT - LABEL_HEIGHT * 2 - BOTTOM_SPACE * 3, self.width, _menuNumber * MENU_VIEW_HEIGHT + LABEL_HEIGHT * 2 + BOTTOM_SPACE * 3);
    self.scrollview.frame = CGRectMake(0, _priceLabel.top - BOTTOM_SPACE - MENU_VIEW_HEIGHT * (_menuNumber), self.width, MENU_VIEW_HEIGHT * (_menuNumber));
    
    UIView * otherView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollview.top - LABEL_HEIGHT - 2 * TOP_SPACE, self.width, LABEL_HEIGHT + TOP_SPACE)];
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
//    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.layer.cornerRadius = COUNT_LABEL_SIZE / 2;
    [self addSubview:_countLabel];
    double allPrice = [self getAllPrice];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%g", allPrice];
    
    if (_shoppingCarBT.top <= 0) {
        _shoppingCarBT.frame = CGRectMake(0, 0, CAR_BUTTON_SIZE, CAR_BUTTON_SIZE);
        _shoppingCarBT.center = CGPointMake(LEFT_SPACE + OTHER_LABEL_WIDTH / 2, _shoppingCarBT.centerY);
        view.frame = CGRectMake(0, _shoppingCarBT.bottom, self.width, self.height - _shoppingCarBT.bottom);
        self.countLabel.frame = CGRectMake(0, _shoppingCarBT.top, COUNT_LABEL_SIZE, COUNT_LABEL_SIZE);
        _countLabel.center = CGPointMake(_shoppingCarBT.right, _countLabel.centerY);
        otherView.frame = CGRectMake(0, _shoppingCarBT.bottom , self.width, LABEL_HEIGHT + TOP_SPACE);
        _scrollview.frame = CGRectMake(0, otherView.bottom + TOP_SPACE, self.width, self.height - _shoppingCarBT.height - otherView.height - TOP_SPACE - _priceLabel.height - 2 * BOTTOM_SPACE);
        _scrollview.contentSize = CGSizeMake(self.width, _menuNumber * MENU_VIEW_HEIGHT);
    }
    
}


- (void)addmenu:(UIButton *)button
{
    ShoppingMenuView * menuView = (ShoppingMenuView *)button.superview;
    
    id  model = [self.menuPropertyArry objectAtIndex:button.tag - 3000];
//    MenuModel * menu = [smallAry firstObject];
    if ([model isKindOfClass:[MenuModel class]]) {
        for (MenuModel * menuMD in self.menusArray) {
            if ([model isEqual:menuMD]) {
                menuMD.count++;
                menuView.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)menuMD.count];
                break;
            }
        }
    }else
    {
        for (MenuModel * menuMD in self.menusArray) {
            for (PropertyModel * proModel in menuMD.PropertyList) {
                if ([model isEqual:proModel]) {
                    proModel.count++;
                    menuMD.count++;
                    menuView.countLabel.text = [NSString stringWithFormat:@"%d", proModel.count];
                    break;
                }
            }
        }
    }
//    menu.count += 1;
//    [smallAry addObject:menu];
//    menuView.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)smallAry.count];
    if (self.sendPrice != nil) {
       self.priceLabel.text = [NSString stringWithFormat:@"¥%g(%@起送)", [self getAllPrice], self.sendPrice];
    }else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", [self getAllPrice]];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)[self getAllCount]];
}

- (void)subtractMenu:(UIButton *)button
{
    BOOL isHave = NO;
    
    ShoppingMenuView * menuView = (ShoppingMenuView *)button.superview;
    
    id  model = [self.menuPropertyArry objectAtIndex:button.tag - 4000];
    if ([model isKindOfClass:[MenuModel class]]) {
        for (int i = 0; i < self.menusArray.count; i++) {
            MenuModel * menuMD = [self.menusArray objectAtIndex:i];
            if ([model isEqual:menuMD]) {
                menuMD.count--;
                menuView.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)menuMD.count];
                if (menuMD.count == 0) {
                    [self.menusArray removeObject:menuMD];
                    [menuView removeFromSuperview];
                    isHave = YES;
                }
                break;
            }
        }
        
    }else
    {
        if (self.menusArray.count > 0) {
            for (int i = 0; i < self.menusArray.count; i++) {
                MenuModel * menuMD = [self.menusArray objectAtIndex:i];
                for (int j = 0; j < menuMD.PropertyList.count; j++) {
                    PropertyModel * proModel = [menuMD.PropertyList objectAtIndex:j];
                    if ([model isEqual:proModel]) {
                        if (proModel.count > 0) {
                            proModel.count--;
                            menuMD.count--;
                            menuView.countLabel.text = [NSString stringWithFormat:@"%d", proModel.count];
                            
                            if (proModel.count == 0) {
                                if (menuMD.count == 0) {
                                    [self.menusArray removeObject:menuMD];
                                }
                                [menuView removeFromSuperview];
                                isHave = YES;
                            }
                            break;
                        }
                    }
                }
            }
            
            
        }
    }
    if (self.sendPrice != nil) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g(%@起送)", [self getAllPrice], self.sendPrice];
    }else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", [self getAllPrice]];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)[self getAllCount]];
    
    
    
    if (isHave) {
        UIView * view = [self viewWithTag:1000];
        UIView * otherView = [self viewWithTag:2000];
        
        [_scrollview removeAllSubviews];
        if (self.menuPropertyArry.count != 0) {
            [self.menuPropertyArry removeAllObjects];
        }
        _menuNumber = 0;
        for (int i = 0; i < self.menusArray.count; i++) {
            MenuModel * menuMD = [self.menusArray objectAtIndex:i];
            NSLog(@"*************%@", menuMD.name);
            
            if (menuMD.PropertyList.count != 0) {
                
                for (int j = 0; j < menuMD.PropertyList.count; j++) {
                    PropertyModel * propertyModel = [menuMD.PropertyList objectAtIndex:j];
                    if (propertyModel.count <= 0) {
                        ;
                    }else
                    {
                        [self.menuPropertyArry addObject:propertyModel];
                        ShoppingMenuView * menuView = [[ShoppingMenuView alloc] initWithFrame:CGRectMake(0,  MENU_VIEW_HEIGHT * (_menuNumber), self.width, MENU_VIEW_HEIGHT)];
                        [menuView.addButton addTarget:self action:@selector(addmenu:) forControlEvents:UIControlEventTouchUpInside];
                        menuView.tag = 5000 + i;
                        menuView.addButton.tag = 3000 + _menuNumber;
                        menuView.subtractBT.tag = 4000 + _menuNumber;
                        [menuView.subtractBT addTarget:self action:@selector(subtractMenu:) forControlEvents:UIControlEventTouchUpInside];
                        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
                        
                        
                        menuView.menuNameLB.text = [NSString stringWithFormat:@"%@(%@)", menuMD.name, propertyModel.styleName];
                        menuView.priceLabel.text = [NSString stringWithFormat:@"¥%g", propertyModel.stylePrice * propertyModel.count];
                        menuView.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)propertyModel.count];
                        
                        [_scrollview addSubview:menuView];
                        
                        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, menuView.bottom - 1, self.width - 2 * LEFT_SPACE, 1)];
                        lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
                        [_scrollview addSubview:lineView];
                        
                        _menuNumber++;
                    }
                }
                
            }else
            {
                [self.menuPropertyArry addObject:menuMD];
                ShoppingMenuView * menuView = [[ShoppingMenuView alloc] initWithFrame:CGRectMake(0,  MENU_VIEW_HEIGHT * (_menuNumber), self.width, MENU_VIEW_HEIGHT)];
                [menuView.addButton addTarget:self action:@selector(addmenu:) forControlEvents:UIControlEventTouchUpInside];
                menuView.tag = 5000 + i;
                menuView.addButton.tag = 3000 + _menuNumber;
                menuView.subtractBT.tag = 4000 + _menuNumber;
                [menuView.subtractBT addTarget:self action:@selector(subtractMenu:) forControlEvents:UIControlEventTouchUpInside];
                menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
                
                
                menuView.menuNameLB.text = menuMD.name;
                menuView.priceLabel.text = [NSString stringWithFormat:@"¥%g", [menuMD.price doubleValue] * menuMD.count];
                //        allPrice += [menuMD.price doubleValue] * smallAry.count;
                //        allCount += smallAry.count;
                menuView.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)menuMD.count];
                
                [_scrollview addSubview:menuView];
                _menuNumber++;
                if (i == self.menusArray.count - 1) {
                    break;
                }
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, menuView.bottom - 1, self.width - 2 * LEFT_SPACE, 1)];
                lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
                [_scrollview addSubview:lineView];
            }
            
        }
        
        
        if (_menuNumber * MENU_VIEW_HEIGHT + _shoppingCarBT.height + otherView.height + TOP_SPACE + 2 * BOTTOM_SPACE + _priceLabel.height < self.height) {
            _scrollview.frame = CGRectMake(0, _priceLabel.top - BOTTOM_SPACE - MENU_VIEW_HEIGHT * _menuNumber, self.width, MENU_VIEW_HEIGHT * _menuNumber);
            _scrollview.contentSize = CGSizeMake(self.width, _menuNumber * MENU_VIEW_HEIGHT);
            otherView.frame = CGRectMake(0, _scrollview.top - LABEL_HEIGHT - 2 * TOP_SPACE, self.width, LABEL_HEIGHT + TOP_SPACE);
            _shoppingCarBT.frame = CGRectMake(0, otherView.top - CAR_BUTTON_SIZE, CAR_BUTTON_SIZE, CAR_BUTTON_SIZE);
            view.frame = CGRectMake(0, _shoppingCarBT.bottom, self.width, self.height - _shoppingCarBT.bottom);
            self.countLabel.frame = CGRectMake(0, _shoppingCarBT.top, COUNT_LABEL_SIZE, COUNT_LABEL_SIZE);
            _shoppingCarBT.center = CGPointMake(LEFT_SPACE + OTHER_LABEL_WIDTH / 2, _shoppingCarBT.centerY);
            _countLabel.center = CGPointMake(_shoppingCarBT.right, _countLabel.centerY);

        }else
        {
            _scrollview.contentSize = CGSizeMake(self.width, _menuNumber * MENU_VIEW_HEIGHT);
        }
        
    }
}


- (double)getAllPrice
{
    double allPrice = 0;
    for (int i = 0; i < self.menusArray.count; i++) {
//        NSMutableArray * ary = [self.menusArray objectAtIndex:i];
//        MenuModel * menu = [ary firstObject];
//        allPrice += [menu.price doubleValue] * ary.count;
        
        MenuModel * menuMD = [self.menusArray objectAtIndex:i];
        if (menuMD.PropertyList.count != 0) {
            for (PropertyModel * proPertyMD in menuMD.PropertyList) {
                allPrice += proPertyMD.stylePrice * proPertyMD.count;
            }
        }else
        {
            allPrice += [menuMD.price doubleValue] * menuMD.count;
        }
        
        
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
        MenuModel * menuMD = [self.menusArray objectAtIndex:i];
        allCount += menuMD.count;
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
