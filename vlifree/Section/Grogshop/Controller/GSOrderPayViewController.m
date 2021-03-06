//
//  GSOrderPayViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSOrderPayViewController.h"
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

#define LEFT_SPACE 15
#define TOP_SPACE 5
#define LABEL_HEIGHT 30


@interface GSOrderPayViewController ()<UITextFieldDelegate, HTTPPostDelegate, BDWalletSDKMainManagerDelegate>
{
    double _allMoney;
}
/**
 *  微信支付自定义页面
 */
@property (nonatomic, strong)PayTypeView * weixinView;
/**
 *  百度支付自定义页面
 */
@property (nonatomic, strong)PayTypeView * baiduView;
// 支付宝
@property (nonatomic, strong)PayTypeView * aliPayView;

/**
 *  时间控件
 */
@property (nonatomic, strong)UIDatePicker * datePicker;
/**
 *  加载时间控件的页面
 */
@property (nonatomic, strong)UIView * pickerView;
/**
 *  支付方式 1 微信支付. 2 百度支付
 */
@property (nonatomic, strong)NSNumber * payType;
/**
 *  选择日期的button, 用来记载是入住时间button还是离店时间button
 */
@property (nonatomic, strong)UIButton * dateButton;
/**
 *  入住人输入框
 */
@property (nonatomic, strong)UITextField * personTF;
/**
 *  电话输入框
 */
@property (nonatomic, strong)UITextField * telTF;
/**
 *  特殊需求输入框
 */
@property (nonatomic, strong)UITextField * requireTF;
/**
 *  入住时间
 */
@property (nonatomic, strong)NSDate * ruzhuDate;
/**
 *  离店时间
 */
@property (nonatomic, strong)NSDate * lidianDate;
/**
 *  显示总天数label
 */
@property (nonatomic, strong)UILabel * daysLB;
//@property (nonatomic, strong)UILabel 
/**
 *  显示价格的label
 */
@property (nonatomic, strong)UILabel * priceLB;
/**
 *  订单号
 */
@property (nonatomic, copy)NSString * orderId;
/**
 *  提示框
 */
@property (nonatomic, strong)JGProgressHUD * hud;
/**
 *  首单立减金额
 */
@property (nonatomic, strong)NSNumber * firstCut;

///**
// *  首单立减价格label
// */
//@property (nonatomic, strong)UILabel * firstCutPriceLB;

@end

@implementation GSOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    self.payType = @1;
    self.navigationItem.title = @"订单填写";
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%d", self.navigationController.navigationBar.translucent);
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 75)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.5];
    [self.view addSubview:scrollView];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 30)];
    aLabel.text = @"订单确认后不可取消，该订单不可变更。如未入住扣除全部房费";
    aLabel.font = [UIFont systemFontOfSize:11];
    aLabel.textAlignment = NSTextAlignmentCenter;
//    aLabel.textColor = [UIColor colorWithRed:227 / 255.0 green:185 / 255.0 blue:16 / 255.0 alpha:1];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.layer.borderColor = LINE_COLOR.CGColor;
    aLabel.layer.borderWidth = 0.7;
//    aLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:254 / 255.0 blue:242 / 255.0 alpha:1];
    aLabel.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:aLabel];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, aLabel.bottom, scrollView.width, 100)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view1];
    
    UILabel * roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, view1.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    roomLB.text = [NSString stringWithFormat:@"房型:%@", self.roomName];
    roomLB.textColor = TEXT_COLOR;
    [view1 addSubview:roomLB];
    
    UILabel * ruzhuLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, roomLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
//    dateLB.font = [UIFont systemFontOfSize:14];
    ruzhuLB.text = @"入住时间:";
    ruzhuLB.textColor = TEXT_COLOR;
    [view1 addSubview:ruzhuLB];
    
    UIButton * ruzhuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    ruzhuBT.frame = CGRectMake(ruzhuLB.right, ruzhuLB.top, 90, ruzhuLB.height);
    ruzhuBT.tag = 10001;
