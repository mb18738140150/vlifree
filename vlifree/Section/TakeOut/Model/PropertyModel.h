//
//  PropertyModel.h
//  vlifree
//
//  Created by 仙林 on 15/12/26.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyModel : NSObject
@property (nonatomic, assign)int count;
@property (nonatomic, assign)int styleId;
@property (nonatomic, strong)NSString * styleName;
@property (nonatomic, assign)double stylePrice;
@property (nonatomic, assign)int styleIntegral;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
