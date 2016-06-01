//
//  FinishOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/7/2.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "FinishOrderViewController.h"
#import "OrderDetailsMD.h"
#import "OrderMenuMD.h"
#import "OrderMenuVIew.h"
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

#define FONT [UIFont systemFontOfSize:15]

@interface FinishOrderViewController ()<HTTPPostDelegate, BDWalletSDKMainManagerDelegate>

@property (nonatomic, strong)UIScrollView * scrollView;
/**
 *  订单状态图
 */
@property (nonatomic, strong)UIImageView * stateImageV;
/**
 *  订单状态文本框
 */
@property (nonatomic, strong)UILabel * stateLabel;
/**
 *  其他价格
 */
@property (nonatomic, strong)UILabel * otherPriceLB;
/**
 *  支付价格
 */
@property (nonatomic, strong)UILabel * totalPriceLB;
/**
 *  商店名
 */
@property (nonatomic, strong)UILabel * storeNameLB;
/**
 *  订单号
 */
@property (nonatomic, strong)UILabel * orderNumberLB;
/**
 *  订单处理状态
 */
@property (nonatomic, strong)UILabel * orderDateLB;
/**
 *  支付方式
 */
@property (nonatomic, strong)UILabel * orderPayTypeLB;
/**
 *  订单电话
 */
@property (nonatomic, strong)UILabel * orderTelLB;
/**
 *  订单地址
 */
@property (nonatomic, strong)UILabel * orderAddressLB;

//@property (nonatomic, strong)UIButton * confirmBT;
//@property (nonatomic, strong)UIButton * cancelBT;
/**
 *  立即支付按钮
 */
@property (nonatomic, strong)UIButton * paymentBT;
/**
 *  支付方式
 */
@property (nonatomic, strong)NSNumber * payType;
/**
 *  订单菜数组
 */
@property (nonatomic, strong)NSMutableArray * orderArray;
/**
 *  订单详情模型
 */
@property (nonatomic, strong)OrderDetailsMD * orderDetailsMD;
@property (nonatomic, strong)JGProgressHUD * hud;

@end

