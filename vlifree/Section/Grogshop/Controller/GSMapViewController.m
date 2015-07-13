//
//  GSMapViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSMapViewController.h"

@interface GSMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>


@property (nonatomic, strong)BMKMapView * mapView;
@property (nonatomic, strong)BMKLocationService * locService;
@property (nonatomic, strong)BMKGeoCodeSearch * geoSearcher;
@property (nonatomic, assign)id annotation;

@end

@implementation GSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.zoomLevel = 18.5;
//    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showMapScaleBar = YES;
    [_mapView setTrafficEnabled:YES];
    [_mapView setMapType:BMKMapTypeStandard];
    
    CLLocationCoordinate2D coor = (CLLocationCoordinate2D){[self.lat doubleValue], [self.lon doubleValue]};
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    annotation.title = self.gsName;
    annotation.subtitle = self.address;
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
    
    [self.view addSubview:_mapView];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:10.f];
//    
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //启动LocationService
    [_locService startUserLocationService];
    
    self.geoSearcher =[[BMKGeoCodeSearch alloc]init];
    _geoSearcher.delegate = self;
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_r.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
   
    
    // Do any additional setup after loading the view.
}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location != nil) {
        [_mapView removeAnnotation:_annotation];
//        _mapView.showsUserLocation = YES;//显示定位图层
        [_mapView updateLocationData:userLocation];
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        annotation.title = userLocation.title;
        _annotation = annotation;
        [_mapView addAnnotation:annotation];
//        [_mapView setCenterCoordinate:annotation.coordinate];
        //    NSLog(@"title = %@, subtitle = %@", userLocation.title, userLocation.subtitle);
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
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        NSLog(@"标注view");
        return newAnnotationView;
    }
    return nil;
}



- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"处理结果1");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //        result.addressDetail.district
        NSLog(@"处理结果2 %@, %@, %@ %@", result.address, result.addressDetail.streetName, result.addressDetail.streetNumber, result.addressDetail.district);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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
