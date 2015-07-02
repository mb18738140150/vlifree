//
//  GSOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSOrderViewController.h"
#import "GSOrderViewCell.h"
#import "DetailsGSOrderViewController.h"
#import "GSPayViewController.h"

@interface GSOrderViewController ()<HTTPPostDelegate>

{
    int _page;
}

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSNumber * allCount;

@end

@implementation GSOrderViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[GSOrderViewCell class] forCellReuseIdentifier:@"cell"];
    _page = 1;
    [self downloadDataWithCommand:@25 page:_page count:COUNT];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据刷新,加载更多

- (void)headerRereshing
{
    _page = 1;
    [self downloadDataWithCommand:@25 page:_page count:COUNT];
}

- (void)footerRereshing
{
    if (self.dataArray.count < [_allCount integerValue]) {
        self.tableView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@25 page:++_page count:COUNT];
    }else
    {
        self.tableView.footerRefreshingText = @"数据已经加载完";
        [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1.5];
    }
    
}

#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    NSDictionary * jsonDic = @{
                               @"Command":command,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count],
                               @"UserId":[UserInfo shareUserInfo].userId
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
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
        self.allCount = [data objectForKey:@"AllCount"];
        NSArray * array = [data objectForKey:@"HotelOrderList"];
        if(_page == 1)
        {
            self.dataArray = nil;
        }
        for (NSDictionary * dic in array) {
            GrogshopOrderMD * grogshopMD = [[GrogshopOrderMD alloc] initWithDictionary:dic];
            
            [self.dataArray addObject:grogshopMD];
        }
        [self.tableView reloadData];
        NSLog(@"%d", _dataArray.count);
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GrogshopOrderMD * grogshopMD = [self.dataArray objectAtIndex:indexPath.row];
    GSOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell createSubview:tableView.bounds];
    [cell.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.payButton.tag = indexPath.row + 4000;
    cell.grogshopOrderMD = grogshopMD;
//    cell.textLabel.text = @"244";
    // Configure the cell...
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GrogshopOrderMD * grogshopMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailsGSOrderViewController * detailsGSODVC = [[DetailsGSOrderViewController alloc] init];
    detailsGSODVC.orderID = grogshopMD.orderSn;
    if ([grogshopMD.payState isEqualToNumber:@1]) {
        detailsGSODVC.isPay = YES;
    }else
    {
        detailsGSODVC.isPay = NO;
    }
    [self.navigationController pushViewController:detailsGSODVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


- (void)payAction:(UIButton *)button
{
    NSLog(@"支付%d", button.tag - 4000);
    GrogshopOrderMD * grogshopMD = [self.dataArray objectAtIndex:button.tag - 4000];
    GSPayViewController * gsPayVC = [[GSPayViewController alloc] init];
    gsPayVC.orderID = grogshopMD.orderSn;
    [self.navigationController pushViewController:gsPayVC animated:YES];
    /*
    DetailsGSOrderViewController * detailsGSODVC = [[DetailsGSOrderViewController alloc] init];
    detailsGSODVC.orderID = grogshopMD.orderSn;
    detailsGSODVC.isPay = NO;
    [self.navigationController pushViewController:detailsGSODVC animated:YES];
     */
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
