//
//  UserInfo.h
//  vlifree
//
//  Created by 仙林 on 15/6/12.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy)NSString * name;
@property (nonatomic, strong)NSNumber * phoneNumber;
@property (nonatomic, strong)NSNumber * hotelOrderCount;
@property (nonatomic, strong)NSNumber * wakeoutOrderCount;
@property (nonatomic, strong)NSNumber * userId;
@property (nonatomic, copy)NSString * servicePhone;
+ (UserInfo *)shareUserInfo;
- (void)setPropertyWithDictionary:(NSDictionary *)dic;



@end
