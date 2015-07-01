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
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"home_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * homeNavc = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNavc.navigationBar.barTintColor = MAIN_COLOR;
    GrogshopViewController * grogshopVC = [[GrogshopViewController alloc] init];
    grogshopVC.tabBarItem.title = @"酒店";
    grogshopVC.tabBarItem.image = [[UIImage imageNamed:@"grogshop_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    grogshopVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"grogshop_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * grogshopNavc = [[UINavigationController alloc] initWithRootViewController:grogshopVC];
//    grogshopNavc.navigationBar.barTintColor = MAIN_COLOR;
    TakeOutViewController * takeOutVC = [[TakeOutViewController alloc] init];
    takeOutVC.tabBarItem.title = @"外卖";
    takeOutVC.tabBarItem.image = [[UIImage imageNamed:@"takeOut_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    takeOutVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"takeOut_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController * takeOutNavc = [[UINavigationController alloc] initWithRootViewController:takeOutVC];
    takeOutNavc.navigationBar.barTintColor = MAIN_COLOR;
    UserViewController * userVC = [[UserViewController alloc] init];
    userVC.tabBarItem.title = @"登录";
    userVC.tabBarItem.image = [[UIImage imageNamed:@"user_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"user_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
