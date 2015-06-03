//
//  AddressViewCell.h
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
@interface AddressViewCell : UITableViewCell

@property (nonatomic, strong)AddressModel * addressModel;

- (void)createSubview:(CGRect)frame;
+ (CGFloat)cellHeightFrome:(NSString *)address frame:(CGRect)frame;


@end
