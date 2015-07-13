//
//  GSPayViewController.h
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPayViewController : UIViewController

@property (nonatomic, copy)NSString * orderID;

- (void)pushOrderDetailsVC;

@end
