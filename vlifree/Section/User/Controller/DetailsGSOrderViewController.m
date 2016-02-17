//
//  DetailsGSOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGSOrderViewController.h"
#import "CreateCommentViewController.h"

#define LEFT_SPACE 20
#define TOP_SPACE 5

@interface DetailsGSOrderViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UILabel * priceLB;
@property (nonatomic, strong)UIButton * cancleButton;
@property (nonatomic, strong)UILabel * personLB;
@property (nonatomic, strong)UILabel * telLB;
@property (nonatomic, strong)UILabel * checkInDateLB;
@property (nonatomic, strong)UILabel * leaveLB;
@property (nonatomic, strong)UILabel * roomLB;
@property (nonatomic, strong)UILabel * countLB;
@property (nonatomic, strong)UILabel * payLB;
@property (nonatomic, strong)UILabel * requireLB;
@property (nonatomic, strong)UIImageView * backMoneyImageview;
@property (nonatomic, strong)UILabel * grogshopLB;
@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UILabel * telGSLB;
@property (nonatomic, strong)UIView * commentView;

@property (nonatomic, strong)NSNumber * payType;

@end

@implementation DetailsGSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    scrollView.tag = 8888;
    [self.view addSubview:scrollView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 200)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.tag = 10000;
    [scrollView addSubview:view1];
    
    
    self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view1.width, 50)];
    _priceLB.backgroundColor = MAIN_COLOR;
//    _priceLB.backgroundColor = MAIN_COLOR;
    _priceLB.text = @"    订单金额: ¥298";
    _priceLB.font = [UIFont systemFontOfSize:20];
    _priceLB.textColor = [UIColor whiteColor];
    [view1 addSubview:_priceLB];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton.frame = CGRectMake(_priceLB.right - 100, 0, 80, 50);
    _cancleButton.backgroundColor = [UIColor clearColor];
    [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_cancleButton addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    _cancleButton.hidden = YES;
    [view1 addSubview:_cancleButton];
    
    self.personLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _priceLB.bottom + TOP_SPACE, view1.width  - 2 * LEFT_SPACE, 30)];
    _personLB.text = @"预定人:马哥";
    _personLB.font = [UIFont systemFontOfSize:15];
    _personLB.textColor = TEXT_COLOR;
    [view1 addSubview:_personLB];
    
    
    self.telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _personLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _telLB.text = @"预定电话: 13456772457";
    _telLB.font = [UIFont systemFontOfSize:15];
    _telLB.textColor = TEXT_COLOR;
    [view1 addSubview:_telLB];
    
    
    self.checkInDateLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _telLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _checkInDateLB.text = @"入住时间: 2015年5月15日 19:52:15";
    _checkInDateLB.font = [UIFont systemFontOfSize:15];
    _checkInDateLB.textColor = TEXT_COLOR;
    [view1 addSubview:_checkInDateLB];
    
    self.leaveLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _checkInDateLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _leaveLB.text = @"离开时间: 2015年5月17日 19:52:15";
    _leaveLB.font = [UIFont systemFontOfSize:15];
    _leaveLB.textColor = TEXT_COLOR;
    [view1 addSubview:_leaveLB];
    
    
    self.roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _leaveLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _roomLB.text = @"总统大套房";
    _roomLB.font = [UIFont systemFontOfSize:15];
    _roomLB.textColor = TEXT_COLOR;
    [view1 addSubview:_roomLB];
    
    
    self.countLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _roomLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _countLB.text = @"预定房间: 1间";
    _countLB.font = [UIFont systemFontOfSize:15];
    _countLB.textColor = TEXT_COLOR;
    [view1 addSubview:_countLB];
    
    
    self.payLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _countLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _payLB.text = @"支付方式: 在线支付";
    _payLB.font = [UIFont systemFontOfSize:15];
    _payLB.textColor = TEXT_COLOR;
    [view1 addSubview:_payLB];
    
    
    self.requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _payLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    _requireLB.text = @"特殊要求";
    _requireLB.font = [UIFont systemFontOfSize:15];
    _requireLB.numberOfLines = 0;
    _requireLB.textColor = TEXT_COLOR;
    [view1 addSubview:_requireLB];
    
    view1.height = _requireLB.bottom + TOP_SPACE;
    
    self.backMoneyImageview = [[UIImageView alloc]initWithFrame:CGRectMake(view1.width - 110, _requireLB.top - 53, 94, 70)];
    _backMoneyImageview.backgroundColor = [UIColor clearColor];
    _backMoneyImageview.hidden = YES;
    [view1 addSubview:_backMoneyImageview];
    
