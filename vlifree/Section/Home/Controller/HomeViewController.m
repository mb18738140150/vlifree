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
#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailTakeOutViewController.h"
#import <MAMapKit/MAMapKit.h>


#define CELL_INDENTIFIER @"cell"

#define BUTTON_HEIGTH 20
#define LOCATION_BUTTON_WIDTH 60
#define LOCATION_LABEL_WIDTH LOCATION_BUTTON_WIDTH - LOCATION_IMAGE_WIDTH
#define LOCATION_IMAGE_WIDTH BUTTON_HEIGTH


@interface HomeViewController ()<CLLocationManagerDelegate, MAMapViewDelegate>


@property (nonatomic, strong)CLLocationManager * locationManager;
@property (nonatomic, strong)UILabel * locationLB;
@property (nonatomic, strong)MAMapView * aMapView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeHeaderView * homeHeaderView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 120)];
    [homeHeaderView.grogshopBT addTarget:self action:@selector(grogshopAction:) forControlEvents:UIControlEventTouchUpInside];
    [homeHeaderView.takeOutBT addTarget:self action:@selector(takeOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [homeHeaderView.supermarketBT addTarget:self action:@selector(supermarketAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = homeHeaderView;
    [self.tableView registerClass:[HomeViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    UIButton * locationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBT.frame = CGRectMake(10, 10, LOCATION_BUTTON_WIDTH, BUTTON_HEIGTH);
    locationBT.tag = 1000;
    [locationBT addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
//    locationBT.backgroundColor = [UIColor greenColor];
    [self.navigationController.navigationBar addSubview:locationBT];
    self.locationLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LOCATION_LABEL_WIDTH, locationBT.height)];
    _locationLB.text = @"郑州";
    _locationLB.font = [UIFont systemFontOfSize:13];
    _locationLB.textColor = [UIColor whiteColor];
    _locationLB.textAlignment = NSTextAlignmentRight;
    [locationBT addSubview:_locationLB];
    
    
    UIImageView * locationIG = [[UIImageView alloc] initWithFrame:CGRectMake(_locationLB.right, 0, LOCATION_IMAGE_WIDTH, _locationLB.height)];
    locationIG.image = [UIImage imageNamed:@"location.png"];
    [locationBT addSubview:locationIG];
    
    [MAMapServices sharedServices].apiKey = @"bdb563c4b3d8dae3a9ba228ab0c1f41c";
    
    self.aMapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _aMapView.delegate = self;
    _aMapView.showsUserLocation = YES;
    _aMapView.userTrackingMode = MAUserTrackingModeNone;
    [_aMapView setZoomLevel:16.5 animated:YES];
    
    /*
    UIButton * searchBT = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBT.frame = CGRectMake(0, (self.navigationController.navigationBar.height - 23) / 2, 100, 23);
    searchBT.tag = 2000;
    searchBT.center = CGPointMake(self.view.centerX, searchBT.centerY);;
    [searchBT setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchBT addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:searchBT];
    */
    /*
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;//设置距离过滤器(每过多次距离更新一次)
//    [self.locationManager requestAlwaysAuthorization];//始终允许访问位置信息
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];//开始更新位置信息
    */
    /*
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, 100, 30)];
    searchBar.center = CGPointMake(self.view.centerX, searchBar.centerY);
    searchBar.placeholder = @"关键字";
    [self.navigationController.navigationBar addSubview:searchBar];
    */
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}





- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    UIButton * locationBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:1000];
    UIButton * searchBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:2000];
    locationBT.hidden = NO;
    searchBT.hidden = NO;
//    NSLog(@"--%@, %@", locationBT, searchBT);
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIButton * locationBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:1000];
    UIButton * searchBT = (UIButton *)[self.navigationController.navigationBar viewWithTag:2000];
//    NSLog(@"%@, %@", locationBT, searchBT);
    locationBT.hidden = YES;
    searchBT.hidden = YES;
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
    NSLog(@"超市");
}


- (void)locationAction:(UIButton *)button
{
    NSLog(@"定位");
    _aMapView.showsUserLocation = YES;
}


- (void)searchAction:(UIButton *)button
{
    NSLog(@"搜索");
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定位


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        [UserLocation shareUserLocation].location = userLocation.location;
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark * placemark = [placemarks firstObject];
                NSLog(@"%@, %@, %@, %@", placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare);
                self.locationLB.text = placemark.locality;
                [UserLocation shareUserLocation].placemark = placemark;
                mapView.showsUserLocation = NO;
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    [cell createSubview:tableView.bounds];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
//    cell.textLabel.text = @"23";
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeViewCell cellHeigth];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"经常光顾";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTakeOutViewController * detaiTOVC = [[DetailTakeOutViewController alloc] init];
    detaiTOVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detaiTOVC animated:YES];
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
