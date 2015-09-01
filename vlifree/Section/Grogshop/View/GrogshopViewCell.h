//
//  GrogshopViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "HotelModel.h"


@interface GrogshopViewCell : MGSwipeTableCell
/**
 *  酒店模型
 */
@property (nonatomic, strong)HotelModel * hotelModel;
/**
 *  酒店图片放大按钮
 */
@property (nonatomic, strong)UIButton * IconButton;
/**
 *  酒店cell子试图加载方法
 *
 *  @param frame 酒店列表(tableView)frame
 */
- (void)createSubiew:(CGRect)frame;
/**
 *  酒店cell高度
 *
 *  @param isFirstReduce 是否有首单减免 1.有首单减免, 2.没有.
 *
 *  @return 返回酒店列表单元格高度(cell高度)
 */
+ (CGFloat)cellHeigthWithIsFirstReduce:(NSNumber *)isFirstReduce;


@end