@implementation FinishOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
//    UIButton * telButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    telButton.frame = CGRectMake(0, 0, 30, 30);
//    [telButton setBackgroundImage:[UIImage imageNamed:@"tel_order_detail_icon.png"] forState:UIControlStateNormal];
//    [telButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * barBT = [[UIBarButtonItem alloc] initWithCustomView:telButton];
//    self.navigationItem.rightBarButtonItem = barBT;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [self.view addSubview:_scrollView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    view1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view1];
    
    self.stateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 20, 20)];
    _stateImageV.image = [UIImage imageNamed:@"stateImage_w.png"];
    [view1 addSubview:_stateImageV];
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImageV.right + 5, _stateImageV.top, 200, _stateImageV.height)];
    _stateLabel.text = @"订单完成";
    _stateLabel.textColor = TEXT_COLOR;
    _stateLabel.font = FONT;
    [view1 addSubview:_stateLabel];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImageV.left, _stateImageV.bottom + 10, view1.width - _stateImageV.left * 2, 20)];
    aLabel.text = @"感谢您使用微外卖，欢迎再次订餐。";
    aLabel.textColor = TEXT_COLOR;
    aLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    aLabel.font = FONT;
    [view1 addSubview:aLabel];
    /*
    self.cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _cancelBT.frame = CGRectMake(view1.width - 200, aLabel.bottom + 10, 80, 25);
    _cancelBT.frame = CGRectMake(view1.width - 100, aLabel.bottom + 10, 80, 25);
    [_cancelBT setTitle:@"取消订单" forState:UIControlStateNormal];
    _cancelBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancelBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _cancelBT.layer.borderWidth = 1;
    _cancelBT.layer.cornerRadius = 3;
    [_cancelBT addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBT.hidden = YES;
//    [view1 addSubview:_cancelBT];
    
    
    
    self.confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBT.frame = CGRectMake(view1.width - 100, aLabel.bottom + 10, 80, 25);
    [_confirmBT setTitle:@"确认订单" forState:UIControlStateNormal];
    _confirmBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    _confirmBT.layer.backgroundColor = [UIColor orangeColor].CGColor;
    _confirmBT.layer.borderWidth = 1;
    _confirmBT.layer.cornerRadius = 3;
    [_confirmBT addTarget:self action:@selector(confirmOrder:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBT.hidden = YES;
//    [view1 addSubview:_confirmBT];
     */
    self.paymentBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _paymentBT.frame = CGRectMake(view1.width - 100, aLabel.bottom + 10, 80, 25);
    [_paymentBT setTitle:@"立即支付" forState:UIControlStateNormal];
    _paymentBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [_paymentBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _paymentBT.layer.borderColor = MAIN_COLOR.CGColor;
    _paymentBT.layer.backgroundColor = [UIColor orangeColor].CGColor;
    _paymentBT.layer.borderWidth = 1;
    _paymentBT.layer.cornerRadius = 3;
    [_paymentBT addTarget:self action:@selector(immediatePayment:) forControlEvents:UIControlEventTouchUpInside];
    _paymentBT.hidden = YES;
    [view1 addSubview:_paymentBT];
    
    
    view1.height = _paymentBT.bottom + 10;
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    lineView1.backgroundColor = LINE_COLOR;
    [view1 addSubview:lineView1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, _scrollView.width, 100)];
    view2.tag = 2000;
    view2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view2];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    lineView2.backgroundColor = LINE_COLOR;
    [view2 addSubview:lineView2];
    
    NSArray * array = @[@"提交订单", @"餐厅接单", @"配送中", @"已收货"];
    for (int i = 0; i < 4; i++) {
        UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view2.width - 200) / 5 * (i + 1) + 50 * i, 10, 50, 50)];
        aImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState_off%d.png", i + 1]];
        aImageView.tag = 10001 + i;
        [view2 addSubview:aImageView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(aImageView.left, aImageView.bottom, aImageView.width, 20)];
        label.tag = 20001 + i;
        label.text = [array objectAtIndex:i];
        label.textColor = TEXT_COLOR;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [view2 addSubview:label];
        if (i != 3) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(aImageView.right, 10, (view2.width - 200) / 5, 1)];
            line.centerY = aImageView.centerY;
            line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
            [view2 addSubview:line];
        }else
        {
            view2.height = label.bottom + 5;
        }
    }
    
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.height - 1, view2.width, 1)];
    lineView3.backgroundColor = LINE_COLOR;
    [view2 addSubview:lineView3];
    
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 10, _scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    view3.tag = 3000;
    [_scrollView addSubview:view3];
    
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view3.width, 1)];
    lineView4.backgroundColor = LINE_COLOR;
    [view3 addSubview:lineView4];
    
    UIImageView * storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    storeIcon.image = [UIImage imageNamed:@"store.png"];
    [view3 addSubview:storeIcon];
    
    self.storeNameLB = [[UILabel alloc] initWithFrame:CGRectMake(storeIcon.right + 5, storeIcon.top, view3.width - 10 - storeIcon.right, storeIcon.height)];
    _storeNameLB.font = FONT;
    _storeNameLB.textColor = TEXT_COLOR;
