//
//  GrogshopViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GrogshopViewController.h"
#import "GrogshopViewCell.h"
#import "GrogshopHeaderView.h"
#import "DetailsGrogshopViewController.h"
#import "CollectStroeDB.h"

#define CELL_INDENTIFIER @"CELL"
@interface GrogshopViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, HTTPPostDelegate>
{
    /**
     *  请求数据页数
     */
    int _page;
    /**
     *  请求类型
     */
    int _type;
}
/**
 *  酒店列表
 */
@property (nonatomic, strong)UITableView * groshopTabelView;
/**
 *  搜索取消按钮
 */
@property (nonatomic, strong)UIButton * cancelBT;
/**
 *  搜索框
 */
@property (nonatomic, strong)UISearchBar * searchB;
/**
 *  数据数组
 */
@property (nonatomic, strong)NSMutableArray * dataArray;
/**
 *  定位时间监控
 */
@property (nonatomic, strong)NSTimer * timer;
/**
 *  数据总个数
 */
@property (nonatomic, strong)NSNumber * allCount;
/**
 *  搜索关键词
 */
@property (nonatomic, copy)NSString * keyWord;

@property (nonatomic, strong)HotelModel * collectModel;

@property (nonatomic, strong)CollectStroeDB * collectDB;

@end

@implementation GrogshopViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectDB = [[CollectStroeDB alloc]init];
    
    self.cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBT.frame = CGRectMake(0, 0, 40, 30);
    [_cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBT setTitleColor:[UIColor colorWithWhite:0.6 alpha:0.8] forState:UIControlStateNormal];
    _cancelBT.hidden = YES;
    [_cancelBT addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
//    _cancelBT.backgroundColor = [UIColor redColor];
    UIBarButtonItem * barBT = [[UIBarButtonItem alloc] initWithCustomView:_cancelBT];
    self.navigationItem.rightBarButtonItem = barBT;
    
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 5 * 3, 30)];
    self.searchB = [[UISearchBar alloc] initWithFrame:searchView.bounds];
    _searchB.backgroundColor = [UIColor clearColor];
    _searchB.layer.cornerRadius = 10;
    _searchB.delegate = self;
    _searchB.tag = 20001;
    _searchB.barTintColor = [UIColor whiteColor];
    UITextField * textTF = (UITextField *)[[[_searchB.subviews firstObject] subviews] lastObject];
//    textTF.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    textTF.borderStyle = UITextBorderStyleNone;
//    textTF.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.7].CGColor;
//    textTF.layer.borderWidth = 1.5;
//    textTF.layer.cornerRadius = 5;
    textTF.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    
    UIView * view = [_searchB.subviews firstObject];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.7].CGColor;
    _searchB.placeholder = @"搜索酒店名称或者位置";
    [searchView addSubview:_searchB];
    self.navigationItem.titleView = searchView;
    
    
    GrogshopHeaderView * gsHeaderView = [[GrogshopHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, [GrogshopHeaderView viewHeight])];
    gsHeaderView.tag = 1000;
    [gsHeaderView.allButton addTarget:self action:@selector(changeTypeData:) forControlEvents:UIControlEventTouchUpInside];
    [gsHeaderView.priceButton addTarget:self action:@selector(changeTypeData:) forControlEvents:UIControlEventTouchUpInside];
    [gsHeaderView.distanceButton addTarget:self action:@selector(changeTypeData:) forControlEvents:UIControlEventTouchUpInside];
    [gsHeaderView.soldButton addTarget:self action:@selector(changeTypeData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gsHeaderView];
    
    
    self.groshopTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, gsHeaderView.bottom, self.view.width, self.view.height - gsHeaderView.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
    _groshopTabelView.dataSource = self;
    _groshopTabelView.delegate = self;
    [self.view addSubview:_groshopTabelView];
    self.groshopTabelView.separatorColor = LINE_COLOR;
    [self.groshopTabelView registerClass:[GrogshopViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    self.groshopTabelView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//    self.groshopTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.groshopTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
//    [self.groshopTabelView.footer noticeNoMoreData];
    self.groshopTabelView.tableFooterView = [[UIView alloc] init];
    _page = 1;
    _type = 2;
    self.keyWord = nil;
    if ([UserLocation shareUserLocation].city != nil) {
        [self downloadDataWithCommand:@2 page:_page count:DATA_COUNT keyWord:nil];
    }else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downloadData) userInfo:nil repeats:YES];
        [_timer fire];
    }
    
    [self performSelector:@selector(isLocationsuccess) withObject:nil afterDelay:40];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {

    }
