//
//  TakeOutViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TakeOutViewController.h"
#import "TakeOutViewCell.h"
#import "TypeView.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailTakeOutViewController.h"
#import "CycleScrollView.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "TakeOutModel.h"
#import "SearchViewController.h"

#define CELL_INDENTIFIER @"cell"

#define CYCLESCROLLVIEW_HEIGHT 150

@interface TakeOutViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, HTTPPostDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

{
    int _page;
    BOOL _isLoc;
    int _type;
}

@property (nonatomic, strong)UITableView * takeOutTabelView;
@property (nonatomic, strong)TypeView * typeView;
//@property (nonatomic, strong)CLLocationManager * locationManager;
@property (nonatomic, strong)BMKLocationService * locService;
@property (nonatomic, strong)BMKGeoCodeSearch * geoSearcher;

@property (nonatomic, strong)UIButton * addressBT;
@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UIImageView * addressIM;

//@property (nonatomic, strong)CycleScrollView * cycleScrollView;//轮播图

@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSNumber * allCount;
@property (nonatomic, strong)NSTimer * timer;

@end

@implementation TakeOutViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
//    [self.takeOutTabelView headerEndRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTakeOut:)];

    self.addressBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    _addressBT.frame = CGRectMake(0, 5, 200, 30);
//    _addressBT.backgroundColor = [UIColor greenColor];
    [_addressBT addTarget:self action:@selector(startLocation:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _addressBT;
    
    self.addressIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _addressIM.image = [UIImage imageNamed:@"location.png"];
    [_addressBT addSubview:_addressIM];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(_addressIM.right, 0, 0, 30)];
    _addressLB.textColor = [UIColor whiteColor];
    _addressLB.font = [UIFont systemFontOfSize:15];
    [_addressBT addSubview:_addressLB];
    NSLog(@"11%@",     _addressLB.font.fontName);
    self.addressBT.frame = CGRectMake(0, 0, _addressIM.width, 30);
    
    [self showLocationAddress];
    
    UIButton * typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 40);
    typeButton.tag = 2000;
    [typeButton setTitle:@"外卖分类" forState:UIControlStateNormal];
    [typeButton setTitle:@"外卖分类" forState:UIControlStateSelected];
    [typeButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [typeButton setTitleColor:TEXT_COLOR forState:UIControlStateSelected];
    [typeButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    [typeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateSelected];
    typeButton.imageView.contentMode = UIViewContentModeTopLeft;
    typeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    typeButton.imageEdgeInsets = UIEdgeInsetsMake(15, typeButton.titleLabel.right, 15, 15);
    [typeButton addTarget:self action:@selector(changeTakeOutType:) forControlEvents:UIControlEventTouchUpInside];
    typeButton.layer.borderWidth = 1;
    typeButton.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
//    typeButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:typeButton];
    
    self.takeOutTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, typeButton.bottom, self.view.width, self.view.height - typeButton.bottom - self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    _takeOutTabelView.dataSource = self;
    _takeOutTabelView.delegate = self;
    [self.view addSubview:_takeOutTabelView];
    
    [self.takeOutTabelView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.takeOutTabelView addFooterWithTarget:self action:@selector(footerRereshing)];
    
//    [self.takeOutTabelView registerClass:[TakeOutViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    /*
    NSMutableArray * iary = [@[@"1-1.jpg", @"1-2.jpg", @"1-3.jpg", @"1-4.jpg"] mutableCopy];
    self.cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, CYCLESCROLLVIEW_HEIGHT) array:nil animationDuration:3];
    //    _cycleScrollView.backgroundColor = [UIColor greenColor];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
//    _takeOutTabelView.tableHeaderView = _cycleScrollView;
    NSMutableArray * imageViewAry = [NSMutableArray array];
    for (int i = 0; i < iary.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _cycleScrollView.width, 150)];
        imageView.image = [UIImage imageNamed:[iary objectAtIndex:i]];
        [imageViewAry addObject:imageView];
    }
    
    _cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return imageViewAry[pageIndex];
    };
    _cycleScrollView.totalPagesCount = ^NSInteger(void){
        return imageViewAry.count;
    };
    */
    
    [self createTypeView];
    
    
    _page = 1;
    _isLoc = NO;
    _type = 0;
    if ([UserLocation shareUserLocation].city) {
        if (!_isSupermark) {
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:0];
//            [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        }
        _isLoc = YES;
    }else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downloadData) userInfo:nil repeats:YES];
        [_timer fire];
    }
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
    
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //启动LocationService
    [_locService startUserLocationService];
    self.geoSearcher =[[BMKGeoCodeSearch alloc]init];
    _geoSearcher.delegate = self;
    /*
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;//设置距离过滤器(每过多次距离更新一次)
    //    [self.locationManager requestAlwaysAuthorization];//始终允许访问位置信息
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];//开始更新位置信息
    */
    // Do any additional setup after loading the view.
}


