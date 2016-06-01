//
//  TOOrderViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeOutOrderMD.h"

typedef void(^DeleteBlock)();
typedef void(^AgainOrderBlock)();

@interface TOOrderViewCell : UITableViewCell


//@property (nonatomic, strong)UIButton * cancelButton;
@property (nonatomic, strong)TakeOutOrderMD * takeOutOrderMD;
@property (nonatomic, strong)UIButton * iconButton;


- (void)crateSubview:(CGRect)frame;
+ (CGFloat)cellHeight;

- (void)deleteOrderAction:(DeleteBlock)deleteBlock;
- (void)againOrderAction:(AgainOrderBlock)againBlock;

@end
