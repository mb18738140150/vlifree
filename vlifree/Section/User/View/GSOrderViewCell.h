//
//  GSOrderViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrogshopOrderMD.h"

typedef void(^CancleOrderBlock)();
typedef void(^PushBlock)();

@interface GSOrderViewCell : UITableViewCell



@property (nonatomic, strong)UIButton * payButton;
@property (nonatomic, strong)GrogshopOrderMD * grogshopOrderMD;

- (void)createSubview:(CGRect)frame;

- (void)setBlock:(PushBlock)block;
- (void)cancleOrderAction:(CancleOrderBlock)cancleBlock;

@end
