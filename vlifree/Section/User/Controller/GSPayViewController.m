//
//  GSPayViewController.m
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSPayViewController.h"
#import "PayTypeView.h"
#import "DetailsGSOrderViewController.h"

#import "WXApi.h"
#import "payRequsestHandler.h"

#import "AlipayOrder.h"
#import "DataSigner.h"

#import "BDWalletSDKMainManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#define LEFT_SPACE 20
#define TOP_SPACE 5
@interface GSPayViewController ()<HTTPPostDelegate, BDWalletSDKMainManagerDelegate>



@property (nonatomic, strong)PayTypeView * weixinView;
@property (nonatomic, strong)PayTypeView * baiduView;
@property (nonatomic, strong)PayTypeView * aliPayView;
@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UILabel * personLB;
@property (nonatomic, strong)UILabel * telLB;
@property (nonatomic, strong)UILabel * checkInDateLB;
@property (nonatomic, strong)UILabel * leaveLB;
@property (nonatomic, strong)UILabel * roomLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UILabel * payLB;
@property (nonatomic, strong)UILabel * requireLB;
@property (nonatomic, strong)UILabel * grogshopLB;
@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * telGSLB;

@property (nonatomic, strong)NSNumber * payType;

@property (nonatomic, copy)NSString * roomName;
@property (nonatomic, assign)double price;
@property (nonatomic, strong)JGProgressHUD * hud;


@end

