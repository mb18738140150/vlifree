//
//  HomeViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"


@class CollectModel;
@interface HomeViewCell : MGSwipeTableCell

@property (nonatomic, strong)CollectModel * collectModel;
@property (nonatomic, strong)UIButton * IconButton;

- (void)createSubview:(CGRect)frame;
+ (CGFloat)cellHeigth;

@end
