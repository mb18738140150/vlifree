//
//  HomeViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderView.h"
#import "HomeViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailTakeOutViewController.h"
#import "CollectModel.h"
#import "DetailsGrogshopViewController.h"
#import "MGSwipeButton.h"
#import "TakeOutViewController.h"
#import "CollectStroeDB.h"

#define CELL_INDENTIFIER @"cell"

#define BUTTON_HEIGTH 20
#define LOCATION_BUTTON_WIDTH 60
#define LOCATION_LABEL_WIDTH LOCATION_BUTTON_WIDTH - LOCATION_IMAGE_WIDTH
#define LOCATION_IMAGE_WIDTH BUTTON_HEIGTH
#define LOADINGIMAGE_WIDTH 20

@interface HomeViewController ()<CLLocationManagerDelegate, HTTPPostDelegate, UITableViewDataSource, UITableViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    /**
     *  请求数据的页数
     */
    int _page;
    /**
     *  是否已经定位了
     */
    BOOL _isLOC;
}
//@property (nonatomic,  strong)UIAlertView * netalert;

//@property (nonatomic, strong)CLLocationManager * locationManager;
/**
 *  位置文本框
 */
@property (nonatomic, strong)UILabel * locationLB;
/**
 *  数据数组
 */
@property (nonatomic, strong)NSMutableArray * dataArray;
/**
 *  首页列表
 */
@property (nonatomic, strong)UITableView * homeTableView;
/**
 *  百度地图SDK定位对象
 */
@property (nonatomic, strong)BMKLocationService * locService;
/**
 *  百度地图SDK地理编码对象
 */
@property (nonatomic, strong)BMKGeoCodeSearch * geoSearcher;

// 定位加载中动画
@property (nonatomic, strong)UIImageView * loadingImageView;
@property (nonatomic, strong)UIButton * locationBT;

@property (nonatomic, strong)CollectModel * collectModel;

@property (nonatomic, strong)CollectStroeDB * collectDB;

@end

@implementation HomeViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginNOtification) name:@"login" object:nil];
    }
    return self;
}

- (void)didLoginNOtification
{
    UIView * aView = [self.view viewWithTag:10009];
    if ([UserInfo shareUserInfo].userId) {
        self.homeTableView.scrollEnabled = YES;
        //        [self.homeTableView.header beginRefreshing];
        [self downloadDataWithCommand:@1 page:_page count:DATA_COUNT];
        aView.hidden = YES;
    }
    self.homeTableView.scrollEnabled = YES;
//    self.dataArray = nil;
    [self.homeTableView reloadData];
    aView.hidden = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectDB = [[CollectStroeDB alloc]init];
    
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    [self.homeTableView registerClass:[HomeViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    self.homeTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];

    [self.view addSubview:_homeTableView];
    
    HomeHeaderView * homeHeaderView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    [homeHeaderView.grogshopBT addTarget:self action:@selector(grogshopAction:) forControlEvents:UIControlEventTouchUpInside];
    [homeHeaderView.takeOutBT addTarget:self action:@selector(takeOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [homeHeaderView.supermarketBT addTarget:self action:@selector(supermarketAction:) forControlEvents:UIControlEventTouchUpInside];
    self.homeTableView.tableHeaderView = homeHeaderView;
    self.homeTableView.tableFooterView = [[UIView alloc] init];

    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 90)];
    aView.backgroundColor = [UIColor whiteColor];
    aView.tag = 10009;
    aView.centerY = self.view.centerY;
    [self.view addSubview:aView];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, aView.width - 20, 30)];
    aLabel.text = @"你还没有登录,请跳转到登录页面登录";
    aLabel.textColor = TEXT_COLOR;
    aLabel.textAlignment = NSTextAlignmentCenter;
    [aView addSubview:aLabel];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, aLabel.bottom + 10, 80, 30);
    button.centerX = aView.width / 2;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(skipLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = MAIN_COLOR;
    [aView addSubview:button];
    
    self.locationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBT.frame = CGRectMake(10, 10, LOCATION_BUTTON_WIDTH, BUTTON_HEIGTH);
    _locationBT.tag = 1000;
    [_locationBT addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
//    locationBT.backgroundColor = [UIColor greenColor];
//    [self.navigationController.navigationBar addSubview:locationBT];
    self.locationLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LOCATION_LABEL_WIDTH, _locationBT.height)];
    _locationLB.text = @"郑州";
    _locationLB.font = [UIFont systemFontOfSize:13];
    _locationLB.textColor = [UIColor whiteColor];
    _locationLB.textAlignment = NSTextAlignmentRight;
    [_locationBT addSubview:_locationLB];
    
    
    UIImageView * locationIG = [[UIImageView alloc] initWithFrame:CGRectMake(_locationLB.right, 0, LOCATION_IMAGE_WIDTH, _locationLB.height)];
    locationIG.image = [UIImage imageNamed:@"location.png"];
    [_locationBT addSubview:locationIG];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBT];

    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, LOADINGIMAGE_WIDTH, LOADINGIMAGE_WIDTH)];
    self.loadingImageView.image = [UIImage imageNamed:@"icon1.png"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_loadingImageView];
    // 菊花旋转
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 3;
    // RepeatCount默认的是 0,意味着动画只会播放一次
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    // RemovedOnCompletion这个属性默认为 YES,那意味着,在指定的时间段完成后,动画就自动的从层上移除了。这个一般不用
    rotationAnimation.removedOnCompletion = NO;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
    
    _page = 1;
    
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
    [self performSelector:@selector(isLocationsuccess) withObject:nil afterDelay:2];
    /*
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;//设置距离过滤器(每过多次距离更新一次)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        //    [self.locationManager requestAlwaysAuthorization];//始终允许访问位置信息
    }
    [self.locationManager startUpdatingLocation];//开始更新位置信息
     */
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    

    
}


