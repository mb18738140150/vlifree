//
//  PayTypeView.h
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeView : UIView

/**
 *  支付logo
 */
@property (nonatomic, strong)UIImageView * iconView;
/**
 *  支付方式名
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *  选中支付的按钮
 */
@property (nonatomic, strong)UIButton * changeButton;



@end
