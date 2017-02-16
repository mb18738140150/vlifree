//
//  MyTabBarController.m
//  vlifree
//
//  Created by 仙林 on 15/5/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "MyTabBarController.h"
#import "GrogshopViewController.h"
#import "UserViewController.h"
#import "HomeViewController.h"
#import "TakeOutViewController.h"


@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = MAIN_COLOR;
    UIView * barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.tabBar.height)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:barView];

    HomeViewController * homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_n_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_s_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * homeNavc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNavc.navigationBar.barTintColor = [UIColor whiteColor];
    GrogshopViewController * grogshopVC = [[GrogshopViewController alloc] init];
    grogshopVC.tabBarItem.title = @"酒店";
    grogshopVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_n_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    grogshopVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_s_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * grogshopNavc = [[UINavigationController alloc] initWithRootViewController:grogshopVC];
//    grogshopNavc.navigationBar.barTintColor = MAIN_COLOR;
    TakeOutViewController * takeOutVC = [[TakeOutViewController alloc] init];
    takeOutVC.tabBarItem.title = @"外卖";
    takeOutVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_n_3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    takeOutVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_s_3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * takeOutNavc = [[UINavigationController alloc] initWithRootViewController:takeOutVC];
    takeOutNavc.navigationBar.barTintColor = [UIColor whiteColor];
    UserViewController * userVC = [[UserViewController alloc] init];
    userVC.tabBarItem.title = @"我的";
    userVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_n_4.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_s_4.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * userNavc = [[UINavigationController alloc] initWithRootViewController:userVC];
    userNavc.navigationBar.barTintColor = MAIN_COLOR;
    self.viewControllers = @[homeNavc, grogshopNavc, takeOutNavc, userNavc];
    

    
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
