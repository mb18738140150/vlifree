//
//  GSMapViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSMapViewController.h"
#import "PoiAnnotation.h"
@interface GSMapViewController ()< QMapViewDelegate, QMSSearchDelegate>


@property (nonatomic, strong)BMKMapView * mapView;
@property (nonatomic, strong)BMKLocationService * locService;
@property (nonatomic, strong)BMKGeoCodeSearch * geoSearcher;
@property (nonatomic, assign)id annotation;

// 腾讯地图
@property (nonatomic, strong) QMapView * qMapView;
@property (nonatomic, strong) QMSSearcher * mapSearcher;
@property (nonatomic, strong) QMSSuggestionResult * suggestionResult;
@property (nonatomic, strong) QMSGeoCodeSearchResult * geoResult;
@property (nonatomic, strong) QMSReverseGeoCodeSearchResult *reGeoResult;
@property (nonatomic, assign) CLLocationCoordinate2D longPressedCoordinate;
@end

@implementation GSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图";

    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
//    _mapView.delegate = self;
    _mapView.zoomLevel = 18.5;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showMapScaleBar = YES;
//    [_mapView setTrafficEnabled:YES];
    [_mapView setMapType:BMKMapTypeStandard];
    
    CLLocationCoordinate2D coor = (CLLocationCoordinate2D){[self.lat doubleValue], [self.lon doubleValue]};
//    NSLog(@"lat = %@, lon = %@", self.lat, self.lon);
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    annotation.title = self.gsName;
    annotation.subtitle = self.address;
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
    
//    [self.view addSubview:_mapView];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:10.f];
//    
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
    //    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //启动LocationService
    [_locService startUserLocationService];
    
    self.geoSearcher =[[BMKGeoCodeSearch alloc]init];
//    _geoSearcher.delegate = self;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.height - 60, 80, 30);
    button.centerX = self.view.width / 2;
    [button setTitle:@"百度地图" forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    button.hidden = YES;
    [button addTarget:self action:@selector(skipBaiduMap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    //    NSString * mapUrlStr = [NSString stringWithFormat:@"baidumap://map/marker?location=%@,%@&title=%@&content=%@&zoom=19&coord_type=bd09ll&src=微生活", self.lat, self.lon, self.gsName, self.address];
    //    NSString * mapUrlStr = @"baidumap://map/marker?location=40.047669,116.313082&title=我的位置&content=百度奎科大厦&src=yourCompanyName|yourAppName";
//    BOOL isHaveBDMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
//    if (isHaveBDMap) {
//        button.hidden = NO;
//        //        NSLog(@"url = %@", mapUrlStr);
//        //        NSString * newUrlStr = [mapUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        //        BOOL a = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newUrlStr]];
//        //        NSLog(@"a = %d", a);
//    }
    
    // 腾讯地图
    self.qMapView = [[QMapView alloc]initWithFrame:self.view.bounds];
    self.qMapView.delegate = self;
    [self.view addSubview:self.qMapView];
    self.qMapView.showsUserLocation = NO;
    self.qMapView.zoomLevel = 16;
    
    
    self.longPressedCoordinate = (CLLocationCoordinate2D){[self.lat doubleValue], [self.lon doubleValue]};
    [self.qMapView setCenterCoordinate:self.longPressedCoordinate];
    
    self.mapSearcher = [[QMSSearcher alloc]initWithDelegate:self];
    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
    [reGeoSearchOption setLocationWithCenterCoordinate:coor];
    [reGeoSearchOption setGet_poi:YES];
    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
   
    
    // Do any additional setup after loading the view.
}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 腾讯反地理编码
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    self.reGeoResult = reverseGeoCodeSearchResult;
    [self setupAnnotation1];
}
- (void)setupAnnotation1
{
    
    [self.qMapView removeAnnotations:self.qMapView.annotations];
    
    PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:self.reGeoResult];
    [annotation setTitle:self.reGeoResult.address];
    [annotation setCoordinate:self.longPressedCoordinate];
    
    [self.qMapView addAnnotation:annotation];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    //    if ([annotation isKindOfClass:[QAnnotationView class]]) {
    NSLog(@"[annotation class] = %@", [annotation class]);
    static NSString * pointReuseIndetifier = @"pointReuseIndetifier";
    QPinAnnotationView * annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    if (annotationView == nil) {
        annotationView = [[QPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
    }
    
    annotationView.animatesDrop = YES;
    //            annotationView.draggable = YES;
    annotationView.canShowCallout = YES;
    
    //            annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
    
    
}

#pragma mark - 百度地图
/*

- (void)skipBaiduMap:(UIButton *)button
{
     NSString * mapUrlStr = [NSString stringWithFormat:@"baidumap://map/marker?location=%@,%@&title=%@&content=%@&zoom=19&coord_type=bd09ll&src=微生活", self.lat, self.lon, self.gsName, self.address];
    NSString * newUrlStr = [mapUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL a = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newUrlStr]];
    NSLog(@"a = %d", a);
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
        if ([annotation isEqual:_annotation]) {
            newAnnotationView.pinColor = BMKPinAnnotationColorRed;
            NSLog(@"标注view我的位置");
        }else
        {
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
            NSLog(@"标注view商家位置");
        }
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
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
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"地图销毁");
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
