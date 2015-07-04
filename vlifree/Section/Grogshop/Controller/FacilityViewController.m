//
//  FacilityViewController.m
//  vlifree
//
//  Created by 仙林 on 15/7/4.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "FacilityViewController.h"


#define IMAGE_SIZE 40
#define LABEL_HEIGHT 20

#define LEFT_SPACE (self.view.width - 4 * IMAGE_SIZE) / 5
#define TOP_SPACE 20
#define TEXT_FONT [UIFont systemFontOfSize:10]

#define OFF_TEXT_COLOR [UIColor colorWithWhite:0.7 alpha:1]

@interface FacilityViewController ()

@end

@implementation FacilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
    
    UILabel * facilityLB = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, 40)];
    facilityLB.text = @"基础设施";
    facilityLB.textAlignment = NSTextAlignmentCenter;
    facilityLB.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:facilityLB];
    

    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, facilityLB.bottom, self.view.width, 140)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    

    UIImageView * broadBandIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:broadBandIMV];
    UILabel * broadBandLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, broadBandIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    broadBandLB.text = @"有线上网";
    broadBandLB.font = TEXT_FONT;
    broadBandLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:broadBandLB];
    if ([[self.detailsDic objectForKey:@"BroadBand"] isEqualToNumber:@YES]) {
        broadBandIMV.image = [UIImage imageNamed:@"broadband_on.png"];
        broadBandLB.textColor = TEXT_COLOR;
    }else
    {
        broadBandIMV.image = [UIImage imageNamed:@"broadband_off.png"];
        broadBandLB.textColor = OFF_TEXT_COLOR;
    }
    
    UIImageView * wifiIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE + broadBandIMV.right, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:wifiIMV];
    UILabel * wifiLB = [[UILabel alloc] initWithFrame:CGRectMake(wifiIMV.left, wifiIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    wifiLB.text = @"无线上网";
    wifiLB.font = TEXT_FONT;
    wifiLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:wifiLB];
    if ([[self.detailsDic objectForKey:@"WifiState"] isEqualToNumber:@YES]) {
        wifiIMV.image = [UIImage imageNamed:@"wifis_on.png"];
        wifiLB.textColor = TEXT_COLOR;
    }else
    {
        wifiIMV.image = [UIImage imageNamed:@"wifis_off.png"];
        wifiLB.textColor = OFF_TEXT_COLOR;
    }
    
    
    UIImageView * fitnessIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE + wifiIMV.right, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:fitnessIMV];
    UILabel * fitnessLB = [[UILabel alloc] initWithFrame:CGRectMake(fitnessIMV.left, fitnessIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    fitnessLB.text = @"健身房";
    fitnessLB.font = TEXT_FONT;
    fitnessLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:fitnessLB];
    if ([[self.detailsDic objectForKey:@"FitnessRoom"] isEqualToNumber:@YES]) {
        fitnessIMV.image = [UIImage imageNamed:@"fitness_on.png"];
        fitnessLB.textColor = TEXT_COLOR;
    }else
    {
        fitnessIMV.image = [UIImage imageNamed:@"fitness_off.png"];
        fitnessLB.textColor = OFF_TEXT_COLOR;
    }
    
    
    UIImageView * swimmingIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE + fitnessIMV.right, TOP_SPACE, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:swimmingIMV];
    UILabel * swimmingLB = [[UILabel alloc] initWithFrame:CGRectMake(swimmingIMV.left, swimmingIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    swimmingLB.text = @"游泳池";
    swimmingLB.font = TEXT_FONT;
    swimmingLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:swimmingLB];
    if ([[self.detailsDic objectForKey:@"SwimmingPool"] isEqualToNumber:@YES]) {
        swimmingIMV.image = [UIImage imageNamed:@"swimming_on.png"];
        swimmingLB.textColor = TEXT_COLOR;
    }else
    {
        swimmingIMV.image = [UIImage imageNamed:@"swimming_off.png"];
        swimmingLB.textColor = OFF_TEXT_COLOR;
    }
    
    
    UIImageView * restaurantIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + broadBandLB.bottom, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:restaurantIMV];
    UILabel * restaurantLB = [[UILabel alloc] initWithFrame:CGRectMake(restaurantIMV.left, restaurantIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    restaurantLB.text = @"餐厅";
    restaurantLB.font = TEXT_FONT;
    restaurantLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:restaurantLB];
    if ([[self.detailsDic objectForKey:@"RestaurantState"] isEqualToNumber:@YES]) {
        restaurantIMV.image = [UIImage imageNamed:@"restaurant_on.png"];
        restaurantLB.textColor = TEXT_COLOR;
    }else
    {
        restaurantIMV.image = [UIImage imageNamed:@"restaurant_off.png"];
        restaurantLB.textColor = OFF_TEXT_COLOR;
    }
    
    UIImageView * parkIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE + restaurantIMV.right, restaurantIMV.top, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:parkIMV];
    UILabel * parkLB = [[UILabel alloc] initWithFrame:CGRectMake(parkIMV.left, parkIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    parkLB.text = @"停车场";
    parkLB.font = TEXT_FONT;
    parkLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:parkLB];
    if ([[self.detailsDic objectForKey:@"ParkState"] isEqualToNumber:@YES]) {
        parkIMV.image = [UIImage imageNamed:@"parking_on.png"];
        parkLB.textColor = TEXT_COLOR;
    }else
    {
        parkIMV.image = [UIImage imageNamed:@"parking_off.png"];
        parkLB.textColor = OFF_TEXT_COLOR;
    }
    
    
    UIImageView * meetingIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE + parkIMV.right, restaurantIMV.top, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:meetingIMV];
    UILabel * meetingLB = [[UILabel alloc] initWithFrame:CGRectMake(meetingIMV.left, meetingIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    meetingLB.text = @"会议室";
    meetingLB.font = TEXT_FONT;
    meetingLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:parkLB];
    if ([[self.detailsDic objectForKey:@"MeetingRoom"] isEqualToNumber:@YES]) {
        meetingIMV.image = [UIImage imageNamed:@"meeting_on.png"];
        meetingLB.textColor = TEXT_COLOR;
    }else
    {
        meetingIMV.image = [UIImage imageNamed:@"meeting_off.png"];
        meetingLB.textColor = OFF_TEXT_COLOR;
    }
    
    
    UIImageView * businessIMV = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE + meetingIMV.right, restaurantIMV.top, IMAGE_SIZE, IMAGE_SIZE)];
    [view addSubview:businessIMV];
    UILabel * businessLB = [[UILabel alloc] initWithFrame:CGRectMake(businessIMV.left, businessIMV.bottom, IMAGE_SIZE, LABEL_HEIGHT)];
    businessLB.text = @"会议中心";
    businessLB.font = TEXT_FONT;
    businessLB.textAlignment = NSTextAlignmentCenter;
    [view addSubview:businessLB];
    if ([[self.detailsDic objectForKey:@"BusinessCenter"] isEqualToNumber:@YES]) {
        businessIMV.image = [UIImage imageNamed:@"business_on.png"];
        businessLB.textColor = TEXT_COLOR;
    }else
    {
        businessIMV.image = [UIImage imageNamed:@"business_off.png"];
        businessLB.textColor = OFF_TEXT_COLOR;
    }
    
    view.height = businessLB.bottom + 10;
    
    
    UILabel * describeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, view.bottom, self.view.width, 40)];
    describeLB.text = @"商家介绍";
    describeLB.textAlignment = NSTextAlignmentCenter;
    describeLB.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:describeLB];
    
    UIView * detailsView = [[UIView alloc] initWithFrame:CGRectMake(0, describeLB.bottom, describeLB.width, 50)];
    detailsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailsView];
    
    UILabel * detailsDBLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, describeLB.width - 20, 50)];
    detailsDBLB.backgroundColor = [UIColor whiteColor];
    detailsDBLB.text = @"无";
    detailsDBLB.numberOfLines = 0;
    detailsDBLB.textColor = TEXT_COLOR;
    [detailsView addSubview:detailsDBLB];
    if ([self.describe length]) {
        detailsDBLB.text = self.describe;
        CGSize size = [detailsDBLB sizeThatFits:CGSizeMake(detailsDBLB.width, CGFLOAT_MAX)];
//        if (size.height + 20 > detailsView.height) {
            detailsDBLB.height = size.height;
            detailsView.height = detailsDBLB.bottom + 10;
//        }
    }
    
    
    // Do any additional setup after loading the view.
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
