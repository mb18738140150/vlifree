//
//  AddAddressViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
typedef void(^RefreshDataBlock)();
@interface AddAddressViewController : UIViewController

/**
 *  地址Model
 */
@property(nonatomic, strong)AddressModel * addressModel;
/**
 *  添加地址成功后回调方法
 *
 *  @param refreshBlock 回调block
 */
- (void)successBack:(RefreshDataBlock)refreshBlock;

@end
