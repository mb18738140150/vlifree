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
#import "TakeoutTypeController.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailTakeOutViewController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "TakeOutModel.h"
#import "SearchViewController.h"
#import "CollectStroeDB.h"
#import "PoiAnnotation.h"
//#import "StoreTypeModel.h"
#define CELL_INDENTIFIER @"cell"

#define CYCLESCROLLVIEW_HEIGHT 150
#define LOADINGIMAGE_WIDTH 20
@interface TakeOutViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, HTTPPostDelegate, QMapViewDelegate, QMSSearchDelegate>

{
    /**
     *  数据请求页数
     */
    int _page;
    /**
     *  是否已经定位
     */
    BOOL _isLoc;
    /**
     *  请求类型
     */
    int _type;
}

@property (nonatomic, strong)UITableView * takeOutTabelView;
/**
 *  类型页面
 */
@property (nonatomic, strong)TypeView * typeView;

@property (nonatomic, strong)NSMutableArray * typeArray;
//@property (nonatomic, strong)CLLocationManager * locationManager;
/**
 *  百度地图SDK定位对象
 */
//@property (nonatomic, strong)BMKLocationService * locService;
/**
 *  百度地图SDK地理编码对象
 */
//@property (nonatomic, strong)BMKGeoCodeSearch * geoSearcher;
// 腾讯地图
@property (nonatomic, strong) QMapView * qMapView;
@property (nonatomic, strong) QMSSearcher * mapSearcher;
@property (nonatomic, strong) QMSReverseGeoCodeSearchResult *reGeoResult;

/**
 *  定位按钮
 */
@property (nonatomic, strong)UIButton * addressBT;
/**
 *  位置信息文本框
 */
@property (nonatomic, strong)UILabel * addressLB;
/**
 *  定位图标
 */
@property (nonatomic, strong)UIImageView * addressIM;

//@property (nonatomic, strong)CycleScrollView * cycleScrollView;//轮播图
/**
 *  数据数组
 */
@property (nonatomic, strong)NSMutableArray * dataArray;
/**
 *  数据总个数
 */
@property (nonatomic, strong)NSNumber * allCount;
/**
 *  监控是否定位的timer
 */
@property (nonatomic, strong)NSTimer * timer;
// 定位加载中动画
@property (nonatomic, strong)UIImageView * loadingImageView;

@property (nonatomic, strong)TakeOutModel * collectModel;

@property (nonatomic, strong)CollectStroeDB * collectDB;

@end

@implementation TakeOutViewController

- (NSMutableArray *)typeArray
{
    if (!_typeArray) {
        self.typeArray = [NSMutableArray array];
    }
    return _typeArray;
}
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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self downloadData];
//    [self.takeOutTabelView headerEndRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTakeOut:)];

    self.collectDB = [[CollectStroeDB alloc]init];
    
    self.addressBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    _addressBT.frame = CGRectMake(0, 5, 200, 30);
//    _addressBT.backgroundColor = [UIColor greenColor];
    [_addressBT addTarget:self action:@selector(startLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.addressIM = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    _addressIM.image = [UIImage imageNamed:@"location.png"];
//    [_addressBT addSubview:_addressIM];
    
    self.addressLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    _addressLB.textColor = [UIColor blackColor];
    _addressLB.font = [UIFont systemFontOfSize:15];
    _addressLB.textAlignment = NSTextAlignmentCenter;
    [_addressBT addSubview:_addressLB];
    NSLog(@"11%@",     _addressLB.font.fontName);
    self.addressBT.frame = CGRectMake(0, 0, 60, 30);
    
    
    self.loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LOADINGIMAGE_WIDTH, LOADINGIMAGE_WIDTH)];
    UIImageView * loadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    loadView.image =[UIImage imageNamed:@"icon1.png"];
