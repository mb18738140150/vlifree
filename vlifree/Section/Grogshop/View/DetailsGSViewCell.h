//
//  DetailsGSViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomModel;
@interface DetailsGSViewCell : UITableViewCell
/**
 *  房间Model
 */
@property (nonatomic, strong)RoomModel * roomModel;
/**
 *  房间预订按钮
 */
@property (nonatomic, strong)UIButton * reserveButton;
/**
 *  房间图片放大按钮
 */
@property (nonatomic, strong)UIButton * iconButton;
/**
 *  房间列表单元格(cell)试图加载
 *
 *  @param frame 房间试图列表(tableView)frame
 */
- (void)createSubviewWithFrame:(CGRect)frame;
/**
 *  房间列表单元格(cell)高度
 *
 *  @return cell的高度
 */
+ (CGFloat)cellHeight;

@end
