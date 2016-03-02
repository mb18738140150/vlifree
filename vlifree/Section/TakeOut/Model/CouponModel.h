//
//  CouponModel.h
//  vlifree
//
//  Created by 仙林 on 15/10/19.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property (nonatomic, assign)int couponId;
@property (nonatomic, assign)double couponFace;
@property (nonatomic, copy)NSString * couponDate;
@property (nonatomic, assign)int couponRecordId;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