@implementation GSPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"立即支付";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    [self.view addSubview:scrollView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 200)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view1];
    
    
    self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view1.width, 50)];
    _priceLB.backgroundColor = [UIColor orangeColor];
    //    _priceLB.backgroundColor = MAIN_COLOR;
    _priceLB.text = @"    订单金额: ¥298";
    _priceLB.font = [UIFont systemFontOfSize:22];
    _priceLB.textColor = [UIColor whiteColor];
    [view1 addSubview:_priceLB];
    
    self.personLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _priceLB.bottom + TOP_SPACE, view1.width  - 2 * LEFT_SPACE, 30)];
    _personLB.text = @"预定人:马哥";
    _personLB.textColor = TEXT_COLOR;
    [view1 addSubview:_personLB];
    
    
    self.telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _personLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _telLB.text = @"预定电话: 13456772457";
    _telLB.textColor = TEXT_COLOR;
    [view1 addSubview:_telLB];
    
    
    self.checkInDateLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _telLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _checkInDateLB.text = @"入住时间: 2015年5月15日 19:52:15";
    _checkInDateLB.textColor = TEXT_COLOR;
    [view1 addSubview:_checkInDateLB];
    
    self.leaveLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _checkInDateLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _leaveLB.text = @"离开时间: 2015年5月17日 19:52:15";
    _leaveLB.textColor = TEXT_COLOR;
    [view1 addSubview:_leaveLB];
    
    
    self.roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _leaveLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _roomLB.text = @"总统大套房";
    _roomLB.textColor = TEXT_COLOR;
    [view1 addSubview:_roomLB];
    
    
    self.countLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _roomLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _countLB.text = @"预定房间: 1间";
    _countLB.textColor = TEXT_COLOR;
    [view1 addSubview:_countLB];
    
    
    self.payLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _countLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _payLB.text = @"支付方式: 在线支付";
    _payLB.textColor = TEXT_COLOR;
    [view1 addSubview:_payLB];
    
    
    self.requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _payLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _requireLB.text = @"特殊要求";
    _requireLB.textColor = TEXT_COLOR;
    [view1 addSubview:_requireLB];
    
    view1.height = _requireLB.bottom + TOP_SPACE;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:line1];
    
    /*
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, scrollView.width, 200)];
    view2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view2];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line2];
    
    
    self.grogshopLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 40)];
    _grogshopLB.text = @"柳州新世纪酒店";
    _grogshopLB.font = [UIFont systemFontOfSize:23];
    [view2 addSubview:_grogshopLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _grogshopLB.bottom, view2.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line3];
    
    UIImageView * addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, 30, 30)];
    addressIcon.image = [UIImage imageNamed:@"addressIcon.png"];
    [view2 addSubview:addressIcon];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(addressIcon.right + 5, addressIcon.top, view2.width - addressIcon.right - LEFT_SPACE - 5, 30)];
    _addressLB.text = @"新环西路1000弄5号903";
    [view2 addSubview:_addressLB];
    
    UIImageView * telIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, addressIcon.bottom + TOP_SPACE, 30, 30)];
    telIcon.image = [UIImage imageNamed:@"phoneIcon.png"];
    [view2 addSubview:telIcon];
    
    self.telGSLB = [[UILabel alloc] initWithFrame:CGRectMake(telIcon.right + 5, telIcon.top, view2.width - addressIcon.right - LEFT_SPACE - 5, 30)];
    _telGSLB.text = @"13589645969";
    [view2 addSubview:_telGSLB];
    
    view2.height = _telGSLB.bottom + TOP_SPACE;
    */
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 5, scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view3];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view3.width, 1)];
    line5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line5];
    
    UILabel * payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view3.width - 2 * LEFT_SPACE, 40)];
    payLabel.text = @"支付方式";
    payLabel.textColor = TEXT_COLOR;
    [view3 addSubview:payLabel];
    
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLabel.bottom, view3.width - 2 * LEFT_SPACE, 1)];
    line6.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line6];
    
    
    self.payType = @1;
    self.weixinView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, line6.bottom + TOP_SPACE, view3.width, 40)];
    _weixinView.changeButton.selected = YES;
    [_weixinView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    _weixinView.iconView.image = [UIImage imageNamed:@"weixinzhifu.png"];
    _weixinView.titleLabel.text = @"微信支付";
    [view3 addSubview:_weixinView];
    
    self.baiduView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, _weixinView.bottom + TOP_SPACE, view3.width, 40)];
    _baiduView.iconView.image = [UIImage imageNamed:@"baiduzhifu.png"];
    _baiduView.titleLabel.text = @"百度钱包";
    [_baiduView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:_baiduView];
    
    self.aliPayView = [[PayTypeView alloc]initWithFrame:CGRectMake(0, _baiduView.bottom, view3.width, 40)];
    _aliPayView.iconView.image = [UIImage imageNamed:@"alipey_icon.png"];
    _aliPayView.titleLabel.text = @"支付宝";
    [_aliPayView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:_aliPayView];
    
    view3.height = _aliPayView.bottom + TOP_SPACE;
        
    scrollView.contentSize = CGSizeMake(scrollView.width, view3.bottom + 10);
    
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(50, self.view.height - 40, self.view.width - 100, 30);
    [payButton setTitle:@"马上支付" forState:UIControlStateNormal];
    payButton.layer.backgroundColor = MAIN_COLOR.CGColor;
    payButton.layer.cornerRadius = 10;
    [payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    
    
    NSDictionary * jsonDic = @{
                               @"Command":@26,
                               @"Id":self.orderID
                               };
    [self playPostWithDictionary:jsonDic];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    
    
    // Do any additional setup after loading the view.
}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)payOrder:(UIButton *)button
{
    NSLog(@"%@", self.payType);
    if ([self.payType isEqualToNumber:@1]) {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            NSDictionary * dic = @{
                                   @"Command":@34,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"PayType":self.payType,
                                   @"OrderId":self.orderID,
                                   @"Cur_IP":[self getIPAddress],
                                   @"OrderType":@1
                                   };
            [self playPostWithDictionary:dic];
            self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            [self.hud showInView:self.view];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"没安装微信或者微信版本太低" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }

    }else if ([self.payType isEqualToNumber:@2])
    {
        NSDictionary * dic = @{
                               @"Command":@34,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"PayType":self.payType,
                               @"OrderId":self.orderID,
                               @"Cur_IP":[self getIPAddress],
                               @"OrderType":@1
                               };
        [self playPostWithDictionary:dic];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        [self.hud showInView:self.view];
        
//        BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
//        NSString *orderInfo = [self buildOrderInfoWithOrderID:self.orderID];
//        [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
    }else
    {
        
        NSDictionary * dic = @{
                               @"Command":@34,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"PayType":self.payType,
                               @"OrderId":self.orderID,
                               @"Cur_IP":[self getIPAddress],
                               @"OrderType":@1
                               };
        [self playPostWithDictionary:dic];
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        [self.hud showInView:self.view];
        
//            NSString *partner = @"2088911824635467";
//            // 商户收款账号
//            NSString *seller = @"yfqpjp@163.com";
//            // 商户私钥，pkcs8格式
//            NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOuotyOsHSZ4n2ZSjYdRJaukQi/6N3mYqGAL14aH3CyaHme9mIwP9a46cpYR8I72Vy2BqbJqce9fNNBjPtQgcmmnkJ1FfEWvMDHctyMHPdwXLZsQlqhNsHdLOymJiHcwo85S0k3SwbqkTivFAdlxJIHpvT3TdLPkurr8OTPCf5DXAgMBAAECgYB80z8+u/os2JPGRVAGLyt/AWC1vRoJZJ07Usp0zh4H2hLk7H6TIhkGkpsDdrkvYLjIt/fFM7DqFEoLX6Z2AkHXRNi8AX8k4lDRZfR7lan75N0suINGJWX/XX8RBduu+I766WlwIVR2RYR4i9ddq4uEwG5sx7dR3VEj3RToxQDp0QJBAPlPIzheyb8g0YLXC4XgaGqbjUOEX3NBFoJD4a/CaiitBKRVcumpORUX3JdWWZ/L4NPo+S6kbiJPCrsnHKHG0hUCQQDx+8u3Gs/OGFiOz4v2jL2eq0NfP+2cRD7/ozyLyjvIsNY3JnVT7wyg9u6Vk/LW1r8dYwQDIh5JQ6LQ7XgtcA47AkEAjhBjcH7LFcd8u8MQxOQAfCdRkxS+U23Whrppw37UgYM+LuqmRbHxXiyvvektvxotbnPGcqauP4ys/8Kk1Sb3lQJAPU6qAi4M0A5jAWub7k8iC30giJVNwfWYcHQO9uu50dLbswVPXICIFo/5SnQ9ZijqKqvXbGPMgIteSMihVgG52QJAKmub7CItcesOmgYrx76NUwlvBQ5ezJyNNNGIo76qaLvawvTY6B/C3o2ioAfgm8T0qfAyT9o4iI+xM7DY+Iulpg==";
//            /*
//             * 生成订单信息及签名
//             */
//            AlipayOrder * order = [[AlipayOrder alloc]init];
//            order.partner = partner;
//            order.seller = seller;
//            order.tradeNO = self.orderID; //订单ID（由商家自行制定）
//            order.productName = self.orderID; //商品标题
//            order.productDescription = self.orderID; //商品描述
//            order.amount = [NSString stringWithFormat:@"%.2f",_price]; //商品价格
//            order.notifyURL =  @"http://wap.vlifee.com/alipay/notify_url.aspx"; //回调URL
//            
//            order.service = @"mobile.securitypay.pay";
//            order.paymentType = @"1";
//            order.inputCharset = @"utf-8";
//            order.itBPay = @"30m";
//            order.showUrl = @"m.alipay.com";
//            
//            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//            NSString *appScheme = @"wxaac5e5f7421e84ac";
//            
//            //将商品信息拼接成字符串
//            NSString *orderSpec = [order description];
//            NSLog(@"orderSpec = %@",orderSpec);
//            
//            id<DataSigner> signer = CreateRSADataSigner(privateKey);
//            NSString *signedString = [signer signString:orderSpec];
//            
//            //将签名成功字符串格式化为订单字符串,请严格按照该格式
//            NSString *orderString = nil;
//            if (signedString != nil) {
//                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                               orderSpec, signedString, @"RSA"];
//                
//                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    NSLog(@"reslut = %@",resultDic);
//                    [self pushOrderDetailsVC];
//                }];
//                
//            }
        
            
        
    }
}


