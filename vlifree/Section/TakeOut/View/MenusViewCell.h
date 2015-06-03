//
//  MenusViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenusViewCell : UITableViewCell


@property (nonatomic, strong)UILabel * countLabel;
@property (nonatomic, strong)UIButton * subtractBT;
@property (nonatomic, strong)UIButton * addButton;

- (void)createSubview:(CGRect)frame;
+ (CGFloat)cellHeight;


@end
