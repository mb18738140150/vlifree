//
//  ShoppingDetailsCarView.h
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingDetailsCarView : UIView


@property (nonatomic, strong)NSMutableArray * menusArray;
@property (nonatomic, strong)UIButton * shoppingCarBT;

@property (nonatomic, strong)NSNumber * sendPrice;

- (instancetype)initWithFrame:(CGRect)frame withMneusArray:(NSMutableArray *)menusArray;


@end
