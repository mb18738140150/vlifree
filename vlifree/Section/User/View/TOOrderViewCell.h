//
//  TOOrderViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeOutOrderMD.h"

@interface TOOrderViewCell : UITableViewCell


@property (nonatomic, strong)UIButton * cancelButton;
@property (nonatomic, strong)TakeOutOrderMD * takeOutOrderMD;
- (void)crateSubview:(CGRect)frame;
+ (CGFloat)cellHeight;


@end
