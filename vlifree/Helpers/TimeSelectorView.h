//
//  TimeSelectorView.h
//  vlifree
//
//  Created by 仙林 on 16/1/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectComplate)(NSString * date);
@interface TimeSelectorView : UIView

- (instancetype)initWithDateArray:(NSArray *)array;

- (void)finishSelectComplete:(SelectComplate)selectBlock;

@end
