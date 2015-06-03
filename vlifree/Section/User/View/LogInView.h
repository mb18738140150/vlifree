//
//  LogInView.h
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInView : UIView

@property (nonatomic, strong)UITextField * phoneTF;
@property (nonatomic, strong)UITextField * passwordTF;
@property (nonatomic, strong)UIButton * logInButton;
@property (nonatomic, strong)UIButton * registerButton;
@property (nonatomic, strong)UIButton * weixinButton;

- (void)textFiledResignFirstResponder;

@end
