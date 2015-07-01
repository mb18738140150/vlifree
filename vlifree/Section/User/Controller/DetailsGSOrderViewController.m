//
//  DetailsGSOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGSOrderViewController.h"

#define LEFT_SPACE 20
#define TOP_SPACE 5

@interface DetailsGSOrderViewController ()<HTTPPostDelegate>

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

@end

@implementation DetailsGSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
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
    [view1 addSubview:_personLB];
    
    
    UILabel * telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _personLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    telLB.text = @"预定电话: 13456772457";
    [view1 addSubview:telLB];
    
    
    self.checkInDateLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, telLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _checkInDateLB.text = @"入住时间: 2015年5月15日 19:52:15";
    [view1 addSubview:_checkInDateLB];
    
    self.leaveLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _checkInDateLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _leaveLB.text = @"离开时间: 2015年5月17日 19:52:15";
    [view1 addSubview:_leaveLB];
    
    
    self.roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _leaveLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _roomLB.text = @"总统大套房";
    [view1 addSubview:_roomLB];
    
    
    self.countLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _roomLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _countLB.text = @"预定房间: 1间";
    [view1 addSubview:_countLB];
    
    
    self.payLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _countLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _payLB.text = @"支付方式: 在线支付";
    [view1 addSubview:_payLB];
    
    
    self.requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _payLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _requireLB.text = @"特殊要求";
    [view1 addSubview:_requireLB];
    
    view1.height = _requireLB.bottom + TOP_SPACE;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:line1];
    
    
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
    
    scrollView.contentSize = CGSizeMake(scrollView.width, view2.bottom + 10);

    
//    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    payButton.frame = CGRectMake(50, self.view.height - 40, self.view.width - 100, 30);
//    [payButton setTitle:@"马上支付" forState:UIControlStateNormal];
//    payButton.layer.backgroundColor = MAIN_COLOR.CGColor;
//    payButton.layer.cornerRadius = 10;
//    [self.view addSubview:payButton];
    
    
    
    NSDictionary * jsonDic = @{
                               @"Command":@26,
                               @"Id":self.orderID
                               };
    [self playPostWithDictionary:jsonDic];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];

    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        self.priceLB.text = [NSString stringWithFormat:@"     订单金额:%@", [data objectForKey:@"Price"]];
        self.personLB.text = [NSString stringWithFormat:@"预定人:%@", [data objectForKey:@"Name"]];
        self.telLB.text = [NSString stringWithFormat:@"预定号码:%@", [data objectForKey:@"PhoneNumber"]];
        self.checkInDateLB.text = [NSString stringWithFormat:@"入住时间:%@", [data objectForKey:@"CheckInTime"]];
        self.leaveLB.text = [NSString stringWithFormat:@"离店时间:%@", [data objectForKey:@"LeaveTime"]];
        self.roomLB.text = [NSString stringWithFormat:@"房型:%@", [data objectForKey:@"RoomType"]];
        self.countLB.text = [NSString stringWithFormat:@"预定房间:%@间", [data objectForKey:@"RoomCount"]];
        self.payType = [data objectForKey:@"PeyType"];
        if ([[data objectForKey:@"PeyType"] isEqualToNumber:@1]) {
            self.payLB.text = @"支付方式:微信支付";
        }else{
            self.payLB.text = @"支付方式:百度支付";
        }
        self.requireLB.text = [NSString stringWithFormat:@"特殊需求:%@", [data objectForKey:@"Demand"]];
        self.grogshopLB.text = [data objectForKey:@"HotelName"];
        self.addressLB.text = [data objectForKey:@"HotelAddress"];
        self.telGSLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"HotelTel"]];
    }
    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
}


- (void)payGSOrder:(UIButton *)button
{
    NSDictionary * dic = @{
                           @"Command":@35,
                           @"UserId":[UserInfo shareUserInfo].userId,
                           @"PayType":self.payType,
                           @"OrderId":self.orderID
                           };
    [self playPostWithDictionary:dic];
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
