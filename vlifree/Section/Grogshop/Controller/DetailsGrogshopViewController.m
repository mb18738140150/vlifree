//
//  DetailsGrogshopViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "DetailsGrogshopViewController.h"
#import "CycleScrollView.h"
#import "DetailsGSHearderView.h"
#import "DetailsFooterView.h"
#import "DetailsGSViewCell.h"
#import "GSOrderPayViewController.h"
#import "DescribeView.h"
#import "GSMapViewController.h"


#define CELL_INDENTIFIER @"CELL"

#define BUTTON_TAG 1000

@interface DetailsGrogshopViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView * detailsTableView;

@property (nonatomic, strong)DetailsGSHearderView * headerView;
@property (nonatomic, strong)DetailsFooterView * footerView;

//@property (nonatomic, strong)CycleScrollView * cycleScrollView;//轮播图

@property (nonatomic, strong)NSMutableArray * dataArray;


@end


@implementation DetailsGrogshopViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.detailsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _detailsTableView.dataSource = self;
    _detailsTableView.delegate = self;
    [_detailsTableView registerClass:[DetailsGSViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    [self.view addSubview:_detailsTableView];
    
    
    self.headerView = [[DetailsGSHearderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 310)];
    [_headerView.addressView.button addTarget:self action:@selector(lookOverMapk:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.phoneView.button addTarget:self action:@selector(callNumberWithPhone:) forControlEvents:UIControlEventTouchUpInside];
//    _headerView.backgroundColor = [UIColor grayColor];
    self.detailsTableView.tableHeaderView = _headerView;
    
//    NSMutableArray * iary = [@[@"1-1.jpg", @"1-2.jpg", @"1-3.jpg", @"1-4.jpg"] mutableCopy];
//    NSMutableArray * imageViewAry = [NSMutableArray array];
//    for (int i = 0; i < iary.count; i++) {
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 150)];
//        imageView.image = [UIImage imageNamed:[iary objectAtIndex:i]];
//        [imageViewAry addObject:imageView];
//    }
//    _headerView.cycleViews = [imageViewAry copy];
    
    
    self.footerView = [[DetailsFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [_footerView.allButton addTarget:self action:@selector(unfoldAllRoom:) forControlEvents:UIControlEventTouchUpInside];
    _footerView.explainArray = @[@"bb", @"22", @"ww"];
    self.detailsTableView.tableFooterView = _footerView;
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    [self downloadDataWithCommand];

}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)unfoldAllRoom:(UIButton *)button
{
    button.selected = !button.selected;
    [self.detailsTableView reloadData];
}


- (void)callNumberWithPhone:(UIButton *)button
{
    NSLog(@"打电话");
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSURL *telURL = [NSURL URLWithString:@"tel:13788052976"];
    //    [[UIApplication sharedApplication] openURL:telURL];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
}

- (void)lookOverMapk:(UIButton *)button
{
    NSLog(@"查看地图");
    GSMapViewController * gsMapVC = [[GSMapViewController alloc] init];
    [self.navigationController pushViewController:gsMapVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reserveGSRoom:(UIButton *)button
{
    NSLog(@"预定%ld", button.tag - BUTTON_TAG);
    GSOrderPayViewController * gsOrderPayVC = [[GSOrderPayViewController alloc] init];
    [self.navigationController pushViewController:gsOrderPayVC animated:YES];
}


#pragma mark - 数据请求
- (void)downloadDataWithCommand
{
    
    NSDictionary * jsonDic = @{
                               @"Command":@10,
                               @"HotelId":self.hotelID
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
    //    NSLog(@"%@", jsonStr);
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
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
        NSArray * array = [data objectForKey:@"AllList"];
        for (NSDictionary * dic in array) {
//            HotelModel * hotelMD = [[HotelModel alloc] initWithDictionary:dic];
//            [self.dataArray addObject:hotelMD];
        }
        [self.detailsTableView reloadData];
    }
//    [self.detailsTableView headerEndRefreshing];
//    [self.detailsTableView footerEndRefreshing];
    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
//    [self.groshopTabelView headerEndRefreshing];
//    [self.groshopTabelView footerEndRefreshing];
    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}



#pragma mark - tableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.footerView.allButton.selected) {
        return 10;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsGSViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    [cell createSubviewWithFrame:tableView.bounds];
    [cell.reserveButton addTarget:self action:@selector(reserveGSRoom:) forControlEvents:UIControlEventTouchUpInside];
    cell.reserveButton.tag = BUTTON_TAG + indexPath.row;
//    cell.textLabel.text = @"222";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DetailsGSViewCell cellHeight];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"精品推荐";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.width - 30, 30)];
    titleLB.text = @"精品推荐";
    [sectionView addSubview:titleLB];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, sectionView.height - 1, titleLB.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [sectionView addSubview:lineView];
    return sectionView;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