//    _storeNameLB.text = self.takeOutOrderMD.storeName;
    [view3 addSubview:_storeNameLB];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(10, _storeNameLB.bottom, view3.width - 20, 1)];
    lineView5.backgroundColor = LINE_COLOR;
    lineView5.tag = 5005;
    [view3 addSubview:lineView5];
    

    
    view3.height = lineView5.bottom + 5;
    

    
    UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.bottom + 10, _scrollView.width, 100)];
    view4.backgroundColor = [UIColor whiteColor];
    view4.tag = 4000;
    [_scrollView addSubview:view4];
    
    UIView * lineView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view4.width, 1)];
    lineView7.backgroundColor = LINE_COLOR;
    [view4 addSubview:lineView7];
   
    /*
    UIButton * againBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    againBT.frame = CGRectMake(view4.width - 100, lineView9.bottom + 5, 80, 25);
    [againBT setTitle:@"再来一单" forState:UIControlStateNormal];
    [againBT setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    againBT.titleLabel.font = [UIFont systemFontOfSize:14];
    againBT.layer.borderColor = [UIColor orangeColor].CGColor;
    againBT.layer.borderWidth = 1;
    againBT.layer.cornerRadius = 5;
    [againBT addTarget:self action:@selector(againOrdor:) forControlEvents:UIControlEventTouchUpInside];
//    [view4 addSubview:againBT];
    view4.height = againBT.bottom + 5;
    */
    UIView * lineView10 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.height - 1, view4.width, 1)];
    lineView10.backgroundColor = LINE_COLOR;
    [view4 addSubview:lineView10];
    
    UIView * view5 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.bottom + 10, _scrollView.width, 270)];
    view5.backgroundColor = [UIColor whiteColor];
    view5.tag = 5000;
    [_scrollView addSubview:view5];
    
    UIView * lineView11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view5.width, 1)];
    lineView11.backgroundColor = LINE_COLOR;
    [view5 addSubview:lineView11];
    
    UIImageView * detalsView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    detalsView.image = [UIImage imageNamed:@"orderDetails.png"];
    [view5 addSubview:detalsView];
    
    UILabel * detailsLB = [[UILabel alloc] initWithFrame:CGRectMake(detalsView.right + 5, detalsView.top, 100, detalsView.height)];
    detailsLB.text = @"订单详情";
    detailsLB.textColor = TEXT_COLOR;
    detailsLB.font = FONT;
    [view5 addSubview:detailsLB];
    
    UIView * lineView12 = [[UIView alloc] initWithFrame:CGRectMake(10, detailsLB.bottom + 5, view5.width - 20, 1)];
    lineView12.backgroundColor = LINE_COLOR;
    [view5 addSubview:lineView12];
    
    self.orderNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView12.bottom + 5, lineView12.width - 10, 30)];
    _orderNumberLB.textColor = TEXT_COLOR;
    _orderNumberLB.font = FONT;
//    _orderNumberLB.text = [NSString stringWithFormat:@"订单号:%@", self.takeOutOrderMD.orderID];
    [view5 addSubview:_orderNumberLB];
    
    
    self.orderDateLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderNumberLB.bottom + 5, lineView12.width - 10, 30)];
//    _orderDateLB.text = [NSString stringWithFormat:@"下单时间: %@", self.takeOutOrderMD.time];
    _orderDateLB.textColor = TEXT_COLOR;
    _orderDateLB.font = FONT;
    [view5 addSubview:_orderDateLB];
    
    self.orderPayTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderDateLB.bottom + 5, lineView12.width - 10, 30)];
    _orderPayTypeLB.text = @"支付方式: 现金支付";
    _orderPayTypeLB.textColor = TEXT_COLOR;
    _orderPayTypeLB.font = FONT;
    [view5 addSubview:_orderPayTypeLB];
    
    self.orderTelLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderPayTypeLB.bottom + 5, lineView12.width - 10, 30)];
    _orderTelLB.textColor = TEXT_COLOR;
    _orderTelLB.font = FONT;
//    _orderTelLB.text = [NSString stringWithFormat:@"手机号码: %@", self.takeOutOrderMD.nextphone];
    [view5 addSubview:_orderTelLB];
    
    
    self.orderAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderTelLB.bottom + 5, lineView12.width - 10, 30)];
//    _orderAddressLB.text = [NSString stringWithFormat:@"收餐地址: %@", self.takeOutOrderMD.address];
    _orderAddressLB.numberOfLines = 0;
    _orderAddressLB.textColor= TEXT_COLOR;
    _orderAddressLB.font = FONT;
    [view5 addSubview:_orderAddressLB];
    view5.height = _orderAddressLB.bottom + 10;
    
    CGSize size = _scrollView.contentSize;
    size.height = view5.bottom;
    _scrollView.contentSize = size;
    
    
    [self downloadData];
    
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)againOrdor:(UIButton *)button
{
    self.navigationController.tabBarController.selectedIndex = 2;
}

- (void)callPhone:(UIButton *)button
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    
//    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _takeOutOrderMD.busiPhone]];
    //    [[UIApplication sharedApplication] openURL:telURL];
//    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
}


