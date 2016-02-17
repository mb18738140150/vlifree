//
//  OnlinePayViewController.m
//  vlifree
//
//  Created by 仙林 on 15/10/16.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "OnlinePayViewController.h"
#import "BillingInfoView.h"
#import "MenuModel.h"
#import "FinishOrderViewController.h"
#import "payRequsestHandler.h"
#import "CouponModel.h"
#import "CouponView.h"
#import "CouponTableViewCell.h"
#import "IntegralView.h"

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

#define TOP_SPACE 10
#define LEFT_SPACE 10
#define LABEL_HEIGHT 30

#define MAIN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface OnlinePayViewController ()<HTTPPostDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, BDWalletSDKMainManagerDelegate>

@property (nonatomic, strong)BillingInfoView * totalMoneyView;
@property (nonatomic, strong)BillingInfoView * couponsView;
@property (nonatomic, strong)BillingInfoView * scoreView;
@property (nonatomic, strong)BillingInfoView * needMoneyView;

@property (nonatomic, strong)PayTypeView * weixinView;
@property (nonatomic, strong)PayTypeView * baiduView;
@property (nonatomic, strong)PayTypeView * aliPayView;

@property (nonatomic, strong)UILabel * scoreLabel;
@property (nonatomic, strong)UILabel * needMoney;

@property (nonatomic, assign)NSInteger payType;

@property (nonatomic, strong)JGProgressHUD * hud;

@property (nonatomic, strong)UIView *tanchuView;
@property (nonatomic, strong)CouponView * couponView;

@property (nonatomic, strong)UIView *tanchuView1;
@property (nonatomic, strong)IntegralView * integralView;

// 优惠券列表数组
@property (nonatomic, strong)NSMutableArray * couponListArray;

@property (nonatomic, copy)NSString * couponFace;

// 店内积分总数
@property (nonatomic, assign)int Integral;
// 抵消积分个数
@property (nonatomic, assign)int useIntegral;
// 优惠券id
@property (nonatomic, assign)int useCoupon;

@property (nonatomic, strong)NSNumber * realMonry;

// 使用的优惠券面额
@property (nonatomic, assign)int couponMoney;
//@property (nonatomic, assign) id<BDWalletSDKLoginDelegate> loginSDKDelegate;
//@property (nonatomic, strong) SAPILoginViewController * loginWebViewController;
@end

@implementation OnlinePayViewController
//@synthesize loginWebViewController;


