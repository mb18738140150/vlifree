//
//  AlertLoginView.m
//  vlifree
//
//  Created by 仙林 on 15/6/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AlertLoginView.h"

#define TOP_SPACE 20
#define LEFT_SPACE 10
#define VIEW_HEIGHT 40
#define TEXTFILED_HEIGHT 30
#define IMAGE_SIZE 30
#define REGISTER_BUTTON_WIDTH 100

#define WEIXIN_BUTTON_WIDTH 65
#define WEIXIN_BUTTON_HEIGHT 95

//#define VIEW_COLOR [UIColor redColor]
#define VIEW_COLOR [UIColor clearColor]


@implementation AlertLoginView




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        [self createSubView];
    }
    return self;
}


- (void)createSubView
{
    if (!_passwordTF) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width - 40, 300)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10;
        [self addSubview:view];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(view.width - 25, 5, 20, 20);
        [button setBackgroundImage:[UIImage imageNamed:@"xx.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelLogIn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIView * phoneView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + button.bottom, view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
        phoneView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        phoneView.layer.borderWidth = 0.7;
        phoneView.layer.cornerRadius = 3;
        [view addSubview:phoneView];
        
        UIImageView * phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, (VIEW_HEIGHT - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
        phoneImage.image = [UIImage imageNamed:@"phone.png"];
        phoneImage.backgroundColor = VIEW_COLOR;
        [phoneView addSubview:phoneImage];
        self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneImage.right + 5, phoneImage.top, phoneView.width - 10 - phoneImage.right, IMAGE_SIZE)];
        _phoneTF.placeholder = @"手机号";
        _phoneTF.font = [UIFont systemFontOfSize:22];
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [phoneView addSubview:_phoneTF];
        
        UIView * passwordView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + phoneView.bottom, view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
        passwordView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        passwordView.layer.borderWidth = 0.7;
        passwordView.layer.cornerRadius = 3;
        [view addSubview:passwordView];
        
        UIImageView * passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, (VIEW_HEIGHT - IMAGE_SIZE) / 2, IMAGE_SIZE, IMAGE_SIZE)];
        passwordImage.image = [UIImage imageNamed:@"password.png"];
        passwordImage.backgroundColor = VIEW_COLOR;
        [passwordView addSubview:passwordImage];
        self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordImage.right + 5, passwordImage.top, passwordView.width - 10 - passwordImage.right, IMAGE_SIZE)];
        _passwordTF.placeholder = @"密码";
        _passwordTF.font = [UIFont systemFontOfSize:22];
        _passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:_passwordTF];
        
        
        self.logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logInButton.frame = CGRectMake(LEFT_SPACE, passwordView.bottom + TOP_SPACE, passwordView.width, VIEW_HEIGHT);
        _logInButton.backgroundColor = MAIN_COLOR;
        [_logInButton setTitle:@"登录" forState:UIControlStateNormal];
        [_logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:_logInButton];
        
        
        UIImageView * weixinImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WEIXIN_BUTTON_WIDTH, WEIXIN_BUTTON_WIDTH)];
        weixinImageV.image = [UIImage imageNamed:@"weixinLogIn.png"];
        UILabel * weixinLB = [[UILabel alloc] initWithFrame:CGRectMake(0, weixinImageV.bottom, WEIXIN_BUTTON_WIDTH, WEIXIN_BUTTON_HEIGHT - WEIXIN_BUTTON_WIDTH)];
        weixinLB.textAlignment = NSTextAlignmentCenter;
        weixinLB.text = @"微信登录";
        weixinLB.font = [UIFont systemFontOfSize:14];
        self.weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinButton.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _logInButton.bottom, WEIXIN_BUTTON_WIDTH, WEIXIN_BUTTON_HEIGHT);
        _weixinButton.center = CGPointMake(view.centerX, _weixinButton.centerY);
        //        _weixinButton.backgroundColor = MAIN_COLOR;
        [_weixinButton addSubview:weixinLB];
        [_weixinButton addSubview:weixinImageV];
        [view addSubview:_weixinButton];
        view.height = _weixinButton.bottom + 5;
        view.center = self.center;
    }

}

- (void)cancelLogIn:(UIButton *)button
{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
