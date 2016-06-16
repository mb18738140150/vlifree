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
#import "OnlinePayViewController.h"
#import "GSOrderPayViewController.h"
#import "JPUSHService.h"
#import "FinishOrderViewController.h"
#import "GSPayViewController.h"
#import "DetailsTOOrderViewController.h"
#import "Net.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Reachability.h"
//#import "AFAppDotNetAPIClient.h"


@interface AppDelegate ()<WXApiDelegate, HTTPPostDelegate, BMKGeneralDelegate>

@property (nonatomic, strong)NSTimer * noticeTimer;
@property (nonatomic, strong)MyTabBarController * myTabBarVC;
@property (nonatomic,  strong)UIAlertView * netalert;

@end

@implementation AppDelegate

- (void)onGetNetworkState:(int)iError
{
    NSLog(@"网络错误 = %d", iError);
}
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"授权验证错误 = %d", iError);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 检测网络变化
//    [AFAppDotNetAPIClient shareClientWithView:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilitysHHHChanged:)
                                                 name: kNetReachabilityChangedNotification
                                               object: nil];
    
   
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilitysHHHChanged:)
//                                                 name: kNetReachabilityChangedNotification
//                                               object: nil];
    
    //初始化Reachability类，并添加一个监测的网址。
     Net* hostReach = [Net reachabilityWithHostName:@"www.baidu.com"];
// Reach * hostReach = [Reach reachabilityWithHostName:@"https://api.app.net/"];
    //开始监测
    [hostReach startNotifier];
    
    
    self.myTabBarVC = [[MyTabBarController alloc] init];
    self.window.rootViewController = _myTabBarVC;
    
    [WXApi registerApp:@"wxaac5e5f7421e84ac"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    BMKMapManager * mapManager = [[BMKMapManager alloc] init];
    [mapManager start:@"4Fra3gSOChrExioQUdEq54dk" generalDelegate:self];
    
    // 初始化腾讯地图
    [[QMapServices sharedServices] setApiKey:@"FK4BZ-FIY35-SCVIC-QLRZK-ZYH23-PAFOX"];
    [[QMSSearchServices sharedServices] setApiKey:@"FK4BZ-FIY35-SCVIC-QLRZK-ZYH23-PAFOX"];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }else
    {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:JPappKey channel:JPchannel apsForProduction:isProductionJP advertisingIdentifier:nil];

//    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert |
//                                                   UIUserNotificationTypeBadge |
//                                                   UIUserNotificationTypeSound)
//                                       categories:nil];
//    [APService setupWithOption:launchOptions];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveLogIn"] isEqualToNumber:@YES]) {
        NSDictionary * dic = @{
                               @"Command":@38,
                               @"LoginType":@1,
                               @"Account":[[NSUserDefaults standardUserDefaults] objectForKey:@"account"],
                               @"Password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                               };
        [self playPostWithDictionary:dic];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CIDAction:)
                                                 name: @"CID"
                                               object: nil];
    
    return YES;
}
#pragma mark - 网络变化通知
- (void)reachabilitysHHHChanged:(NSNotification *)notification
{
    NSLog(@"*******网络发生变化******");
    
    
    NSLog(@"%@", notification.object);
    
    Net * reach = [notification object];
    if ([reach isKindOfClass:[Net class]]) {
        NetStatus status = [reach currentReachabilityStatus];
        NSLog(@"%d", status);
        if (status == NotReachable_net) {
            NSLog(@"*******网络断开******");
            if (self.netalert) {
                NSLog(@"不该走了");
            }else
            {
                self.netalert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [self.netalert show];
            }
        }else if (status == ReachableViaWWAN_net || status == ReachableViaWiFi_net)
        {
//            NSLog(@"*******网络连接上******");
            [self.netalert performSelector:@selector(dismiss) withObject:nil];
            self.netalert = nil;
        }
    }
    
}

- (void)onReq:(BaseReq *)req
{
//    NSLog(@"%@", req);
}

