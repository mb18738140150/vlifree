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

@property (nonatomic, strong)RoomModel * roomModel;
@property (nonatomic, strong)UIButton * reserveButton;
@property (nonatomic, strong)UIButton * iconButton;

- (void)createSubviewWithFrame:(CGRect)frame;

+ (CGFloat)cellHeight;

@end