- (void)skipLoginVC:(UIButton *)button
{
    self.navigationController.tabBarController.selectedIndex = 3;
}

- (void)isLocationsuccess
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"本应用需要打开定位才能请求数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
//    if (![UserLocation shareUserLocation].city) {
////        [SVProgressHUD dismiss];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"本应用需要打开定位才能请求数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
//    }
}

- (void)headerRereshing
{
    if ([UserLocation shareUserLocation].city) {
        _page = 1;
        [self downloadDataWithCommand:@1 page:_page count:DATA_COUNT];
    }else
    {
        [self.locService stopUserLocationService];
        [self.locService startUserLocationService];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.locService) {
        self.locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    UIButton * locationBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:1000];
    UIButton * searchBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:2000];
    locationBT.hidden = NO;
    searchBT.hidden = NO;
    if ([UserLocation shareUserLocation].city) {
        [self.loadingImageView removeFromSuperview];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_locationBT];
        self.locationLB.text = [UserLocation shareUserLocation].city;
    }else
    {
        [_locService stopUserLocationService];
        NSLog(@"试图出现时定位");
        [self.locService startUserLocationService];
    }
    UIView * aView = [self.view viewWithTag:10009];
    if ([UserInfo shareUserInfo].userId) {
        self.homeTableView.scrollEnabled = YES;
//        [self.homeTableView.header beginRefreshing];
        [self downloadDataWithCommand:@1 page:_page count:DATA_COUNT];
        aView.hidden = YES;
    }else
    {
        self.homeTableView.scrollEnabled = NO;
        self.dataArray = nil;
        [self.homeTableView reloadData];
        aView.hidden = NO;
    }
//    NSLog(@"--%@, %@", locationBT, searchBT);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.locService = nil;
//    [self.homeTableView headerEndRefreshing];
//    UIButton * locationBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:1000];
//    UIButton * searchBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:2000];
////    NSLog(@"%@, %@", locationBT, searchBT);
//    locationBT.hidden = YES;
//    searchBT.hidden = YES;
}


- (void)grogshopAction:(UIButton *)button
{
    self.navigationController.tabBarController.selectedIndex = 1;
    NSLog(@"酒店");
}

- (void)takeOutAction:(UIButton *)button
{
    self.navigationController.tabBarController.selectedIndex = 2;
    NSLog(@"外卖");
}


- (void)supermarketAction:(UIButton *)button
{
    self.navigationController.tabBarController.selectedIndex = 2;
    UINavigationController * nav = (UINavigationController *)self.navigationController.tabBarController.selectedViewController;
    TakeOutViewController * takeOutVC = (TakeOutViewController *)nav.topViewController;
    takeOutVC.isSupermark = YES;
    [takeOutVC downloadDataWithCommand:@6 page:1 count:COUNT type:3];
    
    NSLog(@"超市");
}