#pragma mark - 数据请求
- (void)downloadData
{
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary * jsonDic = @{
                               @"Command":@24,
                               @"Id":self.orderID,
                               };
    [self playPostWithDictionary:jsonDic];
    /*
     //    NSLog(@"%@, %@", self.classifyId, [UserInfo shareUserInfo].userId);
     NSString * jsonStr = [jsonDic JSONString];
     NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
     NSLog(@"%@", str);
     NSString * md5Str = [str md5];
     NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
     
     HTTPPost * httpPost = [HTTPPost shareHTTPPost];
     [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
     httpPost.delegate = self;
     */
}



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
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10024]) {
            UIView * view3 = [self.scrollView viewWithTag:3000];
            UIView * view4 = [self.scrollView viewWithTag:4000];
            UIView * view5 = [self.scrollView viewWithTag:5000];
            self.orderDetailsMD = [[OrderDetailsMD alloc] initWithDictionary:data];
            /*
            NSArray * array = [data objectForKey:@"WakeOutOrderDetail"];
            self.orderArray = nil;
            for (NSDictionary * dic in array) {
                OrderMenuMD * orderMenuMD = [[OrderMenuMD alloc] initWithDictionary:dic];
                [self.orderArray addObject:orderMenuMD];
            }
             */
            for (int i = 0 ; i < self.orderDetailsMD.menusArray.count; i++) {
                OrderMenuMD * orderMneuMD = [self.orderDetailsMD.menusArray objectAtIndex:i];
                OrderMenuVIew * menuView = [[OrderMenuVIew alloc] initWithFrame:CGRectMake(15, self.storeNameLB.bottom + 5 + i * 25, view3.width - 30, 25)];
                menuView.menuNameLB.text = orderMneuMD.name;
                menuView.countLabel.text = [NSString stringWithFormat:@"%@", orderMneuMD.count];
                menuView.priceLabel.text = [NSString stringWithFormat:@"¥%g", orderMneuMD.money.doubleValue * orderMneuMD.count.intValue];
                [view3 addSubview:menuView];
            }
            view3.height += 25 * self.orderDetailsMD.menusArray.count + 5;
            UIView * lineView6 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.height - 1, view3.width, 1)];
            lineView6.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
            [view3 addSubview:lineView6];
            view4.top += 25 * self.orderDetailsMD.menusArray.count + 5;
            [self createOtherMoneyView];
            view5.top = view4.bottom + 10;
            view5.height = _orderAddressLB.bottom;
            CGSize size = _scrollView.contentSize;
            size.height = view5.bottom;
            _scrollView.contentSize = size;
            self.payType = [data objectForKey:@"PeyType"];
            switch (_payType.intValue) {
                case 1:
                {
                    self.orderPayTypeLB.text = @"支付方式:微信支付";
                }
                    break;
                case 2:
                {
                    self.orderPayTypeLB.text = @"支付方式:百度支付";
                }
                    break;
                case 3:
                {
                    self.orderPayTypeLB.text = @"支付方式:现金支付";
                }
                    break;
                case 4:
                {
                    self.orderPayTypeLB.text = @"支付方式:优惠券";
                }
                    break;
                case 5:
                {
                    self.orderPayTypeLB.text = @"支付方式:积分";
                }
                    break;
                case 6:
                {
                    self.orderPayTypeLB.text = @"支付方式:优惠券，积分";
                }
                    break;
                case 20:
                {
                    self.orderPayTypeLB.text = @"支付方式:支付宝";
                }
                    break;
                default:
                    break;
            }
            NSNumber * orderState = [data objectForKey:@"OrderState"];
            [self orderState:orderState.intValue];
//            _cancelBT.hidden = YES;
//            _confirmBT.hidden = YES;
            _paymentBT.hidden = YES;
            switch (orderState.intValue) {
                case 1:
                {
                    if ([[data objectForKey:@"IsPey"] isEqualToNumber:@YES]) {
                        self.stateLabel.text = @"已支付";
//                        _cancelBT.hidden = NO;
                    }else
                    {
                        if (_payType.intValue == 3) {
                            self.stateLabel.text = @"现金支付";
//                            _cancelBT.hidden = NO;
                        }else
                        {
                            self.stateLabel.text = @"未支付";
                            _paymentBT.hidden = NO;
                        }
                    }
                }
                    break;
                case 2:
                {
                    self.stateLabel.text = @"餐厅已经接单";
//                    _cancelBT.hidden = YES;
                }
                    break;
                case 3:
                {
                    self.stateLabel.text = @"订单已经在配送";
//                    self.confirmBT.hidden = NO;
                }
                    break;
                case 4:
                {
                    self.stateLabel.text = @"订单已作废";
                }
                    break;
                case 5:
                {
                    self.stateLabel.text = @"申请退款";
                }
                    break;
                case 6:
                {
                    self.stateLabel.text = @"退款成功";
                }
                    break;
                case 7:
                {
                    self.stateLabel.text = @"订单已完成";
                }
                    break;
                    
                default:
                    break;
            }
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showSuccessWithStatus:@"操作成功" duration:1.5];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10032])
        {
            [self downloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10035])
        {
            [self downloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10034])
        {
            
            NSNumber * stamp = [data objectForKey:@"TimeStamp"];
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
//    [SVProgressHUD dismiss];
    NSLog(@"error = %@", error);
}