- (NSMutableArray *)couponListArray
{
    if (!_couponListArray) {
        self.couponListArray = [NSMutableArray array];
    }
    return _couponListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    UIScrollView * scroView = [[UIScrollView alloc]init];
    scroView.tag = 2000;
    scroView.frame = self.view.frame;
    [self.view addSubview:scroView];
    
    UILabel * billinginfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    billinginfoLabel.text = @"结算信息";
    billinginfoLabel.font = [UIFont systemFontOfSize:20];
    billinginfoLabel.backgroundColor = [UIColor clearColor];
    [scroView addSubview:billinginfoLabel];
    
    self.totalMoneyView = [[BillingInfoView alloc]initWithFrame:CGRectMake(0, billinginfoLabel.bottom, self.view.width, 40)];
    _totalMoneyView.titleLabel.text = @"交易金额";
    [_totalMoneyView.button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_totalMoneyView.button setTitle:[NSString stringWithFormat:@"%.2f", self.totalMoney] forState:UIControlStateNormal];
//    _totalMoneyView.buttonLabel.text = [NSString stringWithFormat:@"%.2f", self.totalMoney];
    [scroView addSubview:_totalMoneyView];
    
    self.couponsView = [[BillingInfoView alloc]initWithFrame:CGRectMake(0, _totalMoneyView.bottom, self.view.width, 40)];
    _couponsView.titleLabel.text = @"您有优惠券可使用";
    [_couponsView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_couponsView.button setTitle:@"点击使用" forState:UIControlStateNormal];
    [_couponsView.button addTarget:self action:@selector(useCouponsAction:) forControlEvents:UIControlEventTouchUpInside];
    [scroView addSubview:_couponsView];
    
    self.scoreView = [[BillingInfoView alloc]initWithFrame:CGRectMake(0, _couponsView.bottom, self.view.width, 40)];
    _scoreView.titleLabel.text = @"您有10000积分可使用";
    [_scoreView.button setTitle:@"点击使用" forState:UIControlStateNormal];
    [_scoreView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_scoreView.button addTarget:self action:@selector(useScoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [scroView addSubview:_scoreView];
    
    
    UIView * payView = [[UIView alloc] initWithFrame:CGRectMake(0, _scoreView.bottom + TOP_SPACE, scroView.width, 100)];
    payView.backgroundColor = [UIColor whiteColor];
    payView.tag = 1000;
    [scroView addSubview:payView];
    
    
    UILabel * payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, payView.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    payLabel.text = @"支付方式";
    payLabel.textColor = [UIColor grayColor];
    payLabel.font = [UIFont systemFontOfSize:14];
    [payView addSubview:payLabel];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLabel.bottom, payLabel.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [payView addSubview:lineView];
    
        self.weixinView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, lineView.bottom, payView.width, 40)];
        _weixinView.changeButton.selected = YES;
        [_weixinView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
        _weixinView.iconView.image = [UIImage imageNamed:@"weixinzhifu.png"];
        _weixinView.titleLabel.text = @"微信支付";
        [payView addSubview:_weixinView];
    
    
        _payType = 1;
        self.baiduView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, _weixinView.bottom, payView.width, 40)];
        _baiduView.iconView.image = [UIImage imageNamed:@"baiduzhifu.png"];
        _baiduView.titleLabel.text = @"百度钱包";
        [_baiduView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
        [payView addSubview:_baiduView];
    
    self.aliPayView = [[PayTypeView alloc]initWithFrame:CGRectMake(0, _baiduView.bottom, payView.width, 40)];
    _aliPayView.iconView.image = [UIImage imageNamed:@"alipey_icon.png"];
    _aliPayView.titleLabel.text = @"支付宝";
    [_aliPayView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:_aliPayView];
    
    
        if (![WXApi isWXAppInstalled]) {
            _weixinView.hidden = YES;
            _aliPayView.top = _baiduView.top;
            _baiduView.top = _weixinView.top;
            _baiduView.changeButton.selected = YES;
            _payType = 2;
        }
    
    payView.height = _aliPayView.bottom + TOP_SPACE;
    
//    UIView * lineView10 = [[UIView alloc] initWithFrame:CGRectMake(0, payView.bottom, payView.width, 1)];
//    lineView10.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
//    [scroView addSubview:lineView10];
    
    UIButton * confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBT.frame = CGRectMake(LEFT_SPACE, payView.bottom + 2 * TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 40);
    confirmBT.backgroundColor = MAIN_COLOR;
    [confirmBT setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBT addTarget:self action:@selector(confirmOrderAndPayType:) forControlEvents:UIControlEventTouchUpInside];
    confirmBT.layer.cornerRadius = 10;
    [scroView addSubview:confirmBT];
    
    scroView.contentSize = CGSizeMake(scroView.width, confirmBT.bottom);
    
    NSDictionary * jsondic = @{
                               @"Command":@44,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"StoreId":self.takeOutId
                               };
    
    [self playPostWithDictionary:jsondic];
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    [self.hud showInView:self.view];
    
    self.useCoupon = 0;
    self.useIntegral = 0;
    
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 优惠券弹出框
- (void)useCouponsAction:(UIButton *)button
{
    NSLog(@"***self.totalMoney * 100 = %.2f self.useIntegral = %d",self.totalMoney * 100, self.useIntegral);
    
    if (self.totalMoney * 100 > self.useIntegral) {
        if (self.couponView) {
            if (self.tanchuView.alpha != 0) {
                self.tanchuView.alpha = 0;
            }else
            {
                [self animatedIn];
            }
        }else
        {
            
            UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
            
            self.tanchuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, MAIN_HEIGHT)];
            _tanchuView.backgroundColor = [UIColor grayColor];
            _tanchuView.alpha = .5;
            [keyWindow addSubview:_tanchuView];
            
            self.couponView = [[CouponView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 2 * 10, 350)];
            self.couponView.center = _tanchuView.center;
            [_tanchuView addSubview:_couponView];
            
            [self.couponView.backButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.couponView.noCouponButton addTarget:self action:@selector(noChoiceAction:) forControlEvents:UIControlEventTouchUpInside];
            
            self.couponView.couponTableView.dataSource = self;
            self.couponView.couponTableView.delegate = self;
            
            [self animatedIn];
        }

    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您已使用积分足额抵现" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10004;
        [alert show];
    }
    
}