- (void)locationAction:(UIButton *)button
{
    [_locationBT removeFromSuperview];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_loadingImageView];
    
    [_locService stopUserLocationService];
    NSLog(@"点击定位");
    [self.locService startUserLocationService];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    UIView * aView = [self.view viewWithTag:10009];
    if ([UserInfo shareUserInfo].userId) {
        self.homeTableView.scrollEnabled = YES;
        aView.hidden = YES;
        if ([UserLocation shareUserLocation].city) {
            NSDictionary * jsonDic = @{
                                       @"Command":command,
                                       //                               @"CurPage":[NSNumber numberWithInt:page],
                                       //                               @"CurCount":[NSNumber numberWithInt:count],
                                       @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                                       @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                                       @"UserId":[UserInfo shareUserInfo].userId
                                       };
            [self playPostWithDictionary:jsonDic];
        }else
        {
            [self.homeTableView.header performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
        }
    }else
    {
        self.homeTableView.scrollEnabled = NO;
        self.dataArray = nil;
        [self.homeTableView reloadData];
        aView.hidden = NO;
    }

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
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10001]) {
            NSArray * array = [data objectForKey:@"BusinessList"];
            if(_page == 1)
            {
                _dataArray = nil;
            }
            for (NSDictionary * dic in array) {
                CollectModel * collectMD = [[CollectModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:collectMD];
            }
            [self.homeTableView reloadData];
        }else if([[data objectForKey:@"Command"] isEqualToNumber:@10029])
        {
            CollectStoreModel * collectMD = [[CollectStoreModel alloc]init];
            collectMD.businessName = self.collectModel.businessName;
            collectMD.businessId = self.collectModel.businessId.intValue;
            collectMD.businessType = self.collectModel.businessType.intValue;
            if ([self.collectDB deletemodel:collectMD]) {
                NSLog(@"删除数据成功");
            }else
            {
                NSLog(@"删除数据失败");
            }

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
            [self downloadDataWithCommand:@1 page:_page count:COUNT];
        }
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
    [self.homeTableView.header endRefreshing];
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [self.homeTableView.header endRefreshing];
    NSLog(@"%@", error);
}



#pragma mark - 定位

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"title = %@, subtitle = %@", userLocation.title, userLocation.subtitle);
    if (userLocation.location != nil) {
        [UserLocation shareUserLocation].userLocation = userLocation.location.coordinate;
        if (!_isLOC) {
            [self downloadDataWithCommand:@1 page:_page count:DATA_COUNT];
            _isLOC = YES;
        }
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
        [self.locService stopUserLocationService];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败 error = %@", error);
    [self.locService stopUserLocationService];
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
        self.locationLB.text = result.addressDetail.city;
        [self downloadDataWithCommand:@1 page:_page count:DATA_COUNT];
        
        [self.loadingImageView removeFromSuperview];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_locationBT];
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectModel * collectMD = [self.dataArray objectAtIndex:indexPath.row];
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    [cell createSubview:tableView.bounds];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.collectModel = collectMD;
    [cell.IconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.IconButton.tag = 5000 + indexPath.row;
    __weak HomeViewController * homeVC = self;
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"取消收藏" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        if ([UserInfo shareUserInfo].userId) {
            self.collectModel = collectMD;
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@29,
                                       @"Flag":collectMD.businessType,
                                       @"Id":collectMD.businessId
                                       };
            [homeVC playPostWithDictionary:jsonDic];
        }
        return YES;
    }]];
//    cell.textLabel.text = @"23";
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeViewCell cellHeigth];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"经常光顾";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    label.textColor = TEXT_COLOR;
    label.text = @"  经常光顾";
    label.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectModel * collectMD = [self.dataArray objectAtIndex:indexPath.row];
    if ([collectMD.businessType isEqualToNumber:@2]) {
        DetailTakeOutViewController * detaiTOVC = [[DetailTakeOutViewController alloc] init];
        detaiTOVC.takeOutID = collectMD.businessId;
        detaiTOVC.sendPrice = collectMD.sendPrice;
        detaiTOVC.storeState = collectMD.storeState;
        detaiTOVC.hidesBottomBarWhenPushed = YES;
        detaiTOVC.navigationItem.title = collectMD.businessName;
        [self.navigationController pushViewController:detaiTOVC animated:YES];
    }else
    {
        DetailsGrogshopViewController * detailsGSVC = [[DetailsGrogshopViewController alloc] init];
        detailsGSVC.hidesBottomBarWhenPushed = YES;
        detailsGSVC.hotelID = collectMD.businessId;
        detailsGSVC.lat = collectMD.businessLat;
        detailsGSVC.lon = collectMD.businessLon;
        detailsGSVC.icon = collectMD.icon;
        detailsGSVC.navigationItem.title = collectMD.businessName;
        [self.navigationController pushViewController:detailsGSVC animated:YES];
    }
    
}

#pragma mark - 点击图片放大
- (void)lookBigImage:(UIButton *)button
{
    CollectModel * collectMD = [self.dataArray objectAtIndex:button.tag - 5000];
    CGPoint point = self.homeTableView.contentOffset;
    CGRect cellRect = [self.homeTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 5000 inSection:0]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 100, self.view.width - 100)];
    imageView.center = view.center;
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    __weak UIImageView * imageV = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:collectMD.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