//    self.loadingImageView.image = [UIImage imageNamed:@"icon1.png"];
    [_loadingImageView addSubview:loadView];
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
    [loadView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
    
    self.navigationItem.titleView = _loadingImageView;
//    [self showLocationAddress];
    
//    UIButton * typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    typeButton.frame = CGRectMake(0, 0, self.view.width, 40);
////    typeButton.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 40);
//    typeButton.tag = 2000;
//    [typeButton setTitle:@"外卖分类" forState:UIControlStateNormal];
//    [typeButton setTitle:@"外卖分类" forState:UIControlStateSelected];
//    [typeButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
//    [typeButton setTitleColor:TEXT_COLOR forState:UIControlStateSelected];
//    [typeButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
//    [typeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateSelected];
//    typeButton.imageView.contentMode = UIViewContentModeTopLeft;
//    typeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    typeButton.imageEdgeInsets = UIEdgeInsetsMake(15, typeButton.titleLabel.right, 15, 15);
//    [typeButton addTarget:self action:@selector(changeTakeOutType:) forControlEvents:UIControlEventTouchUpInside];
//    typeButton.layer.borderWidth = 1;
//    typeButton.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
//    typeButton.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:typeButton];
    
    self.takeOutTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
//    self.takeOutTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, typeButton.bottom, self.view.width, self.view.height - typeButton.bottom - self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
    _takeOutTabelView.dataSource = self;
    _takeOutTabelView.delegate = self;
    [self.view addSubview:_takeOutTabelView];
    self.takeOutTabelView.tableFooterView = [[UIView alloc] init];
    self.takeOutTabelView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.takeOutTabelView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//    [self.takeOutTabelView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.takeOutTabelView addFooterWithTarget:self action:@selector(footerRereshing)];
    
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
            [self.takeOutTabelView.header beginRefreshing];
//            [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        }
        _isLoc = YES;
    }
//    else
//    {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downloadData) userInfo:nil repeats:YES];
//        [_timer fire];
//    }
    
    
    self.qMapView = [[QMapView alloc]init];
    self.qMapView.delegate = self;
    self.qMapView.showsUserLocation = YES;
    
    self.mapSearcher = [[QMSSearcher alloc]initWithDelegate:self];
    
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