//    ruzhuBT.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.9].CGColor;
//    ruzhuBT.layer.borderWidth = 0.5;
    [ruzhuBT setTitle:@"选择入住时间" forState:UIControlStateNormal];
    [ruzhuBT setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    ruzhuBT.titleLabel.font = [UIFont systemFontOfSize:15];
//    ruzhuBT.backgroundColor = [UIColor redColor];
    ruzhuBT.titleLabel.textAlignment = NSTextAlignmentLeft;
    [ruzhuBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:ruzhuBT];
    
    
    UILabel * lidianLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, ruzhuLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    //    dateLB.font = [UIFont systemFontOfSize:14];
    lidianLB.text = @"离店时间:";
    lidianLB.textColor = TEXT_COLOR;
    [view1 addSubview:lidianLB];
    
    UIButton * lidianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    lidianBT.frame = CGRectMake(lidianLB.right, lidianLB.top, ruzhuBT.width, lidianLB.height);
    lidianBT.tag = 10002;
//    lidianBT.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.9].CGColor;
//    lidianBT.layer.borderWidth = 0.5;
    [lidianBT setTitle:@"选择离店时间" forState:UIControlStateNormal];
    [lidianBT setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    lidianBT.titleLabel.font = [UIFont systemFontOfSize:15];
    //    ruzhuBT.backgroundColor = [UIColor redColor];
    [lidianBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:lidianBT];
    
    self.daysLB = [[UILabel alloc] initWithFrame:CGRectMake(lidianLB.left, lidianLB.bottom, lidianLB.width * 2, lidianLB.height)];
    _daysLB.text = @"住店时长: ";
    _daysLB.textColor = TEXT_COLOR;
    [view1 addSubview:_daysLB];
    view1.height = _daysLB.bottom + TOP_SPACE;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    line1.backgroundColor = LINE_COLOR;
    [view1 addSubview:line1];
    
//    UIView * cutView = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, scrollView.width, 40)];
//    cutView.backgroundColor = [UIColor whiteColor];
//    [scrollView addSubview:cutView];
//    
//    UILabel * firstCutLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 180, LABEL_HEIGHT)];
//    firstCutLB.text = @"首单立减: -¥20";
//    firstCutLB.textColor = [UIColor redColor];
////    firstCutLB.font = 
//    [cutView addSubview:firstCutLB];
//    cutView.height = firstCutLB.bottom + 5;
    
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, scrollView.width, 140)];
    view2.backgroundColor = [UIColor  whiteColor];
    [scrollView addSubview:view2];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line2.backgroundColor = LINE_COLOR;
    [view2 addSubview:line2];
    
//    UILabel * datumLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 40)];
//    datumLB.text = @"入住资料";
//    [view2 addSubview:datumLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = LINE_COLOR;
    [view2 addSubview:line3];
    
    UILabel * personLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    personLB.text = @"入住人名:";
    personLB.textColor = TEXT_COLOR;
    [view2 addSubview:personLB];
    
    self.personTF = [[UITextField alloc] initWithFrame:CGRectMake(personLB.right, personLB.top, view2.width - LEFT_SPACE - personLB.right, personLB.height)];
    _personTF.borderStyle = UITextBorderStyleNone;
    _personTF.placeholder = @"请输入入住人";
    _personTF.font = [UIFont systemFontOfSize:15];
    _personTF.textColor = TEXT_COLOR;
    _personTF.delegate = self;
    [view2 addSubview:_personTF];
    
    
    UILabel * telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, personLB.bottom + TOP_SPACE, personLB.width, LABEL_HEIGHT)];
    telLB.text = @"手机号码:";
    telLB.textColor = TEXT_COLOR;
    [view2 addSubview:telLB];
    
    self.telTF = [[UITextField alloc] initWithFrame:CGRectMake(telLB.right, telLB.top, view2.width - LEFT_SPACE - telLB.right, telLB.height)];
    _telTF.borderStyle = UITextBorderStyleNone;
    _telTF.placeholder = @"请输入手机号";
    _telTF.font = [UIFont systemFontOfSize:15];
    _telTF.textColor = TEXT_COLOR;
    _telTF.delegate = self;
    [view2 addSubview:_telTF];
    
    UILabel * requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, telLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    requireLB.text = @"特殊需求:";
    requireLB.textColor = TEXT_COLOR;