- (void)createOtherMoneyView
{
    UIView * view4 = [self.scrollView viewWithTag:4000];
    
    CGFloat top = 5;
    if (![self.orderDetailsMD.firstReduce isEqualToNumber:@0]) {
        UILabel * firstTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        firstTitleLB.text = @"首单立减";
        firstTitleLB.textColor = [UIColor redColor];
        firstTitleLB.font = FONT;
        [view4 addSubview:firstTitleLB];
        
        UILabel * firstJLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, firstTitleLB.top, 50, 25)];
        firstJLB.text = [NSString stringWithFormat:@"-%@", self.orderDetailsMD.firstReduce];
        firstJLB.textAlignment = NSTextAlignmentRight;
        firstJLB.textColor = [UIColor redColor];
        firstJLB.font = FONT;
        [view4 addSubview:firstJLB];
        
        UIView * firstlineView = [[UIView alloc] initWithFrame:CGRectMake(10, firstJLB.bottom, view4.width - 20, 1)];
        firstlineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:firstlineView];
        top = firstlineView.bottom + 5;
    }
    
    if (![self.orderDetailsMD.fullReduce isEqualToNumber:@0])
    {
        UILabel * fullTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        fullTitleLB.text = @"满减优惠";
        fullTitleLB.textColor = [UIColor redColor];
        fullTitleLB.font = FONT;
        [view4 addSubview:fullTitleLB];
        
        UILabel * fullJLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, fullTitleLB.top, 50, 25)];
        fullJLB.text = [NSString stringWithFormat:@"-%@", self.orderDetailsMD.fullReduce];
        fullJLB.textAlignment = NSTextAlignmentRight;
        fullJLB.textColor = [UIColor redColor];
        fullJLB.font = FONT;
        [view4 addSubview:fullJLB];
        
        UIView * fullLineView = [[UIView alloc] initWithFrame:CGRectMake(10, fullJLB.bottom, view4.width - 20, 1)];
        fullLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:fullLineView];
        top = fullLineView.bottom + 5;
    }
    
    if (![self.orderDetailsMD.mealBoxMoney isEqualToNumber:@0])
    {
        UILabel * boxTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        boxTitleLB.text = @"餐具费";
        boxTitleLB.font  = FONT;
        [view4 addSubview:boxTitleLB];
        
        UILabel * boxPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, boxTitleLB.top, 50, 25)];
        boxPriceLB.text = [NSString stringWithFormat:@"+%@", self.orderDetailsMD.mealBoxMoney];
        boxPriceLB.textAlignment = NSTextAlignmentRight;
        boxPriceLB.textColor = [UIColor redColor];
        boxTitleLB.font = FONT;
        [view4 addSubview:boxPriceLB];
        
        UIView * boxLineView = [[UIView alloc] initWithFrame:CGRectMake(10, boxTitleLB.bottom, view4.width - 20, 1)];
        boxLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:boxLineView];
        top = boxLineView.bottom + 5;
    }
    
    
    if (![self.orderDetailsMD.deliveryMoney isEqualToNumber:@0])
    {
        UILabel * otherTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        otherTitleLB.text = @"配送费";
        otherTitleLB.font = FONT;
        [view4 addSubview:otherTitleLB];
        
        self.otherPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, otherTitleLB.top, 50, 25)];
        _otherPriceLB.text = [NSString stringWithFormat:@"+%@", self.orderDetailsMD.deliveryMoney];
        _otherPriceLB.textAlignment = NSTextAlignmentRight;
        _otherPriceLB.textColor = [UIColor redColor];
        _otherPriceLB.font = FONT;
        [view4 addSubview:_otherPriceLB];
        
        UIView * lineView8 = [[UIView alloc] initWithFrame:CGRectMake(10, _otherPriceLB.bottom, view4.width - 20, 1)];
        lineView8.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:lineView8];
        
        top = lineView8.bottom + 5;
    }
    if (![self.orderDetailsMD.reduceCard isEqualToNumber:@0]) {
        UILabel * reduceCardTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        reduceCardTitleLB.text = @"优惠券";
        reduceCardTitleLB.textColor = TEXT_COLOR;
        [view4 addSubview:reduceCardTitleLB];
        
        UILabel * reduceCardFaceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, reduceCardTitleLB.top, 50, 25)];
        reduceCardFaceLB.text = [NSString stringWithFormat:@"-%@", self.orderDetailsMD.reduceCard];
        reduceCardFaceLB.textAlignment = NSTextAlignmentRight;
        reduceCardFaceLB.textColor = [UIColor redColor];
        [view4 addSubview:reduceCardFaceLB];
        
        UIView * reduceCardLineView = [[UIView alloc] initWithFrame:CGRectMake(10, reduceCardFaceLB.bottom, view4.width - 20, 1)];
        reduceCardLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:reduceCardLineView];
        top = reduceCardLineView.bottom + 5;
    }
    if (![self.orderDetailsMD.internal isEqualToNumber:@0]) {
        UILabel * intenalTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        intenalTitleLB.text = @"积分";
        intenalTitleLB.textColor = TEXT_COLOR;
        [view4 addSubview:intenalTitleLB];
        
        
        
        UILabel * intenalLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, intenalTitleLB.top, 50, 25)];
        intenalLB.text = [NSString stringWithFormat:@"-%.2f", [self.orderDetailsMD.internal intValue] / 100.0];
        intenalLB.textAlignment = NSTextAlignmentRight;
        intenalLB.textColor = [UIColor redColor];
        [view4 addSubview:intenalLB];
        
        UIView * intenalLineView = [[UIView alloc] initWithFrame:CGRectMake(10, intenalLB.bottom, view4.width - 20, 1)];
        intenalLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:intenalLineView];
        top = intenalLineView.bottom + 5;
    }
    if (![self.orderDetailsMD.discount isEqualToNumber:@0]) {
        UILabel * discountTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
        discountTitleLB.text = @"打折优惠";
        discountTitleLB.textColor = TEXT_COLOR;
        [view4 addSubview:discountTitleLB];
        
        
        
        UILabel * discountLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, discountTitleLB.top, 50, 25)];
        discountLB.text = [NSString stringWithFormat:@"%@折", self.orderDetailsMD.discount];
        discountLB.textAlignment = NSTextAlignmentRight;
        discountLB.textColor = [UIColor redColor];
        [view4 addSubview:discountLB];
        
        UIView * dsicountLineView = [[UIView alloc] initWithFrame:CGRectMake(10, discountLB.bottom, view4.width - 20, 1)];
        dsicountLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [view4 addSubview:dsicountLineView];
        top = dsicountLineView.bottom + 5;
    }
    
    UILabel * totalLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
    totalLB.text = @"合计";
    totalLB.font = FONT;
    [view4 addSubview:totalLB];
    
    self.totalPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(totalLB.right, totalLB.top, view4.width - totalLB.width - 30, 25)];
