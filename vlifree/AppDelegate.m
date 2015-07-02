//
//  AppDelegate.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "WXApi.h"
#import "UserViewController.h"
#import "KeyboardManager.h"
#import "DetailsGrogshopViewController.h"
#import "DetailTakeOutViewController.h"
#import "TakeOutOrderViewController.h"
#import "GSOrderPayViewController.h"

@interface AppDelegate ()<WXApiDelegate>


@property (nonatomic, strong)MyTabBarController * myTabBarVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.myTabBarVC = [[MyTabBarController alloc] init];
    self.window.rootViewController = _myTabBarVC;
    
    [WXApi registerApp:@"wxaac5e5f7421e84ac"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    return YES;
}

- (void)onReq:(BaseReq *)req
{
    NSLog(@"%@", req);
}

- (void)onResp:(BaseResp *)resp
{
    NSLog(@"---%@", resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * sendAR = (SendAuthResp *)resp;
        if (sendAR.errCode == 0) {//0代表已授权登陆
            UINavigationController * userNav = (UINavigationController *)[self.myTabBarVC selectedViewController];
            UIViewController * logInVC = [userNav.viewControllers lastObject];
            if ([logInVC isKindOfClass:[UserViewController class]]) {
                [self getUserLogInVCWithCode:sendAR.code];
            }else if([logInVC isKindOfClass:[DetailsGrogshopViewController class]])
            {
                [(DetailsGrogshopViewController *)logInVC getAccessToken:sendAR.code];
            }else if([logInVC isKindOfClass:[DetailTakeOutViewController class]])
            {
                NSLog(@"外卖登陆");
                [(DetailTakeOutViewController *)logInVC getAccessToken:sendAR.code];
            }
            /*
            //根据授权获取 access_token
            NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxaac5e5f7421e84ac&secret=055e7e10c698b7b140511d8d1a73cec4&code=%@&grant_type=authorization_code", sendAR.code];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            //将请求的url数据放到NSData对象中
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (response) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                //        NSLog(@"++++++%@", dic);
                if ([dic objectForKey:@"access_token"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"refresh_token"] forKey:@"refresh_token"];//保存 refresh_token
                    [self saveAuthorizeDate];//保存获取refresh_token的时间
                    //验证授权是否可用(验证access_token)
                    NSString * yanzhengURLSTR = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@", [dic objectForKey:@"access_token"], [dic objectForKey:@"openid"]];
                    NSURLRequest * yzRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:yanzhengURLSTR]];
                    NSData * yzData = [NSURLConnection sendSynchronousRequest:yzRequest returningResponse:nil error:nil];
                    if (yzData) {
                        NSDictionary * yzDic = [NSJSONSerialization JSONObjectWithData:yzData options:0 error:nil];
                        if ([[yzDic objectForKey:@"errcode"] isEqual:@0]) {
                            NSString * infoURLSTR = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [dic objectForKey:@"access_token"], [dic objectForKey:@"openid"]];
                            NSURLRequest * infoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:infoURLSTR]];
                            NSData * infoData = [NSURLConnection sendSynchronousRequest:infoRequest returningResponse:nil error:nil];
                            if (infoData) {
                                NSDictionary * infoDic = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
                                NSLog(@"user info = %@", infoDic);
                            }
                        }
                    }
                }
            }
            */
        }else
        {
            [SVProgressHUD dismiss];
        }
    }else if ([resp isKindOfClass:[PayResp class]])
    {
        NSLog(@"支付");
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                UINavigationController * nav = (UINavigationController *)self.myTabBarVC.selectedViewController;
                UIViewController * vc = [nav.viewControllers lastObject];
                if ([vc isKindOfClass:[TakeOutOrderViewController class]]) {
                    TakeOutOrderViewController * takeOutOrderVC = (TakeOutOrderViewController *)vc;
                    [takeOutOrderVC pushFinishOrderVC];
                }else if ([vc isKindOfClass:[GSOrderPayViewController class]])
                {
                    GSOrderPayViewController * gsOrderPayVC = (GSOrderPayViewController *)vc;
                    [gsOrderPayVC pushOrderDetailsVC];
                }
            }
                break;
            default:
            {
                NSLog(@"支付失败， retcode=%d",resp.errCode);
                [SVProgressHUD showErrorWithStatus:@"支付失败" duration:2];
            }
                
                break;
        }
    }
}


- (void)getUserLogInVCWithCode:(NSString *)code
{
    UINavigationController * userNav = (UINavigationController *)[self.myTabBarVC selectedViewController];
    UserViewController * userVC = (UserViewController *)userNav.topViewController;
    [userVC showUserInfoViewWithCode:code];
}


- (void)saveAuthorizeDate
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [formater stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"tokenDate"];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
