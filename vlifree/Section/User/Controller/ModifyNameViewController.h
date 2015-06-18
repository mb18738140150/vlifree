//
//  ModifyNameViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^RefreshUserInfo)();
@interface ModifyNameViewController : UIViewController

- (void)refreshUserName:(RefreshUserInfo)refreshBlock;


@end
