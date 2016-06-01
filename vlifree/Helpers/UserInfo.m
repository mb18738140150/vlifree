//
//  UserInfo.m
//  vlifree
//
//  Created by 仙林 on 15/6/12.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserInfo.h"
NSString *const CollectCountCHange = @"CollectCountCHange";
static UserInfo * userInfo = nil;

@interface UserInfo ()<HTTPPostDelegate>

@end

@implementation UserInfo


+ (UserInfo *)shareUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc] init];
        
    });
    return userInfo;
}

- (instancetype)init
{
    [self addObserver:self forKeyPath:@"self.collectCount" options:NSKeyValueObservingOptionNew context:nil];
    return self;
}

- (void)setPropertyWithDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:CollectCountCHange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[change objectForKey:@"new"],@"newCollectCount", nil]];
        
//        NSLog(@"***********%@****", [change objectForKey:@"new"]);
        
    }) ;
}

- (void)setUserId:(NSNumber *)userId
{
    _userId = userId;
    if (userId != nil) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]) {
            NSDictionary * dic = @{
                                   @"Command":@36,
                                   @"UserId":userId,
                                   @"Device":@1,
                                   @"CID":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]
                                   };
            [self playPostWithDictionary:dic];
             NSLog(@"******************%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]);
        }
    }
}

#pragma mark - 数据请求--绑定推送registerID
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
        NSLog(@"userinfo - %@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"+++%@", data);
}

- (void)failWithError:(NSError *)error
{
    
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.collectCount"];
}

@end
