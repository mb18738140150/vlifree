//
//  DetailsTOOrderViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeOutOrderMD.h"

@interface DetailsTOOrderViewController : UIViewController


@property (nonatomic, strong)TakeOutOrderMD * takeOutOrderMD;

- (void)downloadData;

@end