//    requireLB.numberOfLines = 0;
//    requireLB.lineBreakMode = NSLineBreakByWordWrapping;
//    [requireLB sizeToFit];
    [view2 addSubview:requireLB];
    
    
    self.requireTF = [[UITextField alloc] initWithFrame:CGRectMake(requireLB.right, requireLB.top, view2.width - LEFT_SPACE - requireLB.right, requireLB.height)];
    _requireTF.borderStyle = UITextBorderStyleNone;
    _requireTF.placeholder = @"请输入其他要求";
    _requireTF.delegate = self;
    _requireTF.font = [UIFont systemFontOfSize:15];
    _requireTF.textColor = TEXT_COLOR;

    [view2 addSubview:_requireTF];
    
    view2.height = requireLB.bottom + TOP_SPACE * 2;
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.height - 1, view2.width, 1)];
    line4.backgroundColor = LINE_COLOR;
    [view2 addSubview:line4];
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 10, scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view3];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line5.backgroundColor = LINE_COLOR;
    [view3 addSubview:line5];
    
    UILabel * payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view3.width - 2 * LEFT_SPACE, 40)];
    payLabel.text = @"支付方式";
    payLabel.textColor = TEXT_COLOR;
    [view3 addSubview:payLabel];
    
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLabel.bottom, view3.width - 2 * LEFT_SPACE, 1)];
    line6.backgroundColor = LINE_COLOR;
    [view3 addSubview:line6];
    
    
    
    self.weixinView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, line6.bottom + TOP_SPACE, view3.width, 40)];
    _weixinView.changeButton.selected = YES;
    [_weixinView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    _weixinView.iconView.image = [UIImage imageNamed:@"weixinzhifu.png"];
    _weixinView.titleLabel.text = @"微信支付";
    _weixinView.titleLabel.textColor = TEXT_COLOR;
    [view3 addSubview:_weixinView];
    
    self.baiduView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, _weixinView.bottom + TOP_SPACE, view3.width, 40)];
    _baiduView.iconView.image = [UIImage imageNamed:@"baiduzhifu.png"];
    _baiduView.titleLabel.text = @"百度钱包";
    _baiduView.titleLabel.textColor = TEXT_COLOR;
    [_baiduView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:_baiduView];
    
    self.aliPayView = [[PayTypeView alloc]initWithFrame:CGRectMake(0, _baiduView.bottom, view3.width, 40)];
    _aliPayView.iconView.image = [UIImage imageNamed:@"alipey_icon.png"];
    _aliPayView.titleLabel.text = @"支付宝";
    [_aliPayView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:_aliPayView];
    
    if (![WXApi isWXAppInstalled]) {
        _weixinView.hidden = YES;
        _aliPayView.top = _baiduView.top;
        _baiduView.top = _weixinView.top;
        _baiduView.changeButton.selected = YES;
        _payType = @2;
    }
    
    view3.height = _aliPayView.bottom + TOP_SPACE;
    
    UIView * line7 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.height - 1, view3.width, 1)];
    line7.backgroundColor = LINE_COLOR;
    [view3 addSubview:line7];
    
    UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom, scrollView.width, 75)];
    [self.view addSubview:view4];
    
    self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 12.5, scrollView.width - 3 * LEFT_SPACE - 80, 50)];
//    _priceLB.backgroundColor = [UIColor magentaColor];
    _priceLB.numberOfLines = 0;
    _priceLB.attributedText = [self allPriceLBTextWithPrice:self.price firstCut:self.firstCut];
    [view4 addSubview:_priceLB];
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(_priceLB.right + LEFT_SPACE, _priceLB.top, 80, 28);
//    [payButton setTitle:@"马上支付" forState:UIControlStateNormal];
//    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    payButton.backgroundColor = MAIN_COLOR;
    payButton.centerY = _priceLB.centerY;
    [payButton setBackgroundImage:[UIImage imageNamed:@"change_n.png"] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payOrderDetails:) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:payButton];
    
    scrollView.contentSize = CGSizeMake(scrollView.width, view3.bottom);
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    [self createDatePickerView];
    
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"HotelId":self.hotelId,
                               @"Command":@41
                               };
    [self playPostWithDictionary:jsonDic];
    
    // Do any additional setup after loading the view.
}

