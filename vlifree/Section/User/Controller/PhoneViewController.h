//
//  PhoneViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/17.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshUserInfo)();
@interface PhoneViewController : UIViewController

- (void)refreshUserInfo:(RefreshUserInfo)refreshBlock;

@end