- (void)showLocationAddress
{
    NSMutableString * addressStr = [NSMutableString string];
    if ([UserLocation shareUserLocation].district.length) {
        [addressStr appendString:[UserLocation shareUserLocation].district];
    }
    if ([UserLocation shareUserLocation].streetName.length) {
        [addressStr appendString:[UserLocation shareUserLocation].streetName];
    }
    if ([UserLocation shareUserLocation].streetNumber.length) {
        [addressStr appendString:[UserLocation shareUserLocation].streetNumber];
    }
    self.addressLB.text = [addressStr copy];
    CGSize size = [self.addressLB.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    _addressLB.frame = CGRectMake(_addressLB.left, _addressLB.top, size.width, 30);
    _addressBT.frame = CGRectMake(_addressBT.left, _addressBT.top, _addressIM.width + _addressLB.width, _addressBT.height);
}

- (void)downloadData
{
    NSLog(@"2222");
    if ([UserLocation shareUserLocation].city != nil) {
        [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:0];
//        [self.takeOutTabelView headerBeginRefreshing];
        [self.timer invalidate];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.takeOutTabelView headerEndRefreshing];
}


- (void)searchTakeOut:(id)sender
{
    NSLog(@"搜索");
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)startLocation:(UIButton *)button
{
    [_locService stopUserLocationService];
    NSLog(@"11");
    [_locService startUserLocationService];
//    [self.locationManager startUpdatingLocation];
}

- (void)createTypeView
{
    UIButton * button = (UIButton *)[self.view viewWithTag:2000];
    self.typeView = [[TypeView alloc] initWithFrame:CGRectMake(0, button.bottom, self.view.width, self.view.height - button.bottom)];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTypeView)];
    [_typeView addGestureRecognizer:tapGesture];
    for (int i = 0; i < 8; i++) {
        UIButton * button = (UIButton *)[self.typeView viewWithTag:9000 + i];
        [button addTarget:self action:@selector(selectTakeOutType:) forControlEvents:UIControlEventTouchUpInside];
    }
    _typeView.hidden = YES;
    [self.view addSubview:_typeView];
}


- (void)changeTakeOutType:(UIButton *)button
{
//    NSLog(@"3333");
//    button.selected = !button.selected;
//    self.typeView.hidden = !button.selected;
    [self hiddenTypeView];
}

- (void)hiddenTypeView
{
    UIButton * button = (UIButton *)[self.view viewWithTag:2000];
    button.selected = !button.selected;
    self.typeView.hidden = !button.selected;
}

- (void)selectTakeOutType:(UIButton *)button
{
    switch (button.tag) {
        case 9000:
        {
            NSLog(@"零食");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:1];
            _type = 1;
        }
            break;
        case 9001:
        {
            NSLog(@"快餐");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:2];
            _type = 2;
        }
            break;
        case 9002:
        {
            NSLog(@"超市");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:3];
            _type = 3;
        }
            break;
        case 9003:
        {
            NSLog(@"蛋糕");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:4];
            _type = 4;
        }
            break;
        case 9004:
        {
            NSLog(@"奶茶");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:5];
            _type = 5;

        }
            break;
        case 9005:
        {
            NSLog(@"水果");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:6];
            _type = 6;

        }
            break;
        case 9006:
        {
            NSLog(@"甜品");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:7];
            _type = 7;

        }
            break;
        case 9007:
        {
            NSLog(@"面食");
            [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:8];
            _type = 8;
        }
            break;
            
        default:
            break;
    }
    _page = 1;
    self.typeView.hidden = YES;
    UIButton * typeBT = (UIButton *)[self.view viewWithTag:2000];
    typeBT.selected = NO;
//    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
//    [self.takeOutTabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - 数据刷新,加载更多

- (void)headerRereshing
{
    [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type];
    _page = 1;
}

- (void)footerRereshing
{
    NSInteger count = 0;
    for (NSMutableArray * array in self.dataArray) {
        count += array.count;
    }
    if (count < [_allCount integerValue]) {
        self.takeOutTabelView.footerRefreshingText = @"正在加载数据";
        [self downloadDataWithCommand:@6 page:++_page count:DATA_COUNT type:_type];
    }else
    {
        self.takeOutTabelView.footerRefreshingText = @"数据已经加载完";
        [self.takeOutTabelView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1.5];
    }
    
}



