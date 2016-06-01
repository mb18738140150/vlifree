//
//  StoreTypeModel.h
//  vlifree
//
//  Created by 仙林 on 16/4/8.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreTypeModel : NSObject

@property (nonatomic, copy)NSString * storeTypeName;
@property (nonatomic, assign)int storeTypeId;

- (id)initWithDictionary:(NSDictionary *)dic;
@end
