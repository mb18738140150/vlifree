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


#define CELL_INDENTIFIER @"cell"

#define CYCLESCROLLVIEW_HEIGHT 150

@interface TakeOutViewController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MAMapViewDelegate, HTTPPostDelegate>

@property (nonatomic, strong)UITableView * takeOutTabelView;
@property (nonatomic, strong)TypeView * typeView;
@property (nonatomic, strong)CLLocationManager * locationManager;

@property (nonatomic, strong)UIButton * addressBT;
@property (nonatomic, strong)UILabel * addressLB;
@property (nonatomic, strong)UIImageView * addressIM;

@property (nonatomic, strong)CycleScrollView * cycleScrollView;//轮播图
@property (nonatomic, strong)MAMapView * aMapView;



@end

@implementation TakeOutViewController


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
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
    [_addressBT addSubview:_addressLB];
    NSLog(@"11%@",     _addressLB.font.fontName);
    self.addressBT.frame = CGRectMake(0, 0, _addressIM.width, 30);
    
    UIButton * typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 40);
    typeButton.tag = 2000;
    [typeButton setTitle:@"外卖分类" forState:UIControlStateNormal];
    [typeButton setTitle:@"外卖分类" forState:UIControlStateSelected];
    [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
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
    
    self.takeOutTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, typeButton.bottom, self.view.width, self.view.height - typeButton.bottom - self.tabBarController.tabBar.height) style:UITableViewStylePlain];
    _takeOutTabelView.dataSource = self;
    _takeOutTabelView.delegate = self;
    [self.view addSubview:_takeOutTabelView];
    
//    [self.takeOutTabelView registerClass:[TakeOutViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    NSMutableArray * iary = [@[@"1-1.jpg", @"1-2.jpg", @"1-3.jpg", @"1-4.jpg"] mutableCopy];

    self.cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, CYCLESCROLLVIEW_HEIGHT) array:nil animationDuration:3];
    //    _cycleScrollView.backgroundColor = [UIColor greenColor];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _takeOutTabelView.tableHeaderView = _cycleScrollView;
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
    
    
    [self createTypeView];
    
    [MAMapServices sharedServices].apiKey = @"bdb563c4b3d8dae3a9ba228ab0c1f41c";
    
    self.aMapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _aMapView.delegate = self;
    _aMapView.showsUserLocation = YES;
    _aMapView.userTrackingMode = MAUserTrackingModeNone;
    [_aMapView setZoomLevel:16.5 animated:YES];
    
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

- (void)searchTakeOut:(id)sender
{
    NSLog(@"搜索");
}

- (void)startLocation:(UIButton *)button
{
    NSLog(@"11");
    _aMapView.showsUserLocation = YES;
//    [self.locationManager startUpdatingLocation];
}

- (void)createTypeView
{
    UIButton * button = (UIButton *)[self.view viewWithTag:2000];
    self.typeView = [[TypeView alloc] initWithFrame:CGRectMake(0, button.bottom, self.view.width, self.view.height - button.bottom)];
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
    button.selected = !button.selected;
    self.typeView.hidden = !button.selected;
}


- (void)selectTakeOutType:(UIButton *)button
{
    switch (button.tag) {
        case 9000:
        {
            NSLog(@"零食");
        }
            break;
        case 9001:
        {
            NSLog(@"快餐");
        }
            break;
        case 9002:
        {
            NSLog(@"超市");
        }
            break;
        case 9003:
        {
            NSLog(@"蛋糕");
        }
            break;
        case 9004:
        {
            NSLog(@"奶茶");
        }
            break;
        case 9005:
        {
            NSLog(@"水果");
        }
            break;
        case 9006:
        {
            NSLog(@"甜品");
        }
            break;
        case 9007:
        {
            NSLog(@"面食");
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    
    NSDictionary * jsonDic = @{
                               @"Command":command,
                               @"CurPage":[NSNumber numberWithInt:page],
                               @"CurCount":[NSNumber numberWithInt:count],
                               @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].location.coordinate.latitude],
                               @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].location.coordinate.longitude]
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
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
//        self.allCount = [data objectForKey:@"AllCount"];
        NSArray * array = [data objectForKey:@"AllList"];
