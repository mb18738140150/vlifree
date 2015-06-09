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
#import "CollectModel.h"
#import "DetailsGrogshopViewController.h"

#define CELL_INDENTIFIER @"cell"

#define BUTTON_HEIGTH 20
#define LOCATION_BUTTON_WIDTH 60
#define LOCATION_LABEL_WIDTH LOCATION_BUTTON_WIDTH - LOCATION_IMAGE_WIDTH
#define LOCATION_IMAGE_WIDTH BUTTON_HEIGTH


@interface HomeViewController ()<CLLocationManagerDelegate, MAMapViewDelegate, HTTPPostDelegate>
{
    int _page;
    BOOL _isLOC;
}
@property (nonatomic, strong)CLLocationManager * locationManager;
@property (nonatomic, strong)UILabel * locationLB;
@property (nonatomic, strong)MAMapView * aMapView;
@property (nonatomic, strong)NSMutableArray * dataArray;


@end

@implementation HomeViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


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
    _page = 1;
    _isLOC = NO;
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


#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    
    NSDictionary * jsonDic = @{
                               @"Command":command,
//                               @"CurPage":[NSNumber numberWithInt:page],
//                               @"CurCount":[NSNumber numberWithInt:count],
                               @"Lat":[NSNumber numberWithDouble:[UserLocation shareUserLocation].location.coordinate.latitude],
                               @"Lon":[NSNumber numberWithDouble:[UserLocation shareUserLocation].location.coordinate.longitude],
                               @"UserId":@102
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
        NSArray * array = [data objectForKey:@"BusinessList"];
        if(_page == 1)
        {
            _dataArray = nil;
        }
        for (NSDictionary * dic in array) {
            CollectModel * collectMD = [[CollectModel alloc] initWithDictionary:dic];
            [self.dataArray addObject:collectMD];
        }
        [self.tableView reloadData];
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
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
                if (!_isLOC) {
                    [self downloadDataWithCommand:@1 page:_page count:DATA_COUNT];
                    _isLOC = YES;
                }
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
    CollectModel * collectMD = [self.dataArray objectAtIndex:indexPath.row];
    if ([collectMD.businessType isEqualToNumber:@1]) {
        DetailTakeOutViewController * detaiTOVC = [[DetailTakeOutViewController alloc] init];
        detaiTOVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detaiTOVC animated:YES];
    }else
    {
        DetailsGrogshopViewController * detailsGSVC = [[DetailsGrogshopViewController alloc] init];
        detailsGSVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsGSVC animated:YES];
    }
    
}

#pragma mark - 点击图片放大
- (void)lookBigImage:(UIButton *)button
{
    CollectModel * collectMD = [self.dataArray objectAtIndex:button.tag - 5000];
    CGPoint point = self.tableView.contentOffset;
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag - 5000 inSection:0]];
    CGRect btFrame = button.frame;
    btFrame.origin.y = cellRect.origin.y - point.y + button.frame.origin.y;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 70000;
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 100, self.view.width - 100)];
    imageView.center = view.center;
    [imageView setImageWithURL:[NSURL URLWithString:collectMD.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"]];
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