//    _totalPriceLB.text = @"¥35";
    _totalPriceLB.textAlignment = NSTextAlignmentRight;
    _totalPriceLB.textColor = [UIColor redColor];
    _totalPriceLB.font = FONT;
    [view4 addSubview:_totalPriceLB];
    
    UIView * lineView9 = [[UIView alloc] initWithFrame:CGRectMake(0, totalLB.bottom, view4.width, 1)];
    lineView9.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view4 addSubview:lineView9];
    view4.height = lineView9.bottom;
    
    self.storeNameLB.text = _orderDetailsMD.storeName;
    self.otherPriceLB.text = [NSString stringWithFormat:@"¥%@", _orderDetailsMD.deliveryMoney];
    self.totalPriceLB.text = [NSString stringWithFormat:@"¥%@", _orderDetailsMD.allMoney];
    self.orderNumberLB.text = [NSString stringWithFormat:@"订到号码:%@", self.orderID];
    self.orderDateLB.text = [NSString stringWithFormat:@"订单时间:%@",_orderDetailsMD.time];
    self.orderTelLB.text = [NSString stringWithFormat:@"手机号码:%@", _orderDetailsMD.nextphone];
    self.orderAddressLB.text = [NSString stringWithFormat:@"收餐地址:%@", _orderDetailsMD.address];
    [_orderAddressLB sizeToFit];
}

