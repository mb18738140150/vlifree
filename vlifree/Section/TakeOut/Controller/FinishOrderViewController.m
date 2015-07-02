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

@interface FinishOrderViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * stateImageV;
@property (nonatomic, strong)UILabel * stateLabel;
@property (nonatomic, strong)UILabel * otherPriceLB;
@property (nonatomic, strong)UILabel * totalPriceLB;
@property (nonatomic, strong)UILabel * storeNameLB;
@property (nonatomic, strong)UILabel * orderNumberLB;
@property (nonatomic, strong)UILabel * orderDateLB;
@property (nonatomic, strong)UILabel * orderPayTypeLB;
@property (nonatomic, strong)UILabel * orderTelLB;
@property (nonatomic, strong)UILabel * orderAddressLB;

@property (nonatomic, strong)UIButton * confirmBT;
@property (nonatomic, strong)UIButton * cancelBT;

@property (nonatomic, strong)NSNumber * payType;

@property (nonatomic, strong)NSMutableArray * orderArray;
@property (nonatomic, strong)OrderDetailsMD * orderDetailsMD;

@end

@implementation FinishOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIButton * telButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    telButton.frame = CGRectMake(0, 0, 30, 30);
//    [telButton setBackgroundImage:[UIImage imageNamed:@"tel_order_detail_icon.png"] forState:UIControlStateNormal];
//    [telButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * barBT = [[UIBarButtonItem alloc] initWithCustomView:telButton];
//    self.navigationItem.rightBarButtonItem = barBT;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [self.view addSubview:_scrollView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    view1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view1];
    
    self.stateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 30, 30)];
    _stateImageV.image = [UIImage imageNamed:@"stateImage_w.png"];
    [view1 addSubview:_stateImageV];
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImageV.right + 5, _stateImageV.top, 200, _stateImageV.height)];
    _stateLabel.text = @"订单完成";
    [view1 addSubview:_stateLabel];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stateImageV.left, _stateImageV.bottom + 10, view1.width - _stateImageV.left * 2, 20)];
    aLabel.text = @"感谢您使用微外卖，欢迎再次订餐。";
    aLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    aLabel.font = [UIFont systemFontOfSize:15];
    [view1 addSubview:aLabel];
    
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
    
    view1.height = _confirmBT.bottom + 10;
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:lineView1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, _scrollView.width, 100)];
    view2.tag = 2000;
    view2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view2];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:lineView2];
    
    NSArray * array = @[@"提交订单", @"餐厅接单", @"配送中", @"已收货"];
    for (int i = 0; i < 4; i++) {
        UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view2.width - 200) / 5 * (i + 1) + 50 * i, 10, 50, 50)];
        aImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState%d.png", i + 1]];
        aImageView.tag = 10001 + i;
        [view2 addSubview:aImageView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(aImageView.left, aImageView.bottom, aImageView.width, 20)];
        label.tag = 20001 + i;
        label.text = [array objectAtIndex:i];
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
    lineView3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:lineView3];
    
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 10, _scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    view3.tag = 3000;
    [_scrollView addSubview:view3];
    
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view3.width, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:lineView4];
    
    UIImageView * storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    storeIcon.image = [UIImage imageNamed:@"store.png"];
    [view3 addSubview:storeIcon];
    
    self.storeNameLB = [[UILabel alloc] initWithFrame:CGRectMake(storeIcon.right + 5, storeIcon.top, view3.width - 10 - storeIcon.right, storeIcon.height)];
//    _storeNameLB.text = self.takeOutOrderMD.storeName;
    [view3 addSubview:_storeNameLB];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(10, _storeNameLB.bottom, view3.width - 20, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    lineView5.tag = 5005;
    [view3 addSubview:lineView5];
    

    
    view3.height = lineView5.bottom + 5;
    

    
    UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.bottom + 10, _scrollView.width, 100)];
    view4.backgroundColor = [UIColor whiteColor];
    view4.tag = 4000;
    [_scrollView addSubview:view4];
    
    UIView * lineView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view4.width, 1)];
    lineView7.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
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
    lineView10.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view4 addSubview:lineView10];
    
    UIView * view5 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.bottom + 10, _scrollView.width, 270)];
    view5.backgroundColor = [UIColor whiteColor];
    view5.tag = 5000;
    [_scrollView addSubview:view5];
    
    UIView * lineView11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view5.width, 1)];
    lineView11.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view5 addSubview:lineView11];
    
    UIImageView * detalsView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
    detalsView.image = [UIImage imageNamed:@"orderDetails.png"];
    [view5 addSubview:detalsView];
    
    UILabel * detailsLB = [[UILabel alloc] initWithFrame:CGRectMake(detalsView.right + 5, detalsView.top, 100, detalsView.height)];
    detailsLB.text = @"订单详情";
    [view5 addSubview:detailsLB];
    
    UIView * lineView12 = [[UIView alloc] initWithFrame:CGRectMake(10, detailsLB.bottom + 5, view5.width - 20, 1)];
    lineView12.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view5 addSubview:lineView12];
    
    self.orderNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView12.bottom + 5, lineView12.width - 10, 30)];
//    _orderNumberLB.text = [NSString stringWithFormat:@"订单号:%@", self.takeOutOrderMD.orderID];
    [view5 addSubview:_orderNumberLB];
    
    
    self.orderDateLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderNumberLB.bottom + 5, lineView12.width - 10, 30)];
//    _orderDateLB.text = [NSString stringWithFormat:@"下单时间: %@", self.takeOutOrderMD.time];
    [view5 addSubview:_orderDateLB];
    
    self.orderPayTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderDateLB.bottom + 5, lineView12.width - 10, 30)];
    _orderPayTypeLB.text = @"支付方式: 餐到付款";
    [view5 addSubview:_orderPayTypeLB];
    
    self.orderTelLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderPayTypeLB.bottom + 5, lineView12.width - 10, 30)];