#pragma mark - 选择支付方式
- (void)changePayType:(UIButton *)button
{
//    if (button.selected) {
//        return;
//    }
//    if ([button isEqual:self.weixinView.changeButton]) {
//        self.baiduView.changeButton.selected = NO;
//        self.payType = @1;
//        //        NSLog(@"微信");
//    }else if ([button isEqual:self.baiduView.changeButton])
//    {
//        self.weixinView.changeButton.selected = NO;
//        self.payType = @2;
//        //        NSLog(@"百度");
//    }
//    button.selected = !button.selected;
    
    
    if (button.selected) {
        return;
    }
    if ([button isEqual:self.weixinView.changeButton]) {
        self.baiduView.changeButton.selected = NO;
        self.aliPayView.changeButton.selected = NO;
        _payType = @1;
    }else if ([button isEqual:self.baiduView.changeButton])
    {
        self.weixinView.changeButton.selected = NO;
        self.aliPayView.changeButton.selected = NO;
        _payType = @2;
    }else if ([button isEqual:self.aliPayView.changeButton])
    {
        self.baiduView.changeButton.selected = NO;
        self.weixinView.changeButton.selected = NO;
        _payType = @20;
    }
    
    
    button.selected = !button.selected;
    
}

#pragma mark-  数据请求
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
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
    [self.hud dismiss];
    self.hud = nil;
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10026]) {
            self.priceLB.text = [NSString stringWithFormat:@"     订单金额:%@", [data objectForKey:@"Price"]];
            self.price = [[data objectForKey:@"Price"] doubleValue];
            self.personLB.text = [NSString stringWithFormat:@"预定人:%@", [data objectForKey:@"Name"]];
            self.telLB.text = [NSString stringWithFormat:@"预定号码:%@", [data objectForKey:@"PhoneNumber"]];
            NSString * checkInTime = [data objectForKey:@"CheckInTime"];
            self.checkInDateLB.text = [NSString stringWithFormat:@"入住时间:%@", [checkInTime substringToIndex:10]];
            NSString * leaveTime = [data objectForKey:@"LeaveTime"];
            self.leaveLB.text = [NSString stringWithFormat:@"离店时间:%@", [leaveTime substringToIndex:10]];
            self.roomLB.text = [NSString stringWithFormat:@"房型:%@", [data objectForKey:@"RoomType"]];
            self.roomName = [data objectForKey:@"RoomType"];
            self.countLB.text = [NSString stringWithFormat:@"预定房间:%@间", [data objectForKey:@"RoomCount"]];
//            self.payType = [data objectForKey:@"PeyType"];
            if ([[data objectForKey:@"PeyType"] isEqualToNumber:@1]) {
                self.payLB.text = @"支付方式:微信支付";
            }else if ([[data objectForKey:@"PeyType"] isEqualToNumber:@20])
            {
                self.payLB.text = @"支付方式:支付宝支付";
            }
            else{
                self.payLB.text = @"支付方式:百度支付";
            }
            self.requireLB.text = [NSString stringWithFormat:@"特殊需求:%@", [data objectForKey:@"Demand"]];
            self.grogshopLB.text = [data objectForKey:@"HotelName"];
            self.addressLB.text = [data objectForKey:@"HotelAddress"];
            self.telGSLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"HotelTel"]];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10034])
        {
            
            if (self.payType.intValue == 1) {
                NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"AppId"]]       forKey:@"appid"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"NonceStr"]]    forKey:@"noncestr"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"Package"]]      forKey:@"package"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"PartnerId"]]        forKey:@"partnerid"];
                [signParams setObject: [data objectForKey:@"TimeStamp"]   forKey:@"timestamp"];
                [signParams setObject: [data objectForKey:@"PrepayId"]    forKey:@"prepayid"];
                //            [signParams setObject: @"MD5"       forKey:@"signType"];
                NSLog(@"signDic = %@", signParams);
                //            NSString * sign = [self createMd5Sign:signParams];
                NSNumber * stamp = [data objectForKey:@"TimeStamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              =  [NSString stringWithFormat:@"%@", [data objectForKey:@"AppId"]];
                req.partnerId           = [NSString stringWithFormat:@"%@", [data objectForKey:@"PartnerId"]];
                req.prepayId            = [NSString stringWithFormat:@"%@", [data objectForKey:@"PrepayId"]];
                req.nonceStr            = [NSString stringWithFormat:@"%@", [data objectForKey:@"NonceStr"]];
                req.timeStamp           = stamp.intValue;
                req.package             = [NSString stringWithFormat:@"%@", [data objectForKey:@"Package"]];
                req.sign                = [NSString stringWithFormat:@"%@", [data objectForKey:@"Sign"]];
                //            req.sign = sign;
                [WXApi sendReq:req];
            }else if (self.payType.intValue == 2)
            {
                BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
                NSString *orderInfo = [self buildOrderInfoWithOrderID:self.orderID];
                [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
            }else if (self.payType.intValue == 20)
            {
                
                NSString *partner = @"2088911824635467";
                // 商户收款账号
                NSString *seller = @"yfqpjp@163.com";
                // 商户私钥，pkcs8格式
                NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOuotyOsHSZ4n2ZSjYdRJaukQi/6N3mYqGAL14aH3CyaHme9mIwP9a46cpYR8I72Vy2BqbJqce9fNNBjPtQgcmmnkJ1FfEWvMDHctyMHPdwXLZsQlqhNsHdLOymJiHcwo85S0k3SwbqkTivFAdlxJIHpvT3TdLPkurr8OTPCf5DXAgMBAAECgYB80z8+u/os2JPGRVAGLyt/AWC1vRoJZJ07Usp0zh4H2hLk7H6TIhkGkpsDdrkvYLjIt/fFM7DqFEoLX6Z2AkHXRNi8AX8k4lDRZfR7lan75N0suINGJWX/XX8RBduu+I766WlwIVR2RYR4i9ddq4uEwG5sx7dR3VEj3RToxQDp0QJBAPlPIzheyb8g0YLXC4XgaGqbjUOEX3NBFoJD4a/CaiitBKRVcumpORUX3JdWWZ/L4NPo+S6kbiJPCrsnHKHG0hUCQQDx+8u3Gs/OGFiOz4v2jL2eq0NfP+2cRD7/ozyLyjvIsNY3JnVT7wyg9u6Vk/LW1r8dYwQDIh5JQ6LQ7XgtcA47AkEAjhBjcH7LFcd8u8MQxOQAfCdRkxS+U23Whrppw37UgYM+LuqmRbHxXiyvvektvxotbnPGcqauP4ys/8Kk1Sb3lQJAPU6qAi4M0A5jAWub7k8iC30giJVNwfWYcHQO9uu50dLbswVPXICIFo/5SnQ9ZijqKqvXbGPMgIteSMihVgG52QJAKmub7CItcesOmgYrx76NUwlvBQ5ezJyNNNGIo76qaLvawvTY6B/C3o2ioAfgm8T0qfAyT9o4iI+xM7DY+Iulpg==";
                /*
                 * 生成订单信息及签名
                 */
                AlipayOrder * order = [[AlipayOrder alloc]init];
                order.partner = partner;
                order.seller = seller;
                order.tradeNO = self.orderID; //订单ID（由商家自行制定）
                order.productName = self.orderID; //商品标题
                order.productDescription = self.orderID; //商品描述
                order.amount = [NSString stringWithFormat:@"%.2f",_price]; //商品价格
                order.notifyURL =  @"http://wap.vlifee.com/alipay/notify_url.aspx"; //回调URL
                
                order.service = @"mobile.securitypay.pay";
                order.paymentType = @"1";
                order.inputCharset = @"utf-8";
                order.itBPay = @"30m";
                order.showUrl = @"m.alipay.com";
                
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                NSString *appScheme = @"wxaac5e5f7421e84ac";
                
                //将商品信息拼接成字符串
                NSString *orderSpec = [order description];
                NSLog(@"orderSpec = %@",orderSpec);
                
                id<DataSigner> signer = CreateRSADataSigner(privateKey);
                NSString *signedString = [signer signString:orderSpec];
                
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        [self pushOrderDetailsVC];
                    }];
                    
                }
                
                
                
            }
            
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
}


