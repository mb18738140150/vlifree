//
//  TakeOutViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface TakeOutViewCell : MGSwipeTableCell

@property (nonatomic, strong)UIButton * IconButton;

- (void)createSubview:(CGRect)frame;
+ (CGFloat)cellHeight;


@end