- (void)animatedIn
{
    self.tanchuView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.tanchuView.alpha = 1;
        self.tanchuView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)cancleAction
{
    self.tanchuView.alpha = 0;
    
}

- (void)noChoiceAction:(UIButton *)button
{
    
    if (self.couponView.stateImageview.hidden == YES) {
         self.couponView.stateImageview.hidden = NO;
    }else
    {
        
    }
    self.couponFace = nil;
    [self.couponView.couponTableView reloadData];
    _couponsView.titleLabel.text = @"您有优惠券可使用";
    [self.couponsView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.couponsView.imageView.hidden = YES;
    self.useCoupon = 0;
    self.couponMoney = 0;
    self.tanchuView.alpha = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    CouponTableViewCell * couponCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == couponCell) {
        couponCell = [[CouponTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [couponCell createSubview:self.couponView.couponTableView.bounds];
    couponCell.imageStateview.hidden = YES;
    CouponModel * couponModel = [self.couponListArray objectAtIndex:indexPath.row];
    couponCell.couponModel = couponModel;
    
    return couponCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageStateview.hidden = NO;
    self.couponView.stateImageview.hidden = YES;
    self.couponFace = [cell.faceLabel.text substringFromIndex:1];
    self.couponsView.titleLabel.text = [NSString stringWithFormat:@"您使用了%@元优惠券", self.couponFace];
    self.useCoupon = [cell.nameLabel.text intValue];
    self.couponMoney = [self.couponFace intValue];
    [self.couponsView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.couponsView.imageView.hidden = NO;
    self.tanchuView.alpha = 0;
    
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageStateview.hidden = YES;
}
#pragma mark - 积分弹出框

- (void)useScoreAction:(UIButton * )button
{
    NSLog(@"***self.totalMoney = %.2f self.couponMoney = %d",self.totalMoney, self.couponMoney);
    
    if (self.totalMoney > self.couponMoney) {
        if (self.integralView) {
            if (self.tanchuView1.alpha != 0) {
                self.tanchuView1.alpha = 0;
            }else
            {
                [self animatedIn1];
            }
        }else
        {
            
            UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
            
            self.tanchuView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, MAIN_HEIGHT)];
            _tanchuView1.backgroundColor = [UIColor grayColor];
            _tanchuView1.alpha = .2;
            [keyWindow addSubview:_tanchuView1];
            
            self.integralView = [[IntegralView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 2 * 10, 350)];
            self.integralView.center = _tanchuView1.center;
            [_tanchuView1 addSubview:_integralView];
            
            [self.integralView.backButton addTarget:self action:@selector(cancleAction1) forControlEvents:UIControlEventTouchUpInside];
            
            [self.integralView.giveupview.nameButton addTarget:self action:@selector(noChoiceIntegralAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.integralView.useTotalview.nameButton addTarget:self action:@selector(useAllIntegralAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.integralView.choseIntegralview.nameButton addTarget:self action:@selector(choseIntegralAction:) forControlEvents:UIControlEventTouchUpInside];
            
            self.integralView.totalLabel.text = [NSString stringWithFormat:@"%d", self.Integral];
            
            [self animatedIn1];
        }

    }else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您已使用优惠券足额抵现" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10003;
        [alert show];
    }
 
}

- (void)animatedIn1
{
    self.tanchuView1.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView1.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.tanchuView1.alpha = 1;
        self.tanchuView1.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)cancleAction1
{
    self.tanchuView1.alpha = 0;
}

- (void)noChoiceIntegralAction:(UIButton *)button
{
    self.integralView.giveupview.stateImageView.hidden = NO;
    self.integralView.useTotalview.stateImageView.hidden = YES;
    self.integralView.choseIntegralview.stateImageView.hidden = YES;
    
    self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您有%d积分可使用", self.Integral];
    self.useIntegral = 0;
    [self.scoreView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.scoreView.imageView.hidden = YES;
    self.tanchuView1.alpha = 0;
    
    UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:2000];
    UIView * payView = [scrollView viewWithTag:1000];
    payView.hidden = NO;
//    self.weixinView.hidden = NO;
//    self.baiduView.hidden = NO;
}

- (void)useAllIntegralAction:(UIButton *)button
{
    self.integralView.giveupview.stateImageView.hidden = YES;
    self.integralView.useTotalview.stateImageView.hidden = NO;
    self.integralView.choseIntegralview.stateImageView.hidden = YES;
    
    self.tanchuView1.alpha = 0;
    
        if ((self.totalMoney - self.couponMoney) * 100 >= self.Integral) {
            self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您使用了%d积分,抵消了%.2f元", self.Integral, self.Integral / 100.0];
            self.useIntegral = self.Integral;
            UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:2000];
            UIView * payView = [scrollView viewWithTag:1000];
            payView.hidden = NO;
        }else
        {
            self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您使用%.0f积分抵消了%.2f元", (self.totalMoney - self.couponMoney) * 100, (self.totalMoney - self.couponMoney)];
            NSString * str = [NSString stringWithFormat:@"%.2f", (self.totalMoney - self.couponMoney) * 100];
            self.useIntegral = [str intValue];
//            self.weixinView.hidden = YES;
//            self.baiduView.hidden = YES;
            UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:2000];
            UIView * payView = [scrollView viewWithTag:1000];
            payView.hidden = YES;
        }
        
//        [self.scoreView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.scoreView.imageView.hidden = NO;
    
}

- (void)choseIntegralAction:(UIButton *)button
{
    
    self.integralView.giveupview.stateImageView.hidden = YES;
    self.integralView.useTotalview.stateImageView.hidden = YES;
    self.integralView.choseIntegralview.stateImageView.hidden = NO;
    
    self.tanchuView1.alpha = 0;
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请输入积分数量" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 10001;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 10001) {
        if (buttonIndex == 0) {
//            self.weixinView.hidden = NO;
//            self.baiduView.hidden = NO;
            UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:2000];
            UIView * payView = [scrollView viewWithTag:1000];
            payView.hidden = NO;
            double a = [[alertView textFieldAtIndex:0].text doubleValue];
            if (a > self.Integral) {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"您的积分不足" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 10002;
                [alert show];
                
            }else
            {
                if (self.totalMoney * 100 >= a) {
                    self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您使用了%.0f积分,抵消了%.2f元", a, a / 100.0];
                    self.useIntegral = a;
                }else
                {
                    self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您使用%.0f积分抵消了%.2f元", self.totalMoney * 100, self.totalMoney];
                    self.useIntegral = [[alertView textFieldAtIndex:0].text intValue];
//                    self.weixinView.hidden = YES;
//                    self.baiduView.hidden = YES;
                    UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:2000];
                    UIView * payView = [scrollView viewWithTag:1000];
                    payView.hidden = YES;
                }
//                [self.scoreView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.scoreView.imageView.hidden = NO;
            }
        }else
        {
            
        }

    }else if (alertView.tag == 10002)
    {
        self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您有%d积分可使用", self.Integral];
        [self.scoreView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.scoreView.imageView.hidden = YES;
    }else if (alertView.tag == 10003)
    {
        self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您有%d积分可使用", self.Integral];
        [self.scoreView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.scoreView.imageView.hidden = YES;
    }else if (alertView.tag == 10004)
    {
        _couponsView.titleLabel.text = @"您有优惠券可使用";
        [self.couponsView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.couponsView.imageView.hidden = YES;
    }
}

#pragma mark - 选择支付方式
- (void)changePayType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    if ([button isEqual:self.weixinView.changeButton]) {
        self.baiduView.changeButton.selected = NO;
        self.aliPayView.changeButton.selected = NO;
        _payType = 1;
    }else if ([button isEqual:self.baiduView.changeButton])
    {
        self.weixinView.changeButton.selected = NO;
        self.aliPayView.changeButton.selected = NO;
        _payType = 2;
    }else if ([button isEqual:self.aliPayView.changeButton])
    {
         self.baiduView.changeButton.selected = NO;
        self.weixinView.changeButton.selected = NO;
        _payType = 20;
    }
    
    
    button.selected = !button.selected;
}

#pragma mark - 确认付款

- (void)confirmOrderAndPayType:(UIButton *)button
{
    if (_payType == 1) {
        //            [self sendPay_demo];//微信支付
        if([WXApi isWXAppInstalled] == NO)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的设备还没安装微信,请先安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            return;
        }else if([WXApi isWXAppSupportApi] == NO)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的微信版本不支持,请更新微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            return;
        }
    }
    
    NSDictionary * jsonDic = @{
                               @"Command":@45,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"StoreId":self.takeOutId,
                               @"AllMoney":@(self.totalMoney),
                               @"CouponId":@(self.useCoupon),
                               @"Integral":@(self.useIntegral)
                               };
    // 积分优惠券均使用
    if (self.useCoupon && self.useIntegral) {
        _payType = 6;
    }else if (self.useCoupon)
    {
        // 仅使用优惠券
        _payType = 4;
    }else if (self.useIntegral)
    {
        // 仅使用积分
        _payType = 5;
    }
    
    [_jsondic setObject:[NSNumber numberWithInteger:_payType] forKey:@"PayType"];
    [_jsondic setObject:[NSNumber numberWithInteger:_useIntegral] forKey:@"Integral"];
    [_jsondic setObject:[NSNumber numberWithInteger:_useCoupon] forKey:@"CouponId"];
    
    [self playPostWithDictionary:jsonDic];
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    [self.hud showInView:self.view];

}


