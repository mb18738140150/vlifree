//
//  GSOrderPayViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSOrderPayViewController.h"
#import "PayTypeView.h"

#import "WXApi.h"
#import "payRequsestHandler.h"
#import "BDWalletSDKMainManager.h"
#import <CommonCrypto/CommonDigest.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define LEFT_SPACE 15
#define TOP_SPACE 5
#define LABEL_HEIGHT 30


@interface GSOrderPayViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)PayTypeView * weixinView;
@property (nonatomic, strong)PayTypeView * baiduView;
@property (nonatomic, strong)UIDatePicker * datePicker;
@property (nonatomic, strong)UIView * pickerView;

@property (nonatomic, strong)UIButton * dateButton;

@property (nonatomic, strong)UITextField * personTF;
@property (nonatomic, strong)UITextField * telTF;
@property (nonatomic, strong)UITextField * requireTF;
@property (nonatomic, strong)NSDate * ruzhuDate;
@property (nonatomic, strong)NSDate * lidianDate;

@property (nonatomic, strong)UILabel * daysLB;
//@property (nonatomic, strong)UILabel 

@end

@implementation GSOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%d", self.navigationController.navigationBar.translucent);
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    [self.view addSubview:scrollView];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 30)];
    aLabel.text = @"订单确认后不可取消，该订单不可变更。如未入住扣除全部房费";
    aLabel.font = [UIFont systemFontOfSize:11];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.textColor = [UIColor colorWithRed:227 / 255.0 green:185 / 255.0 blue:16 / 255.0 alpha:1];
    aLabel.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    aLabel.layer.borderWidth = 1.5;
    aLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:254 / 255.0 blue:242 / 255.0 alpha:1];
    [scrollView addSubview:aLabel];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, aLabel.bottom, scrollView.width, 100)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view1];
    
    UILabel * roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, view1.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    roomLB.text = [NSString stringWithFormat:@"房型:%@", self.roomName];
    [view1 addSubview:roomLB];
    
    UILabel * ruzhuLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, roomLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
//    dateLB.font = [UIFont systemFontOfSize:14];
    ruzhuLB.text = @"入住时间:";
    [view1 addSubview:ruzhuLB];
    
    UIButton * ruzhuBT = [UIButton buttonWithType:UIButtonTypeCustom];
    ruzhuBT.frame = CGRectMake(ruzhuLB.right, ruzhuLB.top, view1.width - 2 * LEFT_SPACE - ruzhuLB.width, ruzhuLB.height);
    ruzhuBT.tag = 10001;
    ruzhuBT.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.9].CGColor;
    ruzhuBT.layer.borderWidth = 0.5;
    [ruzhuBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    ruzhuBT.backgroundColor = [UIColor redColor];
    [ruzhuBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:ruzhuBT];
    
    
    UILabel * lidianLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, ruzhuLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    //    dateLB.font = [UIFont systemFontOfSize:14];
    lidianLB.text = @"离店时间:";
    [view1 addSubview:lidianLB];
    
    UIButton * lidianBT = [UIButton buttonWithType:UIButtonTypeCustom];
    lidianBT.frame = CGRectMake(lidianLB.right, lidianLB.top, view1.width - 2 * LEFT_SPACE - lidianLB.width, lidianLB.height);
    lidianBT.tag = 10002;
    lidianBT.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.9].CGColor;
    lidianBT.layer.borderWidth = 0.5;
    [lidianBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    ruzhuBT.backgroundColor = [UIColor redColor];
    [lidianBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:lidianBT];
    
    self.daysLB = [[UILabel alloc] initWithFrame:CGRectMake(lidianLB.left, lidianLB.bottom, lidianLB.width * 2, lidianLB.height)];
    _daysLB.text = @"住店时长: ";
    [view1 addSubview:_daysLB];
    view1.height = _daysLB.bottom + TOP_SPACE;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:line1];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, scrollView.width, 140)];
    view2.backgroundColor = [UIColor  whiteColor];
    [scrollView addSubview:view2];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line2];
    
    UILabel * datumLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 40)];
    datumLB.text = @"入住资料";
    [view2 addSubview:datumLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, datumLB.bottom, view2.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line3];
    
    UILabel * personLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    personLB.text = @"入住人名:";
    [view2 addSubview:personLB];
    
    self.personTF = [[UITextField alloc] initWithFrame:CGRectMake(personLB.right, personLB.top, view2.width - LEFT_SPACE - personLB.right, personLB.height)];
    _personTF.borderStyle = UITextBorderStyleRoundedRect;
    _personTF.delegate = self;
    [view2 addSubview:_personTF];
    
    
    UILabel * telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, personLB.bottom + TOP_SPACE, personLB.width, LABEL_HEIGHT)];
    telLB.text = @"手机号码:";
    [view2 addSubview:telLB];
    
    self.telTF = [[UITextField alloc] initWithFrame:CGRectMake(telLB.right, telLB.top, view2.width - LEFT_SPACE - telLB.right, telLB.height)];
    _telTF.borderStyle = UITextBorderStyleRoundedRect;
    _telTF.delegate = self;
    [view2 addSubview:_telTF];
    
    UILabel * requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, telLB.bottom + TOP_SPACE, 80, LABEL_HEIGHT)];
    requireLB.text = @"特殊需求:";
