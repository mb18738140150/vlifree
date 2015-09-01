//
//  HTTPPost.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/15.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol HTTPPostDelegate <NSObject>
/**
 *  网络数据请求成功返回
 *
 *  @param data 请求回来的数据
 */
- (void)refresh:(id)data;

@optional
/**
 *  网络请求失败
 *
 *  @param error 网络请求错误
 */
- (void)failWithError:(NSError *)error;


@end

@interface HTTPPost : NSObject<NSURLConnectionDelegate>
/**
 *  网络请求代理
 */
@property (nonatomic, assign) id<HTTPPostDelegate> delegate;
/**
 *  网络请求单例创建方法
 *
 *  @return 网络请求对象
 */
+ (HTTPPost *)shareHTTPPost;
/**
 *  post请求方法
 *
 *  @param urlString 请求URL
 *  @param body      请求体
 */
- (void)post:(NSString *)urlString HTTPBody:(NSData *)body;
/**
 *  get请求方法
 *
 *  @param urlString 请求URL
 */
- (void)getWithUrlStr:(NSString *)urlString;







@end