#pragma mark - 请求
- (void)playPostWithDictionary:(NSDictionary * )dic
{

    NSString * jsonStr = [dic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"+++%@", [data description]);
    [self.hud dismiss];
    self.hud = nil;
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1])
    {
        
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10014]) {
            self.orderID = [data objectForKey:@"WakeOutOrder"];
            NSNumber * payType = [data objectForKey:@"PayType"];
            if ([payType isEqualToNumber:@1]) {
                NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"AppId"]]       forKey:@"appid"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"NonceStr"]]    forKey:@"noncestr"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"Package"]]      forKey:@"package"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"PartnerId"]]        forKey:@"partnerid"];
                [signParams setObject: [data objectForKey:@"TimeStamp"]   forKey:@"timestamp"];
                [signParams setObject: [data objectForKey:@"PrepayId"]    forKey:@"prepayid"];
                
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
                BOOL a = [WXApi sendReq:req];
                NSLog(@"%d", a);
            }else if ([payType isEqualToNumber:@2])
            {
                BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
                payMainManager.delegate = self;
                NSString *orderInfo = [self buildOrderInfoWithOrderID:[data objectForKey:@"WakeOutOrder"]];
                [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
//                [[SAPIMainManager sharedManager] setDelegate:self];
//                SAPILoginModel * model = [SAPIMainManager sharedManager].currentLoginModel;
//                if (!model) {
//                    self.loginWebViewController = [[SAPILoginViewController alloc]init];
//                    loginWebViewController.hidesBottomBarWhenPushed = YES;
//                    
//                    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginWebViewController];
//                    [self presentViewController:nav animated:YES completion:nil];
//                    
//                }else
//                {
#warning 百度支付登录
//                    
//                    [self paybyBaidu];
//                    
//                    
//                }

            }
            else if ([payType isEqualToNumber:@20])
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
                order.tradeNO = [data objectForKey:@"WakeOutOrder"]; //订单ID（由商家自行制定）
                order.productName = [data objectForKey:@"WakeOutOrder"]; //商品标题
                order.productDescription = [data objectForKey:@"WakeOutOrder"]; //商品描述
                order.amount = [NSString stringWithFormat:@"%.2f",self.realMonry.doubleValue]; //商品价格
                order.notifyURL =  @"http://www.xxx.com"; //回调URL
                
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
                        [self pushFinishOrderVC];
                    }];
                    
                }

                
            }else
            {
                [self pushFinishOrderVC];
            }
            

        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10044]) {
            self.Integral = [[data objectForKey:@"Integral"] intValue];
            NSArray * array = [data objectForKey:@"CouponList"];
            for (NSDictionary * dic in array) {
                CouponModel * couponModel = [[CouponModel alloc]initWithDictionary:dic];
                [self.couponListArray addObject:couponModel];
            }
            
            if (self.couponListArray.count == 0) {
                self.couponsView.titleLabel.text = @"您没有优惠券可使用";
                self.couponsView.button.hidden = YES;
            }
            self.scoreView.titleLabel.text = [NSString stringWithFormat:@"您有%d积分可使用", self.Integral];
            if (self.Integral == 0) {
                self.scoreView.button.hidden = YES;
            }
            
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10045])
        {
            double  realMoney = [[data objectForKey:@"RealMoney"] doubleValue];
            if (realMoney == 0) {
//                [self pushFinishOrderVC];
            }else
            {
                if (self.weixinView.changeButton.selected) {
                    _payType = 1;
                }else if (self.baiduView.changeButton.selected)
                {
                    _payType = 2;
                }else if (self.aliPayView.changeButton.selected)
                {
                    _payType = 20;
                }
            }
            [_jsondic setObject:[NSNumber numberWithInteger:_payType] forKey:@"PayType"];
            [_jsondic setValue:[data objectForKey:@"RealMoney"] forKey:@"TotalMoney"];
            self.realMonry = [data objectForKey:@"RealMoney"];
            [self playPostWithDictionary:_jsondic];
            self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            [self.hud showInView:self.view];
            
            
        }
        
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
    //    [SVProgressHUD dismiss];
}
- (void)failWithError:(NSError *)error
{
    //    [SVProgressHUD dismiss];
    NSLog(@"error = %@", error);
}
#pragma mark - 支付成功跳转到订单页面

