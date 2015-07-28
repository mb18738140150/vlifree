//
//  CreateCommentViewController.h
//  vlifree
//
//  Created by 仙林 on 15/7/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCommentViewController : UIViewController


@property (nonatomic, copy)NSString * icon;
@property (nonatomic, copy)NSString * storeName;
@property (nonatomic, copy)NSString * decribe;

@property (nonatomic, strong)NSNumber * storeId;
@property (nonatomic, copy)NSString * orderId;

@end
