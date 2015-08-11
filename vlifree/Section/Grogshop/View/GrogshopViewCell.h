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

@property (nonatomic, strong)HotelModel * hotelModel;

@property (nonatomic, strong)UIButton * IconButton;

- (void)createSubiew:(CGRect)frame;
+ (CGFloat)cellHeigthWithIsFirstReduce:(NSNumber *)isFirstReduce;


@end