//        if(_page == 1)
//        {
//            _dataArray = nil;
//        }
        for (NSDictionary * dic in array) {
//            [self.dataArray addObject:hotelMD];
        }
        [self.takeOutTabelView reloadData];
    }
    [self.takeOutTabelView headerEndRefreshing];
    [self.takeOutTabelView footerEndRefreshing];
    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
    [self.takeOutTabelView headerEndRefreshing];
    [self.takeOutTabelView footerEndRefreshing];
    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}



#pragma mark - 定位



-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        [UserLocation shareUserLocation].location = userLocation.location;
        NSLog(@"%f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark * placemark = [placemarks firstObject];
                NSLog(@"%@, %@, %@, %@", placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare);
                [UserLocation shareUserLocation].placemark = placemark;
                NSMutableString * addressStr = [NSMutableString string];
                if (placemark.subLocality.length) {
                    [addressStr appendString:placemark.subLocality];
                }
                if (placemark.thoroughfare.length) {
                    [addressStr appendString:placemark.thoroughfare];
                }
                if (placemark.subThoroughfare.length) {
                    [addressStr appendString:placemark.subThoroughfare];
                }
                self.addressLB.text = [addressStr copy];
                CGSize size = [self.addressLB.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
                _addressLB.frame = CGRectMake(_addressLB.left, _addressLB.top, size.width, 30);
                _addressBT.frame = CGRectMake(_addressBT.left, _addressBT.top, _addressIM.width + _addressLB.width, _addressBT.height);
                mapView.showsUserLocation = NO;
            }
        }];
    }
}


/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = [locations lastObject];
    NSLog(@"%@, ----%@", location, location.description);
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"%@, error = %@", placemarks, error);
        if (placemarks.count) {
            CLPlacemark *placeMark = [placemarks firstObject];
            NSString *locatioName = [NSString stringWithFormat:@"您现在所处的位置为%@",placeMark.name];
            NSLog(@"%@, %@, %@, %@, %@", locatioName, placeMark.thoroughfare, placeMark.administrativeArea, placeMark.subLocality, placeMark.subThoroughfare);
            NSMutableString * addressStr = [NSMutableString string];
            if (placeMark.subLocality.length) {
                [addressStr appendString:placeMark.subLocality];
            }
            if (placeMark.thoroughfare.length) {
                [addressStr appendString:placeMark.thoroughfare];
            }
            if (placeMark.subThoroughfare.length) {
                [addressStr appendString:placeMark.subThoroughfare];
            }
            self.addressLB.text = [addressStr copy];
            CGSize size = [self.addressLB.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
            _addressLB.frame = CGRectMake(_addressLB.left, _addressLB.top, size.width, 30);
            _addressBT.frame = CGRectMake(_addressBT.left, _addressBT.top, _addressIM.width + _addressLB.width, _addressBT.height);
        }
    }];
    [manager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获得位置信息");
    }
}
*/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndetifiel = CELL_INDENTIFIER;
    TakeOutViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifiel];
    if (!cell) {
        cell = [[TakeOutViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifiel];
        [cell createSubview:tableView.bounds];
    }
//    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" backgroundColor:[UIColor redColor]]];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"关注商店" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"111");
        return YES;
    }]];
    [cell.IconButton addTarget:self action:@selector(lookBigImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.IconButton.tag = 5000 + indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TakeOutViewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailTakeOutViewController * detailTakeOutVC = [[DetailTakeOutViewController alloc] init];
    detailTakeOutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailTakeOutVC animated:YES];
}


#pragma mark - 点击图片放大

- (void)lookBigImage:(UIButton *)button
{
    CGPoint point = self.takeOutTabelView.contentOffset;
    CGRect cellRect = [self.takeOutTabelView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 5000 inSection:0]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y + self.takeOutTabelView.top;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = view.center;
    CGRect imageFrame = imageView.frame;
    imageView.frame = btFrame;
    imageView.image = [UIImage imageNamed:@"superMarket.png"];
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
