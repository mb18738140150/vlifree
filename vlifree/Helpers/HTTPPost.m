//
//  HTTPPost.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/15.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HTTPPost.h"

static HTTPPost * httpPost = nil;


@interface HTTPPost ()

@property (nonatomic, retain) NSMutableData * data;
@property (nonatomic, retain) NSMutableArray * dataArray;

@end


@implementation HTTPPost


+ (HTTPPost *)shareHTTPPost
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpPost = [[HTTPPost alloc] init];
    });
    return httpPost;
}


- (void)getWithUrlStr:(NSString *)urlString
{
    NSString * newUrlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSLog(@"%@", newUrlStr);
    //把字符创转成URL对象
    NSURL * url = [NSURL URLWithString:newUrlStr];
    //根据URL创建一个请求
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //和服务器建立异步连接
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)post:(NSString *)urlString HTTPBody:(NSData *)body
{
    //为了请求接口的正确性
    NSString * newUrlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", newUrlStr);
    NSURL * url = [NSURL URLWithString:newUrlStr];
    //    NSLog(@"%@", url);
    //根据URL创建一个请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    //和服务器建立异步连接
    [NSURLConnection connectionWithRequest:request delegate:self];
}


//收到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.data = nil;
//        NSLog(@"收到服务器的响应didReceiveResponse");
}


//传输数据(可能会调用多次,每次回来一个data片段)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //把传回来的data片段拼到一起
    [self.data appendData:data];
    
//        NSLog(@"传输数据didReceiveData");
}

//数据传输完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"++%@", [[NSString alloc] initWithData:self.data encoding:0]);
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
//    NSLog(@"%@",dic);
    if ([self.delegate respondsToSelector:@selector(refresh:)]) {
        [self.delegate refresh:dic];
    }
}

//请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(failWithError:)]) {
        [self.delegate failWithError:error];
    }
}


- (NSMutableData *)data
{
    if (_data == nil) {
        self.data = [NSMutableData data];
    }
    return _data;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}



@end