- (void)pushFinishOrderVC
{
    FinishOrderViewController * finishOrderVC = [[FinishOrderViewController alloc] init];
    finishOrderVC.orderID = self.orderID;
    [self.navigationController pushViewController:finishOrderVC animated:YES];
}

#pragma mark -
//
//- (void)walletSDKComeIn:(id)sender
//{
//    [[SAPIMainManager sharedManager] setDelegate:self];
//    
//    SAPILoginModel *model = [SAPIMainManager sharedManager].currentLoginModel;
//    
//    if (!model)
//    {
//        self.loginWebViewController = [[SAPILoginViewController alloc] init];
//        loginWebViewController.hidesBottomBarWhenPushed = YES;
//        
//        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginWebViewController];
//        [self presentViewController:nav animated:YES completion:nil];
//        
//    }else {
//        
//    }
//}

//- (void)sapiManager:(SAPIMainManager *)sapiManager didLoginSucceed:(SAPILoginModel *)model
//{
//    NSLog(@"百度支付登录成功");
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"百度支付登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alert show];
//    [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
//    [self.loginSDKDelegate BDWalletSDKLoginSuccessedWithLoginType:BDWalletSDK_Login_Type_ACCESS_TOKEN token:model.bduss];
//    [self.loginWebViewController.navigationController dismissViewControllerAnimated:YES completion:^{
//        [self.loginSDKDelegate BDWalletSDKLoginSuccessedAfterLoginViewDidDisappearWithLoginType:BDWalletSDK_Login_Type_ACCESS_TOKEN token:model.bduss];
//    }];
//}