#pragma  mark - 跳转到订单详情页面
- (void)pushOrderDetailsVC
{
    DetailsGSOrderViewController * detailsOrderVC = [[DetailsGSOrderViewController alloc] init];
    detailsOrderVC.isPay = YES;
    detailsOrderVC.orderID = self.orderID;
    [self.navigationController pushViewController:detailsOrderVC animated:YES];
}

#pragma mark - 百度支付
-(NSString*)buildOrderInfoWithOrderID:(NSString *)orderId
{
    int money = (int)(_price * 100);
    NSMutableString *str = [[NSMutableString alloc]init];
    
    static NSString *spNo = @"1000011124";
    static NSString *key = @"vwD28fhc8p4cQzFjnfLaJRSvHFrsCBa7";
    NSDateFormatter * dateFM = [[NSDateFormatter alloc] init];
    [dateFM setDateFormat:@"yyyyMMddHHmmss"];
    NSString * dateString = [dateFM stringFromDate:[NSDate date]];
    NSLog(@"11111--%@", dateString);
    /*
     如有中文相关，步骤一 GBK ；步骤二 MD5 GBK ； 步骤三 URLEncode GBK
     详见以下注释
     */
    //    NSString *orderId = [NSString stringWithFormat:@"z2015052713275609521156"];
    [str appendString:@"currency=1&extra=ios123"];
    [str appendString:@"&goods_desc="];
    [str appendString:[self utf8toGbk:self.roomName]];
    [str appendString:@"&goods_name="];
    [str appendString:[self utf8toGbk:self.roomName]]; // 中文处理1
    [str appendString:@"&input_charset=1&order_create_time="];//下单时间
    [str appendString:dateString];//订单生产时间
    [str appendString:@"&order_no="];
    [str appendString:orderId];
    [str appendString:@"&pay_type=2"];
    [str appendString:@"&return_url=http://wap.vlifee.com/bfbpay/notifyurl.aspx&service_code=1&sign_method=1&sp_no="];
    [str appendString:spNo];
    [str appendString:@"&sp_request_type="];
    [str appendString:@"0"];//收银类型
    [str appendString:@"&sp_uno="];
    [str appendString:[NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].userId]];//用户的id(用来绑定快捷支付)
    [str appendString:@"&total_amount="];
    [str appendString:[NSString stringWithFormat:@"%d", money]];//总金额(以分为单位)
    [str appendString:@"&transport_amount=0&unit_amount="];
    [str appendString:[NSString stringWithFormat:@"%d", money]];//商品单价(以分为单位)
    [str appendString:@"&unit_count=1&version=2"];//商品数量
    
    NSString *md5CapPwd = [self mD5GBK:[NSString stringWithFormat:@"%@&key=%@" , str, key]]; // 中文处理2
    
    NSMutableString *str1 = [[NSMutableString alloc]init];
    
    [str1 appendString:@"currency=1&extra=ios123"];
    [str1 appendString:@"&goods_desc="];
    [str1 appendString:[self encodeURL:[self utf8toGbk:self.roomName]]];
    [str1 appendString:@"&goods_name="];
    [str1 appendString:[self encodeURL:[self utf8toGbk:self.roomName]]]; // 中文处理3
    [str1 appendString:@"&input_charset=1&order_create_time="];//下单时间
    [str1 appendString:dateString];//订单生产时间
    [str1 appendString:@"&order_no="];
    [str1 appendString:orderId];
    [str1 appendString:@"&pay_type=2"];
    [str1 appendString:@"&return_url=http://wap.vlifee.com/bfbpay/notifyurl.aspx&service_code=1&sign_method=1&sp_no="];
    [str1 appendString:spNo];
    [str1 appendString:@"&sp_request_type="];
    [str1 appendString:@"0"];//收银类型
    [str1 appendString:@"&sp_uno="];
    [str1 appendString:[NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].userId]];//用户的id(用来绑定快捷支付)
    [str1 appendString:@"&total_amount="];
    [str1 appendString:[NSString stringWithFormat:@"%d", money]];//总金额(以分为单位)
    [str1 appendString:@"&transport_amount=0&unit_amount="];
    [str1 appendString:[NSString stringWithFormat:@"%d", money]];//商品单价(以分为单位)
    [str1 appendString:@"&unit_count=1&version=2"];//商品数量
    NSLog(@"%@", str);
    //    NSLog(@"+++%@", [NSString stringWithFormat:@"%@&sign=%@" , str1 , md5CapPwd]);
    return [NSString stringWithFormat:@"%@&sign=%@" , str1, md5CapPwd];
}

