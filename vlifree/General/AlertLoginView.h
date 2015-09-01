//
//  AlertLoginView.h
//  vlifree
//
//  Created by 仙林 on 15/6/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertLoginView : UIView

/**
 *  手机号码输入框
 */
@property (nonatomic, strong)UITextField * phoneTF;
/**
 *  密码输入框
 */
@property (nonatomic, strong)UITextField * passwordTF;
/**
 *  登陆按钮
 */
@property (nonatomic, strong)UIButton * logInButton;
/**
 *  微信登陆按钮
 */
@property (nonatomic, strong)UIButton * weixinButton;


@end
