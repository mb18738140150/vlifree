

//
//  TakeOutOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/26.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TakeOutOrderViewController.h"
#import "OrderMenuVIew.h"
#import "PayTypeView.h"
#import "AddressViewController.h"
#import "AddressModel.h"
#import "WXApi.h"
#import "payRequsestHandler.h"


#import "BDWalletSDKMainManager.h"
#import <CommonCrypto/CommonDigest.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define LEFT_SPACE 10
#define TOP_SPACE 10
#define LABEL_HEIGHT 30
#define ADDRESS_IMAGE_SIZE 40
#define ORDER_MENU_VIEW_HEIGHT 25

#define TEXT_COLOR [UIColor colorWithWhite:0.2 alpha:1]

@interface TakeOutOrderViewController ()<BDWalletSDKMainManagerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong)PayTypeView * weixinView;
@property (nonatomic, strong)PayTypeView * baiduView;

@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * phoneLable;
@property (nonatomic, strong)UIButton * addressBT;

@property (nonatomic, assign)NSInteger payType; //支付方式 1,微信  2,百度(默认1)


@end

@implementation TakeOutOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    scrollView.tag = 10001;
    [self.view addSubview:scrollView];
    
    self.addressBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBT.frame = CGRectMake(0, 0, self.view.width, 50);
    _addressBT.backgroundColor = [UIColor redColor];
    [_addressBT addTarget:self action:@selector(changeAddressAndPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_addressBT];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, _addressBT.width - 2 * LEFT_SPACE - ADDRESS_IMAGE_SIZE, LABEL_HEIGHT)];
    _addressLB.textColor = [UIColor whiteColor];
    _addressLB.numberOfLines = 0;
    _addressLB.lineBreakMode = NSLineBreakByWordWrapping;
    _addressLB.text = @"请选择送餐地址";
    [_addressBT addSubview:_addressLB];
    
    self.phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _addressLB.bottom, _addressBT.width - 2 * LEFT_SPACE - ADDRESS_IMAGE_SIZE, LABEL_HEIGHT)];
    _phoneLable.textColor = [UIColor whiteColor];
