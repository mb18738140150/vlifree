//
//  TakeOutViewController.h
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
@interface TakeOutViewController : UIViewController
/**
 *  是否是微超市按钮跳转过来的
 */
@property(nonatomic, assign)BOOL isSupermark;
/**
 *  数据请求方法
 *
 *  @param command 命令数字
 *  @param page    数据页数
 *  @param count   每页数据的个数
 *  @param type    数据请求类型
 */
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count type:(int)type;

@end