//- (void)sapiManager:(SAPIMainManager *)sapiManager didLogOut:(SAPILoginModel *)model
//{
//    NSLog(@"百度支付退出登录");
//}

-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDesc
{
    NSLog(@"支付结束 接口 code:%d desc:%@",statusCode,payDesc);
    [self pushFinishOrderVC];
    if (statusCode == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        //        [SVProgressHUD showErrorWithStatus:@"支付失败" duration:2];
    }
}

//- (BOOL)isLogin
//{
//    SAPILoginModel * model = [SAPIMainManager sharedManager].currentLoginModel;
//    if (model) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)loginWithDelegate:(id<BDWalletSDKLoginDelegate>)loginDelegate withController:(UIViewController *)controller
//{
//    self.loginSDKDelegate = loginDelegate;
//    [self walletSDKComeIn:controller];
//}

- (void)logEventId:(NSString *)eventId eventDesc:(NSString *)eventDesc
{
    NSLog(@"**************************\nlogEventId eventDes %@  %@\n********************",eventId,eventDesc);
}

- (void)handleWalletErrorWithCode:(int)errorCode
{
    NSLog(@"登录失效");
}

//- (NSDictionary *)BDWalletLoginInfo
//{
//    SAPILoginModel * model = [SAPIMainManager sharedManager].currentLoginModel;
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:model.uid forKey:@"uid"];
//    [dic setValue:model.bduss forKey:@"bduss"];
//    NSLog(@"########获取登录信息 BDWalletLoginInfo \n%@\n####",model.bduss);
//    [dic setValue:model.uname forKey:@"uname"];
//    [dic setValue:model.displayname forKey:@"displayname"];
//    return dic;
//}

