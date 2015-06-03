//
//  GrogshopHeaderView.h
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrogshopHeaderView : UIView


@property (nonatomic, strong)UIButton * allButton;
@property (nonatomic, strong)UIButton * priceButton;
@property (nonatomic, strong)UIButton * distanceButton;
@property (nonatomic, strong)UIButton * soldButton;

+ (CGFloat)viewHeight;

@end
