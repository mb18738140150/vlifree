//
//  UserViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@interface UserViewCell : UITableViewCell

@property (nonatomic, strong)UIButton * modifyBT;
@property (nonatomic, strong)UserModel * userModel;

- (void)createSubviewWithFrame:(CGRect)frame;
+ (CGFloat)cellHeight;

@end
