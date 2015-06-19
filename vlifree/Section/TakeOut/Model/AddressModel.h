//
//  AddressModel.h
//  vlifree
//
//  Created by 仙林 on 15/5/29.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, copy)NSString * address;
@property (nonatomic, copy)NSString * phoneNumber;
@property (nonatomic, strong)NSNumber * addressId;
@property (nonatomic, strong)NSNumber * isDefault;
@property (nonatomic, assign)BOOL selete;
- (id)initWithDictionary:(NSDictionary *)dic;


@end