- (id)allPriceLBTextWithPrice:(NSNumber *)price firstCut:(NSNumber *)firstCut
{
    double money = price.doubleValue - firstCut.doubleValue;
    NSString * payString = [NSString stringWithFormat:@"支付金额¥%g", money];
    NSMutableAttributedString * string = nil;
    if (firstCut != nil) {
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n首单立减: -¥%@", payString, firstCut]];
    }else
    {
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", payString]];
    }
    [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(4, payString.length - 4)];
    [string addAttributes:@{NSForegroundColorAttributeName : TEXT_COLOR, NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(0, 4)];
    if (firstCut != nil)
    {
        [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(payString.length, string.length - payString.length)];
    }
    return [string copy];
}


- (void)createDatePickerView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
//    [_datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
//    [_datePicker setDate:[NSDate date] animated:YES];
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    self.pickerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _pickerView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [_pickerView addSubview:_datePicker];
    _datePicker.center = _pickerView.center;

    UIButton * dateBT = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBT.frame = CGRectMake(0, 5, 80, 30);
    dateBT.centerX = _datePicker.centerX;
    [dateBT setTitle:@"确定" forState:UIControlStateNormal];
    [dateBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateBT addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventTouchUpInside];
    dateBT.backgroundColor = MAIN_COLOR;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, _pickerView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:dateBT];
    [_pickerView addSubview:view];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提交支付
- (void)payOrderDetails:(UIButton *)button
{
    if (self.ruzhuDate == nil) {
        [self alertMessage:@"请选择入住时间"];
    }else if (self.lidianDate == nil)
    {
        [self alertMessage:@"请选择离店时间"];
    }else if (self.personTF.text.length == 0)
    {
        [self alertMessage:@"请输入入住人名"];
    }else if (self.telTF.text.length == 0)
    {
        [self alertMessage:@"请输入手机号码"];
    }else
    {
        BOOL isPhoneNum = [NSString isTelPhoneNub:self.telTF.text];
        if (isPhoneNum) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterFullStyle];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString * ruzhuDateString = [dateFormatter stringFromDate:self.ruzhuDate];
            NSString * lidianDateString = [dateFormatter stringFromDate:self.lidianDate];
            NSLog(@"ip = %@", [self getIPAddress]);
            
            NSDictionary * jsonDic = @{
                                       @"Cur_IP":[self getIPAddress],
                                       @"Command":@11,
                                       @"SuiteId":self.roomId,
                                       @"SuitePrice":[NSNumber numberWithDouble:_allMoney],
                                       @"CheckInDate":ruzhuDateString,
                                       @"LeaveDate":lidianDateString,
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"PhoneNumber":self.telTF.text,
                                       @"Demand":self.requireTF.text,
                                       @"PayType":self.payType,
                                       @"CheckInName":self.personTF.text
                                       };
            [self playPostWithDictionary:jsonDic];
            [self.hud showInView:self.view];
        }
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


- (void)changeDate:(UIButton *)button
{
    self.dateButton = button;
    if (button.tag == 10002 & self.ruzhuDate != nil) {
        self.datePicker.minimumDate = [NSDate dateWithTimeInterval:3600 * 24 sinceDate:self.ruzhuDate];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }else if (button.tag == 10002 & self.ruzhuDate == nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }else if (button.tag == 10001 & self.lidianDate != nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = self.lidianDate;
    }else if (button.tag == 10001 & self.lidianDate == nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }
    [self.view.window addSubview:_pickerView];
    NSLog(@"时间");
}


