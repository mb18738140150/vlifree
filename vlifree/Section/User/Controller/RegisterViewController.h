//
//  RegisterViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnUserInfo)(void);
@interface RegisterViewController : UIViewController

- (void)returnSucceedRegister:(ReturnUserInfo)returnBlock;

@end