- (void)paybyBaidu
{
    int money = (int)(_totalMoney * 100);
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    
    [order setValue:@"test" forKey:@"goods_name"];
    [order setValue:self.realMonry forKey:@"total_amount"];
    [order setValue:@"http://db-testing-eb07.db01.baidu.com:8666/success.html" forKey:@"return_url"];
    [order setValue:@"2" forKey:@"pay_type"];
    [order setValue:[NSString stringWithFormat:@"%d", money] forKey:@"unit_amount"];
    [order setValue:@"1" forKey:@"unit_count"];
    [order setValue:@"0" forKey:@"transport_amount"];
    [order setValue:@"" forKey:@"page_url"];
    [order setValue:@"" forKey:@"buyer_sp_username"];
    [order setValue:@"ios123" forKey:@"extra"];
    [order setValue:[self utf8toGbk:self.storeName] forKey:@"goods_desc"];
    [order setValue:@"" forKey:@"goods_url"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *environment = [userDefaults objectForKey:@"SapiEnvironment"];
    if ([environment isEqualToString:@"1"]) {
        [order setValue:@"online" forKey:@"environment"];
    }else if ([environment isEqualToString:@"2"]) {
        [order setValue:@"rd" forKey:@"environment"];
    }else if ([environment isEqualToString:@"3"]) {
        [order setValue:@"qa" forKey:@"environment"];
    }
}


#pragma mark - 百度支付
-(NSString*)buildOrderInfoWithOrderID:(NSString *)orderId
{
    int money = self.realMonry.intValue * 100;
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
    [str appendString:[self utf8toGbk:self.storeName]];
    [str appendString:@"&goods_name="];
    [str appendString:[self utf8toGbk:self.storeName]]; // 中文处理1
    [str appendString:@"&input_charset=1&order_create_time="];//下单时间
    [str appendString:dateString];//订单生产时间
    [str appendString:@"&order_no="];
    [str appendString:orderId];
    [str appendString:@"&pay_type=2"];
    [str appendString:@"&return_url=http://wap.vlifee.com/bfbpay/notifyurl.aspx&service_code=1&sign_method=1&sp_no="];// http://wap.vlifee.com/bfbpay/notifyurl.aspx http://wap.vlifee.com/NotifyUrl.aspx
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
    [str1 appendString:[self encodeURL:[self utf8toGbk:self.storeName]]];
    [str1 appendString:@"&goods_name="];
    [str1 appendString:[self encodeURL:[self utf8toGbk:self.storeName]]]; // 中文处理3
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

-(void)dopay
{
    BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
    payMainManager.delegate = self;
    NSString *orderInfo = [self buildOrderInfoTest];    //创建测试orderInfo
    
    // for your info
    {
        // 可选
        //[payMainManager setBdWalletNavTitleColor:Your color];
        //[[BDWalletSDKMainManager getInstance] setBdWalletNavBgImage:[UIImage imageNamed:Your NavBgImage]];
        //[[BDWalletSDKMainManager getInstance] setBdWalletNavBackNormalImage:[UIImage imageNamed:Your BackImage]];
    }
    
    [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
    
}

/*
 此处生成的订单OrderInfo为测试专用，请接入的商户兄弟使用自己的订单，并且是按首字母排序的
 */

-(NSString*)buildOrderInfoTest
{
    NSMutableString *str = [[NSMutableString alloc]init];
    
    static NSString *spNo = @"3400000001";//测试专用，请勿使用
    static NSString *key = @"Au88LPiP5vaN5FNABBa7NC4aQV28awRK";//测试专用，请勿使用
    NSDateFormatter * dateFM = [[NSDateFormatter alloc] init];
    [dateFM setDateFormat:@"YYYYMMDDHHMMSS"];
    NSString * dateString = [dateFM stringFromDate:[NSDate date]];
    NSLog(@"11111--%@", dateString);
    /*
     如有中文相关，步骤一 GBK ；步骤二 MD5 GBK ； 步骤三 URLEncode GBK
     详见以下注释
     */
    NSString *orderId = [NSString stringWithFormat:@"z2015052713275609521156"];
    [str appendString:@"currency=1&extra="];
    [str appendString:@"&goods_desc="];
    [str appendString:[self utf8toGbk:@"外卖"]];
    [str appendString:@"&goods_name="];
    [str appendString:[self utf8toGbk:@"外卖商品"]]; // 中文处理1
    [str appendString:@"&goods_url=http://item.jd.com/736610.html&input_charset=1&order_create_time="];//下单时间
    [str appendString:dateString];//订单生产时间
    [str appendString:@"&order_no="];
    [str appendString:orderId];
    [str appendString:@"&pay_type=2"];
    [str appendString:@"&return_url=http://item.jd.com/736610.html&service_code=1&sign_method=1&sp_no="];
    [str appendString:spNo];
    [str appendString:@"&sp_request_type="];
    [str appendString:@"1"];//收银类型
    [str appendString:@"&sp_uno="];
    [str appendString:@""];//用户的id(用来绑定快捷支付)
    [str appendString:@"&total_amount="];
    [str appendString:@"1"];//总金额(以分为单位)
    [str appendString:@"&transport_amount=0&unit_amount="];
    [str appendString:@"1"];//商品单价(以分为单位)
    [str appendString:@"&unit_count=1"];//商品数量
    
    NSString *md5CapPwd = [self mD5GBK:[NSString stringWithFormat:@"%@&key=%@" , str, key]]; // 中文处理2
    
    NSMutableString *str1 = [[NSMutableString alloc]init];
    
    [str1 appendString:@"currency=1&extra="];
    [str1 appendString:@"&goods_desc="];
    [str1 appendString:[self encodeURL:[self utf8toGbk:@"外卖"]]];
    [str1 appendString:@"&goods_name="];
    [str1 appendString:[self encodeURL:[self utf8toGbk:@"外卖商品"]]];// 中文处理3
    [str1 appendString:@"&goods_url=http://item.jd.com/736610.html&input_charset=1&order_create_time=20130508131702&order_no="];
    [str1 appendString:orderId];
    [str1 appendString:@"&pay_type=2"];
    [str1 appendString:@"&return_url=http://item.jd.com/736610.html&service_code=1&sign_method=1&sp_no="];
    [str1 appendString:spNo];
    [str1 appendString:@"&sp_request_type="];
    [str1 appendString:@"1"];//收银类型
    [str1 appendString:@"&sp_uno="];
    [str1 appendString:@""];
    [str1 appendString:@"&total_amount="];
    [str1 appendString:@"1"];//总金额(以分为单位)
    [str1 appendString:@"&transport_amount=0&unit_amount="];
    [str1 appendString:@"1"];//商品单价(以分为单位)
    [str1 appendString:@"&unit_count=1"];//商品数量
    NSLog(@"+++%@", [NSString stringWithFormat:@"%@&sign=%@" , str1 , md5CapPwd]);
    return [NSString stringWithFormat:@"%@&sign=%@" , str1 , md5CapPwd];
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



#pragma mark - 微信支付模型
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

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
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


- (NSString *)getIPAddress
{
    NSString * address = @"error";
    struct ifaddrs * interfaces = NULL;
    struct ifaddrs * temp_addr = NULL;
    int success = 0;
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