//    phoneLable.text = @"13850308344";
//    [addressBT addSubview:_phoneLable];
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _addressBT.bottom + TOP_SPACE - 1, scrollView.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [scrollView addSubview:lineView1];
    UIView * menusView = [[UIView alloc] initWithFrame:CGRectMake(0, _addressBT.bottom + TOP_SPACE, scrollView.width, 80)];
    menusView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:menusView];
    
    UILabel * orderDetailsLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, menusView.width, LABEL_HEIGHT)];
    orderDetailsLB.textColor = TEXT_COLOR;
    orderDetailsLB.text = @"订单详情";
    orderDetailsLB.font = [UIFont systemFontOfSize:20];
    [menusView addSubview:orderDetailsLB];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, orderDetailsLB.bottom, menusView.width - 2 * LEFT_SPACE, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [menusView addSubview:lineView2];
    
    NSArray * array = @[@"", @"", @"", @"", @""];
    for (int i = 0; i < array.count; i++) {
        OrderMenuVIew * orderMenuV = [[OrderMenuVIew alloc] initWithFrame:CGRectMake(0, lineView2.bottom + i * ORDER_MENU_VIEW_HEIGHT, menusView.width, ORDER_MENU_VIEW_HEIGHT)];
        [menusView addSubview:orderMenuV];
    }
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, lineView2.bottom + array.count * ORDER_MENU_VIEW_HEIGHT, menusView.width - 2 * LEFT_SPACE, 1)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [menusView addSubview:lineView3];
    UILabel * totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, lineView3.bottom, 80, LABEL_HEIGHT)];
    totalLabel.text = @"合计";
    [menusView addSubview:totalLabel];
    
    UILabel * allPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(menusView.width - 50 - LEFT_SPACE, lineView3.bottom, 50, LABEL_HEIGHT)];
    allPriceLB.text = @"¥35";
    [menusView addSubview:allPriceLB];
    
    CGRect frame = menusView.frame;
    frame.size.height = allPriceLB.bottom + TOP_SPACE;
    menusView.frame = frame;
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, menusView.bottom, scrollView.width, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [scrollView addSubview:lineView4];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView4.bottom + TOP_SPACE, scrollView.width, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [scrollView addSubview:lineView5];
    
    UIView * remarksView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView5.bottom, scrollView.width, LABEL_HEIGHT * 2 + 2)];
    remarksView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:remarksView];
    
    UILabel * remarksLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, 80, LABEL_HEIGHT)];
    remarksLB.text = @"备注";
    remarksLB.textColor = TEXT_COLOR;
    [remarksView addSubview:remarksLB];
    UIView * lineView6 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, remarksLB.bottom, scrollView.width - LEFT_SPACE * 2, 1)];
    lineView6.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [remarksView addSubview:lineView6];
    
    UILabel * remarksDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, lineView6.bottom, remarksView.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    remarksDetailLB.text = @"请不要放香菜";
    remarksDetailLB.textColor = remarksLB.textColor;
    [remarksView addSubview:remarksDetailLB];
    
    UIView * lineView7 = [[UIView alloc] initWithFrame:CGRectMake(0, remarksView.bottom, scrollView.width, 1)];
    lineView7.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [scrollView addSubview:lineView7];
    
    UIView * lineView8 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView7.bottom + TOP_SPACE, scrollView.width, 1)];
    lineView8.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [scrollView addSubview:lineView8];
    
    
    UIView * payView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView8.bottom, scrollView.width, 122)];
    payView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:payView];
    
    
    UILabel * payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, payView.width - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    payLabel.text = @"在线支付";
    payLabel.textColor = remarksLB.textColor;
    [payView addSubview:payLabel];
    
    
    UIView * lineView9 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLabel.bottom, payLabel.width, 1)];
    lineView9.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [payView addSubview:lineView9];
    
    self.weixinView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, lineView9.bottom, payView.width, 40)];
    _weixinView.changeButton.selected = YES;
    [_weixinView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    _weixinView.iconView.image = [UIImage imageNamed:@"weixinzhifu.png"];
    _weixinView.titleLabel.text = @"微信支付";
    [payView addSubview:_weixinView];
    
    self.baiduView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, _weixinView.bottom, payView.width, 40)];
    _baiduView.iconView.image = [UIImage imageNamed:@"baiduzhifu.png"];
    _baiduView.titleLabel.text = @"百度钱包";
    [_baiduView.changeButton addTarget:self action:@selector(changePayType:) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:_baiduView];
    
    UIView * lineView10 = [[UIView alloc] initWithFrame:CGRectMake(0, payView.bottom, payView.width, 1)];
    lineView10.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [scrollView addSubview:lineView10];
    UIButton * confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBT.frame = CGRectMake(LEFT_SPACE, lineView10.bottom + TOP_SPACE, scrollView.width - 2 * LEFT_SPACE, 40);
    confirmBT.backgroundColor = MAIN_COLOR;
    [confirmBT setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBT addTarget:self action:@selector(confirmOrderAndPayType:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:confirmBT];
    
    scrollView.contentSize = CGSizeMake(scrollView.width, confirmBT.bottom + TOP_SPACE);
    
    _payType = 1;
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
#pragma mark - 微信注册app_id
//    [WXApi registerApp:@"wxaac5e5f7421e84ac"];
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changePayType:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    if ([button isEqual:self.weixinView.changeButton]) {
        self.baiduView.changeButton.selected = NO;
        _payType = 1;
//        NSLog(@"微信");
    }else if ([button isEqual:self.baiduView.changeButton])
    {
        self.weixinView.changeButton.selected = NO;
        _payType = 2;
//        NSLog(@"百度");
    }
    button.selected = !button.selected;
}


- (void)changeAddressAndPhoneNumber:(UIButton *)button
{
    NSLog(@"选择地址");
    AddressViewController * addressVC = [[AddressViewController alloc] init];
    [addressVC returnAddressModel:^(AddressModel *addressModel) {
        NSLog(@"%@", addressModel.address);
        self.addressLB.text = [NSString stringWithFormat:@"送餐地址:%@\n%@", addressModel.address, addressModel.tel];
        [_addressLB sizeToFit];
        CGRect frame = _addressBT.frame;
        _addressBT.height = _addressLB.frame.size.height + 2 * TOP_SPACE;
        CGFloat addY = _addressBT.height - frame.size.height;
        self.phoneLable.text = addressModel.tel;
        [self reloadViewFrameWithAddY:addY];
    }];
    [self.navigationController pushViewController:addressVC animated:YES];
}


- (void)confirmOrderAndPayType:(UIButton *)button
{
    NSLog(@"确认支付");
    if (_payType == 1) {
        [self sendPay_demo];//微信支付
    }else if (_payType == 2)
    {
        [self dopay];//百度支付
    }
}



- (void)reloadViewFrameWithAddY:(CGFloat)addY
{
    NSLog(@"%g", addY);
    UIScrollView * scrollV = (UIScrollView *)[self.view viewWithTag:10001];
    NSArray * viewsAry = [scrollV subviews];
    for (int i = 0; i < viewsAry.count; i++) {
        UIView * view = viewsAry[i];
        if (![view isEqual:_addressBT]) {
            view.top = view.top + addY;
        }
        if (i == viewsAry.count - 1) {
            CGSize size = scrollV.contentSize;
            size.height = size.height + addY;
            scrollV.contentSize = size;
        }
    }
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
{
    NSLog(@"%@, %@", eventId, eventDesc);
}



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
//                NSLog(@"%d", a);
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
