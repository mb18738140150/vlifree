//
//  DetailsTOOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsTOOrderViewController.h"

@interface DetailsTOOrderViewController ()


@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * stateImageV;
@property (nonatomic, strong)UILabel * stateLabel;


@end

@implementation DetailsTOOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame = CGRectMake(0, 0, 30, 30);
    [telButton setBackgroundImage:[UIImage imageNamed:@"tel_order_detail_icon.png"] forState:UIControlStateNormal];
    [telButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBT = [[UIBarButtonItem alloc] initWithCustomView:telButton];
    self.navigationItem.rightBarButtonItem = barBT;
    
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
    
    UIButton * cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBT.frame = CGRectMake(view1.width - 200, aLabel.bottom + 10, 80, 25);
    [cancelBT setTitle:@"取消订单" forState:UIControlStateNormal];
    cancelBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    cancelBT.layer.borderWidth = 1;
    cancelBT.layer.cornerRadius = 3;
    [view1 addSubview:cancelBT];
    
    UIButton * confirmBT = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBT.frame = CGRectMake(view1.width - 100, aLabel.bottom + 10, 80, 25);
    [confirmBT setTitle:@"确认订单" forState:UIControlStateNormal];
    confirmBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    confirmBT.layer.backgroundColor = [UIColor orangeColor].CGColor;
    confirmBT.layer.borderWidth = 1;
    confirmBT.layer.cornerRadius = 3;
    [view1 addSubview:confirmBT];
    
    view1.height = confirmBT.bottom + 10;
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:lineView1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, _scrollView.width, 100)];
    view2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view2];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:lineView2];
    
    NSArray * array = @[@"提交订单", @"餐厅接单", @"配送中", @"已收货"];
    
    for (int i = 0; i < 4; i++) {
        UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake((view2.width - 200) / 5 * (i + 1) + 50 * i, 10, 50, 50)];
        aImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderState%d.png", i + 1]];
        [view2 addSubview:aImageView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(aImageView.left, aImageView.bottom, aImageView.width, 20)];
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
            label.textColor = [UIColor greenColor];
            view2.height = label.bottom + 5;
        }
        
    }
    
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.height - 1, view2.width, 1)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:lineView3];
    
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 10, _scrollView.width, 100)];
    view3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view3];
    
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view3.width, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:lineView4];
    
    UIImageView * storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    storeIcon.image = [UIImage imageNamed:@"store.png"];
    [view3 addSubview:storeIcon];
    
    UILabel * storeNameLB = [[UILabel alloc] initWithFrame:CGRectMake(storeIcon.right + 5, storeIcon.top, view3.width - 10 - storeIcon.right, storeIcon.height)];
    storeNameLB.text = @"哆啦A梦茶餐厅";
    [view3 addSubview:storeNameLB];
    
    UIView * lineView5 = [[UIView alloc] initWithFrame:CGRectMake(10, storeNameLB.bottom, view3.width - 20, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:lineView5];
    
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lineView5.bottom + 5, view3.width - 130, 20)];
    orderLabel.text = @"港式下午茶a套餐";
    [view3 addSubview:orderLabel];
    
    UILabel * orderCountLB = [[UILabel alloc] initWithFrame:CGRectMake(orderLabel.right + 5, orderLabel.top, 20, 20)];
    orderCountLB.text = @"1";
    [view3 addSubview:orderCountLB];
    
    UILabel * orderPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(orderCountLB.right + 20, orderLabel.top, 55, 20)];
    orderPriceLB.text = @"¥23";
    orderPriceLB.textAlignment = NSTextAlignmentRight;
    [view3 addSubview:orderPriceLB];
    
    view3.height = orderLabel.bottom + 5;
    
    UIView * lineView6 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.height - 1, view3.width, 1)];
    lineView6.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view3 addSubview:lineView6];
    
    UIView * view4 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.bottom + 10, _scrollView.width, 100)];
    view4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view4];
    
    UIView * lineView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view4.width, 1)];
    lineView7.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view4 addSubview:lineView7];
    
    UILabel * otherTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 25)];
    otherTitleLB.text = @"配送费";
    [view4 addSubview:otherTitleLB];
    
    UILabel * otherPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, otherTitleLB.top, 50, 25)];
    otherPriceLB.text = @"¥35";
    otherPriceLB.textAlignment = NSTextAlignmentRight;
    [view4 addSubview:otherPriceLB];
    
    UIView * lineView8 = [[UIView alloc] initWithFrame:CGRectMake(10, otherPriceLB.bottom, view4.width - 20, 1)];
    lineView8.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view4 addSubview:lineView8];
    
    UILabel * totalLB = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView8.bottom + 5, 100, 25)];
    totalLB.text = @"合计";
    [view4 addSubview:totalLB];
    
    UILabel * totalPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(view4.width - 70, totalLB.top, 50, 25)];
    totalPriceLB.text = @"¥35";
    totalPriceLB.textAlignment = NSTextAlignmentRight;
    [view4 addSubview:totalPriceLB];
    
    UIView * lineView9 = [[UIView alloc] initWithFrame:CGRectMake(10, totalLB.bottom, view4.width - 20, 1)];
    lineView9.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view4 addSubview:lineView9];
    
    UIButton * againBT = [UIButton buttonWithType:UIButtonTypeCustom];
    againBT.frame = CGRectMake(view4.width - 100, lineView9.bottom + 5, 80, 25);
    [againBT setTitle:@"再来一单" forState:UIControlStateNormal];
    [againBT setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    againBT.titleLabel.font = [UIFont systemFontOfSize:14];
    againBT.layer.borderColor = [UIColor orangeColor].CGColor;
    againBT.layer.borderWidth = 1;
    againBT.layer.cornerRadius = 5;
    [view4 addSubview:againBT];
    view4.height = againBT.bottom + 5;
    
    UIView * lineView10 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.height - 1, view4.width, 1)];
    lineView10.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view4 addSubview:lineView10];
    
    UIView * view5 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.bottom + 10, _scrollView.width, 270)];
    view5.backgroundColor = [UIColor whiteColor];
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
    
    UILabel * orderNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView12.bottom + 5, lineView12.width - 10, 30)];
    orderNumberLB.text = @"订单号码: 3247693974979";
    [view5 addSubview:orderNumberLB];
    
    
    UILabel * orderDateLB = [[UILabel alloc] initWithFrame:CGRectMake(15, orderNumberLB.bottom + 5, lineView12.width - 10, 30)];
    orderDateLB.text = @"订单时间: 2015年5月16日 11:24:24";
    [view5 addSubview:orderDateLB];
    
    UILabel * orderPayTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(15, orderDateLB.bottom + 5, lineView12.width - 10, 30)];
    orderPayTypeLB.text = @"支付方式: 餐到付款";
    [view5 addSubview:orderPayTypeLB];
    
    UILabel * orderTelLB = [[UILabel alloc] initWithFrame:CGRectMake(15, orderPayTypeLB.bottom + 5, lineView12.width - 10, 30)];
    orderTelLB.text = @"手机号码: 13739443500";
    [view5 addSubview:orderTelLB];
    
    
    UILabel * orderAddressLB = [[UILabel alloc] initWithFrame:CGRectMake(15, orderTelLB.bottom + 5, lineView12.width - 10, 30)];
    orderAddressLB.text = @"收餐地址: 未来路1235号590";
    [view5 addSubview:orderAddressLB];
    view5.height = orderAddressLB.bottom + 10;
    
    CGSize size = _scrollView.contentSize;
    size.height = view5.bottom;
    _scrollView.contentSize = size;
    
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

- (void)callPhone:(UIButton *)button
{
    NSLog(@"22222222");
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:@"tel:13788052976"];
//    [[UIApplication sharedApplication] openURL:telURL];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
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