//    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
//    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
//    [view1 addSubview:line1];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 5, scrollView.width, 200)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.tag = 20000;
    [scrollView addSubview:view2];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line2];
    
    
    self.grogshopLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 40)];
    _grogshopLB.text = @"柳州新世纪酒店";
    _grogshopLB.font = [UIFont systemFontOfSize:16];
    _grogshopLB.textColor = TEXT_COLOR;
    [view2 addSubview:_grogshopLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, _grogshopLB.bottom, view2.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line3];
    
    UIImageView * addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, 20, 20)];
    addressIcon.image = [UIImage imageNamed:@"addressIcon.png"];
    [view2 addSubview:addressIcon];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(addressIcon.right + 5, addressIcon.top, view2.width - addressIcon.right - LEFT_SPACE - 5, 20)];
    _addressLB.text = @"新环西路1000弄5号903";
    _addressLB.font = [UIFont systemFontOfSize:15];
    _addressLB.textColor = TEXT_COLOR;
    [view2 addSubview:_addressLB];
    
    UIImageView * telIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, addressIcon.bottom + TOP_SPACE, 20, 20)];
    telIcon.image = [UIImage imageNamed:@"phoneIcon.png"];
    [view2 addSubview:telIcon];
    
    self.telGSLB = [[UILabel alloc] initWithFrame:CGRectMake(telIcon.right + 5, telIcon.top, view2.width - addressIcon.right - LEFT_SPACE - 5, 20)];
    _telGSLB.text = @"13589645969";
    _telGSLB.textColor = TEXT_COLOR;
    [view2 addSubview:_telGSLB];
    
    view2.height = _telGSLB.bottom;
    
    self.commentView = [[UIView alloc]initWithFrame:CGRectMake(0, view2.bottom, scrollView.width, 30)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_commentView];
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, 20, 20)];
    commentIcon.image = [UIImage imageNamed:@"commentIcon.png"];
    [_commentView addSubview:commentIcon];
    
    UIButton * commentBT = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBT.frame = CGRectMake(commentIcon.right + 5, commentIcon.top, _commentView.width - commentIcon.right - LEFT_SPACE - 5, 20);
    [commentBT setTitle:@"评论" forState:UIControlStateNormal];
    commentBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    commentBT.titleLabel.font = [UIFont systemFontOfSize:15];
    commentBT.backgroundColor = [UIColor clearColor];
    [commentBT setTintColor:[UIColor whiteColor]];
    [commentBT setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [commentBT addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    _commentView.hidden = YES;
    [_commentView addSubview:commentBT];
    
    scrollView.contentSize = CGSizeMake(scrollView.width, _commentView.bottom + 10);

    
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
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];

    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    if (self.isPay) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10026]) {
            self.priceLB.text = [NSString stringWithFormat:@"     订单金额:¥%@", [data objectForKey:@"Price"]];
            self.personLB.text = [NSString stringWithFormat:@"预定人:%@", [data objectForKey:@"Name"]];
            self.telLB.text = [NSString stringWithFormat:@"预定号码:%@", [data objectForKey:@"PhoneNumber"]];
            
            NSDateFormatter * monthFomatter = [[NSDateFormatter alloc]init];
            monthFomatter.dateFormat = @"yyyy/MM/dd hh:mm:ss";
            
            NSDateFormatter * monthFomatter1 = [[NSDateFormatter alloc]init];
            monthFomatter1.dateFormat = @"yyyy/MM/dd";
            
            NSString * checkInTime = [data objectForKey:@"CheckInTime"];
            NSDate * checkIndate = [NSDate date];
            checkIndate = [monthFomatter dateFromString:checkInTime];
            NSString * checkInstr = [monthFomatter1 stringFromDate:checkIndate];
            self.checkInDateLB.text = [NSString stringWithFormat:@"入住时间:%@", checkInstr];
            
            NSString * leaveTime = [data objectForKey:@"LeaveTime"];
            NSDate * leaveDate = [NSDate date];
            leaveDate = [monthFomatter dateFromString:leaveTime];
            NSString * leavestr = [monthFomatter1 stringFromDate:leaveDate];
            self.leaveLB.text = [NSString stringWithFormat:@"离店时间:%@", leavestr];
            
            self.roomLB.text = [NSString stringWithFormat:@"房型:%@", [data objectForKey:@"RoomType"]];
            self.countLB.text = [NSString stringWithFormat:@"预定房间:%@间", [data objectForKey:@"RoomCount"]];
            self.payType = [data objectForKey:@"PeyType"];
            if ([[data objectForKey:@"PeyType"] isEqualToNumber:@1]) {
                self.payLB.text = @"支付方式:微信支付";
            }else{
                self.payLB.text = @"支付方式:百度支付";
            }
            
            if ([[data objectForKey:@"PeyState"] intValue] == 1) {
                if ([[data objectForKey:@"OrderState"] intValue] == 6) {
                    self.backMoneyImageview.image = [UIImage imageNamed:@"back_money.png"];
                    _backMoneyImageview.hidden = NO;
                }else if ([[data objectForKey:@"OrderState"] intValue] == 4)
                {
                    self.backMoneyImageview.image = [UIImage imageNamed:@"cancel_order.png"];
                    _backMoneyImageview.hidden = NO;
                }else if ([[data objectForKey:@"OrderState"] intValue] == 1)
                {
                    [_cancleButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    _cancleButton.hidden = NO;
                }
                
                if ([[data objectForKey:@"IsComment"] intValue] == 1) {
                    _commentView.hidden = YES;
                }else
                {
                    _commentView.hidden = NO;
                }
                
            }else if ([[data objectForKey:@"PeyState"] intValue] == 2)
            {
                if ([[data objectForKey:@"OrderState"] intValue] == 6) {
                    self.backMoneyImageview.image = [UIImage imageNamed:@"back_money.png"];
                    _backMoneyImageview.hidden = NO;
                }else if ([[data objectForKey:@"OrderState"] intValue] == 4)
                {
                    self.backMoneyImageview.image = [UIImage imageNamed:@"cancel_order.png"];
                    _backMoneyImageview.hidden = NO;
                }else if ([[data objectForKey:@"OrderState"] intValue] == 1)
                {
                    [_cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
                    _cancleButton.hidden = NO;
                }
                
            }
            
            
            
            NSString * str = [NSString stringWithFormat:@"特殊需求:%@", [data objectForKey:@"Demand"]];
            
            CGSize maxSize = CGSizeMake(self.requireLB.width, 1000);
            CGRect textRect = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            float height = textRect.size.height;
            NSLog(@"height = %f", textRect.size.height);
            UIScrollView * scrollView = [self.view viewWithTag:8888];
            UIView * view1 = [scrollView viewWithTag:10000];
            UIView * view2 = [scrollView viewWithTag:20000];
            _requireLB.frame = CGRectMake(LEFT_SPACE, _payLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, height);
            self.requireLB.text = [NSString stringWithFormat:@"特殊需求:%@", [data objectForKey:@"Demand"]];
            NSLog(@"***%f", _requireLB.height);
            view1.height = _requireLB.bottom + TOP_SPACE;
            view2.frame = CGRectMake(0, view1.bottom + 5, scrollView.width, 200);
            view2.height = _telGSLB.bottom;
            self.commentView.frame = CGRectMake(0, view2.bottom, scrollView.width, 30);
            scrollView.contentSize = CGSizeMake(scrollView.width, _commentView.bottom + 10);
            self.grogshopLB.text = [data objectForKey:@"HotelName"];
            self.addressLB.text = [data objectForKey:@"HotelAddress"];
            self.telGSLB.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"HotelTel"]];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10046])
        {
            if ([self.cancleButton.titleLabel.text isEqualToString:@"取消订单"]) {
                self.cancleButton.hidden = YES;
                self.backMoneyImageview.image = [UIImage imageNamed:@"cancel_order.png"];
                _backMoneyImageview.hidden = NO;
            }
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

#pragma mark - 取消订单、退款
#warning 取消订单、退款参数一样？
- (void)cancleAction:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"取消订单"]) {
        NSLog(@"取消订单");
        NSDictionary * dic = @{
                               @"Command":@46,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"OrderId":self.orderID
                               };
        [self playPostWithDictionary:dic];
    }else
    {
        NSLog(@"申请退款");
        NSDictionary * dic = @{
                               @"Command":@46,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"OrderId":self.orderID
                               };
        [self playPostWithDictionary:dic];
    }
}


#pragma mark - 评论
#warning 酒店订单与外卖订单请求参数一样？
- (void)commentAction:(UIButton * )button
{
    CreateCommentViewController * commentVC = [[CreateCommentViewController alloc]init];
    [self.navigationController pushViewController:commentVC animated:YES];
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