//    [self.groshopTabelView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
/**
 *  检测是否已经定位成功了
 */
- (void)isLocationsuccess
{
    if (![UserLocation shareUserLocation].city) {
//        [SVProgressHUD dismiss];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"本应用需要打开定位才能请求数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
}
/**
 *  数据请求
 */
- (void)downloadData
{
    NSLog(@"2222");
    if ([UserLocation shareUserLocation].city != nil) {
        [self downloadDataWithCommand:@2 page:_page count:DATA_COUNT keyWord:nil];
//        [self.groshopTabelView headerBeginRefreshing];
        [self.timer invalidate];
    }
}


- (void)cancelSearch:(UIButton *)button
{
    button.hidden = YES;
    [self.searchB resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTypeData:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    GrogshopHeaderView * gsView = (GrogshopHeaderView *)[self.view viewWithTag:1000];
    gsView.allButton.selected = NO;
    gsView.priceButton.selected = NO;
    gsView.distanceButton.selected = NO;
    gsView.soldButton.selected = NO;
    button.selected = !button.selected;
    _page = 1;
    if ([button isEqual:gsView.allButton]) {
        [self downloadDataWithCommand:@2 page:_page count:DATA_COUNT keyWord:nil];
        _type = 2;
    }else if ([button isEqual:gsView.priceButton]) {
        [self downloadDataWithCommand:@3 page:_page count:DATA_COUNT keyWord:nil];
        _type = 3;
    }else if ([button isEqual:gsView.distanceButton]) {
        [self downloadDataWithCommand:@4 page:_page count:DATA_COUNT keyWord:nil];
        _type = 4;
    }else if ([button isEqual:gsView.soldButton]) {
        [self downloadDataWithCommand:@5 page:_page count:DATA_COUNT keyWord:nil];
        _type = 5;
    }
    self.keyWord = nil;
//    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeClear];
//    [self.groshopTabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 数据刷新,加载更多

- (void)headerRereshing
{
//    [self.groshopTabelView.footer resetNoMoreData];
    [self downloadDataWithCommand:[NSNumber numberWithInt:_type] page:1 count:DATA_COUNT keyWord:self.keyWord];
    _page = 1;
}

- (void)footerRereshing
{
//    if (self.dataArray.count < [_allCount integerValue]) {
////        self.groshopTabelView.footerRefreshingText = @"正在加载数据";
//        [self.groshopTabelView.footer resetNoMoreData];
        [self downloadDataWithCommand:[NSNumber numberWithInt:_type] page:++_page count:DATA_COUNT keyWord:self.keyWord];
//    }else
//    {
////        self.groshopTabelView.footerRefreshingText = @"数据已经加载完";
//        [self.groshopTabelView.footer noticeNoMoreData];
//        [self.groshopTabelView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1.5];
//    }
    
}

#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count keyWord:(NSString *)keyWord
{
    if ([UserLocation shareUserLocation].city) {
        NSDictionary * jsonDic = nil;
        if (keyWord == nil) {
            jsonDic = @{
                        @"Command":command,
                        @"CurPage":[NSNumber numberWithInt:page],
                        @"CurCount":[NSNumber numberWithInt:count],
                        @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                        @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                        @"City":[UserLocation shareUserLocation].city
                        };
        }else
        {
            jsonDic = @{
                        @"Command":command,
                        @"CurPage":[NSNumber numberWithInt:page],
                        @"CurCount":[NSNumber numberWithInt:count],
                        @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                        @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                        @"City":[UserLocation shareUserLocation].city,
                        @"KeyWord":keyWord
                        };
            self.keyWord = keyWord;
        }
        [self playPostWithDictionary:jsonDic];
    }else
    {
        [self performSelector:@selector(tableViewEndRefresh) withObject:nil afterDelay:2];
    }
}

- (void)tableViewEndRefresh
{
    [self.groshopTabelView.header endRefreshing];
    [self.groshopTabelView.footer endRefreshing];
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
//    NSLog(@"+++%@", data);
    [self.groshopTabelView.header endRefreshing];
    [self.groshopTabelView.footer endRefreshing];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if([[data objectForKey:@"Command"] isEqualToNumber:@10028])
        {
            CollectStoreModel * collectMD = [[CollectStoreModel alloc]init];
            collectMD.businessName = self.collectModel.hotelName;
            collectMD.businessId = self.collectModel.hotelId.intValue;
            collectMD.businessType = 1;
//            if ([self.collectDB insert:collectMD]) {
//                NSLog(@"写入数据成功");
//            }else
//            {
//                NSLog(@"写入数据失败");
//            }
            [UserInfo shareUserInfo].collectCount = [NSNumber numberWithInt:([UserInfo shareUserInfo].collectCount.intValue + 1)];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }else
        {
            self.allCount = [data objectForKey:@"AllCount"];
            NSArray * array = [data objectForKey:@"HotelList"];
            if(_page == 1)
            {
                _dataArray = nil;
            }
            int count = 0;
            for (NSDictionary * dic in array) {
                HotelModel * hotelMD = [[HotelModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:hotelMD];
                count++;
            }
            
            [self.groshopTabelView reloadData];
           
            if (count > 0) {
                [self.groshopTabelView.footer resetNoMoreData];
            }else
            {
                [self.groshopTabelView.footer noticeNoMoreData];
            }
        }
        
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    }else
    {
        if (((NSString *)[data objectForKey:@"ErrorMsg"]).length != 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
        
    }
}

- (void)failWithError:(NSError *)error
{
    [self.groshopTabelView.header endRefreshing];
    [self.groshopTabelView.footer endRefreshing];
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}

#pragma mark - 搜索框

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _cancelBT.hidden = NO;
    /*
    [searchBar setShowsCancelButton:YES animated:YES];
    for (UIView * view in searchBar.subviews) {
//        NSLog(@"%@", view);
        for (UIView * smallView in view.subviews) {
            smallView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        }
        
    }
     */
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    self.cancelBT.hidden = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _page = 1;
    [self downloadDataWithCommand:@33 page:_page count:COUNT keyWord:searchBar.text];
    _type = 33;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelModel * hotelMD = [self.dataArray objectAtIndex:indexPath.row];
    GrogshopViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER];
    [cell createSubiew:tableView.bounds];
    __weak GrogshopViewController * grogshopVC = self;
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"关注酒店" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"111");
        if ([UserInfo shareUserInfo].userId) {
            self.collectModel = hotelMD;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@28,
                                       @"Flag":@1,
                                       @"Id":hotelMD.hotelId
                                       };
            [grogshopVC playPostWithDictionary:jsonDic];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏需要先登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
        return YES;
    }]];
    [cell.IconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.IconButton.tag = 5000 + indexPath.row;
    cell.hotelModel = hotelMD;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookBigImage)];
