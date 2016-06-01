//
//  MSegmentControl.h
//  vlifree
//
//  Created by 仙林 on 16/3/26.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MSegmentedControlDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)mSegmentedControlSelectAtIndex:(NSInteger)index;

@end
@interface MSegmentControl : UIView

@property (assign, nonatomic) id<MSegmentedControlDelegate>delegate;
@property (nonatomic, assign)int selectIndex;
//初始化函数
- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate;

- (void)changeTitles:(NSArray *)titles;
//提供方法改变 index
- (void)changeSegmentedControlWithIndex:(NSInteger)index;

- (void)changetakeoutorderCount:(NSNumber *)orderCount;
- (void)changeorderCount:(NSNumber *)orderCount;
- (void)changecollectCount:(NSNumber *)collectCount;

@end