- (NSString *)mD5GBK:(NSString *)src
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char *cStr = [src cStringUsingEncoding:enc];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)encodeURL:(NSString *)string
{
    NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)string,
                                                                                                    NULL,
                                                                                                    CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                                                    kCFStringEncodingGB_18030_2000));
    if (escaped_value) {
        return escaped_value;
    }
    return @"";
}


-(NSString*)utf8toGbk:(NSString*)str
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* str1 = [str stringByReplacingPercentEscapesUsingEncoding:enc];
    return str1;
}


-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDesc;
{
    NSLog(@"支付结束 接口 code:%d desc:%@",statusCode,payDesc);
    if (statusCode == 0) {
        [self pushOrderDetailsVC];
    }
}

- (void)logEventId:(NSString*)eventId eventDesc:(NSString*)eventDesc;
{}



#pragma mark - 微信支付

- (void)weixinSendPay
{
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //订单金额，单位（元）
    NSString *ORDER_PRICE   = @"0.01";
    
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                           [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
                           [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
                           ORDER_PRICE];
    
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
                [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
            }
        }else{
            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
        }
    }else{
        [self alert:@"提示信息" msg:@"服务器返回错误"];
    }
    
}


- (void)sendPay_demo
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        if ([WXApi isWXAppInstalled]) {
            if ([WXApi isWXAppSupportApi]) {
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                
                BOOL a = [WXApi sendReq:req];
                NSLog(@"%d", a);
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的微信版本太低,不支持支付调用,请更新微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
            }
            
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的手机还没安装微信,请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=I57gmdk90nd5bla84nkyqldicn3294Fh"];
    //得到MD5 sign签名
    NSString *md5Sign =[[WXUtil md5:contentString] uppercaseString];
//    NSString * md5Sign = [contentString md5];
    NSLog(@"%@", [NSString stringWithFormat:@"MD5签名字符串：\n%@\n\n",contentString]);
    
    return md5Sign;
}


//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

- (void)alertMessage:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alter show];
    [alter performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
}

// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