- (void)orderState:(int)state
{
    UIView * view2 = [self.scrollView viewWithTag:2000];
    for (int i = 0; i < 4; i++) {
        UIImageView * stateIV = (UIImageView *)[view2 viewWithTag:10001 + i];
        UILabel * stateLB = (UILabel *)[view2 viewWithTag:20001 + i];
        if (state == i + 1 && state != 4) {
            stateLB.textColor = [UIColor greenColor];
            stateIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState%d.png", i + 1]];
        }else if (state == 7)
        {
            stateIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState%d.png", i + 1]];
            if (i == 3) {
                stateLB.textColor = [UIColor greenColor];
            }
        }else if (state > i + 1 && state < 4)
        {
            stateIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState%d.png", i + 1]];
        }
    }
}


- (void)cancelOrder:(UIButton *)button
{
    NSDictionary * dic = @{
                           @"Command":@32,
                           @"UserId":[UserInfo shareUserInfo].userId,
                           @"TakeoutOrderId":self.orderID
                           };
    [self playPostWithDictionary:dic];
//    [SVProgressHUD showWithStatus:@"取消请求中..." maskType:SVProgressHUDMaskTypeClear];
}


- (void)confirmOrder:(UIButton *)button
{
    NSDictionary * dic = @{
                           @"Command":@35,
                           @"UserId":[UserInfo shareUserInfo].userId,
                           @"OrderId":self.orderID,
                           @"PayType":self.payType
                           };
    [self playPostWithDictionary:dic];
//    [SVProgressHUD showWithStatus:@"确认中..." maskType:SVProgressHUDMaskTypeClear];
}



- (void)immediatePayment:(UIButton *)button
{
    if ([self.payType isEqualToNumber:@1]) {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            //            [SVProgressHUD showWithStatus:@"正在提交支付..." maskType:SVProgressHUDMaskTypeClear];
            NSDictionary * dic = @{
                                   @"Command":@34,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"PayType":self.payType,
                                   @"OrderId":self.orderID,
                                   @"Cur_IP":[self getIPAddress],
                                   @"OrderType":@2
                                   };
            [self playPostWithDictionary:dic];
            self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            [self.hud showInView:self.view];
        }else
        {
            //            [SVProgressHUD showErrorWithStatus:@"你还没安装微信或者微信版本太低" duration:2];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"没安装微信或者微信版本太低" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
        
    }else if ([self.payType isEqualToNumber:@2])
    {
        BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
        NSString *orderInfo = [self buildOrderInfoWithOrderID:self.orderID];
        [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
    }else
    {
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
            order.amount = [NSString stringWithFormat:@"%.2f",self.orderDetailsMD.allMoney.doubleValue]; //商品价格
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
                }];
                
            }
            
            
        }
    }
    
}


#pragma mark - 百度支付
-(NSString*)buildOrderInfoWithOrderID:(NSString *)orderId
{
    int money = (int)(self.orderDetailsMD.allMoney.doubleValue * 100);
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
    [str appendString:[self utf8toGbk:self.orderDetailsMD.storeName]];
    [str appendString:@"&goods_name="];
    [str appendString:[self utf8toGbk:self.orderDetailsMD.storeName]]; // 中文处理1
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
    [str1 appendString:[self encodeURL:[self utf8toGbk:self.orderDetailsMD.storeName]]];
    [str1 appendString:@"&goods_name="];
    [str1 appendString:[self encodeURL:[self utf8toGbk:self.orderDetailsMD.storeName]]]; // 中文处理3
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
    if (statusCode == 0) {
        [self downloadData];
    }
    NSLog(@"支付结束 接口 code:%d desc:%@",statusCode,payDesc);
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