//    [cell.icon addGestureRecognizer:tap];
//    cell.icon.tag = 5000 + indexPath.row;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelModel * hotelMD = [self.dataArray objectAtIndex:indexPath.row];
    return [GrogshopViewCell cellHeigthWithIsFirstReduce:hotelMD.isFirstReduce];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HotelModel * hotelMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailsGrogshopViewController * detailsVC = [[DetailsGrogshopViewController alloc] init];
    detailsVC.hidesBottomBarWhenPushed = YES;
    detailsVC.hotelID = hotelMD.hotelId;
    detailsVC.lat = hotelMD.hotelLat;
    detailsVC.lon = hotelMD.hotelLon;
    detailsVC.icon = hotelMD.icon;
    detailsVC.hotelName = hotelMD.hotelName;
    detailsVC.navigationItem.title = hotelMD.hotelName;
    [self.navigationController pushViewController:detailsVC animated:YES];
}


#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
    HotelModel * hotelMD = [self.dataArray objectAtIndex:button.tag - 5000];
    CGPoint point = self.groshopTabelView.contentOffset;
    CGRect cellRect = [self.groshopTabelView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 5000 inSection:0]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.groshopTabelView.top;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = view.center;
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    __weak UIImageView * imageV = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:hotelMD.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            imageV.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    CGRect imageFrame = imageView.frame;
    imageView.frame = btFrame;
//    imageView.image = [UIImage imageNamed:@"superMarket.png"];
    [view addSubview:imageView];
    [self.view.window addSubview:view];
    
    [UIView animateWithDuration:1 animations:^{
        imageView.frame = imageFrame;
    }];
    
//    NSLog(@",  %g, %g", cellRect.origin.x, cellRect.origin.y);
}

- (void)removeBigImage
{
    UIView * view = [self.view.window viewWithTag:70000];
    [view removeFromSuperview];
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