#pragma mark - 腾讯地图定位
- (void)startLocation:(UIButton *)button
{
    [_addressBT removeFromSuperview];
    self.navigationItem.titleView = _loadingImageView;
    self.qMapView.showsUserLocation = YES;
}
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
//    NSLog(@"刷新位置");
    
    PoiAnnotation *annotation = [[PoiAnnotation alloc] init];
    [annotation setCoordinate:userLocation.coordinate];
    [annotation setTitle:[NSString stringWithFormat:@"%@", userLocation.title]];
    
    [annotation setSubtitle:[NSString stringWithFormat:@"lat:%f, lng:%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude]];
    
    [UserLocation shareUserLocation].userLocation = userLocation.coordinate;
//    NSLog(@"****%f***%f", [UserLocation shareUserLocation].userLocation.latitude, [UserLocation shareUserLocation].userLocation.longitude);
    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
    [reGeoSearchOption setLocationWithCenterCoordinate:userLocation.coordinate];
    [reGeoSearchOption setGet_poi:YES];
    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
    
}
- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，定位失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 腾讯反地理编码
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    self.reGeoResult = reverseGeoCodeSearchResult;
    if (self.reGeoResult.address.length != 0) {
        
//        NSLog(@"******%@",self.reGeoResult.address);
        [UserLocation shareUserLocation].city = self.reGeoResult.ad_info.city;
        self.qMapView.showsUserLocation = NO;
        [_loadingImageView removeFromSuperview];
        self.navigationItem.titleView = _addressBT;
        _addressLB.text = self.reGeoResult.address;
        CGSize size = [self.addressLB.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
        _addressLB.frame = CGRectMake(0 , _addressLB.top, size.width, 30);
        _addressBT.frame = CGRectMake(self.view.width / 2 - size.width / 2, _addressBT.top,  size.width, _addressBT.height);
        [self downloadData];
    }
}

- (void)downloadData
{
//    NSLog(@"2222");
    if ([UserLocation shareUserLocation].city != nil) {
//        [self downloadDataWithCommand:@6 page:_page count:DATA_COUNT type:0];
        [self.takeOutTabelView.header beginRefreshing];
//        [self.timer invalidate];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.takeOutTabelView headerEndRefreshing];
}

#pragma mark - 搜索
- (void)searchTakeOut:(id)sender
{
//    NSLog(@"搜索");
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 外卖分类选择

- (void)createTypeView
{

        self.typeView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width / 2 + 10)];
    for (int i = 0; i < 8; i++) {
        UIButton * button = (UIButton *)[self.typeView viewWithTag:9000 + i];
        [button addTarget:self action:@selector(selectTakeOutType:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.takeOutTabelView.tableHeaderView  = _typeView;
}


//- (void)changeTakeOutType:(UIButton *)button
//{
////    NSLog(@"3333");
////    button.selected = !button.selected;
////    self.typeView.hidden = !button.selected;
//    [self hiddenTypeView];
//}

//- (void)hiddenTypeView
//{
//    UIButton * button = (UIButton *)[self.view viewWithTag:2000];
//    button.selected = !button.selected;
//    self.typeView.hidden = !button.selected;
//}

- (void)selectTakeOutType:(UIButton *)button
{
    TakeoutTypeController * takeoutTyprVC = [[TakeoutTypeController alloc]init];
    switch (button.tag) {
        case 9000:
        {
            takeoutTyprVC.takeoutType = @"美食";
            takeoutTyprVC.type = 1;
        }
            break;
        case 9001:
        {
            takeoutTyprVC.takeoutType = @"甜品饮食";
            takeoutTyprVC.type = 2;
        }
            break;
        case 9002:
        {
            takeoutTyprVC.takeoutType = @"水果";
            takeoutTyprVC.type = 3;
        }
            break;
        case 9003:
        {
            takeoutTyprVC.takeoutType = @"超市";
            takeoutTyprVC.type = 4;
        }
            break;
        case 9004:
        {
            takeoutTyprVC.takeoutType = @"零食小吃";
            takeoutTyprVC.type = 5;

        }
            break;
        case 9005:
        {
            takeoutTyprVC.takeoutType = @"鲜花蛋糕";
            takeoutTyprVC.type = 6;

        }
            break;
        case 9006:
        {
            NSLog(@"甜品");
            takeoutTyprVC.takeoutType = @"送药上门";
            takeoutTyprVC.type = 7;

        }
            break;
        case 9007:
        {
            takeoutTyprVC.takeoutType = @"蔬菜";
            takeoutTyprVC.type = 8;
        }
            break;
            
        default:
            break;
    }
    _page = 1;
    takeoutTyprVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:takeoutTyprVC animated:YES];
    
//    self.typeView.hidden = YES;
//    UIButton * typeBT = (UIButton *)[self.view viewWithTag:2000];
//    typeBT.selected = NO;
//    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
//    [self.takeOutTabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - 数据刷新,加载更多

- (void)headerRereshing
{
    [self.takeOutTabelView.footer resetNoMoreData];
    _page = 1;
    [self downloadDataWithCommand:@6 page:1 count:DATA_COUNT type:_type];
}

- (void)footerRereshing
{
//    NSInteger count = 0;
//    for (NSMutableArray * array in self.dataArray) {
//        count += array.count;
//    }
//    if (count < [_allCount integerValue]) {
////        self.takeOutTabelView.footerRefreshingText = @"正在加载数据";
//        [self.takeOutTabelView.footer resetNoMoreData];
        [self downloadDataWithCommand:@6 page:++_page count:DATA_COUNT type:_type];
//    }else
//    {
////        self.takeOutTabelView.footerRefreshingText = @"数据已经加载完";
//        [self.takeOutTabelView.footer noticeNoMoreData];
//        [self.takeOutTabelView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:1.5];
//    }
    
}



#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count type:(int)type
{
    if ([UserLocation shareUserLocation].city) {
        _type = 0;
        NSDictionary * jsonDic = @{
                                   @"Command":command,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.latitude],
                                   @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].userLocation.longitude],
                                   @"City":[UserLocation shareUserLocation].city,
                                   @"WakeoutType":[NSNumber numberWithInt:0],
                                   @"SortType":@0,
                                   @"Favourableactivity":@0
                                   };
        [self playPostWithDictionary:jsonDic];
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
    [self.takeOutTabelView.header endRefreshing];
    [self.takeOutTabelView.footer endRefreshing];
//    NSLog(@"+++%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10006]) {
            self.allCount = [data objectForKey:@"AllCount"];
            
            
            NSArray * array = [data objectForKey:@"StoreList"];
            if(_page == 1)
            {
                if (self.dataArray.count != 0) {
                    [self.dataArray removeAllObjects];
                }
            }
            NSInteger count = 0;
            for (NSDictionary * dic in array) {
                TakeOutModel * takeOutMD = [[TakeOutModel alloc] initWithDictionary:dic];
                if ([takeOutMD.peyType isEqualToNumber:@YES]) {
                    [self.dataArray addObject:takeOutMD];
                }
                count++;
            }

            [self.takeOutTabelView reloadData];
            if (count > 0) {
                [self.takeOutTabelView.footer resetNoMoreData];
            }else
            {
                [self.takeOutTabelView.footer noticeNoMoreData];
            }
            
            
        }else if([[data objectForKey:@"Command"] isEqualToNumber:@10028])
        {
            CollectStoreModel * collectMD = [[CollectStoreModel alloc]init];
            collectMD.businessName = self.collectModel.storeName;
            collectMD.businessId = self.collectModel.storeId.intValue;
            collectMD.businessType = 2;
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
        }
    }else
    {
        if (((NSString *)[data objectForKey:@"ErrorMsg"]).length == 0) {
            ;
        }else
        {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
        }
    }
}

