//
//  ClassModel.h
//  vlifree
//
//  Created by 仙林 on 15/6/16.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

@property (nonatomic, strong)NSNumber * Id;
@property (nonatomic, copy)NSString * title;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