- (void)getDate:(UIButton *)button
{
    if (self.dateButton.tag == 10001) {
        self.ruzhuDate = self.datePicker.date;
    }else if (self.dateButton.tag == 10002)
    {
        self.lidianDate = self.datePicker.date;
    }
    if (self.ruzhuDate != nil & self.lidianDate != nil) {
        NSInteger days = [self calculateAgeFromDate:self.ruzhuDate toDate:self.lidianDate];
        self.daysLB.text = [NSString stringWithFormat:@"住店时长: 共%ld天", (long)days];
        double price = self.price.doubleValue * days;
        _allMoney = price;
        self.priceLB.attributedText = [self allPriceLBTextWithPrice:[NSNumber numberWithDouble:price] firstCut:self.firstCut];
    }
    [self.pickerView removeFromSuperview];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
    [self.dateButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
//    NSLog(@"%@", _dateButton);
//    _dateButton.backgroundColor = [UIColor redColor];
    NSLog(@"%@", dateString);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.personTF resignFirstResponder];
    [self.telTF resignFirstResponder];
    [self.requireTF resignFirstResponder];
    return YES;
}


- (NSInteger)calculateAgeFromDate:(NSDate *)date1 toDate:(NSDate *)date2{
    
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger hours = [components hour];
    
    NSInteger day = 1;
    NSLog(@"////%ld", (long)hours);
    if (hours > 22) {
        day = hours / 24 + 1;
        NSLog(@"---%ld", (long)day);
    }
    return day;
}

#pragma mark - 数据请求
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
    [self.hud dismiss];
    NSLog(@"+++%@", data);
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10041]) {
            if ([[data objectForKey:@"IsFirstReduce"] isEqualToNumber:@1]) {
                self.firstCut = [data objectForKey:@"FirstReduce"];
                _priceLB.attributedText = [self allPriceLBTextWithPrice:self.price firstCut:self.firstCut];
            }
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10011])
        {
            self.orderId = [data objectForKey:@"HotelOrder"];
            NSString * appid = [data objectForKey:@"AppId"];
            if ([self.payType isEqualToNumber:@1]) {
                NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"AppId"]]       forKey:@"appid"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"NonceStr"]]    forKey:@"noncestr"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"Package"]]      forKey:@"package"];
                [signParams setObject: [NSString stringWithFormat:@"%@", [data objectForKey:@"PartnerId"]]        forKey:@"partnerid"];
                [signParams setObject: [data objectForKey:@"TimeStamp"]   forKey:@"timestamp"];
                [signParams setObject: [data objectForKey:@"PrepayId"]    forKey:@"prepayid"];
                
                NSString * sign = [self createMd5Sign:signParams];
                NSLog(@"%@", sign);
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
            }else if([self.payType isEqualToNumber:@2])
            {
                BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
                //            NSLog(@"order_no = %@", [data objectForKey:@"HotelOrder"]);
                NSString *orderInfo = [self buildOrderInfoWithOrderID:[data objectForKey:@"HotelOrder"]];
                [payMainManager doPayWithOrderInfo:orderInfo params:nil delegate:self];
            }else
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
                order.tradeNO = [data objectForKey:@"HotelOrder"]; //订单ID（由商家自行制定）
                order.productName = [data objectForKey:@"HotelOrder"]; //商品标题
                order.productDescription = [data objectForKey:@"HotelOrder"]; //商品描述
                order.amount = [NSString stringWithFormat:@"%.2f",_allMoney]; //商品价格
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
    //    [self.detailsTableView headerEndRefreshing];
    //    [self.detailsTableView footerEndRefreshing];
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [self.hud dismiss];
    NSLog(@"%@", error);
}

#pragma  mark - 跳转到订单详情页面
- (void)pushOrderDetailsVC
{
    DetailsGSOrderViewController * detailsOrderVC = [[DetailsGSOrderViewController alloc] init];
    detailsOrderVC.isPay = YES;
    detailsOrderVC.orderID = self.orderId;
    [self.navigationController pushViewController:detailsOrderVC animated:YES];
}


#pragma mark - 百度支付

/*
-(void)dopay
{
    BDWalletSDKMainManager* payMainManager = [BDWalletSDKMainManager getInstance];
    
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
*/
/*
 此处生成的订单OrderInfo为测试专用，请接入的商户兄弟使用自己的订单，并且是按首字母排序的
 */
-(NSString*)buildOrderInfoWithOrderID:(NSString *)orderId
{
    int money = (int)(_allMoney * 100);
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
    [self pushOrderDetailsVC];
    if (statusCode == 0) {
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
//        [SVProgressHUD showErrorWithStatus:@"支付失败" duration:2];
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
    
    //输出Debug Info
//    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
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
