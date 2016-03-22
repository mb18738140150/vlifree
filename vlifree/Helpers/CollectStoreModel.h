//
//  CollectStoreModel.h
//  vlifree
//
//  Created by 仙林 on 16/3/22.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectStoreModel : NSObject
/**
 *  商店id
 */
@property (nonatomic, assign)int businessId;
/**
 *  商店名
 */
@property (nonatomic, copy)NSString * businessName;
/**
 *  商店类型 1.酒店 2.外卖
 */
@property (nonatomic, assign)int  businessType;
@end
