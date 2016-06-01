//
//  UserTOOrderViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/30.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "UserTOOrderViewController.h"
#import "TOOrderViewCell.h"
#import "DetailsTOOrderViewController.h"

@interface UserTOOrderViewController ()<HTTPPostDelegate>
{
    int _page;
}

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSNumber * allCount;

@end

@implementation UserTOOrderViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"外卖订单";
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: TEXT_COLOR,
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:17]
                                                                    };
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[TOOrderViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    _page = 1;
    [self downloadDataWithCommand:@23 page:_page count:COUNT];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.tableView headerEndRefreshing];
}

#pragma mark - 数据刷新,加载更多

- (void)headerRereshing
{
    _page = 1;
    [self downloadDataWithCommand:@23 page:_page count:COUNT];
}

- (void)footerRereshing
{
    if (self.dataArray.count < [_allCount integerValue]) {
        [self.tableView.footer resetNoMoreData];
        [self downloadDataWithCommand:@23 page:++_page count:COUNT];
    }else
    {
        [self.tableView.footer noticeNoMoreData];
//        [self.tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1.5];
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
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
        NSArray * array = [data objectForKey:@"WakeOutOrderList"];
        self.allCount = [data objectForKey:@"AllCount"];
        if(_page == 1)
        {
            _dataArray = nil;
        }
        for (NSDictionary * dic in array) {
            TakeOutOrderMD * takeOutOrderMD = [[TakeOutOrderMD alloc] initWithDictionary:dic];
            [self.dataArray addObject:takeOutOrderMD];
        }
        [self.tableView reloadData];
        if (self.dataArray.count < [_allCount integerValue])
        {
            [self.tableView.footer resetNoMoreData];
        }else
        {
            [self.tableView.footer noticeNoMoreData];
        }
    }
}

- (void)failWithError:(NSError *)error
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    TakeOutOrderMD * takeOutMD = [self.dataArray objectAtIndex:indexPath.row];
    TOOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell crateSubview:tableView.bounds];
    cell.takeOutOrderMD = takeOutMD;
    [cell.iconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.iconButton.tag = 10000 + indexPath.row;
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TOOrderViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakeOutOrderMD * takeOutOrderMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailsTOOrderViewController * detailsVC = [[DetailsTOOrderViewController alloc] init];
    detailsVC.takeOutOrderMD = takeOutOrderMD;
    [self.navigationController pushViewController:detailsVC animated:YES];
}


#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
    int section = 0;
    NSInteger row = button.tag - 10000;
    TakeOutOrderMD * takeOutOrderMd = [self.dataArray objectAtIndex:row];
    CGPoint point = self.tableView.contentOffset;
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.tableView.top;
    btFrame.origin.x = self.tableView.left + button.left;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = view.center;
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    CGRect imageFrame = imageView.frame;
    imageView.frame = btFrame;
    imageView.image = [UIImage imageNamed:@"superMarket.png"];
    [view addSubview:imageView];
    [self.view.window addSubview:view];
    __weak UIImageView * imageV = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:takeOutOrderMd.storeIcon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            imageV.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    [UIView animateWithDuration:1 animations:^{
        imageView.frame = imageFrame;
    }];
    
    NSLog(@",  %g, %g", cellRect.origin.x, cellRect.origin.y);
}

- (void)removeBigImage
{
    UIView * view = [self.view.window viewWithTag:70000];
    [view removeFromSuperview];
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
