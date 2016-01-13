//
//  CouponTableViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"


@interface CouponTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * dateLabel;
@property (nonatomic, strong)UILabel * faceLabel;
@property (nonatomic, strong)UIImageView * imageStateview;

@property (nonatomic, strong)CouponModel * couponModel;

- (void)createSubview:(CGRect)frame;


@end
