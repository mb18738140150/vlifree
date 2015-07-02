//
//  TakeOutOrderViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeOutOrderViewController : UIViewController

@property (nonatomic, copy)NSString * storeName;

@property (nonatomic, copy)NSDictionary * orderDic;

@property (nonatomic, strong)NSMutableArray * shopArray;

@property (nonatomic, strong)NSNumber * takeOutId;

@property (nonatomic, strong)NSNumber * mealBoxMoney;


- (void)pushFinishOrderVC;

@end
