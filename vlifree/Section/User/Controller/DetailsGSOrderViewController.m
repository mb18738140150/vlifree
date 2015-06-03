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

@interface DetailsGSOrderViewController ()

@end

@implementation DetailsGSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    [self.view addSubview:scrollView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 200)];
    view1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view1];
    
    
    UILabel * priceLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view1.width, 50)];
    priceLB.backgroundColor = [UIColor redColor];
    priceLB.text = @"    订单金额: ¥298";
    priceLB.font = [UIFont systemFontOfSize:22];
    priceLB.textColor = [UIColor whiteColor];
    [view1 addSubview:priceLB];
    
    UILabel * personLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, priceLB.bottom + TOP_SPACE, view1.width  - 2 * LEFT_SPACE, 30)];
    personLB.text = @"预定人:马哥";
    [view1 addSubview:personLB];
    
    
    UILabel * telLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, personLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    telLB.text = @"预定电话: 13456772457";
    [view1 addSubview:telLB];
    
    
    UILabel * checkInDateLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, telLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    checkInDateLB.text = @"入住时间: 2015年5月15日 19:52:15";
    [view1 addSubview:checkInDateLB];
    
    UILabel * leaveLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, checkInDateLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    leaveLB.text = @"离开时间: 2015年5月17日 19:52:15";
    [view1 addSubview:leaveLB];
    
    
    UILabel * roomLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, leaveLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    roomLB.text = @"总统大套房";
    [view1 addSubview:roomLB];
    
    
    UILabel * countLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, roomLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    countLB.text = @"预定房间: 1间";
    [view1 addSubview:countLB];
    
    
    UILabel * payLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, countLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    payLB.text = @"支付方式: 在线支付";
    [view1 addSubview:payLB];
    
    
    UILabel * requireLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, payLB.bottom + TOP_SPACE, view1.width - 2 * LEFT_SPACE, 30)];
    requireLB.text = @"特殊要求";
    [view1 addSubview:requireLB];
    
    view1.height = requireLB.bottom + TOP_SPACE;
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view1 addSubview:line1];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 10, scrollView.width, 200)];
    view2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view2];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line2];
    
    
    UILabel * grogshopLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, 0, view2.width - 2 * LEFT_SPACE, 40)];
    grogshopLB.text = @"柳州新世纪酒店";
    grogshopLB.font = [UIFont systemFontOfSize:23];
    [view2 addSubview:grogshopLB];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, grogshopLB.bottom, view2.width - 2 * LEFT_SPACE, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [view2 addSubview:line3];
    
    UIImageView * addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, line3.bottom + TOP_SPACE, 30, 30)];
    addressIcon.image = [UIImage imageNamed:@"addressIcon.png"];
    [view2 addSubview:addressIcon];
    
    UILabel * addressLB = [[UILabel alloc] initWithFrame:CGRectMake(addressIcon.right + 5, addressIcon.top, view2.width - addressIcon.right - LEFT_SPACE - 5, 30)];
    addressLB.text = @"新环西路1000弄5号903";
    [view2 addSubview:addressLB];
    
    UIImageView * telIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, addressIcon.bottom + TOP_SPACE, 30, 30)];
    telIcon.image = [UIImage imageNamed:@"phoneIcon.png"];
    [view2 addSubview:telIcon];
    
    UILabel * telGSLB = [[UILabel alloc] initWithFrame:CGRectMake(telIcon.right + 5, telIcon.top, view2.width - addressIcon.right - LEFT_SPACE - 5, 30)];
    telGSLB.text = @"13589645969";
    [view2 addSubview:telGSLB];
    
    view2.height = telGSLB.bottom + TOP_SPACE;
    scrollView.contentSize = CGSizeMake(scrollView.width, view2.bottom);
    
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
