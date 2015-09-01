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
/**
 *  收藏商店模型
 */
@property (nonatomic, strong)CollectModel * collectModel;
/**
 *  商店图片放大按钮
 */
@property (nonatomic, strong)UIButton * IconButton;
/**
 *  加载子试图的方法
 *
 *  @param frame tableView的frame
 */
- (void)createSubview:(CGRect)frame;
/**
 *  cell的高度
 *
 *  @return 高度
 */
+ (CGFloat)cellHeigth;

@end
