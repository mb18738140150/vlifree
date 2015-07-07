//
//  GSMapViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/5.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSMapViewController.h"

@interface GSMapViewController ()<MAMapViewDelegate>


@property (nonatomic, strong)MAMapView * mapView;


@end

@implementation GSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MAMapServices sharedServices].apiKey = @"bdb563c4b3d8dae3a9ba228ab0c1f41c";
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    [_mapView setZoomLevel:17.f];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.lat doubleValue];
    coor.longitude = [self.lon doubleValue];
    NSLog(@"%f, %f", coor.latitude, coor.longitude);
    MAPointAnnotation * annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coor;
    annotation.title = self.gsName;
    annotation.subtitle = self.address;
    [_mapView addAnnotation:annotation];
    [_mapView setCenterCoordinate:coor animated:YES];
    self.view = _mapView;
    
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



-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        MAPointAnnotation * annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = userLocation.location.coordinate;
        NSLog(@"address = %@, %@", annotation.title, annotation.subtitle);
        NSLog(@"address22 = %@, %@", userLocation.title, userLocation.subtitle);
        [_mapView addAnnotation:annotation];
        _mapView.showsUserLocation = NO;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
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