#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count type:(int)type
{
    _type = type;
    NSDictionary * jsonDic = @{
                               @"Command":command,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count],
                               @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                               @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                               @"City":[UserLocation shareUserLocation].city,
                               @"WakeoutType":[NSNumber numberWithInt:type]
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
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10006]) {
            self.allCount = [data objectForKey:@"AllCount"];
            NSArray * array = [data objectForKey:@"StoreList"];
            if(_page == 1)
            {
                _dataArray = nil;
            }
            NSMutableArray * sendArray = [NSMutableArray array];
            NSMutableArray * noSendAry = [NSMutableArray array];
            for (NSDictionary * dic in array) {
                TakeOutModel * takeOutMD = [[TakeOutModel alloc] initWithDictionary:dic];
                if ([takeOutMD.peyType isEqualToNumber:@YES]) {
                    [sendArray addObject:takeOutMD];
                }else
                {
                    [noSendAry addObject:takeOutMD];
                }
//                [self.dataArray addObject:takeOutMD];
            }
            if (sendArray.count > 0) {
                [self.dataArray addObject:sendArray];
            }
            if (noSendAry.count > 0) {
                [self.dataArray addObject:noSendAry];
            }
            [self.takeOutTabelView reloadData];
        }else if([[data objectForKey:@"Command"] isEqualToNumber:@10028])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }
    if (self.takeOutTabelView.isHeaderRefreshing) {
        [self.takeOutTabelView headerEndRefreshing];
    }
    if (self.takeOutTabelView.isFooterRefreshing) {
        [self.takeOutTabelView footerEndRefreshing];
    }
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [self.takeOutTabelView headerEndRefreshing];
    [self.takeOutTabelView footerEndRefreshing];
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}



#pragma mark - 定位

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"title = %@, subtitle = %@", userLocation.title, userLocation.subtitle);
    if (userLocation.location != nil) {
        [UserLocation shareUserLocation].userLocation = userLocation.location.coordinate;
        //发起反向地理编码检索
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [_geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    }
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败 error = %@", error);
    [self.locService startUserLocationService];
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //        result.addressDetail.district
        NSLog(@"处理结果2 %@, %@, %@ %@", result.address, result.addressDetail.streetName, result.addressDetail.streetNumber, result.addressDetail.district);
        [UserLocation shareUserLocation].city = result.addressDetail.city;
        [UserLocation shareUserLocation].streetName = result.addressDetail.streetName;
        [UserLocation shareUserLocation].streetNumber = result.addressDetail.streetNumber;
        [UserLocation shareUserLocation].district = result.addressDetail.district;
        [self showLocationAddress];
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndetifiel = CELL_INDENTIFIER;
    TakeOutModel * takeOutMD = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    TakeOutViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifiel];
    if (!cell) {
        cell = [[TakeOutViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifiel];
    }
    [cell createSubview:tableView.bounds activityCount:takeOutMD.activityArray.count];
    __weak TakeOutViewController * takeOutVC = self;
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"关注商店" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        if ([UserInfo shareUserInfo].userId) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@28,
                                       @"Flag":@2,
                                       @"Id":takeOutMD.storeId
                                       };
            [takeOutVC playPostWithDictionary:jsonDic];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏需要先登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
        return YES;
    }]];
    [cell.IconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.takeOutModel = takeOutMD;
    cell.IconButton.tag = 5000000 + indexPath.row + indexPath.section * 1000;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakeOutModel * takoOutMD = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return [TakeOutViewCell cellHeightWithTakeOutModel:takoOutMD];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray * array = [self.dataArray objectAtIndex:section];
    TakeOutModel * takeOutMD = [array firstObject];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:13];
    if ([takeOutMD.peyType isEqualToNumber:@YES]) {
        label.text = @"在配送范围内";
    }else
    {
        label.text = @"不在配送范围";
    }
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TakeOutModel * takeOutMD = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
    detailTakeOutVC.takeOutID = takeOutMD.storeId;
    detailTakeOutVC.sendPrice = takeOutMD.sendPrice;
    detailTakeOutVC.outSentMoney = takeOutMD.outSentMoney;
    detailTakeOutVC.storeState = takeOutMD.storeState;
    detailTakeOutVC.storeName = takeOutMD.storeName;
    detailTakeOutVC.navigationItem.title = takeOutMD.storeName;
    detailTakeOutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailTakeOutVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
    int section = (button.tag - 5000000) / 1000;
    int row = (button.tag - 5000000) % 1000;
    TakeOutModel * takeOutMd = [[self.dataArray objectAtIndex:section] objectAtIndex:row];
    CGPoint point = self.takeOutTabelView.contentOffset;
    CGRect cellRect = [self.takeOutTabelView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.takeOutTabelView.top;
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
    [imageView setImageWithURL:[NSURL URLWithString:takeOutMd.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
