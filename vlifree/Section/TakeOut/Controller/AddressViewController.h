//
//  AddressViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
typedef void(^ReturnAddresssModelBlock)(AddressModel * addressModel);

@interface AddressViewController : UIViewController

/**
 *  选择地址成功后回调方法
 *
 *  @param addressBlock 地址回调block
 */
- (void)returnAddressModel:(ReturnAddresssModelBlock)addressBlock;



@end
