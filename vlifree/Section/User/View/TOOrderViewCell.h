//
//  TOOrderViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOOrderViewCell : UITableViewCell


@property (nonatomic, strong)UIButton * cancelButton;
- (void)crateSubview:(CGRect)frame;
+ (CGFloat)cellHeight;


@end
