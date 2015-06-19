//
//  WXLoginViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/18.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshUserInfo)();
@interface WXLoginViewController : UIViewController


- (void)refreshUserInfo:(RefreshUserInfo)refreshBlock;


@end