- (void)onResp:(BaseResp *)resp
{
//    NSLog(@"---%@", resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * sendAR = (SendAuthResp *)resp;
        if (sendAR.errCode == 0) {//0代表已授权登录
            UINavigationController * userNav = (UINavigationController *)[self.myTabBarVC selectedViewController];
            UIViewController * logInVC = [userNav.viewControllers lastObject];
            if ([logInVC isKindOfClass:[UserViewController class]]) {
                [self getUserLogInVCWithCode:sendAR.code];
            }else if([logInVC isKindOfClass:[DetailsGrogshopViewController class]])
            {
                [(DetailsGrogshopViewController *)logInVC getAccessToken:sendAR.code];
            }else if([logInVC isKindOfClass:[DetailTakeOutViewController class]])
            {
//                NSLog(@"外卖登录");
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
        }
    }else if ([resp isKindOfClass:[PayResp class]])
    {
//        NSLog(@"支付");
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
                UINavigationController * nav = (UINavigationController *)self.myTabBarVC.selectedViewController;
                UIViewController * vc = [nav.viewControllers lastObject];
                if ([vc isKindOfClass:[OnlinePayViewController class]]) {
                    OnlinePayViewController * onLineVC = (OnlinePayViewController *)vc;
                    [onLineVC pushFinishOrderVC];
                }else if ([vc isKindOfClass:[GSOrderPayViewController class]])
                {
                    GSOrderPayViewController * gsOrderPayVC = (GSOrderPayViewController *)vc;
                    [gsOrderPayVC pushOrderDetailsVC];
                }else if ([vc isKindOfClass:[FinishOrderViewController class]])
                {
                    FinishOrderViewController * finishOrderVC = (FinishOrderViewController *)vc;
                    [finishOrderVC downloadData];
                }else if ([vc isKindOfClass:[DetailsTOOrderViewController class]])
                {
                    DetailsTOOrderViewController * detailsOrderVC = (DetailsTOOrderViewController *)vc;
                    [detailsOrderVC downloadData];
                }else if ([vc isKindOfClass:[GSPayViewController class]])
                {
                    GSPayViewController * gsPayVC = (GSPayViewController *)vc;
                    [gsPayVC pushOrderDetailsVC];
                }
            }
                break;
            default:
            {
//                NSLog(@"支付失败， retcode=%d",resp.errCode);
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
                /*
                else if ([vc isKindOfClass:[FinishOrderViewController class]])
                {
                    FinishOrderViewController * finishOrderVC = (FinishOrderViewController *)vc;
                    [finishOrderVC downloadData];
                }else if ([vc isKindOfClass:[DetailsTOOrderViewController class]])
                {
                    DetailsTOOrderViewController * detailsOrderVC = (DetailsTOOrderViewController *)vc;
                    [detailsOrderVC downloadData];
                }else if ([vc isKindOfClass:[GSOrderPayViewController class]])
                {
                    GSOrderPayViewController * gsPayVC = (GSOrderPayViewController *)vc;
                    [gsPayVC pushOrderDetailsVC];
                }
                 */
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
    NSString * str = [url absoluteString];
//    NSLog(@"sourceApplication%@ ****** %@", sourceApplication, str);
    
    if ([sourceApplication containsString:@"alipay"]) {
        
//        NSString * 
        
        
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"****短**** result = %@",resultDic);
            
            UINavigationController * nav = (UINavigationController *)self.myTabBarVC.selectedViewController;
            UIViewController * vc = [nav.viewControllers lastObject];
            if ([vc isKindOfClass:[OnlinePayViewController class]]) {
                OnlinePayViewController * onLineVC = (OnlinePayViewController *)vc;
                [onLineVC pushFinishOrderVC];
            }else if ([vc isKindOfClass:[GSOrderPayViewController class]])
            {
                GSOrderPayViewController * gsOrderPayVC = (GSOrderPayViewController *)vc;
                [gsOrderPayVC pushOrderDetailsVC];
            }else if ([vc isKindOfClass:[FinishOrderViewController class]])
            {
                FinishOrderViewController * finishOrderVC = (FinishOrderViewController *)vc;
                [finishOrderVC downloadData];
            }else if ([vc isKindOfClass:[DetailsTOOrderViewController class]])
            {
                DetailsTOOrderViewController * detailsOrderVC = (DetailsTOOrderViewController *)vc;
                [detailsOrderVC downloadData];
            }else if ([vc isKindOfClass:[GSPayViewController class]])
            {
                GSPayViewController * gsPayVC = (GSPayViewController *)vc;
                [gsPayVC pushOrderDetailsVC];
            }

            
        }];
        
        return YES;
    }else
    {
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    NSString * registrationID = [JPUSHService registrationID];
    NSLog(@"registrID = %@", registrationID);
    
    if (registrationID.length == 0) {
        self.noticeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollNotice) userInfo:nil repeats:YES];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
    }
    
    if ([UserInfo shareUserInfo].userId) {
        NSDictionary * dic = @{
                               @"Command":@36,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":registrationID
                               };
        [self playPostWithDictionary:dic];
    }
}
- (void)scrollNotice
{
    NSString * registrationID = [JPUSHService registrationID];
    if (registrationID.length != 0) {
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CID" object:self];
        NSLog(@"registrID = %@", registrationID);
        [self.noticeTimer invalidate];
        self.noticeTimer = nil;
    }
}
- (void)CIDAction:(NSNotification *)notification
{
    if ([UserInfo shareUserInfo].userId) {
        NSDictionary * dic = @{
                               @"Command":@36,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]
                               };
        [self playPostWithDictionary:dic];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
//    [self playSound];
    
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微生活提醒你，你的帐号在别的设备登录，您已被退出"]) {
        UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在另一台设备登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"你点击了退出登录");
            [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogin"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Pwd"];
            [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
            
        }];
        
        UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pwd"];
            NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
            NSLog(@"你点击了重新登录");
            
            NSDictionary * jsonDic = nil;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"]) {
                jsonDic = @{
                            @"Pwd":passWord,
                            @"UserName":name,
                            @"Command":@5,
                            @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"],
                            @"DeviceType":@1
                            };
            }else
            {
                jsonDic = @{
                            @"Pwd":passWord,
                            @"UserName":name,
                            @"Command":@5,
                            @"RegistrationID":[NSNull null],
                            @"DeviceType":@1
                            };
            }
            NSString * jsonStr = [jsonDic JSONString];
            NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
            NSLog(@"jsonStr = %@", str);
            NSString * md5Str = [str md5];
            NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
            HTTPPost * httpPost = [HTTPPost shareHTTPPost];
            [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
            httpPost.delegate = self;
            
        }];
        
        [alertcontroller addAction:cameraAction];
        [alertcontroller addAction:libraryAction];
        [nav presentViewController:alertcontroller animated:YES completion:nil];
        
        
    }
    
     NSLog(@"11%@, %@", userInfo, [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
static SystemSoundID shake_sound_male_id = 0;

-(void) playSound

{
    NSString *path = nil;
    
        path = [[NSBundle mainBundle] pathForResource:@"tangshi" ofType:@"caf"];
    
    if (path) {
        //注册声音到系统
        NSURL *url = [NSURL fileURLWithPath:path];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
        OSStatus err =  AudioServicesCreateSystemSoundID(inFileURL,&shake_sound_male_id);
        if (err != kAudioServicesNoError) {
            NSLog(@"Cound not load %@, error code %@", url, err);
        }
        
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
        NSLog(@"走了******");
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - 数据请求--绑定推送registerID
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
        NSLog(@"apdelegate - %@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
//    NSLog(@"+++%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10038]) {
            [[UserInfo shareUserInfo] setValuesForKeysWithDictionary:[data objectForKey:@"UserInfo"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
        }
    }
}


@end