//    requireLB.numberOfLines = 0;
//    requireLB.lineBreakMode = NSLineBreakByWordWrapping;
//    [requireLB sizeToFit];
    [view2 addSubview:requireLB];
    
    
    self.requireTF = [[UITextField alloc] initWithFrame:CGRectMake(requireLB.right, requireLB.top, view2.width - LEFT_SPACE - requireLB.right, requireLB.height)];
    _requireTF.borderStyle = UITextBorderStyleRoundedRect;
    _requireTF.delegate = self;
    [view2 addSubview:_requireTF];
    
    view2.height = requireLB.bottom + TOP_SPACE * 2;
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.height - 1, view2.width, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line4];
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 10, scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view3];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line5];
    
    UILabel * payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view3.width - 2 * LEFT_SPACE, 40)];
    payLabel.text = @"支付方式";
    [view3 addSubview:payLabel];
    
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLabel.bottom, view3.width - 2 * LEFT_SPACE, 1)];
    line6.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line6];
    
    
    
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
    
    view3.height = _baiduView.bottom + TOP_SPACE;
    
    UIView * line7 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.height - 1, view3.width, 1)];
    line7.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:line7];
    
    UILabel * priceLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, view3.bottom + 20, scrollView.width - 3 * LEFT_SPACE - 80, 35)];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额¥%@", self.price]];
    [string addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:24]} range:NSMakeRange(4, string.length - 4)];
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} range:NSMakeRange(0, 4)];
    priceLB.attributedText = [string copy];
    [scrollView addSubview:priceLB];
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(priceLB.right + LEFT_SPACE, priceLB.top, 80, priceLB.height);
    [payButton setTitle:@"马上支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = MAIN_COLOR;
    [scrollView addSubview:payButton];
    scrollView.contentSize = CGSizeMake(scrollView.width, payButton.bottom + 20);
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    [self createDatePickerView];
    // Do any additional setup after loading the view.
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


#pragma mark - 选择支付方式
- (void)changePayType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    if ([button isEqual:self.weixinView.changeButton]) {
        self.baiduView.changeButton.selected = NO;
        
        //        NSLog(@"微信");
    }else if ([button isEqual:self.baiduView.changeButton])
    {
        self.weixinView.changeButton.selected = NO;
        //        NSLog(@"百度");
    }
    button.selected = !button.selected;
}


- (void)changeDate:(UIButton *)button
{
    self.dateButton = button;
    if (button.tag == 10002 & self.ruzhuDate != nil) {
        self.datePicker.minimumDate = self.ruzhuDate;
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
        self.daysLB.text = [NSString stringWithFormat:@"住店时长: 共%ld天", days];
    }
    [self.pickerView removeFromSuperview];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
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
        day = hours / 24 + 2;
        NSLog(@"---%ld", (long)day);
    }
    return day;
}



#pragma mark - 百度支付


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


-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDesc;
{
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

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
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
