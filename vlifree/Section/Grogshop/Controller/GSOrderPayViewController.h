//
//  GSOrderPayViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSOrderPayViewController : UIViewController


@property (nonatomic, copy)NSString * roomName;
@property (nonatomic, strong)NSNumber * price;
@property (nonatomic, strong)NSNumber * roomId;

- (void)pushOrderDetailsVC;

@end
