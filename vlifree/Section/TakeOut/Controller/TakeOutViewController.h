//
//  TakeOutViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeOutViewController : UIViewController

@property(nonatomic, assign)BOOL isSupermark;
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count type:(int)type;

@end