- (void)failWithError:(NSError *)error
{
    [self.takeOutTabelView.header endRefreshing];
    [self.takeOutTabelView.footer endRefreshing];
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndetifiel = CELL_INDENTIFIER;
    TakeOutModel * takeOutMD = [self.dataArray objectAtIndex:indexPath.row];
    TakeOutViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifiel];
    if (!cell) {
        cell = [[TakeOutViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifiel];
    }
    [cell createSubview:tableView.bounds activityCount:(int)takeOutMD.activityArray.count];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    __weak TakeOutViewController * takeOutVC = self;
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"关注商店" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        if ([UserInfo shareUserInfo].userId) {
            self.collectModel = takeOutMD;
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
    TakeOutModel * takoOutMD = [self.dataArray objectAtIndex:indexPath.row];
    return [TakeOutViewCell cellHeightWithTakeOutModel:takoOutMD];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else
    {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 1, 15)];
    lineView.backgroundColor = BACKGROUNDCOLOR;
    [headView addSubview:lineView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right, 12, tableView.width - 20 - 1, 15)];
    label.textColor = TEXT_COLOR;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @" 附近的美食";
    label.backgroundColor = [UIColor whiteColor];
    [headView addSubview:label];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.bottom - 0.3, headView.width, .3)];
    bottomView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    [headView addSubview:bottomView];
    
        return headView;
   
    
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSMutableArray * array = [self.dataArray objectAtIndex:section];
//    TakeOutModel * takeOutMD = [array firstObject];
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
//    label.backgroundColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor redColor];
//    label.font = [UIFont systemFontOfSize:13];
//    if ([takeOutMD.peyType isEqualToNumber:@YES]) {
//        label.text = @"在配送范围内";
//    }else
//    {
//        label.text = @"不在配送范围";
//    }
//    return label;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TakeOutModel * takeOutMD = [self.dataArray objectAtIndex:indexPath.row];
    DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
    detailTakeOutVC.takeOutID = takeOutMD.storeId;
    detailTakeOutVC.sendPrice = takeOutMD.sendPrice;
    detailTakeOutVC.outSentMoney = takeOutMD.outSentMoney;
    detailTakeOutVC.storeState = takeOutMD.storeState;
    detailTakeOutVC.storeName = takeOutMD.storeName;
    detailTakeOutVC.iConimageURL = takeOutMD.icon;
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
    NSInteger section = (button.tag - 5000000) / 1000;
    NSInteger row = (button.tag - 5000000) % 1000;
    TakeOutModel * takeOutMd = [[self.dataArray objectAtIndex:section] objectAtIndex:row];
    CGPoint point = self.takeOutTabelView.contentOffset;
    CGRect cellRect = [self.takeOutTabelView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y ;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = view.center;
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    
    imageView.image = [UIImage imageNamed:@"superMarket.png"];
    __weak UIImageView * imageV = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:takeOutMd.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            imageV.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    CGRect imageFrame = imageView.frame;
    imageView.frame = btFrame;
    
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