//    _orderTelLB.text = [NSString stringWithFormat:@"手机号码: %@", self.takeOutOrderMD.nextphone];
    [view5 addSubview:_orderTelLB];
    
    
    self.orderAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(15, _orderTelLB.bottom + 5, lineView12.width - 10, 30)];
//    _orderAddressLB.text = [NSString stringWithFormat:@"收餐地址: %@", self.takeOutOrderMD.address];
    _orderAddressLB.numberOfLines = 0;
    [view5 addSubview:_orderAddressLB];
    view5.height = _orderAddressLB.bottom + 10;
    
    CGSize size = _scrollView.contentSize;
    size.height = view5.bottom;
    _scrollView.contentSize = size;
    
    
    [self downloadData];
    
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    // Do any additional setup after loading the view.
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
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
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
                menuView.priceLabel.text = [NSString stringWithFormat:@"¥%@", orderMneuMD.money];
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
                    self.orderPayTypeLB.text = @"支付方式:餐到付款";
                }
                    break;
                default:
                    break;
            }
            NSNumber * orderState = [data objectForKey:@"OrderState"];
            [self orderState:orderState.intValue];
            _cancelBT.hidden = YES;
            _confirmBT.hidden = YES;
            switch (orderState.intValue) {
                case 1:
                {
                    if ([[data objectForKey:@"IsPey"] isEqualToNumber:@YES]) {
                        self.stateLabel.text = @"已支付";
                    }else
                    {
                        self.stateLabel.text = @"未支付";
                    }
                    _cancelBT.hidden = NO;
                    
                }
                    break;
                case 2:
                {
                    self.stateLabel.text = @"餐厅已经接单";
                    _cancelBT.hidden = YES;
                }
                    break;
                case 3:
                {
                    self.stateLabel.text = @"订单已经在配送";
                    self.confirmBT.hidden = NO;
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
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"操作成功" duration:1.5];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10032])
        {
            [self downloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10035])
        {
            [self downloadData];
        }
        
    }
}
- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"error = %@", error);
}


- (void)createOtherMoneyView
{
    UIView * view4 = [self.scrollView viewWithTag:4000];
    
     CGFloat top = 5;
     if (![self.orderDetailsMD.firstReduce isEqualToNumber:@0]) {
     UILabel * firstTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
     firstTitleLB.text = @"首单减免";
     [view4 addSubview:firstTitleLB];
     
     UILabel * firstJLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, firstTitleLB.top, 50, 25)];
     firstJLB.text = [NSString stringWithFormat:@"-%@", self.orderDetailsMD.firstReduce];
     firstJLB.textAlignment = NSTextAlignmentRight;
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
     [view4 addSubview:fullTitleLB];
     
     UILabel * fullJLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, fullTitleLB.top, 50, 25)];
     fullJLB.text = [NSString stringWithFormat:@"-%@", self.orderDetailsMD.fullReduce];
     fullJLB.textAlignment = NSTextAlignmentRight;
     [view4 addSubview:fullJLB];
     
     UIView * fullLineView = [[UIView alloc] initWithFrame:CGRectMake(10, fullJLB.bottom, view4.width - 20, 1)];
     fullLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
     [view4 addSubview:fullLineView];
     }
     
     if (![self.orderDetailsMD.mealBoxMoney isEqualToNumber:@0])
     {
     UILabel * boxTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
     boxTitleLB.text = @"餐具费";
     [view4 addSubview:boxTitleLB];
     
     UILabel * boxPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, boxTitleLB.top, 50, 25)];
     boxPriceLB.text = [NSString stringWithFormat:@"+%@", self.orderDetailsMD.mealBoxMoney];
     boxPriceLB.textAlignment = NSTextAlignmentRight;
     [view4 addSubview:boxPriceLB];
     
     UIView * boxLineView = [[UIView alloc] initWithFrame:CGRectMake(10, _otherPriceLB.bottom, view4.width - 20, 1)];
     boxLineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
     [view4 addSubview:boxLineView];
     top = boxLineView.bottom + 5;
     }
     
     
     if (![self.orderDetailsMD.deliveryMoney isEqualToNumber:@0])
     {
     UILabel * otherTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
     otherTitleLB.text = @"配送费";
     [view4 addSubview:otherTitleLB];
     
     self.otherPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, otherTitleLB.top, 50, 25)];
     _otherPriceLB.text = [NSString stringWithFormat:@"+%@", self.orderDetailsMD.deliveryMoney];
     _otherPriceLB.textAlignment = NSTextAlignmentRight;
     [view4 addSubview:_otherPriceLB];
     
     UIView * lineView8 = [[UIView alloc] initWithFrame:CGRectMake(10, _otherPriceLB.bottom, view4.width - 20, 1)];
     lineView8.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
     [view4 addSubview:lineView8];
     
     top = lineView8.bottom + 5;
     }
    UILabel * totalLB = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 100, 25)];
    totalLB.text = @"合计";
    [view4 addSubview:totalLB];
    
    self.totalPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, totalLB.top, 50, 25)];
    _totalPriceLB.text = @"¥35";
    _totalPriceLB.textAlignment = NSTextAlignmentRight;
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
        }else if (state == 7)
        {
            stateIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState%d.png", i + 1]];
            if (i == 3) {
                stateLB.textColor = [UIColor greenColor];
            }
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
    [SVProgressHUD showWithStatus:@"取消请求中..." maskType:SVProgressHUDMaskTypeBlack];
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
    [SVProgressHUD showWithStatus:@"确认中..." maskType:SVProgressHUDMaskTypeBlack];
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
